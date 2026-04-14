#!/usr/bin/env bash
set -euo pipefail

HOSTS_FILE="${WORK_MODE_HOSTS_FILE:-/etc/hosts}"
SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)/$(basename "${BASH_SOURCE[0]}")"
HELPER_PATH="${WORK_MODE_HELPER_PATH:-/usr/local/sbin/work-mode-hosts}"
SUDOERS_PATH="${WORK_MODE_SUDOERS_PATH:-/etc/sudoers.d/work-mode-hosts}"
BEGIN_MARKER="# BEGIN WORK MODE DNS BLOCK"
END_MARKER="# END WORK MODE DNS BLOCK"
IPV4_BLOCK="0.0.0.0"
IPV6_BLOCK="::1"
TMP_HOSTS_FILE=""
TMP_SUDOERS_FILE=""

DOMAINS=(
    youtube.com
    www.youtube.com
    m.youtube.com
    music.youtube.com
    studio.youtube.com
    tv.youtube.com
    youtu.be
    www.youtu.be
    youtube-nocookie.com
    www.youtube-nocookie.com
    youtubei.googleapis.com
    ytimg.com
    www.ytimg.com
    i.ytimg.com
    s.ytimg.com
    googlevideo.com
    www.googlevideo.com
    discord.com
    www.discord.com
    canary.discord.com
    ptb.discord.com
    discord.gg
    www.discord.gg
    gateway.discord.gg
    discordapp.com
    www.discordapp.com
    cdn.discordapp.com
    media.discordapp.net
    substack.com
    www.substack.com
    app.substack.com
    reader.substack.com
    open.substack.com
    substackcdn.com
    substack-post-media.s3.amazonaws.com
)

usage() {
    cat <<EOF
Usage: $(basename "$0") [on|off|toggle|status|domains|doctor|setup]

Toggles a marked DNS-resolution block in $HOSTS_FILE for YouTube, Substack,
and Discord. Without an argument, defaults to: toggle.

Run \`$(basename "$0") setup\` once to install a root-owned helper and sudoers
rule so toggles do not prompt for your password.
EOF
}

is_enabled() {
    grep -Fxq "$BEGIN_MARKER" "$HOSTS_FILE"
}

print_domains() {
    printf '%s\n' "${DOMAINS[@]}"
}

strip_work_mode_block() {
    awk -v begin="$BEGIN_MARKER" -v end="$END_MARKER" '
        $0 == begin { skipping = 1; next }
        $0 == end { skipping = 0; next }
        !skipping { print }
    ' "$HOSTS_FILE"
}

append_work_mode_block() {
    {
        printf '\n%s\n' "$BEGIN_MARKER"
        printf '# Managed by %s; run `%s off` to remove.\n' "$0" "$0"
        for domain in "${DOMAINS[@]}"; do
            printf '%s\t%s\n' "$IPV4_BLOCK" "$domain"
            printf '%s\t%s\n' "$IPV6_BLOCK" "$domain"
        done
        printf '%s\n' "$END_MARKER"
    } >> "$1"
}

write_hosts_file() {
    local tmp_file="$1"

    if [[ "$HOSTS_FILE" == "/etc/hosts" && "${EUID:-$(id -u)}" -eq 0 ]]; then
        if [[ "$(uname -s)" == "Darwin" ]]; then
            install -m 0644 -o root -g wheel "$tmp_file" "$HOSTS_FILE"
        else
            install -m 0644 -o root -g root "$tmp_file" "$HOSTS_FILE"
        fi
    elif [[ -w "$HOSTS_FILE" ]]; then
        cp "$tmp_file" "$HOSTS_FILE"
    elif [[ "$(uname -s)" == "Darwin" ]]; then
        sudo install -m 0644 -o root -g wheel "$tmp_file" "$HOSTS_FILE"
    else
        sudo install -m 0644 -o root -g root "$tmp_file" "$HOSTS_FILE"
    fi
}

resolver_still_blocks() {
    dscacheutil -q host -a name "$1" 2>/dev/null \
        | awk '/^(ip_address: 0\.0\.0\.0|ipv6_address: ::1)$/ { found = 1 } END { exit !found }'
}

warn_if_dns_still_blocked() {
    [[ "$HOSTS_FILE" == "/etc/hosts" ]] || return 0

    if resolver_still_blocks youtube.com; then
        echo "Warning: /etc/hosts is off, but DNS still resolves youtube.com to 0.0.0.0 or ::1." >&2
        echo "Run \`$(basename "$0") doctor\` to inspect the active resolver." >&2
    fi
}

doctor() {
    "$0" status
    echo
    echo "Hosts entries:"
    if grep -nE 'WORK MODE DNS BLOCK|youtube|youtu\.be|ytimg|googlevideo|discord|substack' "$HOSTS_FILE"; then
        :
    else
        echo "No work-mode domains found in $HOSTS_FILE."
    fi

    echo
    echo "Resolver answers:"
    for domain in youtube.com discord.com substack.com; do
        echo "== $domain =="
        dscacheutil -q host -a name "$domain" 2>/dev/null || true
    done

    if [[ "$(uname -s)" == "Darwin" ]]; then
        echo
        echo "Active DNS servers:"
        scutil --dns 2>/dev/null | awk '/nameserver\\[[0-9]+\\]/ { print }'
    fi
}

flush_dns() {
    [[ "${WORK_MODE_SKIP_FLUSH:-0}" == "1" ]] && return 0
    [[ "$HOSTS_FILE" != "/etc/hosts" ]] && return 0

    if [[ "$(uname -s)" == "Darwin" ]]; then
        dscacheutil -flushcache >/dev/null 2>&1 || true
        if [[ "${EUID:-$(id -u)}" -eq 0 ]]; then
            killall -HUP mDNSResponder >/dev/null 2>&1 || true
        else
            sudo killall -HUP mDNSResponder >/dev/null 2>&1 || true
        fi
    elif command -v resolvectl >/dev/null 2>&1; then
        resolvectl flush-caches >/dev/null 2>&1 || true
    elif command -v systemd-resolve >/dev/null 2>&1; then
        systemd-resolve --flush-caches >/dev/null 2>&1 || true
    fi
}

install_passwordless_helper() {
    local setup_user root_group

    setup_user="${SUDO_USER:-$(id -un)}"
    root_group="root"
    if [[ "$(uname -s)" == "Darwin" ]]; then
        root_group="wheel"
    fi

    TMP_SUDOERS_FILE="$(mktemp "${TMPDIR:-/tmp}/work-mode-sudoers.XXXXXX")"
    trap 'rm -f "$TMP_HOSTS_FILE" "$TMP_SUDOERS_FILE"' EXIT

    cat > "$TMP_SUDOERS_FILE" <<EOF
$setup_user ALL=(root) NOPASSWD: $HELPER_PATH on, $HELPER_PATH off, $HELPER_PATH toggle, $HELPER_PATH status, $HELPER_PATH domains
EOF

    echo "Installing root-owned helper at $HELPER_PATH"
    sudo mkdir -p "$(dirname "$HELPER_PATH")"
    sudo install -m 0755 -o root -g "$root_group" "$SCRIPT_PATH" "$HELPER_PATH"

    echo "Installing sudoers rule at $SUDOERS_PATH"
    sudo visudo -cf "$TMP_SUDOERS_FILE" >/dev/null
    sudo install -m 0440 -o root -g "$root_group" "$TMP_SUDOERS_FILE" "$SUDOERS_PATH"
    sudo visudo -cf "$SUDOERS_PATH" >/dev/null

    if sudo -n "$HELPER_PATH" status >/dev/null 2>&1; then
        echo "Passwordless work mode helper is ready."
    else
        echo "Installed helper, but passwordless sudo did not validate." >&2
        exit 1
    fi
}

delegate_to_passwordless_helper() {
    local action="$1"

    [[ "$HOSTS_FILE" == "/etc/hosts" ]] || return 1
    [[ "${EUID:-$(id -u)}" -ne 0 ]] || return 1
    [[ "$SCRIPT_PATH" != "$HELPER_PATH" ]] || return 1
    [[ -x "$HELPER_PATH" ]] || return 1

    sudo -n "$HELPER_PATH" "$action"
}

set_work_mode() {
    local state="$1"

    [[ -r "$HOSTS_FILE" ]] || {
        echo "Cannot read hosts file: $HOSTS_FILE" >&2
        exit 1
    }

    TMP_HOSTS_FILE="$(mktemp "${TMPDIR:-/tmp}/work-mode-hosts.XXXXXX")"
    trap 'rm -f "$TMP_HOSTS_FILE"' EXIT

    strip_work_mode_block > "$TMP_HOSTS_FILE"

    if [[ "$state" == "on" ]]; then
        append_work_mode_block "$TMP_HOSTS_FILE"
    fi

    write_hosts_file "$TMP_HOSTS_FILE"
    flush_dns
}

action="${1:-toggle}"

case "$action" in
    on|off|toggle)
        if delegate_to_passwordless_helper "$action"; then
            exit 0
        fi
        ;;
esac

case "$action" in
    on)
        set_work_mode on
        echo "Work mode is on. Blocked $((${#DOMAINS[@]})) hostnames."
        ;;
    off)
        set_work_mode off
        echo "Work mode is off."
        warn_if_dns_still_blocked
        ;;
    toggle)
        if is_enabled; then
            set_work_mode off
            echo "Work mode is off."
            warn_if_dns_still_blocked
        else
            set_work_mode on
            echo "Work mode is on. Blocked $((${#DOMAINS[@]})) hostnames."
        fi
        ;;
    status)
        if is_enabled; then
            echo "Work mode is on."
        else
            echo "Work mode is off."
        fi
        ;;
    domains)
        print_domains
        ;;
    doctor)
        doctor
        ;;
    setup)
        install_passwordless_helper
        ;;
    -h|--help|help)
        usage
        ;;
    *)
        usage >&2
        exit 2
        ;;
esac
