#!/usr/bin/env bash
set -euo pipefail

MAC_MINI_SSH_TARGET="${MAC_MINI_SSH_TARGET:-sylvan@Sylvans-mac-mini.local}"
MAC_MINI_HTTP_HOST="${MAC_MINI_HTTP_HOST:-Sylvans-Mac-mini.local}"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}"
CACHE_FILE="${CACHE_DIR}/mac-mini-services.tsv"
CACHE_DATE_FILE="${CACHE_DIR}/mac-mini-services.date"
CACHE_LOCK_DIR="${CACHE_DIR}/mac-mini-services.lock"

OUTPUT_FORMAT="tsv"
FORCE_REFRESH=0

while [[ $# -gt 0 ]]; do
    case "$1" in
        --markdown|markdown)
            OUTPUT_FORMAT="markdown"
            ;;
        --tsv|tsv)
            OUTPUT_FORMAT="tsv"
            ;;
        --refresh)
            FORCE_REFRESH=1
            ;;
        *)
            echo "Unsupported option: $1" >&2
            exit 1
            ;;
    esac
    shift
done

records_file="$(mktemp)"
deduped_file="$(mktemp)"
sorted_file="$(mktemp)"
trap 'rm -f "$records_file" "$deduped_file" "$sorted_file"' EXIT

remote_run() {
    local command="${1:-}"
    if running_on_mac_mini; then
        /bin/zsh <<EOF
set -euo pipefail
if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "\$(/opt/homebrew/bin/brew shellenv)"
fi
${command}
EOF
        return 0
    fi

    ssh "$MAC_MINI_SSH_TARGET" /bin/zsh <<EOF
set -euo pipefail
if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "\$(/opt/homebrew/bin/brew shellenv)"
fi
${command}
EOF
}

running_on_mac_mini() {
    local current_host
    current_host="$(hostname 2>/dev/null || true)"

    case "$current_host" in
        Sylvans-Mac-mini|Sylvans-Mac-mini.local|sylvans-mac-mini|sylvans-mac-mini.local)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

emit_row() {
    local service="${1:-}"
    local url="${2:-}"
    local source="${3:-}"
    local notes="${4:-}"
    [[ -n "$service" && -n "$url" ]] || return 0
    printf '%s\t%s\t%s\t%s\n' "$service" "$url" "$source" "$notes" >> "$records_file"
}

service_from_name() {
    case "${1:-}" in
        actualbudget) echo "Actual Budget" ;;
        calcom) echo "Cal.com" ;;
        caddy-proxy) echo "Reverse Proxy" ;;
        grafana) echo "Garmin Grafana" ;;
        portainer) echo "Portainer" ;;
        open-notebook-open_notebook-1) echo "Open Notebook" ;;
        open-notebook-surrealdb-1) echo "SurrealDB" ;;
        open-notebook-ollama-1) echo "Ollama" ;;
        database) echo "PostgreSQL" ;;
        redis) echo "Redis" ;;
        headlamp) echo "Headlamp" ;;
        jellyfin) echo "Jellyfin" ;;
        *) echo "${1:-unknown}" ;;
    esac
}

preferred_port_for_service() {
    case "${1:-}" in
        Actual\ Budget) echo "5006" ;;
        Cal.com) echo "3000" ;;
        Garmin\ Grafana) echo "3300" ;;
        Headlamp) echo "8080" ;;
        Jellyfin) echo "8096" ;;
        Open\ Notebook) echo "5055" ;;
        Portainer) echo "9443" ;;
        SurrealDB) echo "8000" ;;
        *) echo "" ;;
    esac
}

source_priority() {
    case "${1:-}" in
        k8s) echo "1" ;;
        docker) echo "2" ;;
        *) echo "9" ;;
    esac
}

port_notes() {
    local service="${1:-}"
    local port="${2:-}"

    case "$service:$port" in
        Actual\ Budget:5006) echo "Direct Docker port on the Mac mini" ;;
        Cal.com:3000) echo "Direct Docker port on the Mac mini" ;;
        Garmin\ Grafana:3300) echo "Grafana UI for the Garmin stack on the Mac mini" ;;
        Open\ Notebook:5055) echo "Primary Open Notebook UI port" ;;
        Open\ Notebook:8502) echo "Secondary Open Notebook UI port" ;;
        Portainer:9443) echo "Direct Portainer HTTPS endpoint" ;;
        SurrealDB:8000) echo "Direct SurrealDB HTTP API port" ;;
        Headlamp:8080) echo "k3s LoadBalancer service" ;;
        Jellyfin:8096) echo "k3s LoadBalancer service" ;;
        *) echo "Direct service port on the Mac mini" ;;
    esac
}

port_from_url() {
    printf '%s\n' "${1:-}" | sed -nE 's#.*:([0-9]+)$#\1#p'
}

row_score() {
    local service="${1:-}"
    local source="${2:-}"
    local url="${3:-}"
    local port preferred_port priority

    port="$(port_from_url "$url")"
    preferred_port="$(preferred_port_for_service "$service")"
    priority="$(source_priority "$source")"

    if [[ -n "$preferred_port" && "$port" == "$preferred_port" ]]; then
        echo "0${priority}"
    else
        echo "1${priority}"
    fi
}

render_markdown() {
    local input_file="${1:-}"
    printf '| Service | URL | Source | Notes |\n'
    printf '| --- | --- | --- | --- |\n'
    while IFS=$'\t' read -r service url source notes; do
        printf '| %s | `%s` | `%s` | %s |\n' "$service" "$url" "$source" "$notes"
    done < "$input_file"
}

collect_docker() {
    local docker_rows
    docker_rows="$(remote_run "docker ps --format '{{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}' 2>/dev/null || true")"

    [[ -n "$docker_rows" ]] || return 0

    while IFS=$'\t' read -r name image status ports; do
        [[ -n "$name" ]] || continue
        [[ "$name" == k8s_* ]] && continue

        local service
        service="$(service_from_name "$name")"

        while IFS=' ' read -r host_port container_port protocol; do
            [[ -n "${host_port:-}" && -n "${container_port:-}" ]] || continue
            [[ "$protocol" == "tcp" ]] || continue

            if [[ "$service" == "Reverse Proxy" ]]; then
                continue
            fi

            local url_scheme="http"
            if [[ "$host_port" == "9443" ]]; then
                url_scheme="https"
            fi

            emit_row \
                "$service" \
                "${url_scheme}://${MAC_MINI_HTTP_HOST}:${host_port}" \
                "docker" \
                "$(port_notes "$service" "$host_port"); container=${name}; image=${image}; status=${status}"
        done < <(
            printf '%s\n' "$ports" \
                | tr ',' '\n' \
                | sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//' \
                | sed -nE 's#.*:([0-9]+)->([0-9]+)/(tcp|udp).*#\1 \2 \3#p' \
                | awk '!seen[$1 ":" $2 ":" $3]++'
        )
    done <<< "$docker_rows"
}

collect_k8s() {
    local services_json
    services_json="$(remote_run 'kubectl get svc -A -o json 2>/dev/null || true')"

    [[ -n "$services_json" ]] || return 0

    while IFS=$'\t' read -r namespace name port; do
        [[ -n "$name" && -n "$port" ]] || continue

        local service
        service="$(service_from_name "$name")"

        emit_row \
            "$service" \
            "http://${MAC_MINI_HTTP_HOST}:${port}" \
            "k8s" \
            "$(port_notes "$service" "$port"); service=${namespace}/${name}"
    done < <(
        printf '%s\n' "$services_json" \
            | jq -r '
                .items[]
                | select(.spec.type == "LoadBalancer")
                | . as $service
                | .spec.ports[]
                | [$service.metadata.namespace, $service.metadata.name, (.port | tostring)]
                | @tsv
            '
    )
}

dedupe_services() {
    awk -F '\t' '
        function preferred_port(service) {
            if (service == "Actual Budget") return "5006"
            if (service == "Cal.com") return "3000"
            if (service == "Garmin Grafana") return "3300"
            if (service == "Headlamp") return "8080"
            if (service == "Jellyfin") return "8096"
            if (service == "Open Notebook") return "5055"
            if (service == "Portainer") return "9443"
            if (service == "SurrealDB") return "8000"
            return ""
        }

        function source_priority(source) {
            if (source == "k8s") return 1
            if (source == "docker") return 2
            return 9
        }

        function port_from_url(url, parts, count) {
            count = split(url, parts, ":")
            return parts[count]
        }

        function row_score(service, source, url, preferred, port) {
            preferred = preferred_port(service)
            port = port_from_url(url)
            if (preferred != "" && port == preferred) {
                return "0" source_priority(source)
            }
            return "1" source_priority(source)
        }

        {
            service = $1
            url = $2
            source = $3
            notes = $4

            score = row_score(service, source, url)

            if (!(service in best_score) || score < best_score[service]) {
                if (service in best_url) {
                    alt[service] = alt[service] (alt[service] ? "; " : "") "alternate endpoint=" best_url[service]
                }
                best_score[service] = score
                best_url[service] = url
                best_source[service] = source
                best_notes[service] = notes
            } else {
                alt[service] = alt[service] (alt[service] ? "; " : "") "alternate endpoint=" url
            }
        }

        END {
            for (service in best_url) {
                notes = best_notes[service]
                if (alt[service] != "") {
                    notes = notes "; " alt[service]
                }
                print service "\t" best_url[service] "\t" best_source[service] "\t" notes
            }
        }
    ' "$records_file" > "$deduped_file"

    LC_ALL=C sort -t $'\t' -k1,1 -k3,3 -k2,2 "$deduped_file" > "$sorted_file"
}

cache_is_fresh_today() {
    [[ -f "$CACHE_FILE" && -f "$CACHE_DATE_FILE" ]] || return 1
    [[ "$(cat "$CACHE_DATE_FILE" 2>/dev/null)" == "$(date +%F)" ]]
}

print_output_file() {
    local input_file="${1:-}"
    case "$OUTPUT_FORMAT" in
        markdown)
            render_markdown "$input_file"
            ;;
        tsv)
            cat "$input_file"
            ;;
    esac
}

write_cache() {
    mkdir -p "$CACHE_DIR"
    cp "$sorted_file" "$CACHE_FILE"
    date +%F > "$CACHE_DATE_FILE"
}

refresh_cache_live() {
    : > "$records_file"
    : > "$deduped_file"
    : > "$sorted_file"

    collect_docker
    collect_k8s
    dedupe_services
    write_cache
    print_output_file "$CACHE_FILE"
}

queue_background_refresh() {
    mkdir -p "$CACHE_DIR"
    if mkdir "$CACHE_LOCK_DIR" 2>/dev/null; then
        (
            trap 'rmdir "$CACHE_LOCK_DIR" 2>/dev/null || true' EXIT
            bash "$0" --refresh >/dev/null 2>&1
        ) >/dev/null 2>&1 &
    fi
}

if [[ "$FORCE_REFRESH" == "1" ]]; then
    refresh_cache_live
    exit 0
fi

if cache_is_fresh_today; then
    print_output_file "$CACHE_FILE"
    exit 0
fi

if [[ -f "$CACHE_FILE" ]]; then
    queue_background_refresh
    print_output_file "$CACHE_FILE"
    exit 0
fi

refresh_cache_live
