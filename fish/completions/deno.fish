# Print an optspec for argparse to handle cmd's options that are independent of any subcommand.
function __fish_deno_global_optspecs
	string join \n no-check= import-map= no-remote no-npm node-modules-dir= vendor= c/config= no-config r/reload= lock= no-lock cert= unsafely-ignore-certificate-errors= A/allow-all R/allow-read= deny-read= W/allow-write= deny-write= N/allow-net= deny-net= E/allow-env= deny-env= S/allow-sys= deny-sys= allow-run= deny-run= allow-ffi= deny-ffi= allow-hrtime deny-hrtime no-prompt I/allow-import= inspect= inspect-brk= inspect-wait= allow-scripts= frozen= cached-only location= v8-flags= seed= enable-testing-features-do-not-use strace-ops= check= watch= watch-hmr= watch-exclude= no-clear-screen ext= env-file= no-code-cache unstable unstable-bare-node-builtins unstable-detect-cjs unstable-byonm unstable-sloppy-imports unstable-broadcast-channel unstable-cron unstable-ffi unstable-fs unstable-http unstable-kv unstable-net unstable-process unstable-temporal unstable-unsafe-proto unstable-webgpu unstable-worker-options h/help= V/version L/log-level= q/quiet
end

function __fish_deno_needs_command
	# Figure out if the current invocation already has a command.
	set -l cmd (commandline -opc)
	set -e cmd[1]
	argparse -s (__fish_deno_global_optspecs) -- $cmd 2>/dev/null
	or return
	if set -q argv[1]
		# Also print the command, so this can be used to figure out what it is.
		echo $argv[1]
		return 1
	end
	return 0
end

function __fish_deno_using_subcommand
	set -l cmd (__fish_deno_needs_command)
	test -z "$cmd"
	and return 1
	contains -- $cmd[1] $argv
end

complete -c deno -n "__fish_deno_needs_command" -l no-check -d 'Skip type-checking. If the value of "remote" is supplied, diagnostic errors from remote modules will be ignored' -r
complete -c deno -n "__fish_deno_needs_command" -l import-map -d 'Load import map file from local file or remote URL   Docs: https://docs.deno.com/runtime/manual/basics/import_maps' -r -F
complete -c deno -n "__fish_deno_needs_command" -l node-modules-dir -d 'Sets the node modules management mode for npm packages' -r
complete -c deno -n "__fish_deno_needs_command" -l vendor -d 'Toggles local vendor folder usage for remote modules and a node_modules folder for npm packages' -r -f -a "{true\t'',false\t''}"
complete -c deno -n "__fish_deno_needs_command" -s c -l config -d 'Configure different aspects of deno including TypeScript, linting, and code formatting   Typically the configuration file will be called `deno.json` or `deno.jsonc` and   automatically detected; in that case this flag is not necessary.   Docs: https://docs.deno.com/go/config' -r -F
complete -c deno -n "__fish_deno_needs_command" -s r -l reload -d 'Reload source code cache (recompile TypeScript)   no value                                                 Reload everything   jsr:@std/http/file-server,jsr:@std/assert/assert-equals  Reloads specific modules   npm:                                                     Reload all npm modules   npm:chalk                                                Reload specific npm module' -r -F
complete -c deno -n "__fish_deno_needs_command" -l lock -d 'Check the specified lock file. (If value is not provided, defaults to "./deno.lock")' -r -F
complete -c deno -n "__fish_deno_needs_command" -l cert -d 'Load certificate authority from PEM encoded file' -r -F
complete -c deno -n "__fish_deno_needs_command" -l unsafely-ignore-certificate-errors -d 'DANGER: Disables verification of TLS certificates' -r
complete -c deno -n "__fish_deno_needs_command" -s R -l allow-read -d 'Allow file system read access. Optionally specify allowed paths' -r -F
complete -c deno -n "__fish_deno_needs_command" -l deny-read -d 'Deny file system read access. Optionally specify denied paths' -r -F
complete -c deno -n "__fish_deno_needs_command" -s W -l allow-write -d 'Allow file system write access. Optionally specify allowed paths' -r -F
complete -c deno -n "__fish_deno_needs_command" -l deny-write -d 'Deny file system write access. Optionally specify denied paths' -r -F
complete -c deno -n "__fish_deno_needs_command" -s N -l allow-net -d 'Allow network access. Optionally specify allowed IP addresses and host names, with ports as necessary' -r
complete -c deno -n "__fish_deno_needs_command" -l deny-net -d 'Deny network access. Optionally specify denied IP addresses and host names, with ports as necessary' -r
complete -c deno -n "__fish_deno_needs_command" -s E -l allow-env -d 'Allow access to system environment information. Optionally specify accessible environment variables' -r
complete -c deno -n "__fish_deno_needs_command" -l deny-env -d 'Deny access to system environment information. Optionally specify accessible environment variables' -r
complete -c deno -n "__fish_deno_needs_command" -s S -l allow-sys -d 'Allow access to OS information. Optionally allow specific APIs by function name' -r
complete -c deno -n "__fish_deno_needs_command" -l deny-sys -d 'Deny access to OS information. Optionally deny specific APIs by function name' -r
complete -c deno -n "__fish_deno_needs_command" -l allow-run -d 'Allow running subprocesses. Optionally specify allowed runnable program names' -r
complete -c deno -n "__fish_deno_needs_command" -l deny-run -d 'Deny running subprocesses. Optionally specify denied runnable program names' -r
complete -c deno -n "__fish_deno_needs_command" -l allow-ffi -d '(Unstable) Allow loading dynamic libraries. Optionally specify allowed directories or files' -r -F
complete -c deno -n "__fish_deno_needs_command" -l deny-ffi -d '(Unstable) Deny loading dynamic libraries. Optionally specify denied directories or files' -r -F
complete -c deno -n "__fish_deno_needs_command" -s I -l allow-import -d 'Allow importing from remote hosts. Optionally specify allowed IP addresses and host names, with ports as necessary. Default value: deno.land:443,jsr.io:443,esm.sh:443,cdn.jsdelivr.net:443,raw.githubusercontent.com:443,user.githubusercontent.com:443' -r
complete -c deno -n "__fish_deno_needs_command" -l inspect -d 'Activate inspector on host:port [default: 127.0.0.1:9229]' -r
complete -c deno -n "__fish_deno_needs_command" -l inspect-brk -d 'Activate inspector on host:port, wait for debugger to connect and break at the start of user script' -r
complete -c deno -n "__fish_deno_needs_command" -l inspect-wait -d 'Activate inspector on host:port and wait for debugger to connect before running user code' -r
complete -c deno -n "__fish_deno_needs_command" -l allow-scripts -d 'Allow running npm lifecycle scripts for the given packages   Note: Scripts will only be executed when using a node_modules directory (`--node-modules-dir`)' -r
complete -c deno -n "__fish_deno_needs_command" -l frozen -d 'Error out if lockfile is out of date' -r -f -a "{true\t'',false\t''}"
complete -c deno -n "__fish_deno_needs_command" -l location -d 'Value of globalThis.location used by some web APIs' -r -f
complete -c deno -n "__fish_deno_needs_command" -l v8-flags -d 'To see a list of all available flags use --v8-flags=--help   Flags can also be set via the DENO_V8_FLAGS environment variable.   Any flags set with this flag are appended after the DENO_V8_FLAGS environment variable' -r
complete -c deno -n "__fish_deno_needs_command" -l seed -d 'Set the random number generator seed' -r
complete -c deno -n "__fish_deno_needs_command" -l strace-ops -d 'Trace low-level op calls' -r
complete -c deno -n "__fish_deno_needs_command" -l check -d 'Enable type-checking. This subcommand does not type-check by default   If the value of "all" is supplied, remote modules will be included.   Alternatively, the \'deno check\' subcommand can be used' -r
complete -c deno -n "__fish_deno_needs_command" -l watch -d 'Watch for file changes and restart process automatically.   Local files from entry point module graph are watched by default.   Additional paths might be watched by passing them as arguments to this flag.' -r -F
complete -c deno -n "__fish_deno_needs_command" -l watch-hmr -d 'Watch for file changes and restart process automatically.   Local files from entry point module graph are watched by default.   Additional paths might be watched by passing them as arguments to this flag.' -r -F
complete -c deno -n "__fish_deno_needs_command" -l watch-exclude -d 'Exclude provided files/patterns from watch mode' -r -F
complete -c deno -n "__fish_deno_needs_command" -l ext -d 'Set content type of the supplied file' -r -f -a "{ts\t'',tsx\t'',js\t'',jsx\t''}"
complete -c deno -n "__fish_deno_needs_command" -l env-file -d 'Load environment variables from local file   Only the first environment variable with a given key is used.   Existing process environment variables are not overwritten.' -r -F
complete -c deno -n "__fish_deno_needs_command" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_needs_command" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_needs_command" -l no-remote -d 'Do not resolve remote modules'
complete -c deno -n "__fish_deno_needs_command" -l no-npm -d 'Do not resolve npm modules'
complete -c deno -n "__fish_deno_needs_command" -l no-config -d 'Disable automatic loading of the configuration file'
complete -c deno -n "__fish_deno_needs_command" -l no-lock -d 'Disable auto discovery of the lock file'
complete -c deno -n "__fish_deno_needs_command" -s A -l allow-all -d 'Allow all permissions'
complete -c deno -n "__fish_deno_needs_command" -l allow-hrtime -d 'REMOVED in Deno 2.0'
complete -c deno -n "__fish_deno_needs_command" -l deny-hrtime -d 'REMOVED in Deno 2.0'
complete -c deno -n "__fish_deno_needs_command" -l no-prompt -d 'Always throw if required permission wasn\'t passed'
complete -c deno -n "__fish_deno_needs_command" -l cached-only -d 'Require that remote dependencies are already cached'
complete -c deno -n "__fish_deno_needs_command" -l enable-testing-features-do-not-use -d 'INTERNAL: Enable internal features used during integration testing'
complete -c deno -n "__fish_deno_needs_command" -l no-clear-screen -d 'Do not clear terminal screen when under watch mode'
complete -c deno -n "__fish_deno_needs_command" -l no-code-cache -d 'Disable V8 code cache feature'
complete -c deno -n "__fish_deno_needs_command" -l unstable -d 'Enable all unstable features and APIs. Instead of using this flag, consider enabling individual unstable features   To view the list of individual unstable feature flags, run this command again with --help=unstable'
complete -c deno -n "__fish_deno_needs_command" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_deno_needs_command" -l unstable-detect-cjs -d 'Reads the package.json type field in a project to treat .js files as .cjs'
complete -c deno -n "__fish_deno_needs_command" -l unstable-byonm
complete -c deno -n "__fish_deno_needs_command" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing'
complete -c deno -n "__fish_deno_needs_command" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_deno_needs_command" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_deno_needs_command" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_deno_needs_command" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_deno_needs_command" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_deno_needs_command" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_deno_needs_command" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_deno_needs_command" -l unstable-process -d 'Enable unstable process APIs'
complete -c deno -n "__fish_deno_needs_command" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_deno_needs_command" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_deno_needs_command" -l unstable-webgpu -d 'Enable unstable `WebGPU` APIs'
complete -c deno -n "__fish_deno_needs_command" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_deno_needs_command" -s V -l version -d 'Print version'
complete -c deno -n "__fish_deno_needs_command" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_needs_command" -a "run" -d 'Run a JavaScript or TypeScript program, or a task or script.  By default all programs are run in sandbox without access to disk, network or ability to spawn subprocesses.   deno run https://examples.deno.land/hello-world.ts  Grant permission to read from disk and listen to network:   deno run --allow-read --allow-net jsr:@std/http/file-server  Grant permission to read allow-listed files from disk:   deno run --allow-read=/etc jsr:@std/http/file-server  Grant all permissions:   deno run -A jsr:@std/http/file-server  Specifying the filename \'-\' to read the file from stdin.   curl https://examples.deno.land/hello-world.ts | deno run -  Read more: https://docs.deno.com/go/run'
complete -c deno -n "__fish_deno_needs_command" -a "serve" -d 'Run a server defined in a main module  The serve command uses the default exports of the main module to determine which servers to start.  Start a server defined in server.ts:   deno serve server.ts  Start a server defined in server.ts, watching for changes and running on port 5050:   deno serve --watch --port 5050 server.ts  Read more: https://docs.deno.com/go/serve'
complete -c deno -n "__fish_deno_needs_command" -a "add" -d 'Add dependencies to your configuration file.   deno add jsr:@std/path  You can add multiple dependencies at once:   deno add jsr:@std/path jsr:@std/assert'
complete -c deno -n "__fish_deno_needs_command" -a "remove" -d 'Remove dependencies from the configuration file.   deno remove @std/path  You can remove multiple dependencies at once:   deno remove @std/path @std/assert '
complete -c deno -n "__fish_deno_needs_command" -a "bench" -d 'Run benchmarks using Deno\'s built-in bench tool.  Evaluate the given files, run all benches declared with \'Deno.bench()\' and report results to standard output:   deno bench src/fetch_bench.ts src/signal_bench.ts  If you specify a directory instead of a file, the path is expanded to all contained files matching the glob {*_,*.,}bench.{js,mjs,ts,mts,jsx,tsx}:   deno bench src/  Read more: https://docs.deno.com/go/bench'
complete -c deno -n "__fish_deno_needs_command" -a "bundle" -d '⚠️ `deno bundle` was removed in Deno 2.  See the Deno 1.x to 2.x Migration Guide for migration instructions: https://docs.deno.com/runtime/manual/advanced/migrate_deprecations'
complete -c deno -n "__fish_deno_needs_command" -a "cache" -d 'Cache and compile remote dependencies.  Download and compile a module with all of its static dependencies and save them in the local cache, without running any code:   deno cache jsr:@std/http/file-server  Future runs of this module will trigger no downloads or compilation unless --reload is specified  Read more: https://docs.deno.com/go/cache'
complete -c deno -n "__fish_deno_needs_command" -a "check" -d 'Download and type-check without execution.    deno check jsr:@std/http/file-server  Unless --reload is specified, this command will not re-download already cached dependencies  Read more: https://docs.deno.com/go/check'
complete -c deno -n "__fish_deno_needs_command" -a "clean" -d 'Remove the cache directory ($DENO_DIR)'
complete -c deno -n "__fish_deno_needs_command" -a "compile" -d 'Compiles the given script into a self contained executable.    deno compile --allow-read --allow-net jsr:@std/http/file-server   deno compile --output file_server jsr:@std/http/file-server  Any flags specified which affect runtime behavior will be applied to the resulting binary.  This allows distribution of a Deno application to systems that do not have Deno installed. Under the hood, it bundles a slimmed down version of the Deno runtime along with your JavaScript or TypeScript code.  Cross-compiling to different target architectures is supported using the --target flag. On the first invocation with deno will download the proper binary and cache it in $DENO_DIR.  Read more: https://docs.deno.com/go/compile '
complete -c deno -n "__fish_deno_needs_command" -a "completions" -d 'Output shell completion script to standard output.    deno completions bash > /usr/local/etc/bash_completion.d/deno.bash   source /usr/local/etc/bash_completion.d/deno.bash'
complete -c deno -n "__fish_deno_needs_command" -a "coverage" -d 'Print coverage reports from coverage profiles.  Collect a coverage profile with deno test:   deno test --coverage=cov_profile  Print a report to stdout:   deno coverage cov_profile  Include urls that start with the file schema and exclude files ending with test.ts and test.js, for an url to match it must match the include pattern and not match the exclude pattern:   deno coverage --include="^file:" --exclude="test\\.(ts|js)" cov_profile  Write a report using the lcov format:   deno coverage --lcov --output=cov.lcov cov_profile/  Generate html reports from lcov:   genhtml -o html_cov cov.lcov  Read more: https://docs.deno.com/go/coverage'
complete -c deno -n "__fish_deno_needs_command" -a "doc" -d 'Show documentation for a module.  Output documentation to standard output:     deno doc ./path/to/module.ts  Output documentation in HTML format:     deno doc --html --name="My library" ./path/to/module.ts  Lint a module for documentation diagnostics:     deno doc --lint ./path/to/module.ts  Target a specific symbol:     deno doc ./path/to/module.ts MyClass.someField  Show documentation for runtime built-ins:     deno doc     deno doc --filter Deno.Listener  Read more: https://docs.deno.com/go/doc'
complete -c deno -n "__fish_deno_needs_command" -a "eval" -d 'Evaluate JavaScript from the command line.   deno eval "console.log(\'hello world\')"  To evaluate as TypeScript:   deno eval --ext=ts "const v: string = \'hello\'; console.log(v)"  This command has implicit access to all permissions.  Read more: https://docs.deno.com/go/eval'
complete -c deno -n "__fish_deno_needs_command" -a "fmt" -d 'Auto-format various file types.   deno fmt myfile1.ts myfile2.ts  Supported file types are:   JavaScript, TypeScript, Markdown, JSON(C) and Jupyter Notebooks  Supported file types which are behind corresponding unstable flags (see formatting options):   HTML, CSS, SCSS, SASS, LESS, YAML, Svelte, Vue, Astro and Angular  Format stdin and write to stdout:   cat file.ts | deno fmt -  Check if the files are formatted:   deno fmt --check  Ignore formatting code by preceding it with an ignore comment:   // deno-fmt-ignore  Ignore formatting a file by adding an ignore comment at the top of the file:   // deno-fmt-ignore-file  Read more: https://docs.deno.com/go/fmt'
complete -c deno -n "__fish_deno_needs_command" -a "init" -d 'scaffolds a basic Deno project with a script, test, and configuration file'
complete -c deno -n "__fish_deno_needs_command" -a "info" -d 'Show information about a module or the cache directories.  Get information about a module:   deno info jsr:@std/http/file-server  The following information is shown:   local: Local path of the file   type: JavaScript, TypeScript, or JSON   emit: Local path of compiled source code (TypeScript only)   dependencies: Dependency tree of the source file  Read more: https://docs.deno.com/go/info'
complete -c deno -n "__fish_deno_needs_command" -a "install" -d 'Installs dependencies either in the local project or globally to a bin directory.  Local installation  Add dependencies to the local project\'s configuration (deno.json / package.json) and installs them in the package cache. If no dependency is specified, installs all dependencies listed in the config file. If the --entrypoint flag is passed, installs the dependencies of the specified entrypoint(s).    deno install   deno install jsr:@std/bytes   deno install npm:chalk   deno install --entrypoint entry1.ts entry2.ts  Global installation  If the --global flag is set, installs a script as an executable in the installation root\'s bin directory.    deno install --global --allow-net --allow-read jsr:@std/http/file-server   deno install -g https://examples.deno.land/color-logging.ts  To change the executable name, use -n/--name:   deno install -g --allow-net --allow-read -n serve jsr:@std/http/file-server  The executable name is inferred by default:   - Attempt to take the file stem of the URL path. The above example would     become file_server.   - If the file stem is something generic like main, mod, index or cli,     and the path has no parent, take the file name of the parent path. Otherwise     settle with the generic name.   - If the resulting name has an @... suffix, strip it.  To change the installation root, use --root:   deno install -g --allow-net --allow-read --root /usr/local jsr:@std/http/file-server  The installation root is determined, in order of precedence:   - --root option   - DENO_INSTALL_ROOT environment variable   - $HOME/.deno  These must be added to the path manually if required.'
complete -c deno -n "__fish_deno_needs_command" -a "i" -d 'Installs dependencies either in the local project or globally to a bin directory.  Local installation  Add dependencies to the local project\'s configuration (deno.json / package.json) and installs them in the package cache. If no dependency is specified, installs all dependencies listed in the config file. If the --entrypoint flag is passed, installs the dependencies of the specified entrypoint(s).    deno install   deno install jsr:@std/bytes   deno install npm:chalk   deno install --entrypoint entry1.ts entry2.ts  Global installation  If the --global flag is set, installs a script as an executable in the installation root\'s bin directory.    deno install --global --allow-net --allow-read jsr:@std/http/file-server   deno install -g https://examples.deno.land/color-logging.ts  To change the executable name, use -n/--name:   deno install -g --allow-net --allow-read -n serve jsr:@std/http/file-server  The executable name is inferred by default:   - Attempt to take the file stem of the URL path. The above example would     become file_server.   - If the file stem is something generic like main, mod, index or cli,     and the path has no parent, take the file name of the parent path. Otherwise     settle with the generic name.   - If the resulting name has an @... suffix, strip it.  To change the installation root, use --root:   deno install -g --allow-net --allow-read --root /usr/local jsr:@std/http/file-server  The installation root is determined, in order of precedence:   - --root option   - DENO_INSTALL_ROOT environment variable   - $HOME/.deno  These must be added to the path manually if required.'
complete -c deno -n "__fish_deno_needs_command" -a "json_reference"
complete -c deno -n "__fish_deno_needs_command" -a "jupyter" -d 'Deno kernel for Jupyter notebooks'
complete -c deno -n "__fish_deno_needs_command" -a "uninstall" -d 'Uninstalls a dependency or an executable script in the installation root\'s bin directory.   deno uninstall @std/dotenv chalk   deno uninstall --global file_server  To change the installation root, use --root flag:   deno uninstall --global --root /usr/local serve  The installation root is determined, in order of precedence:   - --root option   - DENO_INSTALL_ROOT environment variable   - $HOME/.deno'
complete -c deno -n "__fish_deno_needs_command" -a "lsp" -d 'The \'deno lsp\' subcommand provides a way for code editors and IDEs to interact with Deno using the Language Server Protocol. Usually humans do not use this subcommand directly. For example, \'deno lsp\' can provide IDEs with go-to-definition support and automatic code formatting.  How to connect various editors and IDEs to \'deno lsp\': https://docs.deno.com/go/lsp'
complete -c deno -n "__fish_deno_needs_command" -a "lint" -d 'Lint JavaScript/TypeScript source code.    deno lint   deno lint myfile1.ts myfile2.js  Print result as JSON:   deno lint --json  Read from stdin:   cat file.ts | deno lint -   cat file.ts | deno lint --json -  List available rules:   deno lint --rules  To ignore specific diagnostics, you can write an ignore comment on the preceding line with a rule name (or multiple):   // deno-lint-ignore no-explicit-any   // deno-lint-ignore require-await no-empty  To ignore linting on an entire file, you can add an ignore comment at the top of the file:   // deno-lint-ignore-file  Read more: https://docs.deno.com/go/lint '
complete -c deno -n "__fish_deno_needs_command" -a "publish" -d 'Publish the current working directory\'s package or workspace to JSR'
complete -c deno -n "__fish_deno_needs_command" -a "repl" -d 'Starts a read-eval-print-loop, which lets you interactively build up program state in the global context. It is especially useful for quick prototyping and checking snippets of code.  TypeScript is supported, however it is not type-checked, only transpiled.'
complete -c deno -n "__fish_deno_needs_command" -a "task" -d 'Run a task defined in the configuration file.   deno task build  List all available tasks:   deno task'
complete -c deno -n "__fish_deno_needs_command" -a "test" -d 'Run tests using Deno\'s built-in test runner.  Evaluate the given modules, run all tests declared with Deno.test() and report results to standard output:   deno test src/fetch_test.ts src/signal_test.ts  Directory arguments are expanded to all contained files matching the glob {*_,*.,}test.{js,mjs,ts,mts,jsx,tsx} or **/__tests__/**:  deno test src/  Read more: https://docs.deno.com/go/test'
complete -c deno -n "__fish_deno_needs_command" -a "types" -d 'Print runtime TypeScript declarations.    deno types > lib.deno.d.ts  The declaration file could be saved and used for typing information.'
complete -c deno -n "__fish_deno_needs_command" -a "upgrade" -d 'Upgrade deno executable to the given version.  Latest   deno upgrade  Specific version   deno upgrade 1.45.0   deno upgrade 1.46.0-rc.1   deno upgrade 9bc2dd29ad6ba334fd57a20114e367d3c04763d4  Channel   deno upgrade stable   deno upgrade rc   deno upgrade canary  The version is downloaded from https://dl.deno.land and is used to replace the current executable.  If you want to not replace the current Deno executable but instead download an update to a different location, use the --output flag:   deno upgrade --output $HOME/my_deno  Read more: https://docs.deno.com/go/upgrade'
complete -c deno -n "__fish_deno_needs_command" -a "vendor" -d '⚠️ `deno vendor` was removed in Deno 2.  See the Deno 1.x to 2.x Migration Guide for migration instructions: https://docs.deno.com/runtime/manual/advanced/migrate_deprecations'
complete -c deno -n "__fish_deno_needs_command" -a "help"
complete -c deno -n "__fish_deno_using_subcommand run" -l no-check -d 'Skip type-checking. If the value of "remote" is supplied, diagnostic errors from remote modules will be ignored' -r
complete -c deno -n "__fish_deno_using_subcommand run" -l import-map -d 'Load import map file from local file or remote URL   Docs: https://docs.deno.com/runtime/manual/basics/import_maps' -r -F
complete -c deno -n "__fish_deno_using_subcommand run" -l node-modules-dir -d 'Sets the node modules management mode for npm packages' -r
complete -c deno -n "__fish_deno_using_subcommand run" -l vendor -d 'Toggles local vendor folder usage for remote modules and a node_modules folder for npm packages' -r -f -a "{true\t'',false\t''}"
complete -c deno -n "__fish_deno_using_subcommand run" -s c -l config -d 'Configure different aspects of deno including TypeScript, linting, and code formatting   Typically the configuration file will be called `deno.json` or `deno.jsonc` and   automatically detected; in that case this flag is not necessary.   Docs: https://docs.deno.com/go/config' -r -F
complete -c deno -n "__fish_deno_using_subcommand run" -s r -l reload -d 'Reload source code cache (recompile TypeScript)   no value                                                 Reload everything   jsr:@std/http/file-server,jsr:@std/assert/assert-equals  Reloads specific modules   npm:                                                     Reload all npm modules   npm:chalk                                                Reload specific npm module' -r -F
complete -c deno -n "__fish_deno_using_subcommand run" -l lock -d 'Check the specified lock file. (If value is not provided, defaults to "./deno.lock")' -r -F
complete -c deno -n "__fish_deno_using_subcommand run" -l cert -d 'Load certificate authority from PEM encoded file' -r -F
complete -c deno -n "__fish_deno_using_subcommand run" -l unsafely-ignore-certificate-errors -d 'DANGER: Disables verification of TLS certificates' -r
complete -c deno -n "__fish_deno_using_subcommand run" -s R -l allow-read -d 'Allow file system read access. Optionally specify allowed paths' -r -F
complete -c deno -n "__fish_deno_using_subcommand run" -l deny-read -d 'Deny file system read access. Optionally specify denied paths' -r -F
complete -c deno -n "__fish_deno_using_subcommand run" -s W -l allow-write -d 'Allow file system write access. Optionally specify allowed paths' -r -F
complete -c deno -n "__fish_deno_using_subcommand run" -l deny-write -d 'Deny file system write access. Optionally specify denied paths' -r -F
complete -c deno -n "__fish_deno_using_subcommand run" -s N -l allow-net -d 'Allow network access. Optionally specify allowed IP addresses and host names, with ports as necessary' -r
complete -c deno -n "__fish_deno_using_subcommand run" -l deny-net -d 'Deny network access. Optionally specify denied IP addresses and host names, with ports as necessary' -r
complete -c deno -n "__fish_deno_using_subcommand run" -s E -l allow-env -d 'Allow access to system environment information. Optionally specify accessible environment variables' -r
complete -c deno -n "__fish_deno_using_subcommand run" -l deny-env -d 'Deny access to system environment information. Optionally specify accessible environment variables' -r
complete -c deno -n "__fish_deno_using_subcommand run" -s S -l allow-sys -d 'Allow access to OS information. Optionally allow specific APIs by function name' -r
complete -c deno -n "__fish_deno_using_subcommand run" -l deny-sys -d 'Deny access to OS information. Optionally deny specific APIs by function name' -r
complete -c deno -n "__fish_deno_using_subcommand run" -l allow-run -d 'Allow running subprocesses. Optionally specify allowed runnable program names' -r
complete -c deno -n "__fish_deno_using_subcommand run" -l deny-run -d 'Deny running subprocesses. Optionally specify denied runnable program names' -r
complete -c deno -n "__fish_deno_using_subcommand run" -l allow-ffi -d '(Unstable) Allow loading dynamic libraries. Optionally specify allowed directories or files' -r -F
complete -c deno -n "__fish_deno_using_subcommand run" -l deny-ffi -d '(Unstable) Deny loading dynamic libraries. Optionally specify denied directories or files' -r -F
complete -c deno -n "__fish_deno_using_subcommand run" -s I -l allow-import -d 'Allow importing from remote hosts. Optionally specify allowed IP addresses and host names, with ports as necessary. Default value: deno.land:443,jsr.io:443,esm.sh:443,cdn.jsdelivr.net:443,raw.githubusercontent.com:443,user.githubusercontent.com:443' -r
complete -c deno -n "__fish_deno_using_subcommand run" -l inspect -d 'Activate inspector on host:port [default: 127.0.0.1:9229]' -r
complete -c deno -n "__fish_deno_using_subcommand run" -l inspect-brk -d 'Activate inspector on host:port, wait for debugger to connect and break at the start of user script' -r
complete -c deno -n "__fish_deno_using_subcommand run" -l inspect-wait -d 'Activate inspector on host:port and wait for debugger to connect before running user code' -r
complete -c deno -n "__fish_deno_using_subcommand run" -l allow-scripts -d 'Allow running npm lifecycle scripts for the given packages   Note: Scripts will only be executed when using a node_modules directory (`--node-modules-dir`)' -r
complete -c deno -n "__fish_deno_using_subcommand run" -l frozen -d 'Error out if lockfile is out of date' -r -f -a "{true\t'',false\t''}"
complete -c deno -n "__fish_deno_using_subcommand run" -l location -d 'Value of globalThis.location used by some web APIs' -r -f
complete -c deno -n "__fish_deno_using_subcommand run" -l v8-flags -d 'To see a list of all available flags use --v8-flags=--help   Flags can also be set via the DENO_V8_FLAGS environment variable.   Any flags set with this flag are appended after the DENO_V8_FLAGS environment variable' -r
complete -c deno -n "__fish_deno_using_subcommand run" -l seed -d 'Set the random number generator seed' -r
complete -c deno -n "__fish_deno_using_subcommand run" -l strace-ops -d 'Trace low-level op calls' -r
complete -c deno -n "__fish_deno_using_subcommand run" -l check -d 'Enable type-checking. This subcommand does not type-check by default   If the value of "all" is supplied, remote modules will be included.   Alternatively, the \'deno check\' subcommand can be used' -r
complete -c deno -n "__fish_deno_using_subcommand run" -l watch -d 'Watch for file changes and restart process automatically.   Local files from entry point module graph are watched by default.   Additional paths might be watched by passing them as arguments to this flag.' -r -F
complete -c deno -n "__fish_deno_using_subcommand run" -l watch-hmr -d 'Watch for file changes and restart process automatically.   Local files from entry point module graph are watched by default.   Additional paths might be watched by passing them as arguments to this flag.' -r -F
complete -c deno -n "__fish_deno_using_subcommand run" -l watch-exclude -d 'Exclude provided files/patterns from watch mode' -r -F
complete -c deno -n "__fish_deno_using_subcommand run" -l ext -d 'Set content type of the supplied file' -r -f -a "{ts\t'',tsx\t'',js\t'',jsx\t''}"
complete -c deno -n "__fish_deno_using_subcommand run" -l env-file -d 'Load environment variables from local file   Only the first environment variable with a given key is used.   Existing process environment variables are not overwritten.' -r -F
complete -c deno -n "__fish_deno_using_subcommand run" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand run" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand run" -l unstable -d 'Enable all unstable features and APIs. Instead of using this flag, consider enabling individual unstable features   To view the list of individual unstable feature flags, run this command again with --help=unstable'
complete -c deno -n "__fish_deno_using_subcommand run" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_deno_using_subcommand run" -l unstable-detect-cjs -d 'Reads the package.json type field in a project to treat .js files as .cjs'
complete -c deno -n "__fish_deno_using_subcommand run" -l unstable-byonm
complete -c deno -n "__fish_deno_using_subcommand run" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing'
complete -c deno -n "__fish_deno_using_subcommand run" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_deno_using_subcommand run" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_deno_using_subcommand run" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_deno_using_subcommand run" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_deno_using_subcommand run" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_deno_using_subcommand run" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_deno_using_subcommand run" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_deno_using_subcommand run" -l unstable-process -d 'Enable unstable process APIs'
complete -c deno -n "__fish_deno_using_subcommand run" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_deno_using_subcommand run" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_deno_using_subcommand run" -l unstable-webgpu -d 'Enable unstable `WebGPU` APIs'
complete -c deno -n "__fish_deno_using_subcommand run" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_deno_using_subcommand run" -l no-remote -d 'Do not resolve remote modules'
complete -c deno -n "__fish_deno_using_subcommand run" -l no-npm -d 'Do not resolve npm modules'
complete -c deno -n "__fish_deno_using_subcommand run" -l no-config -d 'Disable automatic loading of the configuration file'
complete -c deno -n "__fish_deno_using_subcommand run" -l no-lock -d 'Disable auto discovery of the lock file'
complete -c deno -n "__fish_deno_using_subcommand run" -s A -l allow-all -d 'Allow all permissions'
complete -c deno -n "__fish_deno_using_subcommand run" -l allow-hrtime -d 'REMOVED in Deno 2.0'
complete -c deno -n "__fish_deno_using_subcommand run" -l deny-hrtime -d 'REMOVED in Deno 2.0'
complete -c deno -n "__fish_deno_using_subcommand run" -l no-prompt -d 'Always throw if required permission wasn\'t passed'
complete -c deno -n "__fish_deno_using_subcommand run" -l cached-only -d 'Require that remote dependencies are already cached'
complete -c deno -n "__fish_deno_using_subcommand run" -l enable-testing-features-do-not-use -d 'INTERNAL: Enable internal features used during integration testing'
complete -c deno -n "__fish_deno_using_subcommand run" -l no-clear-screen -d 'Do not clear terminal screen when under watch mode'
complete -c deno -n "__fish_deno_using_subcommand run" -l no-code-cache -d 'Disable V8 code cache feature'
complete -c deno -n "__fish_deno_using_subcommand run" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand serve" -l no-check -d 'Skip type-checking. If the value of "remote" is supplied, diagnostic errors from remote modules will be ignored' -r
complete -c deno -n "__fish_deno_using_subcommand serve" -l import-map -d 'Load import map file from local file or remote URL   Docs: https://docs.deno.com/runtime/manual/basics/import_maps' -r -F
complete -c deno -n "__fish_deno_using_subcommand serve" -l node-modules-dir -d 'Sets the node modules management mode for npm packages' -r
complete -c deno -n "__fish_deno_using_subcommand serve" -l vendor -d 'Toggles local vendor folder usage for remote modules and a node_modules folder for npm packages' -r -f -a "{true\t'',false\t''}"
complete -c deno -n "__fish_deno_using_subcommand serve" -s c -l config -d 'Configure different aspects of deno including TypeScript, linting, and code formatting   Typically the configuration file will be called `deno.json` or `deno.jsonc` and   automatically detected; in that case this flag is not necessary.   Docs: https://docs.deno.com/go/config' -r -F
complete -c deno -n "__fish_deno_using_subcommand serve" -s r -l reload -d 'Reload source code cache (recompile TypeScript)   no value                                                 Reload everything   jsr:@std/http/file-server,jsr:@std/assert/assert-equals  Reloads specific modules   npm:                                                     Reload all npm modules   npm:chalk                                                Reload specific npm module' -r -F
complete -c deno -n "__fish_deno_using_subcommand serve" -l lock -d 'Check the specified lock file. (If value is not provided, defaults to "./deno.lock")' -r -F
complete -c deno -n "__fish_deno_using_subcommand serve" -l cert -d 'Load certificate authority from PEM encoded file' -r -F
complete -c deno -n "__fish_deno_using_subcommand serve" -l unsafely-ignore-certificate-errors -d 'DANGER: Disables verification of TLS certificates' -r
complete -c deno -n "__fish_deno_using_subcommand serve" -s R -l allow-read -d 'Allow file system read access. Optionally specify allowed paths' -r -F
complete -c deno -n "__fish_deno_using_subcommand serve" -l deny-read -d 'Deny file system read access. Optionally specify denied paths' -r -F
complete -c deno -n "__fish_deno_using_subcommand serve" -s W -l allow-write -d 'Allow file system write access. Optionally specify allowed paths' -r -F
complete -c deno -n "__fish_deno_using_subcommand serve" -l deny-write -d 'Deny file system write access. Optionally specify denied paths' -r -F
complete -c deno -n "__fish_deno_using_subcommand serve" -s N -l allow-net -d 'Allow network access. Optionally specify allowed IP addresses and host names, with ports as necessary' -r
complete -c deno -n "__fish_deno_using_subcommand serve" -l deny-net -d 'Deny network access. Optionally specify denied IP addresses and host names, with ports as necessary' -r
complete -c deno -n "__fish_deno_using_subcommand serve" -s E -l allow-env -d 'Allow access to system environment information. Optionally specify accessible environment variables' -r
complete -c deno -n "__fish_deno_using_subcommand serve" -l deny-env -d 'Deny access to system environment information. Optionally specify accessible environment variables' -r
complete -c deno -n "__fish_deno_using_subcommand serve" -s S -l allow-sys -d 'Allow access to OS information. Optionally allow specific APIs by function name' -r
complete -c deno -n "__fish_deno_using_subcommand serve" -l deny-sys -d 'Deny access to OS information. Optionally deny specific APIs by function name' -r
complete -c deno -n "__fish_deno_using_subcommand serve" -l allow-run -d 'Allow running subprocesses. Optionally specify allowed runnable program names' -r
complete -c deno -n "__fish_deno_using_subcommand serve" -l deny-run -d 'Deny running subprocesses. Optionally specify denied runnable program names' -r
complete -c deno -n "__fish_deno_using_subcommand serve" -l allow-ffi -d '(Unstable) Allow loading dynamic libraries. Optionally specify allowed directories or files' -r -F
complete -c deno -n "__fish_deno_using_subcommand serve" -l deny-ffi -d '(Unstable) Deny loading dynamic libraries. Optionally specify denied directories or files' -r -F
complete -c deno -n "__fish_deno_using_subcommand serve" -s I -l allow-import -d 'Allow importing from remote hosts. Optionally specify allowed IP addresses and host names, with ports as necessary. Default value: deno.land:443,jsr.io:443,esm.sh:443,cdn.jsdelivr.net:443,raw.githubusercontent.com:443,user.githubusercontent.com:443' -r
complete -c deno -n "__fish_deno_using_subcommand serve" -l inspect -d 'Activate inspector on host:port [default: 127.0.0.1:9229]' -r
complete -c deno -n "__fish_deno_using_subcommand serve" -l inspect-brk -d 'Activate inspector on host:port, wait for debugger to connect and break at the start of user script' -r
complete -c deno -n "__fish_deno_using_subcommand serve" -l inspect-wait -d 'Activate inspector on host:port and wait for debugger to connect before running user code' -r
complete -c deno -n "__fish_deno_using_subcommand serve" -l allow-scripts -d 'Allow running npm lifecycle scripts for the given packages   Note: Scripts will only be executed when using a node_modules directory (`--node-modules-dir`)' -r
complete -c deno -n "__fish_deno_using_subcommand serve" -l frozen -d 'Error out if lockfile is out of date' -r -f -a "{true\t'',false\t''}"
complete -c deno -n "__fish_deno_using_subcommand serve" -l location -d 'Value of globalThis.location used by some web APIs' -r -f
complete -c deno -n "__fish_deno_using_subcommand serve" -l v8-flags -d 'To see a list of all available flags use --v8-flags=--help   Flags can also be set via the DENO_V8_FLAGS environment variable.   Any flags set with this flag are appended after the DENO_V8_FLAGS environment variable' -r
complete -c deno -n "__fish_deno_using_subcommand serve" -l seed -d 'Set the random number generator seed' -r
complete -c deno -n "__fish_deno_using_subcommand serve" -l strace-ops -d 'Trace low-level op calls' -r
complete -c deno -n "__fish_deno_using_subcommand serve" -l port -d 'The TCP port to serve on. Pass 0 to pick a random free port [default: 8000]' -r
complete -c deno -n "__fish_deno_using_subcommand serve" -l host -d 'The TCP address to serve on, defaulting to 0.0.0.0 (all interfaces)' -r
complete -c deno -n "__fish_deno_using_subcommand serve" -l check -d 'Enable type-checking. This subcommand does not type-check by default   If the value of "all" is supplied, remote modules will be included.   Alternatively, the \'deno check\' subcommand can be used' -r
complete -c deno -n "__fish_deno_using_subcommand serve" -l watch -d 'Watch for file changes and restart process automatically.   Local files from entry point module graph are watched by default.   Additional paths might be watched by passing them as arguments to this flag.' -r -F
complete -c deno -n "__fish_deno_using_subcommand serve" -l watch-hmr -d 'Watch for file changes and restart process automatically.   Local files from entry point module graph are watched by default.   Additional paths might be watched by passing them as arguments to this flag.' -r -F
complete -c deno -n "__fish_deno_using_subcommand serve" -l watch-exclude -d 'Exclude provided files/patterns from watch mode' -r -F
complete -c deno -n "__fish_deno_using_subcommand serve" -l ext -d 'Set content type of the supplied file' -r -f -a "{ts\t'',tsx\t'',js\t'',jsx\t''}"
complete -c deno -n "__fish_deno_using_subcommand serve" -l env-file -d 'Load environment variables from local file   Only the first environment variable with a given key is used.   Existing process environment variables are not overwritten.' -r -F
complete -c deno -n "__fish_deno_using_subcommand serve" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand serve" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand serve" -l unstable -d 'Enable all unstable features and APIs. Instead of using this flag, consider enabling individual unstable features   To view the list of individual unstable feature flags, run this command again with --help=unstable'
complete -c deno -n "__fish_deno_using_subcommand serve" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_deno_using_subcommand serve" -l unstable-detect-cjs -d 'Reads the package.json type field in a project to treat .js files as .cjs'
complete -c deno -n "__fish_deno_using_subcommand serve" -l unstable-byonm
complete -c deno -n "__fish_deno_using_subcommand serve" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing'
complete -c deno -n "__fish_deno_using_subcommand serve" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_deno_using_subcommand serve" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_deno_using_subcommand serve" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_deno_using_subcommand serve" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_deno_using_subcommand serve" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_deno_using_subcommand serve" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_deno_using_subcommand serve" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_deno_using_subcommand serve" -l unstable-process -d 'Enable unstable process APIs'
complete -c deno -n "__fish_deno_using_subcommand serve" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_deno_using_subcommand serve" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_deno_using_subcommand serve" -l unstable-webgpu -d 'Enable unstable `WebGPU` APIs'
complete -c deno -n "__fish_deno_using_subcommand serve" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_deno_using_subcommand serve" -l no-remote -d 'Do not resolve remote modules'
complete -c deno -n "__fish_deno_using_subcommand serve" -l no-npm -d 'Do not resolve npm modules'
complete -c deno -n "__fish_deno_using_subcommand serve" -l no-config -d 'Disable automatic loading of the configuration file'
complete -c deno -n "__fish_deno_using_subcommand serve" -l no-lock -d 'Disable auto discovery of the lock file'
complete -c deno -n "__fish_deno_using_subcommand serve" -s A -l allow-all -d 'Allow all permissions'
complete -c deno -n "__fish_deno_using_subcommand serve" -l allow-hrtime -d 'REMOVED in Deno 2.0'
complete -c deno -n "__fish_deno_using_subcommand serve" -l deny-hrtime -d 'REMOVED in Deno 2.0'
complete -c deno -n "__fish_deno_using_subcommand serve" -l no-prompt -d 'Always throw if required permission wasn\'t passed'
complete -c deno -n "__fish_deno_using_subcommand serve" -l cached-only -d 'Require that remote dependencies are already cached'
complete -c deno -n "__fish_deno_using_subcommand serve" -l enable-testing-features-do-not-use -d 'INTERNAL: Enable internal features used during integration testing'
complete -c deno -n "__fish_deno_using_subcommand serve" -l parallel -d 'Run multiple server workers in parallel. Parallelism defaults to the number of available CPUs or the value of the DENO_JOBS environment variable'
complete -c deno -n "__fish_deno_using_subcommand serve" -l no-clear-screen -d 'Do not clear terminal screen when under watch mode'
complete -c deno -n "__fish_deno_using_subcommand serve" -l no-code-cache -d 'Disable V8 code cache feature'
complete -c deno -n "__fish_deno_using_subcommand serve" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand add" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand add" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand add" -l allow-scripts -d 'Allow running npm lifecycle scripts for the given packages   Note: Scripts will only be executed when using a node_modules directory (`--node-modules-dir`)' -r
complete -c deno -n "__fish_deno_using_subcommand add" -l unstable -d 'Enable all unstable features and APIs. Instead of using this flag, consider enabling individual unstable features   To view the list of individual unstable feature flags, run this command again with --help=unstable'
complete -c deno -n "__fish_deno_using_subcommand add" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_deno_using_subcommand add" -l unstable-detect-cjs -d 'Reads the package.json type field in a project to treat .js files as .cjs'
complete -c deno -n "__fish_deno_using_subcommand add" -l unstable-byonm
complete -c deno -n "__fish_deno_using_subcommand add" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing'
complete -c deno -n "__fish_deno_using_subcommand add" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_deno_using_subcommand add" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_deno_using_subcommand add" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_deno_using_subcommand add" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_deno_using_subcommand add" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_deno_using_subcommand add" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_deno_using_subcommand add" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_deno_using_subcommand add" -l unstable-process -d 'Enable unstable process APIs'
complete -c deno -n "__fish_deno_using_subcommand add" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_deno_using_subcommand add" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_deno_using_subcommand add" -l unstable-webgpu -d 'Enable unstable `WebGPU` APIs'
complete -c deno -n "__fish_deno_using_subcommand add" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_deno_using_subcommand add" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand add" -s D -l dev -d 'Add as a dev dependency'
complete -c deno -n "__fish_deno_using_subcommand remove" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand remove" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand remove" -l unstable -d 'Enable all unstable features and APIs. Instead of using this flag, consider enabling individual unstable features   To view the list of individual unstable feature flags, run this command again with --help=unstable'
complete -c deno -n "__fish_deno_using_subcommand remove" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_deno_using_subcommand remove" -l unstable-detect-cjs -d 'Reads the package.json type field in a project to treat .js files as .cjs'
complete -c deno -n "__fish_deno_using_subcommand remove" -l unstable-byonm
complete -c deno -n "__fish_deno_using_subcommand remove" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing'
complete -c deno -n "__fish_deno_using_subcommand remove" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_deno_using_subcommand remove" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_deno_using_subcommand remove" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_deno_using_subcommand remove" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_deno_using_subcommand remove" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_deno_using_subcommand remove" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_deno_using_subcommand remove" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_deno_using_subcommand remove" -l unstable-process -d 'Enable unstable process APIs'
complete -c deno -n "__fish_deno_using_subcommand remove" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_deno_using_subcommand remove" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_deno_using_subcommand remove" -l unstable-webgpu -d 'Enable unstable `WebGPU` APIs'
complete -c deno -n "__fish_deno_using_subcommand remove" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_deno_using_subcommand remove" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand bench" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand bench" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand bench" -l no-check -d 'Skip type-checking. If the value of "remote" is supplied, diagnostic errors from remote modules will be ignored' -r
complete -c deno -n "__fish_deno_using_subcommand bench" -l import-map -d 'Load import map file from local file or remote URL   Docs: https://docs.deno.com/runtime/manual/basics/import_maps' -r -F
complete -c deno -n "__fish_deno_using_subcommand bench" -l node-modules-dir -d 'Sets the node modules management mode for npm packages' -r
complete -c deno -n "__fish_deno_using_subcommand bench" -l vendor -d 'Toggles local vendor folder usage for remote modules and a node_modules folder for npm packages' -r -f -a "{true\t'',false\t''}"
complete -c deno -n "__fish_deno_using_subcommand bench" -s c -l config -d 'Configure different aspects of deno including TypeScript, linting, and code formatting   Typically the configuration file will be called `deno.json` or `deno.jsonc` and   automatically detected; in that case this flag is not necessary.   Docs: https://docs.deno.com/go/config' -r -F
complete -c deno -n "__fish_deno_using_subcommand bench" -s r -l reload -d 'Reload source code cache (recompile TypeScript)   no value                                                 Reload everything   jsr:@std/http/file-server,jsr:@std/assert/assert-equals  Reloads specific modules   npm:                                                     Reload all npm modules   npm:chalk                                                Reload specific npm module' -r -F
complete -c deno -n "__fish_deno_using_subcommand bench" -l lock -d 'Check the specified lock file. (If value is not provided, defaults to "./deno.lock")' -r -F
complete -c deno -n "__fish_deno_using_subcommand bench" -l cert -d 'Load certificate authority from PEM encoded file' -r -F
complete -c deno -n "__fish_deno_using_subcommand bench" -l unsafely-ignore-certificate-errors -d 'DANGER: Disables verification of TLS certificates' -r
complete -c deno -n "__fish_deno_using_subcommand bench" -s R -l allow-read -d 'Allow file system read access. Optionally specify allowed paths' -r -F
complete -c deno -n "__fish_deno_using_subcommand bench" -l deny-read -d 'Deny file system read access. Optionally specify denied paths' -r -F
complete -c deno -n "__fish_deno_using_subcommand bench" -s W -l allow-write -d 'Allow file system write access. Optionally specify allowed paths' -r -F
complete -c deno -n "__fish_deno_using_subcommand bench" -l deny-write -d 'Deny file system write access. Optionally specify denied paths' -r -F
complete -c deno -n "__fish_deno_using_subcommand bench" -s N -l allow-net -d 'Allow network access. Optionally specify allowed IP addresses and host names, with ports as necessary' -r
complete -c deno -n "__fish_deno_using_subcommand bench" -l deny-net -d 'Deny network access. Optionally specify denied IP addresses and host names, with ports as necessary' -r
complete -c deno -n "__fish_deno_using_subcommand bench" -s E -l allow-env -d 'Allow access to system environment information. Optionally specify accessible environment variables' -r
complete -c deno -n "__fish_deno_using_subcommand bench" -l deny-env -d 'Deny access to system environment information. Optionally specify accessible environment variables' -r
complete -c deno -n "__fish_deno_using_subcommand bench" -s S -l allow-sys -d 'Allow access to OS information. Optionally allow specific APIs by function name' -r
complete -c deno -n "__fish_deno_using_subcommand bench" -l deny-sys -d 'Deny access to OS information. Optionally deny specific APIs by function name' -r
complete -c deno -n "__fish_deno_using_subcommand bench" -l allow-run -d 'Allow running subprocesses. Optionally specify allowed runnable program names' -r
complete -c deno -n "__fish_deno_using_subcommand bench" -l deny-run -d 'Deny running subprocesses. Optionally specify denied runnable program names' -r
complete -c deno -n "__fish_deno_using_subcommand bench" -l allow-ffi -d '(Unstable) Allow loading dynamic libraries. Optionally specify allowed directories or files' -r -F
complete -c deno -n "__fish_deno_using_subcommand bench" -l deny-ffi -d '(Unstable) Deny loading dynamic libraries. Optionally specify denied directories or files' -r -F
complete -c deno -n "__fish_deno_using_subcommand bench" -s I -l allow-import -d 'Allow importing from remote hosts. Optionally specify allowed IP addresses and host names, with ports as necessary. Default value: deno.land:443,jsr.io:443,esm.sh:443,cdn.jsdelivr.net:443,raw.githubusercontent.com:443,user.githubusercontent.com:443' -r
complete -c deno -n "__fish_deno_using_subcommand bench" -l allow-scripts -d 'Allow running npm lifecycle scripts for the given packages   Note: Scripts will only be executed when using a node_modules directory (`--node-modules-dir`)' -r
complete -c deno -n "__fish_deno_using_subcommand bench" -l frozen -d 'Error out if lockfile is out of date' -r -f -a "{true\t'',false\t''}"
complete -c deno -n "__fish_deno_using_subcommand bench" -l location -d 'Value of globalThis.location used by some web APIs' -r -f
complete -c deno -n "__fish_deno_using_subcommand bench" -l v8-flags -d 'To see a list of all available flags use --v8-flags=--help   Flags can also be set via the DENO_V8_FLAGS environment variable.   Any flags set with this flag are appended after the DENO_V8_FLAGS environment variable' -r
complete -c deno -n "__fish_deno_using_subcommand bench" -l seed -d 'Set the random number generator seed' -r
complete -c deno -n "__fish_deno_using_subcommand bench" -l strace-ops -d 'Trace low-level op calls' -r
complete -c deno -n "__fish_deno_using_subcommand bench" -l check -d 'Set type-checking behavior. This subcommand type-checks local modules by default, so adding --check is redundant   If the value of "all" is supplied, remote modules will be included.   Alternatively, the \'deno check\' subcommand can be used' -r
complete -c deno -n "__fish_deno_using_subcommand bench" -l ignore -d 'Ignore files' -r
complete -c deno -n "__fish_deno_using_subcommand bench" -l filter -d 'Run benchmarks with this string or regexp pattern in the bench name' -r
complete -c deno -n "__fish_deno_using_subcommand bench" -l watch-exclude -d 'Exclude provided files/patterns from watch mode' -r -F
complete -c deno -n "__fish_deno_using_subcommand bench" -l env-file -d 'Load environment variables from local file   Only the first environment variable with a given key is used.   Existing process environment variables are not overwritten.' -r -F
complete -c deno -n "__fish_deno_using_subcommand bench" -l ext -d 'Set content type of the supplied file' -r -f -a "{ts\t'',tsx\t'',js\t'',jsx\t''}"
complete -c deno -n "__fish_deno_using_subcommand bench" -l unstable -d 'Enable all unstable features and APIs. Instead of using this flag, consider enabling individual unstable features   To view the list of individual unstable feature flags, run this command again with --help=unstable'
complete -c deno -n "__fish_deno_using_subcommand bench" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_deno_using_subcommand bench" -l unstable-detect-cjs -d 'Reads the package.json type field in a project to treat .js files as .cjs'
complete -c deno -n "__fish_deno_using_subcommand bench" -l unstable-byonm
complete -c deno -n "__fish_deno_using_subcommand bench" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing'
complete -c deno -n "__fish_deno_using_subcommand bench" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_deno_using_subcommand bench" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_deno_using_subcommand bench" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_deno_using_subcommand bench" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_deno_using_subcommand bench" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_deno_using_subcommand bench" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_deno_using_subcommand bench" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_deno_using_subcommand bench" -l unstable-process -d 'Enable unstable process APIs'
complete -c deno -n "__fish_deno_using_subcommand bench" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_deno_using_subcommand bench" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_deno_using_subcommand bench" -l unstable-webgpu -d 'Enable unstable `WebGPU` APIs'
complete -c deno -n "__fish_deno_using_subcommand bench" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_deno_using_subcommand bench" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand bench" -l no-remote -d 'Do not resolve remote modules'
complete -c deno -n "__fish_deno_using_subcommand bench" -l no-npm -d 'Do not resolve npm modules'
complete -c deno -n "__fish_deno_using_subcommand bench" -l no-config -d 'Disable automatic loading of the configuration file'
complete -c deno -n "__fish_deno_using_subcommand bench" -l no-lock -d 'Disable auto discovery of the lock file'
complete -c deno -n "__fish_deno_using_subcommand bench" -s A -l allow-all -d 'Allow all permissions'
complete -c deno -n "__fish_deno_using_subcommand bench" -l allow-hrtime -d 'REMOVED in Deno 2.0'
complete -c deno -n "__fish_deno_using_subcommand bench" -l deny-hrtime -d 'REMOVED in Deno 2.0'
complete -c deno -n "__fish_deno_using_subcommand bench" -l no-prompt -d 'Always throw if required permission wasn\'t passed'
complete -c deno -n "__fish_deno_using_subcommand bench" -l cached-only -d 'Require that remote dependencies are already cached'
complete -c deno -n "__fish_deno_using_subcommand bench" -l enable-testing-features-do-not-use -d 'INTERNAL: Enable internal features used during integration testing'
complete -c deno -n "__fish_deno_using_subcommand bench" -l json -d 'UNSTABLE: Output benchmark result in JSON format'
complete -c deno -n "__fish_deno_using_subcommand bench" -l no-run -d 'Cache bench modules, but don\'t run benchmarks'
complete -c deno -n "__fish_deno_using_subcommand bench" -l watch -d 'Watch for file changes and restart process automatically.   Only local files from entry point module graph are watched.'
complete -c deno -n "__fish_deno_using_subcommand bench" -l no-clear-screen -d 'Do not clear terminal screen when under watch mode'
complete -c deno -n "__fish_deno_using_subcommand bundle" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand bundle" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand bundle" -l unstable -d 'Enable all unstable features and APIs. Instead of using this flag, consider enabling individual unstable features   To view the list of individual unstable feature flags, run this command again with --help=unstable'
complete -c deno -n "__fish_deno_using_subcommand bundle" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_deno_using_subcommand bundle" -l unstable-detect-cjs -d 'Reads the package.json type field in a project to treat .js files as .cjs'
complete -c deno -n "__fish_deno_using_subcommand bundle" -l unstable-byonm
complete -c deno -n "__fish_deno_using_subcommand bundle" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing'
complete -c deno -n "__fish_deno_using_subcommand bundle" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_deno_using_subcommand bundle" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_deno_using_subcommand bundle" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_deno_using_subcommand bundle" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_deno_using_subcommand bundle" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_deno_using_subcommand bundle" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_deno_using_subcommand bundle" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_deno_using_subcommand bundle" -l unstable-process -d 'Enable unstable process APIs'
complete -c deno -n "__fish_deno_using_subcommand bundle" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_deno_using_subcommand bundle" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_deno_using_subcommand bundle" -l unstable-webgpu -d 'Enable unstable `WebGPU` APIs'
complete -c deno -n "__fish_deno_using_subcommand bundle" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_deno_using_subcommand bundle" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand cache" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand cache" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand cache" -l no-check -d 'Skip type-checking. If the value of "remote" is supplied, diagnostic errors from remote modules will be ignored' -r
complete -c deno -n "__fish_deno_using_subcommand cache" -l import-map -d 'Load import map file from local file or remote URL   Docs: https://docs.deno.com/runtime/manual/basics/import_maps' -r -F
complete -c deno -n "__fish_deno_using_subcommand cache" -l node-modules-dir -d 'Sets the node modules management mode for npm packages' -r
complete -c deno -n "__fish_deno_using_subcommand cache" -l vendor -d 'Toggles local vendor folder usage for remote modules and a node_modules folder for npm packages' -r -f -a "{true\t'',false\t''}"
complete -c deno -n "__fish_deno_using_subcommand cache" -s c -l config -d 'Configure different aspects of deno including TypeScript, linting, and code formatting   Typically the configuration file will be called `deno.json` or `deno.jsonc` and   automatically detected; in that case this flag is not necessary.   Docs: https://docs.deno.com/go/config' -r -F
complete -c deno -n "__fish_deno_using_subcommand cache" -s r -l reload -d 'Reload source code cache (recompile TypeScript)   no value                                                 Reload everything   jsr:@std/http/file-server,jsr:@std/assert/assert-equals  Reloads specific modules   npm:                                                     Reload all npm modules   npm:chalk                                                Reload specific npm module' -r -F
complete -c deno -n "__fish_deno_using_subcommand cache" -l lock -d 'Check the specified lock file. (If value is not provided, defaults to "./deno.lock")' -r -F
complete -c deno -n "__fish_deno_using_subcommand cache" -l cert -d 'Load certificate authority from PEM encoded file' -r -F
complete -c deno -n "__fish_deno_using_subcommand cache" -l unsafely-ignore-certificate-errors -d 'DANGER: Disables verification of TLS certificates' -r
complete -c deno -n "__fish_deno_using_subcommand cache" -l check -d 'Enable type-checking. This subcommand does not type-check by default   If the value of "all" is supplied, remote modules will be included.   Alternatively, the \'deno check\' subcommand can be used' -r
complete -c deno -n "__fish_deno_using_subcommand cache" -l frozen -d 'Error out if lockfile is out of date' -r -f -a "{true\t'',false\t''}"
complete -c deno -n "__fish_deno_using_subcommand cache" -l allow-scripts -d 'Allow running npm lifecycle scripts for the given packages   Note: Scripts will only be executed when using a node_modules directory (`--node-modules-dir`)' -r
complete -c deno -n "__fish_deno_using_subcommand cache" -s I -l allow-import -d 'Allow importing from remote hosts. Optionally specify allowed IP addresses and host names, with ports as necessary. Default value: deno.land:443,jsr.io:443,esm.sh:443,cdn.jsdelivr.net:443,raw.githubusercontent.com:443,user.githubusercontent.com:443' -r
complete -c deno -n "__fish_deno_using_subcommand cache" -l unstable -d 'Enable all unstable features and APIs. Instead of using this flag, consider enabling individual unstable features   To view the list of individual unstable feature flags, run this command again with --help=unstable'
complete -c deno -n "__fish_deno_using_subcommand cache" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_deno_using_subcommand cache" -l unstable-detect-cjs -d 'Reads the package.json type field in a project to treat .js files as .cjs'
complete -c deno -n "__fish_deno_using_subcommand cache" -l unstable-byonm
complete -c deno -n "__fish_deno_using_subcommand cache" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing'
complete -c deno -n "__fish_deno_using_subcommand cache" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_deno_using_subcommand cache" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_deno_using_subcommand cache" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_deno_using_subcommand cache" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_deno_using_subcommand cache" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_deno_using_subcommand cache" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_deno_using_subcommand cache" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_deno_using_subcommand cache" -l unstable-process -d 'Enable unstable process APIs'
complete -c deno -n "__fish_deno_using_subcommand cache" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_deno_using_subcommand cache" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_deno_using_subcommand cache" -l unstable-webgpu -d 'Enable unstable `WebGPU` APIs'
complete -c deno -n "__fish_deno_using_subcommand cache" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_deno_using_subcommand cache" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand cache" -l no-remote -d 'Do not resolve remote modules'
complete -c deno -n "__fish_deno_using_subcommand cache" -l no-npm -d 'Do not resolve npm modules'
complete -c deno -n "__fish_deno_using_subcommand cache" -l no-config -d 'Disable automatic loading of the configuration file'
complete -c deno -n "__fish_deno_using_subcommand cache" -l no-lock -d 'Disable auto discovery of the lock file'
complete -c deno -n "__fish_deno_using_subcommand check" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand check" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand check" -l import-map -d 'Load import map file from local file or remote URL   Docs: https://docs.deno.com/runtime/manual/basics/import_maps' -r -F
complete -c deno -n "__fish_deno_using_subcommand check" -l node-modules-dir -d 'Sets the node modules management mode for npm packages' -r
complete -c deno -n "__fish_deno_using_subcommand check" -l vendor -d 'Toggles local vendor folder usage for remote modules and a node_modules folder for npm packages' -r -f -a "{true\t'',false\t''}"
complete -c deno -n "__fish_deno_using_subcommand check" -s c -l config -d 'Configure different aspects of deno including TypeScript, linting, and code formatting   Typically the configuration file will be called `deno.json` or `deno.jsonc` and   automatically detected; in that case this flag is not necessary.   Docs: https://docs.deno.com/go/config' -r -F
complete -c deno -n "__fish_deno_using_subcommand check" -s r -l reload -d 'Reload source code cache (recompile TypeScript)   no value                                                 Reload everything   jsr:@std/http/file-server,jsr:@std/assert/assert-equals  Reloads specific modules   npm:                                                     Reload all npm modules   npm:chalk                                                Reload specific npm module' -r -F
complete -c deno -n "__fish_deno_using_subcommand check" -l lock -d 'Check the specified lock file. (If value is not provided, defaults to "./deno.lock")' -r -F
complete -c deno -n "__fish_deno_using_subcommand check" -l cert -d 'Load certificate authority from PEM encoded file' -r -F
complete -c deno -n "__fish_deno_using_subcommand check" -l unsafely-ignore-certificate-errors -d 'DANGER: Disables verification of TLS certificates' -r
complete -c deno -n "__fish_deno_using_subcommand check" -l frozen -d 'Error out if lockfile is out of date' -r -f -a "{true\t'',false\t''}"
complete -c deno -n "__fish_deno_using_subcommand check" -s I -l allow-import -d 'Allow importing from remote hosts. Optionally specify allowed IP addresses and host names, with ports as necessary. Default value: deno.land:443,jsr.io:443,esm.sh:443,cdn.jsdelivr.net:443,raw.githubusercontent.com:443,user.githubusercontent.com:443' -r
complete -c deno -n "__fish_deno_using_subcommand check" -l unstable -d 'Enable all unstable features and APIs. Instead of using this flag, consider enabling individual unstable features   To view the list of individual unstable feature flags, run this command again with --help=unstable'
complete -c deno -n "__fish_deno_using_subcommand check" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_deno_using_subcommand check" -l unstable-detect-cjs -d 'Reads the package.json type field in a project to treat .js files as .cjs'
complete -c deno -n "__fish_deno_using_subcommand check" -l unstable-byonm
complete -c deno -n "__fish_deno_using_subcommand check" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing'
complete -c deno -n "__fish_deno_using_subcommand check" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_deno_using_subcommand check" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_deno_using_subcommand check" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_deno_using_subcommand check" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_deno_using_subcommand check" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_deno_using_subcommand check" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_deno_using_subcommand check" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_deno_using_subcommand check" -l unstable-process -d 'Enable unstable process APIs'
complete -c deno -n "__fish_deno_using_subcommand check" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_deno_using_subcommand check" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_deno_using_subcommand check" -l unstable-webgpu -d 'Enable unstable `WebGPU` APIs'
complete -c deno -n "__fish_deno_using_subcommand check" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_deno_using_subcommand check" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand check" -l no-remote -d 'Do not resolve remote modules'
complete -c deno -n "__fish_deno_using_subcommand check" -l no-npm -d 'Do not resolve npm modules'
complete -c deno -n "__fish_deno_using_subcommand check" -l no-config -d 'Disable automatic loading of the configuration file'
complete -c deno -n "__fish_deno_using_subcommand check" -l no-lock -d 'Disable auto discovery of the lock file'
complete -c deno -n "__fish_deno_using_subcommand check" -l all -d 'Type-check all code, including remote modules and npm packages'
complete -c deno -n "__fish_deno_using_subcommand check" -l remote -d 'Type-check all modules, including remote ones'
complete -c deno -n "__fish_deno_using_subcommand check" -l doc -d 'Type-check code blocks in JSDoc as well as actual code'
complete -c deno -n "__fish_deno_using_subcommand check" -l doc-only -d 'Type-check code blocks in JSDoc and Markdown only'
complete -c deno -n "__fish_deno_using_subcommand clean" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand clean" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand clean" -l unstable -d 'Enable all unstable features and APIs. Instead of using this flag, consider enabling individual unstable features   To view the list of individual unstable feature flags, run this command again with --help=unstable'
complete -c deno -n "__fish_deno_using_subcommand clean" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_deno_using_subcommand clean" -l unstable-detect-cjs -d 'Reads the package.json type field in a project to treat .js files as .cjs'
complete -c deno -n "__fish_deno_using_subcommand clean" -l unstable-byonm
complete -c deno -n "__fish_deno_using_subcommand clean" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing'
complete -c deno -n "__fish_deno_using_subcommand clean" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_deno_using_subcommand clean" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_deno_using_subcommand clean" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_deno_using_subcommand clean" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_deno_using_subcommand clean" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_deno_using_subcommand clean" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_deno_using_subcommand clean" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_deno_using_subcommand clean" -l unstable-process -d 'Enable unstable process APIs'
complete -c deno -n "__fish_deno_using_subcommand clean" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_deno_using_subcommand clean" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_deno_using_subcommand clean" -l unstable-webgpu -d 'Enable unstable `WebGPU` APIs'
complete -c deno -n "__fish_deno_using_subcommand clean" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_deno_using_subcommand clean" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand compile" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand compile" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand compile" -l no-check -d 'Skip type-checking. If the value of "remote" is supplied, diagnostic errors from remote modules will be ignored' -r
complete -c deno -n "__fish_deno_using_subcommand compile" -l import-map -d 'Load import map file from local file or remote URL   Docs: https://docs.deno.com/runtime/manual/basics/import_maps' -r -F
complete -c deno -n "__fish_deno_using_subcommand compile" -l node-modules-dir -d 'Sets the node modules management mode for npm packages' -r
complete -c deno -n "__fish_deno_using_subcommand compile" -l vendor -d 'Toggles local vendor folder usage for remote modules and a node_modules folder for npm packages' -r -f -a "{true\t'',false\t''}"
complete -c deno -n "__fish_deno_using_subcommand compile" -s c -l config -d 'Configure different aspects of deno including TypeScript, linting, and code formatting   Typically the configuration file will be called `deno.json` or `deno.jsonc` and   automatically detected; in that case this flag is not necessary.   Docs: https://docs.deno.com/go/config' -r -F
complete -c deno -n "__fish_deno_using_subcommand compile" -s r -l reload -d 'Reload source code cache (recompile TypeScript)   no value                                                 Reload everything   jsr:@std/http/file-server,jsr:@std/assert/assert-equals  Reloads specific modules   npm:                                                     Reload all npm modules   npm:chalk                                                Reload specific npm module' -r -F
complete -c deno -n "__fish_deno_using_subcommand compile" -l lock -d 'Check the specified lock file. (If value is not provided, defaults to "./deno.lock")' -r -F
complete -c deno -n "__fish_deno_using_subcommand compile" -l cert -d 'Load certificate authority from PEM encoded file' -r -F
complete -c deno -n "__fish_deno_using_subcommand compile" -l unsafely-ignore-certificate-errors -d 'DANGER: Disables verification of TLS certificates' -r
complete -c deno -n "__fish_deno_using_subcommand compile" -s R -l allow-read -d 'Allow file system read access. Optionally specify allowed paths' -r -F
complete -c deno -n "__fish_deno_using_subcommand compile" -l deny-read -d 'Deny file system read access. Optionally specify denied paths' -r -F
complete -c deno -n "__fish_deno_using_subcommand compile" -s W -l allow-write -d 'Allow file system write access. Optionally specify allowed paths' -r -F
complete -c deno -n "__fish_deno_using_subcommand compile" -l deny-write -d 'Deny file system write access. Optionally specify denied paths' -r -F
complete -c deno -n "__fish_deno_using_subcommand compile" -s N -l allow-net -d 'Allow network access. Optionally specify allowed IP addresses and host names, with ports as necessary' -r
complete -c deno -n "__fish_deno_using_subcommand compile" -l deny-net -d 'Deny network access. Optionally specify denied IP addresses and host names, with ports as necessary' -r
complete -c deno -n "__fish_deno_using_subcommand compile" -s E -l allow-env -d 'Allow access to system environment information. Optionally specify accessible environment variables' -r
complete -c deno -n "__fish_deno_using_subcommand compile" -l deny-env -d 'Deny access to system environment information. Optionally specify accessible environment variables' -r
complete -c deno -n "__fish_deno_using_subcommand compile" -s S -l allow-sys -d 'Allow access to OS information. Optionally allow specific APIs by function name' -r
complete -c deno -n "__fish_deno_using_subcommand compile" -l deny-sys -d 'Deny access to OS information. Optionally deny specific APIs by function name' -r
complete -c deno -n "__fish_deno_using_subcommand compile" -l allow-run -d 'Allow running subprocesses. Optionally specify allowed runnable program names' -r
complete -c deno -n "__fish_deno_using_subcommand compile" -l deny-run -d 'Deny running subprocesses. Optionally specify denied runnable program names' -r
complete -c deno -n "__fish_deno_using_subcommand compile" -l allow-ffi -d '(Unstable) Allow loading dynamic libraries. Optionally specify allowed directories or files' -r -F
complete -c deno -n "__fish_deno_using_subcommand compile" -l deny-ffi -d '(Unstable) Deny loading dynamic libraries. Optionally specify denied directories or files' -r -F
complete -c deno -n "__fish_deno_using_subcommand compile" -s I -l allow-import -d 'Allow importing from remote hosts. Optionally specify allowed IP addresses and host names, with ports as necessary. Default value: deno.land:443,jsr.io:443,esm.sh:443,cdn.jsdelivr.net:443,raw.githubusercontent.com:443,user.githubusercontent.com:443' -r
complete -c deno -n "__fish_deno_using_subcommand compile" -l allow-scripts -d 'Allow running npm lifecycle scripts for the given packages   Note: Scripts will only be executed when using a node_modules directory (`--node-modules-dir`)' -r
complete -c deno -n "__fish_deno_using_subcommand compile" -l frozen -d 'Error out if lockfile is out of date' -r -f -a "{true\t'',false\t''}"
complete -c deno -n "__fish_deno_using_subcommand compile" -l location -d 'Value of globalThis.location used by some web APIs' -r -f
complete -c deno -n "__fish_deno_using_subcommand compile" -l v8-flags -d 'To see a list of all available flags use --v8-flags=--help   Flags can also be set via the DENO_V8_FLAGS environment variable.   Any flags set with this flag are appended after the DENO_V8_FLAGS environment variable' -r
complete -c deno -n "__fish_deno_using_subcommand compile" -l seed -d 'Set the random number generator seed' -r
complete -c deno -n "__fish_deno_using_subcommand compile" -l strace-ops -d 'Trace low-level op calls' -r
complete -c deno -n "__fish_deno_using_subcommand compile" -l check -d 'Set type-checking behavior. This subcommand type-checks local modules by default, so adding --check is redundant   If the value of "all" is supplied, remote modules will be included.   Alternatively, the \'deno check\' subcommand can be used' -r
complete -c deno -n "__fish_deno_using_subcommand compile" -l include -d 'Includes an additional module in the compiled executable\'s module graph.   Use this flag if a dynamically imported module or a web worker main module   fails to load in the executable. This flag can be passed multiple times,   to include multiple additional modules.' -r -F
complete -c deno -n "__fish_deno_using_subcommand compile" -s o -l output -d 'Output file (defaults to $PWD/<inferred-name>)' -r -F
complete -c deno -n "__fish_deno_using_subcommand compile" -l target -d 'Target OS architecture' -r -f -a "{x86_64-unknown-linux-gnu\t'',aarch64-unknown-linux-gnu\t'',x86_64-pc-windows-msvc\t'',x86_64-apple-darwin\t'',aarch64-apple-darwin\t''}"
complete -c deno -n "__fish_deno_using_subcommand compile" -l icon -d 'Set the icon of the executable on Windows (.ico)' -r
complete -c deno -n "__fish_deno_using_subcommand compile" -l ext -d 'Set content type of the supplied file' -r -f -a "{ts\t'',tsx\t'',js\t'',jsx\t''}"
complete -c deno -n "__fish_deno_using_subcommand compile" -l env-file -d 'Load environment variables from local file   Only the first environment variable with a given key is used.   Existing process environment variables are not overwritten.' -r -F
complete -c deno -n "__fish_deno_using_subcommand compile" -l unstable -d 'Enable all unstable features and APIs. Instead of using this flag, consider enabling individual unstable features   To view the list of individual unstable feature flags, run this command again with --help=unstable'
complete -c deno -n "__fish_deno_using_subcommand compile" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_deno_using_subcommand compile" -l unstable-detect-cjs -d 'Reads the package.json type field in a project to treat .js files as .cjs'
complete -c deno -n "__fish_deno_using_subcommand compile" -l unstable-byonm
complete -c deno -n "__fish_deno_using_subcommand compile" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing'
complete -c deno -n "__fish_deno_using_subcommand compile" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_deno_using_subcommand compile" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_deno_using_subcommand compile" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_deno_using_subcommand compile" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_deno_using_subcommand compile" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_deno_using_subcommand compile" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_deno_using_subcommand compile" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_deno_using_subcommand compile" -l unstable-process -d 'Enable unstable process APIs'
complete -c deno -n "__fish_deno_using_subcommand compile" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_deno_using_subcommand compile" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_deno_using_subcommand compile" -l unstable-webgpu -d 'Enable unstable `WebGPU` APIs'
complete -c deno -n "__fish_deno_using_subcommand compile" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_deno_using_subcommand compile" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand compile" -l no-remote -d 'Do not resolve remote modules'
complete -c deno -n "__fish_deno_using_subcommand compile" -l no-npm -d 'Do not resolve npm modules'
complete -c deno -n "__fish_deno_using_subcommand compile" -l no-config -d 'Disable automatic loading of the configuration file'
complete -c deno -n "__fish_deno_using_subcommand compile" -l no-lock -d 'Disable auto discovery of the lock file'
complete -c deno -n "__fish_deno_using_subcommand compile" -s A -l allow-all -d 'Allow all permissions'
complete -c deno -n "__fish_deno_using_subcommand compile" -l allow-hrtime -d 'REMOVED in Deno 2.0'
complete -c deno -n "__fish_deno_using_subcommand compile" -l deny-hrtime -d 'REMOVED in Deno 2.0'
complete -c deno -n "__fish_deno_using_subcommand compile" -l no-prompt -d 'Always throw if required permission wasn\'t passed'
complete -c deno -n "__fish_deno_using_subcommand compile" -l cached-only -d 'Require that remote dependencies are already cached'
complete -c deno -n "__fish_deno_using_subcommand compile" -l enable-testing-features-do-not-use -d 'INTERNAL: Enable internal features used during integration testing'
complete -c deno -n "__fish_deno_using_subcommand compile" -l no-terminal -d 'Hide terminal on Windows'
complete -c deno -n "__fish_deno_using_subcommand completions" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand completions" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand completions" -l unstable -d 'Enable all unstable features and APIs. Instead of using this flag, consider enabling individual unstable features   To view the list of individual unstable feature flags, run this command again with --help=unstable'
complete -c deno -n "__fish_deno_using_subcommand completions" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_deno_using_subcommand completions" -l unstable-detect-cjs -d 'Reads the package.json type field in a project to treat .js files as .cjs'
complete -c deno -n "__fish_deno_using_subcommand completions" -l unstable-byonm
complete -c deno -n "__fish_deno_using_subcommand completions" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing'
complete -c deno -n "__fish_deno_using_subcommand completions" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_deno_using_subcommand completions" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_deno_using_subcommand completions" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_deno_using_subcommand completions" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_deno_using_subcommand completions" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_deno_using_subcommand completions" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_deno_using_subcommand completions" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_deno_using_subcommand completions" -l unstable-process -d 'Enable unstable process APIs'
complete -c deno -n "__fish_deno_using_subcommand completions" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_deno_using_subcommand completions" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_deno_using_subcommand completions" -l unstable-webgpu -d 'Enable unstable `WebGPU` APIs'
complete -c deno -n "__fish_deno_using_subcommand completions" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_deno_using_subcommand completions" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand coverage" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand coverage" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand coverage" -l ignore -d 'Ignore coverage files' -r -F
complete -c deno -n "__fish_deno_using_subcommand coverage" -l include -d 'Include source files in the report' -r
complete -c deno -n "__fish_deno_using_subcommand coverage" -l exclude -d 'Exclude source files from the report' -r
complete -c deno -n "__fish_deno_using_subcommand coverage" -l output -d 'Exports the coverage report in lcov format to the given file.   If no --output arg is specified then the report is written to stdout.' -r -F
complete -c deno -n "__fish_deno_using_subcommand coverage" -l unstable -d 'Enable all unstable features and APIs. Instead of using this flag, consider enabling individual unstable features   To view the list of individual unstable feature flags, run this command again with --help=unstable'
complete -c deno -n "__fish_deno_using_subcommand coverage" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_deno_using_subcommand coverage" -l unstable-detect-cjs -d 'Reads the package.json type field in a project to treat .js files as .cjs'
complete -c deno -n "__fish_deno_using_subcommand coverage" -l unstable-byonm
complete -c deno -n "__fish_deno_using_subcommand coverage" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing'
complete -c deno -n "__fish_deno_using_subcommand coverage" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_deno_using_subcommand coverage" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_deno_using_subcommand coverage" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_deno_using_subcommand coverage" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_deno_using_subcommand coverage" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_deno_using_subcommand coverage" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_deno_using_subcommand coverage" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_deno_using_subcommand coverage" -l unstable-process -d 'Enable unstable process APIs'
complete -c deno -n "__fish_deno_using_subcommand coverage" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_deno_using_subcommand coverage" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_deno_using_subcommand coverage" -l unstable-webgpu -d 'Enable unstable `WebGPU` APIs'
complete -c deno -n "__fish_deno_using_subcommand coverage" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_deno_using_subcommand coverage" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand coverage" -l lcov -d 'Output coverage report in lcov format'
complete -c deno -n "__fish_deno_using_subcommand coverage" -l html -d 'Output coverage report in HTML format in the given directory'
complete -c deno -n "__fish_deno_using_subcommand coverage" -l detailed -d 'Output coverage report in detailed format in the terminal'
complete -c deno -n "__fish_deno_using_subcommand doc" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand doc" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand doc" -l import-map -d 'Load import map file from local file or remote URL   Docs: https://docs.deno.com/runtime/manual/basics/import_maps' -r -F
complete -c deno -n "__fish_deno_using_subcommand doc" -s r -l reload -d 'Reload source code cache (recompile TypeScript)   no value                                                 Reload everything   jsr:@std/http/file-server,jsr:@std/assert/assert-equals  Reloads specific modules   npm:                                                     Reload all npm modules   npm:chalk                                                Reload specific npm module' -r -F
complete -c deno -n "__fish_deno_using_subcommand doc" -l lock -d 'Check the specified lock file. (If value is not provided, defaults to "./deno.lock")' -r -F
complete -c deno -n "__fish_deno_using_subcommand doc" -s I -l allow-import -d 'Allow importing from remote hosts. Optionally specify allowed IP addresses and host names, with ports as necessary. Default value: deno.land:443,jsr.io:443,esm.sh:443,cdn.jsdelivr.net:443,raw.githubusercontent.com:443,user.githubusercontent.com:443' -r
complete -c deno -n "__fish_deno_using_subcommand doc" -l name -d 'The name that will be used in the docs (ie for breadcrumbs)' -r
complete -c deno -n "__fish_deno_using_subcommand doc" -l category-docs -d 'Path to a JSON file keyed by category and an optional value of a markdown doc' -r
complete -c deno -n "__fish_deno_using_subcommand doc" -l symbol-redirect-map -d 'Path to a JSON file keyed by file, with an inner map of symbol to an external link' -r
complete -c deno -n "__fish_deno_using_subcommand doc" -l default-symbol-map -d 'Uses the provided mapping of default name to wanted name for usage blocks' -r
complete -c deno -n "__fish_deno_using_subcommand doc" -l output -d 'Directory for HTML documentation output' -r -f -a "(__fish_complete_directories)"
complete -c deno -n "__fish_deno_using_subcommand doc" -l filter -d 'Dot separated path to symbol' -r
complete -c deno -n "__fish_deno_using_subcommand doc" -l unstable -d 'Enable all unstable features and APIs. Instead of using this flag, consider enabling individual unstable features   To view the list of individual unstable feature flags, run this command again with --help=unstable'
complete -c deno -n "__fish_deno_using_subcommand doc" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_deno_using_subcommand doc" -l unstable-detect-cjs -d 'Reads the package.json type field in a project to treat .js files as .cjs'
complete -c deno -n "__fish_deno_using_subcommand doc" -l unstable-byonm
complete -c deno -n "__fish_deno_using_subcommand doc" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing'
complete -c deno -n "__fish_deno_using_subcommand doc" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_deno_using_subcommand doc" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_deno_using_subcommand doc" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_deno_using_subcommand doc" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_deno_using_subcommand doc" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_deno_using_subcommand doc" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_deno_using_subcommand doc" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_deno_using_subcommand doc" -l unstable-process -d 'Enable unstable process APIs'
complete -c deno -n "__fish_deno_using_subcommand doc" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_deno_using_subcommand doc" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_deno_using_subcommand doc" -l unstable-webgpu -d 'Enable unstable `WebGPU` APIs'
complete -c deno -n "__fish_deno_using_subcommand doc" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_deno_using_subcommand doc" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand doc" -l no-lock -d 'Disable auto discovery of the lock file'
complete -c deno -n "__fish_deno_using_subcommand doc" -l no-npm -d 'Do not resolve npm modules'
complete -c deno -n "__fish_deno_using_subcommand doc" -l no-remote -d 'Do not resolve remote modules'
complete -c deno -n "__fish_deno_using_subcommand doc" -l json -d 'Output documentation in JSON format'
complete -c deno -n "__fish_deno_using_subcommand doc" -l html -d 'Output documentation in HTML format'
complete -c deno -n "__fish_deno_using_subcommand doc" -l strip-trailing-html -d 'Remove trailing .html from various links. Will still generate files with a .html extension'
complete -c deno -n "__fish_deno_using_subcommand doc" -l private -d 'Output private documentation'
complete -c deno -n "__fish_deno_using_subcommand doc" -l lint -d 'Output documentation diagnostics.'
complete -c deno -n "__fish_deno_using_subcommand eval" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand eval" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand eval" -l no-check -d 'Skip type-checking. If the value of "remote" is supplied, diagnostic errors from remote modules will be ignored' -r
complete -c deno -n "__fish_deno_using_subcommand eval" -l import-map -d 'Load import map file from local file or remote URL   Docs: https://docs.deno.com/runtime/manual/basics/import_maps' -r -F
complete -c deno -n "__fish_deno_using_subcommand eval" -l node-modules-dir -d 'Sets the node modules management mode for npm packages' -r
complete -c deno -n "__fish_deno_using_subcommand eval" -l vendor -d 'Toggles local vendor folder usage for remote modules and a node_modules folder for npm packages' -r -f -a "{true\t'',false\t''}"
complete -c deno -n "__fish_deno_using_subcommand eval" -s c -l config -d 'Configure different aspects of deno including TypeScript, linting, and code formatting   Typically the configuration file will be called `deno.json` or `deno.jsonc` and   automatically detected; in that case this flag is not necessary.   Docs: https://docs.deno.com/go/config' -r -F
complete -c deno -n "__fish_deno_using_subcommand eval" -s r -l reload -d 'Reload source code cache (recompile TypeScript)   no value                                                 Reload everything   jsr:@std/http/file-server,jsr:@std/assert/assert-equals  Reloads specific modules   npm:                                                     Reload all npm modules   npm:chalk                                                Reload specific npm module' -r -F
complete -c deno -n "__fish_deno_using_subcommand eval" -l lock -d 'Check the specified lock file. (If value is not provided, defaults to "./deno.lock")' -r -F
complete -c deno -n "__fish_deno_using_subcommand eval" -l cert -d 'Load certificate authority from PEM encoded file' -r -F
complete -c deno -n "__fish_deno_using_subcommand eval" -l unsafely-ignore-certificate-errors -d 'DANGER: Disables verification of TLS certificates' -r
complete -c deno -n "__fish_deno_using_subcommand eval" -l inspect -d 'Activate inspector on host:port [default: 127.0.0.1:9229]' -r
complete -c deno -n "__fish_deno_using_subcommand eval" -l inspect-brk -d 'Activate inspector on host:port, wait for debugger to connect and break at the start of user script' -r
complete -c deno -n "__fish_deno_using_subcommand eval" -l inspect-wait -d 'Activate inspector on host:port and wait for debugger to connect before running user code' -r
complete -c deno -n "__fish_deno_using_subcommand eval" -l allow-scripts -d 'Allow running npm lifecycle scripts for the given packages   Note: Scripts will only be executed when using a node_modules directory (`--node-modules-dir`)' -r
complete -c deno -n "__fish_deno_using_subcommand eval" -l frozen -d 'Error out if lockfile is out of date' -r -f -a "{true\t'',false\t''}"
complete -c deno -n "__fish_deno_using_subcommand eval" -l location -d 'Value of globalThis.location used by some web APIs' -r -f
complete -c deno -n "__fish_deno_using_subcommand eval" -l v8-flags -d 'To see a list of all available flags use --v8-flags=--help   Flags can also be set via the DENO_V8_FLAGS environment variable.   Any flags set with this flag are appended after the DENO_V8_FLAGS environment variable' -r
complete -c deno -n "__fish_deno_using_subcommand eval" -l seed -d 'Set the random number generator seed' -r
complete -c deno -n "__fish_deno_using_subcommand eval" -l strace-ops -d 'Trace low-level op calls' -r
complete -c deno -n "__fish_deno_using_subcommand eval" -l check -d 'Enable type-checking. This subcommand does not type-check by default   If the value of "all" is supplied, remote modules will be included.   Alternatively, the \'deno check\' subcommand can be used' -r
complete -c deno -n "__fish_deno_using_subcommand eval" -l ext -d 'Set content type of the supplied file' -r -f -a "{ts\t'',tsx\t'',js\t'',jsx\t''}"
complete -c deno -n "__fish_deno_using_subcommand eval" -l env-file -d 'Load environment variables from local file   Only the first environment variable with a given key is used.   Existing process environment variables are not overwritten.' -r -F
complete -c deno -n "__fish_deno_using_subcommand eval" -l unstable -d 'Enable all unstable features and APIs. Instead of using this flag, consider enabling individual unstable features   To view the list of individual unstable feature flags, run this command again with --help=unstable'
complete -c deno -n "__fish_deno_using_subcommand eval" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_deno_using_subcommand eval" -l unstable-detect-cjs -d 'Reads the package.json type field in a project to treat .js files as .cjs'
complete -c deno -n "__fish_deno_using_subcommand eval" -l unstable-byonm
complete -c deno -n "__fish_deno_using_subcommand eval" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing'
complete -c deno -n "__fish_deno_using_subcommand eval" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_deno_using_subcommand eval" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_deno_using_subcommand eval" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_deno_using_subcommand eval" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_deno_using_subcommand eval" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_deno_using_subcommand eval" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_deno_using_subcommand eval" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_deno_using_subcommand eval" -l unstable-process -d 'Enable unstable process APIs'
complete -c deno -n "__fish_deno_using_subcommand eval" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_deno_using_subcommand eval" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_deno_using_subcommand eval" -l unstable-webgpu -d 'Enable unstable `WebGPU` APIs'
complete -c deno -n "__fish_deno_using_subcommand eval" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_deno_using_subcommand eval" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand eval" -l no-remote -d 'Do not resolve remote modules'
complete -c deno -n "__fish_deno_using_subcommand eval" -l no-npm -d 'Do not resolve npm modules'
complete -c deno -n "__fish_deno_using_subcommand eval" -l no-config -d 'Disable automatic loading of the configuration file'
complete -c deno -n "__fish_deno_using_subcommand eval" -l no-lock -d 'Disable auto discovery of the lock file'
complete -c deno -n "__fish_deno_using_subcommand eval" -l cached-only -d 'Require that remote dependencies are already cached'
complete -c deno -n "__fish_deno_using_subcommand eval" -l enable-testing-features-do-not-use -d 'INTERNAL: Enable internal features used during integration testing'
complete -c deno -n "__fish_deno_using_subcommand eval" -s p -l print -d 'print result to stdout'
complete -c deno -n "__fish_deno_using_subcommand fmt" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand fmt" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand fmt" -s c -l config -d 'Configure different aspects of deno including TypeScript, linting, and code formatting   Typically the configuration file will be called `deno.json` or `deno.jsonc` and   automatically detected; in that case this flag is not necessary.   Docs: https://docs.deno.com/go/config' -r -F
complete -c deno -n "__fish_deno_using_subcommand fmt" -l ext -d 'Set content type of the supplied file' -r -f -a "{ts\t'',tsx\t'',js\t'',jsx\t'',md\t'',json\t'',jsonc\t'',css\t'',scss\t'',sass\t'',less\t'',html\t'',svelte\t'',vue\t'',astro\t'',yml\t'',yaml\t'',ipynb\t''}"
complete -c deno -n "__fish_deno_using_subcommand fmt" -l ignore -d 'Ignore formatting particular source files' -r -F
complete -c deno -n "__fish_deno_using_subcommand fmt" -l watch-exclude -d 'Exclude provided files/patterns from watch mode' -r -F
complete -c deno -n "__fish_deno_using_subcommand fmt" -l use-tabs -d 'Use tabs instead of spaces for indentation [default: false]' -r -f -a "{true\t'',false\t''}"
complete -c deno -n "__fish_deno_using_subcommand fmt" -l line-width -d 'Define maximum line width [default: 80]' -r
complete -c deno -n "__fish_deno_using_subcommand fmt" -l indent-width -d 'Define indentation width [default: 2]' -r
complete -c deno -n "__fish_deno_using_subcommand fmt" -l single-quote -d 'Use single quotes [default: false]' -r -f -a "{true\t'',false\t''}"
complete -c deno -n "__fish_deno_using_subcommand fmt" -l prose-wrap -d 'Define how prose should be wrapped [default: always]' -r -f -a "{always\t'',never\t'',preserve\t''}"
complete -c deno -n "__fish_deno_using_subcommand fmt" -l no-semicolons -d 'Don\'t use semicolons except where necessary [default: false]' -r -f -a "{true\t'',false\t''}"
complete -c deno -n "__fish_deno_using_subcommand fmt" -l unstable -d 'Enable all unstable features and APIs. Instead of using this flag, consider enabling individual unstable features   To view the list of individual unstable feature flags, run this command again with --help=unstable'
complete -c deno -n "__fish_deno_using_subcommand fmt" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_deno_using_subcommand fmt" -l unstable-detect-cjs -d 'Reads the package.json type field in a project to treat .js files as .cjs'
complete -c deno -n "__fish_deno_using_subcommand fmt" -l unstable-byonm
complete -c deno -n "__fish_deno_using_subcommand fmt" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing'
complete -c deno -n "__fish_deno_using_subcommand fmt" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_deno_using_subcommand fmt" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_deno_using_subcommand fmt" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_deno_using_subcommand fmt" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_deno_using_subcommand fmt" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_deno_using_subcommand fmt" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_deno_using_subcommand fmt" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_deno_using_subcommand fmt" -l unstable-process -d 'Enable unstable process APIs'
complete -c deno -n "__fish_deno_using_subcommand fmt" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_deno_using_subcommand fmt" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_deno_using_subcommand fmt" -l unstable-webgpu -d 'Enable unstable `WebGPU` APIs'
complete -c deno -n "__fish_deno_using_subcommand fmt" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_deno_using_subcommand fmt" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand fmt" -l no-config -d 'Disable automatic loading of the configuration file'
complete -c deno -n "__fish_deno_using_subcommand fmt" -l check -d 'Check if the source files are formatted'
complete -c deno -n "__fish_deno_using_subcommand fmt" -l watch -d 'Watch for file changes and restart process automatically.   Only local files from entry point module graph are watched.'
complete -c deno -n "__fish_deno_using_subcommand fmt" -l no-clear-screen -d 'Do not clear terminal screen when under watch mode'
complete -c deno -n "__fish_deno_using_subcommand fmt" -l unstable-css -d 'Enable formatting CSS, SCSS, Sass and Less files'
complete -c deno -n "__fish_deno_using_subcommand fmt" -l unstable-html -d 'Enable formatting HTML files'
complete -c deno -n "__fish_deno_using_subcommand fmt" -l unstable-component -d 'Enable formatting Svelte, Vue, Astro and Angular files'
complete -c deno -n "__fish_deno_using_subcommand fmt" -l unstable-yaml -d 'Enable formatting YAML files'
complete -c deno -n "__fish_deno_using_subcommand init" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand init" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand init" -l unstable -d 'Enable all unstable features and APIs. Instead of using this flag, consider enabling individual unstable features   To view the list of individual unstable feature flags, run this command again with --help=unstable'
complete -c deno -n "__fish_deno_using_subcommand init" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_deno_using_subcommand init" -l unstable-detect-cjs -d 'Reads the package.json type field in a project to treat .js files as .cjs'
complete -c deno -n "__fish_deno_using_subcommand init" -l unstable-byonm
complete -c deno -n "__fish_deno_using_subcommand init" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing'
complete -c deno -n "__fish_deno_using_subcommand init" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_deno_using_subcommand init" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_deno_using_subcommand init" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_deno_using_subcommand init" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_deno_using_subcommand init" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_deno_using_subcommand init" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_deno_using_subcommand init" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_deno_using_subcommand init" -l unstable-process -d 'Enable unstable process APIs'
complete -c deno -n "__fish_deno_using_subcommand init" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_deno_using_subcommand init" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_deno_using_subcommand init" -l unstable-webgpu -d 'Enable unstable `WebGPU` APIs'
complete -c deno -n "__fish_deno_using_subcommand init" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_deno_using_subcommand init" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand init" -l lib -d 'Generate an example library project'
complete -c deno -n "__fish_deno_using_subcommand init" -l serve -d 'Generate an example project for `deno serve`'
complete -c deno -n "__fish_deno_using_subcommand info" -s I -l allow-import -d 'Allow importing from remote hosts. Optionally specify allowed IP addresses and host names, with ports as necessary. Default value: deno.land:443,jsr.io:443,esm.sh:443,cdn.jsdelivr.net:443,raw.githubusercontent.com:443,user.githubusercontent.com:443' -r
complete -c deno -n "__fish_deno_using_subcommand info" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand info" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand info" -s r -l reload -d 'Reload source code cache (recompile TypeScript)   no value                                                 Reload everything   jsr:@std/http/file-server,jsr:@std/assert/assert-equals  Reloads specific modules   npm:                                                     Reload all npm modules   npm:chalk                                                Reload specific npm module' -r -F
complete -c deno -n "__fish_deno_using_subcommand info" -l cert -d 'Load certificate authority from PEM encoded file' -r -F
complete -c deno -n "__fish_deno_using_subcommand info" -l unsafely-ignore-certificate-errors -d 'DANGER: Disables verification of TLS certificates' -r
complete -c deno -n "__fish_deno_using_subcommand info" -l location -d 'Show files used for origin bound APIs like the Web Storage API when running a script with --location=<HREF>' -r -f
complete -c deno -n "__fish_deno_using_subcommand info" -l no-check -d 'Skip type-checking. If the value of "remote" is supplied, diagnostic errors from remote modules will be ignored' -r
complete -c deno -n "__fish_deno_using_subcommand info" -l lock -d 'Check the specified lock file. (If value is not provided, defaults to "./deno.lock")' -r -F
complete -c deno -n "__fish_deno_using_subcommand info" -s c -l config -d 'Configure different aspects of deno including TypeScript, linting, and code formatting   Typically the configuration file will be called `deno.json` or `deno.jsonc` and   automatically detected; in that case this flag is not necessary.   Docs: https://docs.deno.com/go/config' -r -F
complete -c deno -n "__fish_deno_using_subcommand info" -l import-map -d 'Load import map file from local file or remote URL   Docs: https://docs.deno.com/runtime/manual/basics/import_maps' -r -F
complete -c deno -n "__fish_deno_using_subcommand info" -l node-modules-dir -d 'Sets the node modules management mode for npm packages' -r
complete -c deno -n "__fish_deno_using_subcommand info" -l vendor -d 'Toggles local vendor folder usage for remote modules and a node_modules folder for npm packages' -r -f -a "{true\t'',false\t''}"
complete -c deno -n "__fish_deno_using_subcommand info" -l unstable -d 'Enable all unstable features and APIs. Instead of using this flag, consider enabling individual unstable features   To view the list of individual unstable feature flags, run this command again with --help=unstable'
complete -c deno -n "__fish_deno_using_subcommand info" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_deno_using_subcommand info" -l unstable-detect-cjs -d 'Reads the package.json type field in a project to treat .js files as .cjs'
complete -c deno -n "__fish_deno_using_subcommand info" -l unstable-byonm
complete -c deno -n "__fish_deno_using_subcommand info" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing'
complete -c deno -n "__fish_deno_using_subcommand info" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_deno_using_subcommand info" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_deno_using_subcommand info" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_deno_using_subcommand info" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_deno_using_subcommand info" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_deno_using_subcommand info" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_deno_using_subcommand info" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_deno_using_subcommand info" -l unstable-process -d 'Enable unstable process APIs'
complete -c deno -n "__fish_deno_using_subcommand info" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_deno_using_subcommand info" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_deno_using_subcommand info" -l unstable-webgpu -d 'Enable unstable `WebGPU` APIs'
complete -c deno -n "__fish_deno_using_subcommand info" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_deno_using_subcommand info" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand info" -l no-config -d 'Disable automatic loading of the configuration file'
complete -c deno -n "__fish_deno_using_subcommand info" -l no-remote -d 'Do not resolve remote modules'
complete -c deno -n "__fish_deno_using_subcommand info" -l no-npm -d 'Do not resolve npm modules'
complete -c deno -n "__fish_deno_using_subcommand info" -l no-lock -d 'Disable auto discovery of the lock file'
complete -c deno -n "__fish_deno_using_subcommand info" -l json -d 'UNSTABLE: Outputs the information in JSON format'
complete -c deno -n "__fish_deno_using_subcommand install" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand install" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand install" -l no-check -d 'Skip type-checking. If the value of "remote" is supplied, diagnostic errors from remote modules will be ignored' -r
complete -c deno -n "__fish_deno_using_subcommand install" -l import-map -d 'Load import map file from local file or remote URL   Docs: https://docs.deno.com/runtime/manual/basics/import_maps' -r -F
complete -c deno -n "__fish_deno_using_subcommand install" -l node-modules-dir -d 'Sets the node modules management mode for npm packages' -r
complete -c deno -n "__fish_deno_using_subcommand install" -l vendor -d 'Toggles local vendor folder usage for remote modules and a node_modules folder for npm packages' -r -f -a "{true\t'',false\t''}"
complete -c deno -n "__fish_deno_using_subcommand install" -s c -l config -d 'Configure different aspects of deno including TypeScript, linting, and code formatting   Typically the configuration file will be called `deno.json` or `deno.jsonc` and   automatically detected; in that case this flag is not necessary.   Docs: https://docs.deno.com/go/config' -r -F
complete -c deno -n "__fish_deno_using_subcommand install" -s r -l reload -d 'Reload source code cache (recompile TypeScript)   no value                                                 Reload everything   jsr:@std/http/file-server,jsr:@std/assert/assert-equals  Reloads specific modules   npm:                                                     Reload all npm modules   npm:chalk                                                Reload specific npm module' -r -F
complete -c deno -n "__fish_deno_using_subcommand install" -l lock -d 'Check the specified lock file. (If value is not provided, defaults to "./deno.lock")' -r -F
complete -c deno -n "__fish_deno_using_subcommand install" -l cert -d 'Load certificate authority from PEM encoded file' -r -F
complete -c deno -n "__fish_deno_using_subcommand install" -l unsafely-ignore-certificate-errors -d 'DANGER: Disables verification of TLS certificates' -r
complete -c deno -n "__fish_deno_using_subcommand install" -l inspect -d 'Activate inspector on host:port [default: 127.0.0.1:9229]' -r
complete -c deno -n "__fish_deno_using_subcommand install" -l inspect-brk -d 'Activate inspector on host:port, wait for debugger to connect and break at the start of user script' -r
complete -c deno -n "__fish_deno_using_subcommand install" -l inspect-wait -d 'Activate inspector on host:port and wait for debugger to connect before running user code' -r
complete -c deno -n "__fish_deno_using_subcommand install" -l frozen -d 'Error out if lockfile is out of date' -r -f -a "{true\t'',false\t''}"
complete -c deno -n "__fish_deno_using_subcommand install" -l location -d 'Value of globalThis.location used by some web APIs' -r -f
complete -c deno -n "__fish_deno_using_subcommand install" -l v8-flags -d 'To see a list of all available flags use --v8-flags=--help   Flags can also be set via the DENO_V8_FLAGS environment variable.   Any flags set with this flag are appended after the DENO_V8_FLAGS environment variable' -r
complete -c deno -n "__fish_deno_using_subcommand install" -l seed -d 'Set the random number generator seed' -r
complete -c deno -n "__fish_deno_using_subcommand install" -l strace-ops -d 'Trace low-level op calls' -r
complete -c deno -n "__fish_deno_using_subcommand install" -s R -l allow-read -d 'Allow file system read access. Optionally specify allowed paths' -r -F
complete -c deno -n "__fish_deno_using_subcommand install" -l deny-read -d 'Deny file system read access. Optionally specify denied paths' -r -F
complete -c deno -n "__fish_deno_using_subcommand install" -s W -l allow-write -d 'Allow file system write access. Optionally specify allowed paths' -r -F
complete -c deno -n "__fish_deno_using_subcommand install" -l deny-write -d 'Deny file system write access. Optionally specify denied paths' -r -F
complete -c deno -n "__fish_deno_using_subcommand install" -s N -l allow-net -d 'Allow network access. Optionally specify allowed IP addresses and host names, with ports as necessary' -r
complete -c deno -n "__fish_deno_using_subcommand install" -l deny-net -d 'Deny network access. Optionally specify denied IP addresses and host names, with ports as necessary' -r
complete -c deno -n "__fish_deno_using_subcommand install" -s E -l allow-env -d 'Allow access to system environment information. Optionally specify accessible environment variables' -r
complete -c deno -n "__fish_deno_using_subcommand install" -l deny-env -d 'Deny access to system environment information. Optionally specify accessible environment variables' -r
complete -c deno -n "__fish_deno_using_subcommand install" -s S -l allow-sys -d 'Allow access to OS information. Optionally allow specific APIs by function name' -r
complete -c deno -n "__fish_deno_using_subcommand install" -l deny-sys -d 'Deny access to OS information. Optionally deny specific APIs by function name' -r
complete -c deno -n "__fish_deno_using_subcommand install" -l allow-run -d 'Allow running subprocesses. Optionally specify allowed runnable program names' -r
complete -c deno -n "__fish_deno_using_subcommand install" -l deny-run -d 'Deny running subprocesses. Optionally specify denied runnable program names' -r
complete -c deno -n "__fish_deno_using_subcommand install" -l allow-ffi -d '(Unstable) Allow loading dynamic libraries. Optionally specify allowed directories or files' -r -F
complete -c deno -n "__fish_deno_using_subcommand install" -l deny-ffi -d '(Unstable) Deny loading dynamic libraries. Optionally specify denied directories or files' -r -F
complete -c deno -n "__fish_deno_using_subcommand install" -s I -l allow-import -d 'Allow importing from remote hosts. Optionally specify allowed IP addresses and host names, with ports as necessary. Default value: deno.land:443,jsr.io:443,esm.sh:443,cdn.jsdelivr.net:443,raw.githubusercontent.com:443,user.githubusercontent.com:443' -r
complete -c deno -n "__fish_deno_using_subcommand install" -l check -d 'Set type-checking behavior. This subcommand type-checks local modules by default, so adding --check is redundant   If the value of "all" is supplied, remote modules will be included.   Alternatively, the \'deno check\' subcommand can be used' -r
complete -c deno -n "__fish_deno_using_subcommand install" -l allow-scripts -d 'Allow running npm lifecycle scripts for the given packages   Note: Scripts will only be executed when using a node_modules directory (`--node-modules-dir`)' -r
complete -c deno -n "__fish_deno_using_subcommand install" -s n -l name -d 'Executable file name' -r
complete -c deno -n "__fish_deno_using_subcommand install" -l root -d 'Installation root' -r -f -a "(__fish_complete_directories)"
complete -c deno -n "__fish_deno_using_subcommand install" -l env-file -d 'Load environment variables from local file   Only the first environment variable with a given key is used.   Existing process environment variables are not overwritten.' -r -F
complete -c deno -n "__fish_deno_using_subcommand install" -l unstable -d 'Enable all unstable features and APIs. Instead of using this flag, consider enabling individual unstable features   To view the list of individual unstable feature flags, run this command again with --help=unstable'
complete -c deno -n "__fish_deno_using_subcommand install" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_deno_using_subcommand install" -l unstable-detect-cjs -d 'Reads the package.json type field in a project to treat .js files as .cjs'
complete -c deno -n "__fish_deno_using_subcommand install" -l unstable-byonm
complete -c deno -n "__fish_deno_using_subcommand install" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing'
complete -c deno -n "__fish_deno_using_subcommand install" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_deno_using_subcommand install" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_deno_using_subcommand install" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_deno_using_subcommand install" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_deno_using_subcommand install" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_deno_using_subcommand install" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_deno_using_subcommand install" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_deno_using_subcommand install" -l unstable-process -d 'Enable unstable process APIs'
complete -c deno -n "__fish_deno_using_subcommand install" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_deno_using_subcommand install" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_deno_using_subcommand install" -l unstable-webgpu -d 'Enable unstable `WebGPU` APIs'
complete -c deno -n "__fish_deno_using_subcommand install" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_deno_using_subcommand install" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand install" -l no-remote -d 'Do not resolve remote modules'
complete -c deno -n "__fish_deno_using_subcommand install" -l no-npm -d 'Do not resolve npm modules'
complete -c deno -n "__fish_deno_using_subcommand install" -l no-config -d 'Disable automatic loading of the configuration file'
complete -c deno -n "__fish_deno_using_subcommand install" -l no-lock -d 'Disable auto discovery of the lock file'
complete -c deno -n "__fish_deno_using_subcommand install" -l cached-only -d 'Require that remote dependencies are already cached'
complete -c deno -n "__fish_deno_using_subcommand install" -l enable-testing-features-do-not-use -d 'INTERNAL: Enable internal features used during integration testing'
complete -c deno -n "__fish_deno_using_subcommand install" -s A -l allow-all -d 'Allow all permissions'
complete -c deno -n "__fish_deno_using_subcommand install" -l allow-hrtime -d 'REMOVED in Deno 2.0'
complete -c deno -n "__fish_deno_using_subcommand install" -l deny-hrtime -d 'REMOVED in Deno 2.0'
complete -c deno -n "__fish_deno_using_subcommand install" -l no-prompt -d 'Always throw if required permission wasn\'t passed'
complete -c deno -n "__fish_deno_using_subcommand install" -s f -l force -d 'Forcefully overwrite existing installation'
complete -c deno -n "__fish_deno_using_subcommand install" -s g -l global -d 'Install a package or script as a globally available executable'
complete -c deno -n "__fish_deno_using_subcommand install" -s e -l entrypoint -d 'Install dependents of the specified entrypoint(s)'
complete -c deno -n "__fish_deno_using_subcommand install" -s D -l dev -d 'Add as a dev dependency'
complete -c deno -n "__fish_deno_using_subcommand i" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand i" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand i" -l no-check -d 'Skip type-checking. If the value of "remote" is supplied, diagnostic errors from remote modules will be ignored' -r
complete -c deno -n "__fish_deno_using_subcommand i" -l import-map -d 'Load import map file from local file or remote URL   Docs: https://docs.deno.com/runtime/manual/basics/import_maps' -r -F
complete -c deno -n "__fish_deno_using_subcommand i" -l node-modules-dir -d 'Sets the node modules management mode for npm packages' -r
complete -c deno -n "__fish_deno_using_subcommand i" -l vendor -d 'Toggles local vendor folder usage for remote modules and a node_modules folder for npm packages' -r -f -a "{true\t'',false\t''}"
complete -c deno -n "__fish_deno_using_subcommand i" -s c -l config -d 'Configure different aspects of deno including TypeScript, linting, and code formatting   Typically the configuration file will be called `deno.json` or `deno.jsonc` and   automatically detected; in that case this flag is not necessary.   Docs: https://docs.deno.com/go/config' -r -F
complete -c deno -n "__fish_deno_using_subcommand i" -s r -l reload -d 'Reload source code cache (recompile TypeScript)   no value                                                 Reload everything   jsr:@std/http/file-server,jsr:@std/assert/assert-equals  Reloads specific modules   npm:                                                     Reload all npm modules   npm:chalk                                                Reload specific npm module' -r -F
complete -c deno -n "__fish_deno_using_subcommand i" -l lock -d 'Check the specified lock file. (If value is not provided, defaults to "./deno.lock")' -r -F
complete -c deno -n "__fish_deno_using_subcommand i" -l cert -d 'Load certificate authority from PEM encoded file' -r -F
complete -c deno -n "__fish_deno_using_subcommand i" -l unsafely-ignore-certificate-errors -d 'DANGER: Disables verification of TLS certificates' -r
complete -c deno -n "__fish_deno_using_subcommand i" -l inspect -d 'Activate inspector on host:port [default: 127.0.0.1:9229]' -r
complete -c deno -n "__fish_deno_using_subcommand i" -l inspect-brk -d 'Activate inspector on host:port, wait for debugger to connect and break at the start of user script' -r
complete -c deno -n "__fish_deno_using_subcommand i" -l inspect-wait -d 'Activate inspector on host:port and wait for debugger to connect before running user code' -r
complete -c deno -n "__fish_deno_using_subcommand i" -l frozen -d 'Error out if lockfile is out of date' -r -f -a "{true\t'',false\t''}"
complete -c deno -n "__fish_deno_using_subcommand i" -l location -d 'Value of globalThis.location used by some web APIs' -r -f
complete -c deno -n "__fish_deno_using_subcommand i" -l v8-flags -d 'To see a list of all available flags use --v8-flags=--help   Flags can also be set via the DENO_V8_FLAGS environment variable.   Any flags set with this flag are appended after the DENO_V8_FLAGS environment variable' -r
complete -c deno -n "__fish_deno_using_subcommand i" -l seed -d 'Set the random number generator seed' -r
complete -c deno -n "__fish_deno_using_subcommand i" -l strace-ops -d 'Trace low-level op calls' -r
complete -c deno -n "__fish_deno_using_subcommand i" -s R -l allow-read -d 'Allow file system read access. Optionally specify allowed paths' -r -F
complete -c deno -n "__fish_deno_using_subcommand i" -l deny-read -d 'Deny file system read access. Optionally specify denied paths' -r -F
complete -c deno -n "__fish_deno_using_subcommand i" -s W -l allow-write -d 'Allow file system write access. Optionally specify allowed paths' -r -F
complete -c deno -n "__fish_deno_using_subcommand i" -l deny-write -d 'Deny file system write access. Optionally specify denied paths' -r -F
complete -c deno -n "__fish_deno_using_subcommand i" -s N -l allow-net -d 'Allow network access. Optionally specify allowed IP addresses and host names, with ports as necessary' -r
complete -c deno -n "__fish_deno_using_subcommand i" -l deny-net -d 'Deny network access. Optionally specify denied IP addresses and host names, with ports as necessary' -r
complete -c deno -n "__fish_deno_using_subcommand i" -s E -l allow-env -d 'Allow access to system environment information. Optionally specify accessible environment variables' -r
complete -c deno -n "__fish_deno_using_subcommand i" -l deny-env -d 'Deny access to system environment information. Optionally specify accessible environment variables' -r
complete -c deno -n "__fish_deno_using_subcommand i" -s S -l allow-sys -d 'Allow access to OS information. Optionally allow specific APIs by function name' -r
complete -c deno -n "__fish_deno_using_subcommand i" -l deny-sys -d 'Deny access to OS information. Optionally deny specific APIs by function name' -r
complete -c deno -n "__fish_deno_using_subcommand i" -l allow-run -d 'Allow running subprocesses. Optionally specify allowed runnable program names' -r
complete -c deno -n "__fish_deno_using_subcommand i" -l deny-run -d 'Deny running subprocesses. Optionally specify denied runnable program names' -r
complete -c deno -n "__fish_deno_using_subcommand i" -l allow-ffi -d '(Unstable) Allow loading dynamic libraries. Optionally specify allowed directories or files' -r -F
complete -c deno -n "__fish_deno_using_subcommand i" -l deny-ffi -d '(Unstable) Deny loading dynamic libraries. Optionally specify denied directories or files' -r -F
complete -c deno -n "__fish_deno_using_subcommand i" -s I -l allow-import -d 'Allow importing from remote hosts. Optionally specify allowed IP addresses and host names, with ports as necessary. Default value: deno.land:443,jsr.io:443,esm.sh:443,cdn.jsdelivr.net:443,raw.githubusercontent.com:443,user.githubusercontent.com:443' -r
complete -c deno -n "__fish_deno_using_subcommand i" -l check -d 'Set type-checking behavior. This subcommand type-checks local modules by default, so adding --check is redundant   If the value of "all" is supplied, remote modules will be included.   Alternatively, the \'deno check\' subcommand can be used' -r
complete -c deno -n "__fish_deno_using_subcommand i" -l allow-scripts -d 'Allow running npm lifecycle scripts for the given packages   Note: Scripts will only be executed when using a node_modules directory (`--node-modules-dir`)' -r
complete -c deno -n "__fish_deno_using_subcommand i" -s n -l name -d 'Executable file name' -r
complete -c deno -n "__fish_deno_using_subcommand i" -l root -d 'Installation root' -r -f -a "(__fish_complete_directories)"
complete -c deno -n "__fish_deno_using_subcommand i" -l env-file -d 'Load environment variables from local file   Only the first environment variable with a given key is used.   Existing process environment variables are not overwritten.' -r -F
complete -c deno -n "__fish_deno_using_subcommand i" -l unstable -d 'Enable all unstable features and APIs. Instead of using this flag, consider enabling individual unstable features   To view the list of individual unstable feature flags, run this command again with --help=unstable'
complete -c deno -n "__fish_deno_using_subcommand i" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_deno_using_subcommand i" -l unstable-detect-cjs -d 'Reads the package.json type field in a project to treat .js files as .cjs'
complete -c deno -n "__fish_deno_using_subcommand i" -l unstable-byonm
complete -c deno -n "__fish_deno_using_subcommand i" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing'
complete -c deno -n "__fish_deno_using_subcommand i" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_deno_using_subcommand i" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_deno_using_subcommand i" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_deno_using_subcommand i" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_deno_using_subcommand i" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_deno_using_subcommand i" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_deno_using_subcommand i" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_deno_using_subcommand i" -l unstable-process -d 'Enable unstable process APIs'
complete -c deno -n "__fish_deno_using_subcommand i" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_deno_using_subcommand i" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_deno_using_subcommand i" -l unstable-webgpu -d 'Enable unstable `WebGPU` APIs'
complete -c deno -n "__fish_deno_using_subcommand i" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_deno_using_subcommand i" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand i" -l no-remote -d 'Do not resolve remote modules'
complete -c deno -n "__fish_deno_using_subcommand i" -l no-npm -d 'Do not resolve npm modules'
complete -c deno -n "__fish_deno_using_subcommand i" -l no-config -d 'Disable automatic loading of the configuration file'
complete -c deno -n "__fish_deno_using_subcommand i" -l no-lock -d 'Disable auto discovery of the lock file'
complete -c deno -n "__fish_deno_using_subcommand i" -l cached-only -d 'Require that remote dependencies are already cached'
complete -c deno -n "__fish_deno_using_subcommand i" -l enable-testing-features-do-not-use -d 'INTERNAL: Enable internal features used during integration testing'
complete -c deno -n "__fish_deno_using_subcommand i" -s A -l allow-all -d 'Allow all permissions'
complete -c deno -n "__fish_deno_using_subcommand i" -l allow-hrtime -d 'REMOVED in Deno 2.0'
complete -c deno -n "__fish_deno_using_subcommand i" -l deny-hrtime -d 'REMOVED in Deno 2.0'
complete -c deno -n "__fish_deno_using_subcommand i" -l no-prompt -d 'Always throw if required permission wasn\'t passed'
complete -c deno -n "__fish_deno_using_subcommand i" -s f -l force -d 'Forcefully overwrite existing installation'
complete -c deno -n "__fish_deno_using_subcommand i" -s g -l global -d 'Install a package or script as a globally available executable'
complete -c deno -n "__fish_deno_using_subcommand i" -s e -l entrypoint -d 'Install dependents of the specified entrypoint(s)'
complete -c deno -n "__fish_deno_using_subcommand i" -s D -l dev -d 'Add as a dev dependency'
complete -c deno -n "__fish_deno_using_subcommand json_reference" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand json_reference" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand json_reference" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand jupyter" -l conn -d 'Path to JSON file describing connection parameters, provided by Jupyter' -r -F
complete -c deno -n "__fish_deno_using_subcommand jupyter" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand jupyter" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand jupyter" -l unstable -d 'Enable all unstable features and APIs. Instead of using this flag, consider enabling individual unstable features   To view the list of individual unstable feature flags, run this command again with --help=unstable'
complete -c deno -n "__fish_deno_using_subcommand jupyter" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_deno_using_subcommand jupyter" -l unstable-detect-cjs -d 'Reads the package.json type field in a project to treat .js files as .cjs'
complete -c deno -n "__fish_deno_using_subcommand jupyter" -l unstable-byonm
complete -c deno -n "__fish_deno_using_subcommand jupyter" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing'
complete -c deno -n "__fish_deno_using_subcommand jupyter" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_deno_using_subcommand jupyter" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_deno_using_subcommand jupyter" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_deno_using_subcommand jupyter" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_deno_using_subcommand jupyter" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_deno_using_subcommand jupyter" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_deno_using_subcommand jupyter" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_deno_using_subcommand jupyter" -l unstable-process -d 'Enable unstable process APIs'
complete -c deno -n "__fish_deno_using_subcommand jupyter" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_deno_using_subcommand jupyter" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_deno_using_subcommand jupyter" -l unstable-webgpu -d 'Enable unstable `WebGPU` APIs'
complete -c deno -n "__fish_deno_using_subcommand jupyter" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_deno_using_subcommand jupyter" -l install -d 'Installs kernelspec, requires \'jupyter\' command to be available.'
complete -c deno -n "__fish_deno_using_subcommand jupyter" -l kernel -d 'Start the kernel'
complete -c deno -n "__fish_deno_using_subcommand jupyter" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand uninstall" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand uninstall" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand uninstall" -l root -d 'Installation root' -r -f -a "(__fish_complete_directories)"
complete -c deno -n "__fish_deno_using_subcommand uninstall" -l unstable -d 'Enable all unstable features and APIs. Instead of using this flag, consider enabling individual unstable features   To view the list of individual unstable feature flags, run this command again with --help=unstable'
complete -c deno -n "__fish_deno_using_subcommand uninstall" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_deno_using_subcommand uninstall" -l unstable-detect-cjs -d 'Reads the package.json type field in a project to treat .js files as .cjs'
complete -c deno -n "__fish_deno_using_subcommand uninstall" -l unstable-byonm
complete -c deno -n "__fish_deno_using_subcommand uninstall" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing'
complete -c deno -n "__fish_deno_using_subcommand uninstall" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_deno_using_subcommand uninstall" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_deno_using_subcommand uninstall" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_deno_using_subcommand uninstall" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_deno_using_subcommand uninstall" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_deno_using_subcommand uninstall" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_deno_using_subcommand uninstall" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_deno_using_subcommand uninstall" -l unstable-process -d 'Enable unstable process APIs'
complete -c deno -n "__fish_deno_using_subcommand uninstall" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_deno_using_subcommand uninstall" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_deno_using_subcommand uninstall" -l unstable-webgpu -d 'Enable unstable `WebGPU` APIs'
complete -c deno -n "__fish_deno_using_subcommand uninstall" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_deno_using_subcommand uninstall" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand uninstall" -s g -l global -d 'Remove globally installed package or module'
complete -c deno -n "__fish_deno_using_subcommand lsp" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand lsp" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand lsp" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand lint" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand lint" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand lint" -l ext -d 'Specify the file extension to lint when reading from stdin.For example, use `jsx` to lint JSX files or `tsx` for TSX files.This argument is necessary because stdin input does not automatically infer the file type.Example usage: `cat file.jsx | deno lint - --ext=jsx`.' -r
complete -c deno -n "__fish_deno_using_subcommand lint" -l rules-tags -d 'Use set of rules with a tag' -r
complete -c deno -n "__fish_deno_using_subcommand lint" -l rules-include -d 'Include lint rules' -r
complete -c deno -n "__fish_deno_using_subcommand lint" -l rules-exclude -d 'Exclude lint rules' -r
complete -c deno -n "__fish_deno_using_subcommand lint" -s c -l config -d 'Configure different aspects of deno including TypeScript, linting, and code formatting   Typically the configuration file will be called `deno.json` or `deno.jsonc` and   automatically detected; in that case this flag is not necessary.   Docs: https://docs.deno.com/go/config' -r -F
complete -c deno -n "__fish_deno_using_subcommand lint" -l ignore -d 'Ignore linting particular source files' -r -F
complete -c deno -n "__fish_deno_using_subcommand lint" -l watch-exclude -d 'Exclude provided files/patterns from watch mode' -r -F
complete -c deno -n "__fish_deno_using_subcommand lint" -l unstable -d 'Enable all unstable features and APIs. Instead of using this flag, consider enabling individual unstable features   To view the list of individual unstable feature flags, run this command again with --help=unstable'
complete -c deno -n "__fish_deno_using_subcommand lint" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_deno_using_subcommand lint" -l unstable-detect-cjs -d 'Reads the package.json type field in a project to treat .js files as .cjs'
complete -c deno -n "__fish_deno_using_subcommand lint" -l unstable-byonm
complete -c deno -n "__fish_deno_using_subcommand lint" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing'
complete -c deno -n "__fish_deno_using_subcommand lint" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_deno_using_subcommand lint" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_deno_using_subcommand lint" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_deno_using_subcommand lint" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_deno_using_subcommand lint" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_deno_using_subcommand lint" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_deno_using_subcommand lint" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_deno_using_subcommand lint" -l unstable-process -d 'Enable unstable process APIs'
complete -c deno -n "__fish_deno_using_subcommand lint" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_deno_using_subcommand lint" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_deno_using_subcommand lint" -l unstable-webgpu -d 'Enable unstable `WebGPU` APIs'
complete -c deno -n "__fish_deno_using_subcommand lint" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_deno_using_subcommand lint" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand lint" -l fix -d 'Fix any linting errors for rules that support it'
complete -c deno -n "__fish_deno_using_subcommand lint" -l rules -d 'List available rules'
complete -c deno -n "__fish_deno_using_subcommand lint" -l no-config -d 'Disable automatic loading of the configuration file'
complete -c deno -n "__fish_deno_using_subcommand lint" -l json -d 'Output lint result in JSON format'
complete -c deno -n "__fish_deno_using_subcommand lint" -l compact -d 'Output lint result in compact format'
complete -c deno -n "__fish_deno_using_subcommand lint" -l watch -d 'Watch for file changes and restart process automatically.   Only local files from entry point module graph are watched.'
complete -c deno -n "__fish_deno_using_subcommand lint" -l no-clear-screen -d 'Do not clear terminal screen when under watch mode'
complete -c deno -n "__fish_deno_using_subcommand publish" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand publish" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand publish" -l token -d 'The API token to use when publishing. If unset, interactive authentication is be used' -r
complete -c deno -n "__fish_deno_using_subcommand publish" -s c -l config -d 'Configure different aspects of deno including TypeScript, linting, and code formatting   Typically the configuration file will be called `deno.json` or `deno.jsonc` and   automatically detected; in that case this flag is not necessary.   Docs: https://docs.deno.com/go/config' -r -F
complete -c deno -n "__fish_deno_using_subcommand publish" -l check -d 'Set type-checking behavior. This subcommand type-checks local modules by default, so adding --check is redundant   If the value of "all" is supplied, remote modules will be included.   Alternatively, the \'deno check\' subcommand can be used' -r
complete -c deno -n "__fish_deno_using_subcommand publish" -l no-check -d 'Skip type-checking. If the value of "remote" is supplied, diagnostic errors from remote modules will be ignored' -r
complete -c deno -n "__fish_deno_using_subcommand publish" -l unstable -d 'Enable all unstable features and APIs. Instead of using this flag, consider enabling individual unstable features   To view the list of individual unstable feature flags, run this command again with --help=unstable'
complete -c deno -n "__fish_deno_using_subcommand publish" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_deno_using_subcommand publish" -l unstable-detect-cjs -d 'Reads the package.json type field in a project to treat .js files as .cjs'
complete -c deno -n "__fish_deno_using_subcommand publish" -l unstable-byonm
complete -c deno -n "__fish_deno_using_subcommand publish" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing'
complete -c deno -n "__fish_deno_using_subcommand publish" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_deno_using_subcommand publish" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_deno_using_subcommand publish" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_deno_using_subcommand publish" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_deno_using_subcommand publish" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_deno_using_subcommand publish" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_deno_using_subcommand publish" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_deno_using_subcommand publish" -l unstable-process -d 'Enable unstable process APIs'
complete -c deno -n "__fish_deno_using_subcommand publish" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_deno_using_subcommand publish" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_deno_using_subcommand publish" -l unstable-webgpu -d 'Enable unstable `WebGPU` APIs'
complete -c deno -n "__fish_deno_using_subcommand publish" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_deno_using_subcommand publish" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand publish" -l no-config -d 'Disable automatic loading of the configuration file'
complete -c deno -n "__fish_deno_using_subcommand publish" -l dry-run -d 'Prepare the package for publishing performing all checks and validations without uploading'
complete -c deno -n "__fish_deno_using_subcommand publish" -l allow-slow-types -d 'Allow publishing with slow types'
complete -c deno -n "__fish_deno_using_subcommand publish" -l allow-dirty -d 'Allow publishing if the repository has uncommitted changed'
complete -c deno -n "__fish_deno_using_subcommand publish" -l no-provenance -d 'Disable provenance attestation.   Enabled by default on Github actions, publicly links the package to where it was built and published from.'
complete -c deno -n "__fish_deno_using_subcommand repl" -l env-file -d 'Load environment variables from local file   Only the first environment variable with a given key is used.   Existing process environment variables are not overwritten.' -r -F
complete -c deno -n "__fish_deno_using_subcommand repl" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand repl" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand repl" -l import-map -d 'Load import map file from local file or remote URL   Docs: https://docs.deno.com/runtime/manual/basics/import_maps' -r -F
complete -c deno -n "__fish_deno_using_subcommand repl" -l node-modules-dir -d 'Sets the node modules management mode for npm packages' -r
complete -c deno -n "__fish_deno_using_subcommand repl" -l vendor -d 'Toggles local vendor folder usage for remote modules and a node_modules folder for npm packages' -r -f -a "{true\t'',false\t''}"
complete -c deno -n "__fish_deno_using_subcommand repl" -s c -l config -d 'Configure different aspects of deno including TypeScript, linting, and code formatting   Typically the configuration file will be called `deno.json` or `deno.jsonc` and   automatically detected; in that case this flag is not necessary.   Docs: https://docs.deno.com/go/config' -r -F
complete -c deno -n "__fish_deno_using_subcommand repl" -s r -l reload -d 'Reload source code cache (recompile TypeScript)   no value                                                 Reload everything   jsr:@std/http/file-server,jsr:@std/assert/assert-equals  Reloads specific modules   npm:                                                     Reload all npm modules   npm:chalk                                                Reload specific npm module' -r -F
complete -c deno -n "__fish_deno_using_subcommand repl" -l lock -d 'Check the specified lock file. (If value is not provided, defaults to "./deno.lock")' -r -F
complete -c deno -n "__fish_deno_using_subcommand repl" -l cert -d 'Load certificate authority from PEM encoded file' -r -F
complete -c deno -n "__fish_deno_using_subcommand repl" -l unsafely-ignore-certificate-errors -d 'DANGER: Disables verification of TLS certificates' -r
complete -c deno -n "__fish_deno_using_subcommand repl" -l inspect -d 'Activate inspector on host:port [default: 127.0.0.1:9229]' -r
complete -c deno -n "__fish_deno_using_subcommand repl" -l inspect-brk -d 'Activate inspector on host:port, wait for debugger to connect and break at the start of user script' -r
complete -c deno -n "__fish_deno_using_subcommand repl" -l inspect-wait -d 'Activate inspector on host:port and wait for debugger to connect before running user code' -r
complete -c deno -n "__fish_deno_using_subcommand repl" -s R -l allow-read -d 'Allow file system read access. Optionally specify allowed paths' -r -F
complete -c deno -n "__fish_deno_using_subcommand repl" -l deny-read -d 'Deny file system read access. Optionally specify denied paths' -r -F
complete -c deno -n "__fish_deno_using_subcommand repl" -s W -l allow-write -d 'Allow file system write access. Optionally specify allowed paths' -r -F
complete -c deno -n "__fish_deno_using_subcommand repl" -l deny-write -d 'Deny file system write access. Optionally specify denied paths' -r -F
complete -c deno -n "__fish_deno_using_subcommand repl" -s N -l allow-net -d 'Allow network access. Optionally specify allowed IP addresses and host names, with ports as necessary' -r
complete -c deno -n "__fish_deno_using_subcommand repl" -l deny-net -d 'Deny network access. Optionally specify denied IP addresses and host names, with ports as necessary' -r
complete -c deno -n "__fish_deno_using_subcommand repl" -s E -l allow-env -d 'Allow access to system environment information. Optionally specify accessible environment variables' -r
complete -c deno -n "__fish_deno_using_subcommand repl" -l deny-env -d 'Deny access to system environment information. Optionally specify accessible environment variables' -r
complete -c deno -n "__fish_deno_using_subcommand repl" -s S -l allow-sys -d 'Allow access to OS information. Optionally allow specific APIs by function name' -r
complete -c deno -n "__fish_deno_using_subcommand repl" -l deny-sys -d 'Deny access to OS information. Optionally deny specific APIs by function name' -r
complete -c deno -n "__fish_deno_using_subcommand repl" -l allow-run -d 'Allow running subprocesses. Optionally specify allowed runnable program names' -r
complete -c deno -n "__fish_deno_using_subcommand repl" -l deny-run -d 'Deny running subprocesses. Optionally specify denied runnable program names' -r
complete -c deno -n "__fish_deno_using_subcommand repl" -l allow-ffi -d '(Unstable) Allow loading dynamic libraries. Optionally specify allowed directories or files' -r -F
complete -c deno -n "__fish_deno_using_subcommand repl" -l deny-ffi -d '(Unstable) Deny loading dynamic libraries. Optionally specify denied directories or files' -r -F
complete -c deno -n "__fish_deno_using_subcommand repl" -s I -l allow-import -d 'Allow importing from remote hosts. Optionally specify allowed IP addresses and host names, with ports as necessary. Default value: deno.land:443,jsr.io:443,esm.sh:443,cdn.jsdelivr.net:443,raw.githubusercontent.com:443,user.githubusercontent.com:443' -r
complete -c deno -n "__fish_deno_using_subcommand repl" -l frozen -d 'Error out if lockfile is out of date' -r -f -a "{true\t'',false\t''}"
complete -c deno -n "__fish_deno_using_subcommand repl" -l location -d 'Value of globalThis.location used by some web APIs' -r -f
complete -c deno -n "__fish_deno_using_subcommand repl" -l v8-flags -d 'To see a list of all available flags use --v8-flags=--help   Flags can also be set via the DENO_V8_FLAGS environment variable.   Any flags set with this flag are appended after the DENO_V8_FLAGS environment variable' -r
complete -c deno -n "__fish_deno_using_subcommand repl" -l seed -d 'Set the random number generator seed' -r
complete -c deno -n "__fish_deno_using_subcommand repl" -l strace-ops -d 'Trace low-level op calls' -r
complete -c deno -n "__fish_deno_using_subcommand repl" -l eval-file -d 'Evaluates the provided file(s) as scripts when the REPL starts. Accepts file paths and URLs' -r -F
complete -c deno -n "__fish_deno_using_subcommand repl" -l eval -d 'Evaluates the provided code when the REPL starts' -r
complete -c deno -n "__fish_deno_using_subcommand repl" -l unstable -d 'Enable all unstable features and APIs. Instead of using this flag, consider enabling individual unstable features   To view the list of individual unstable feature flags, run this command again with --help=unstable'
complete -c deno -n "__fish_deno_using_subcommand repl" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_deno_using_subcommand repl" -l unstable-detect-cjs -d 'Reads the package.json type field in a project to treat .js files as .cjs'
complete -c deno -n "__fish_deno_using_subcommand repl" -l unstable-byonm
complete -c deno -n "__fish_deno_using_subcommand repl" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing'
complete -c deno -n "__fish_deno_using_subcommand repl" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_deno_using_subcommand repl" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_deno_using_subcommand repl" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_deno_using_subcommand repl" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_deno_using_subcommand repl" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_deno_using_subcommand repl" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_deno_using_subcommand repl" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_deno_using_subcommand repl" -l unstable-process -d 'Enable unstable process APIs'
complete -c deno -n "__fish_deno_using_subcommand repl" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_deno_using_subcommand repl" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_deno_using_subcommand repl" -l unstable-webgpu -d 'Enable unstable `WebGPU` APIs'
complete -c deno -n "__fish_deno_using_subcommand repl" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_deno_using_subcommand repl" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand repl" -l no-remote -d 'Do not resolve remote modules'
complete -c deno -n "__fish_deno_using_subcommand repl" -l no-npm -d 'Do not resolve npm modules'
complete -c deno -n "__fish_deno_using_subcommand repl" -l no-config -d 'Disable automatic loading of the configuration file'
complete -c deno -n "__fish_deno_using_subcommand repl" -l no-lock -d 'Disable auto discovery of the lock file'
complete -c deno -n "__fish_deno_using_subcommand repl" -s A -l allow-all -d 'Allow all permissions'
complete -c deno -n "__fish_deno_using_subcommand repl" -l allow-hrtime -d 'REMOVED in Deno 2.0'
complete -c deno -n "__fish_deno_using_subcommand repl" -l deny-hrtime -d 'REMOVED in Deno 2.0'
complete -c deno -n "__fish_deno_using_subcommand repl" -l no-prompt -d 'Always throw if required permission wasn\'t passed'
complete -c deno -n "__fish_deno_using_subcommand repl" -l cached-only -d 'Require that remote dependencies are already cached'
complete -c deno -n "__fish_deno_using_subcommand repl" -l enable-testing-features-do-not-use -d 'INTERNAL: Enable internal features used during integration testing'
complete -c deno -n "__fish_deno_using_subcommand task" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand task" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand task" -s c -l config -d 'Configure different aspects of deno including TypeScript, linting, and code formatting   Typically the configuration file will be called `deno.json` or `deno.jsonc` and   automatically detected; in that case this flag is not necessary.   Docs: https://docs.deno.com/go/config' -r -F
complete -c deno -n "__fish_deno_using_subcommand task" -l cwd -d 'Specify the directory to run the task in' -r -f -a "(__fish_complete_directories)"
complete -c deno -n "__fish_deno_using_subcommand task" -l node-modules-dir -d 'Sets the node modules management mode for npm packages' -r
complete -c deno -n "__fish_deno_using_subcommand task" -l unstable -d 'Enable all unstable features and APIs. Instead of using this flag, consider enabling individual unstable features   To view the list of individual unstable feature flags, run this command again with --help=unstable'
complete -c deno -n "__fish_deno_using_subcommand task" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_deno_using_subcommand task" -l unstable-detect-cjs -d 'Reads the package.json type field in a project to treat .js files as .cjs'
complete -c deno -n "__fish_deno_using_subcommand task" -l unstable-byonm
complete -c deno -n "__fish_deno_using_subcommand task" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing'
complete -c deno -n "__fish_deno_using_subcommand task" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_deno_using_subcommand task" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_deno_using_subcommand task" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_deno_using_subcommand task" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_deno_using_subcommand task" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_deno_using_subcommand task" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_deno_using_subcommand task" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_deno_using_subcommand task" -l unstable-process -d 'Enable unstable process APIs'
complete -c deno -n "__fish_deno_using_subcommand task" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_deno_using_subcommand task" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_deno_using_subcommand task" -l unstable-webgpu -d 'Enable unstable `WebGPU` APIs'
complete -c deno -n "__fish_deno_using_subcommand task" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_deno_using_subcommand task" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand test" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand test" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand test" -l no-check -d 'Skip type-checking. If the value of "remote" is supplied, diagnostic errors from remote modules will be ignored' -r
complete -c deno -n "__fish_deno_using_subcommand test" -l import-map -d 'Load import map file from local file or remote URL   Docs: https://docs.deno.com/runtime/manual/basics/import_maps' -r -F
complete -c deno -n "__fish_deno_using_subcommand test" -l node-modules-dir -d 'Sets the node modules management mode for npm packages' -r
complete -c deno -n "__fish_deno_using_subcommand test" -l vendor -d 'Toggles local vendor folder usage for remote modules and a node_modules folder for npm packages' -r -f -a "{true\t'',false\t''}"
complete -c deno -n "__fish_deno_using_subcommand test" -s c -l config -d 'Configure different aspects of deno including TypeScript, linting, and code formatting   Typically the configuration file will be called `deno.json` or `deno.jsonc` and   automatically detected; in that case this flag is not necessary.   Docs: https://docs.deno.com/go/config' -r -F
complete -c deno -n "__fish_deno_using_subcommand test" -s r -l reload -d 'Reload source code cache (recompile TypeScript)   no value                                                 Reload everything   jsr:@std/http/file-server,jsr:@std/assert/assert-equals  Reloads specific modules   npm:                                                     Reload all npm modules   npm:chalk                                                Reload specific npm module' -r -F
complete -c deno -n "__fish_deno_using_subcommand test" -l lock -d 'Check the specified lock file. (If value is not provided, defaults to "./deno.lock")' -r -F
complete -c deno -n "__fish_deno_using_subcommand test" -l cert -d 'Load certificate authority from PEM encoded file' -r -F
complete -c deno -n "__fish_deno_using_subcommand test" -l unsafely-ignore-certificate-errors -d 'DANGER: Disables verification of TLS certificates' -r
complete -c deno -n "__fish_deno_using_subcommand test" -s R -l allow-read -d 'Allow file system read access. Optionally specify allowed paths' -r -F
complete -c deno -n "__fish_deno_using_subcommand test" -l deny-read -d 'Deny file system read access. Optionally specify denied paths' -r -F
complete -c deno -n "__fish_deno_using_subcommand test" -s W -l allow-write -d 'Allow file system write access. Optionally specify allowed paths' -r -F
complete -c deno -n "__fish_deno_using_subcommand test" -l deny-write -d 'Deny file system write access. Optionally specify denied paths' -r -F
complete -c deno -n "__fish_deno_using_subcommand test" -s N -l allow-net -d 'Allow network access. Optionally specify allowed IP addresses and host names, with ports as necessary' -r
complete -c deno -n "__fish_deno_using_subcommand test" -l deny-net -d 'Deny network access. Optionally specify denied IP addresses and host names, with ports as necessary' -r
complete -c deno -n "__fish_deno_using_subcommand test" -s E -l allow-env -d 'Allow access to system environment information. Optionally specify accessible environment variables' -r
complete -c deno -n "__fish_deno_using_subcommand test" -l deny-env -d 'Deny access to system environment information. Optionally specify accessible environment variables' -r
complete -c deno -n "__fish_deno_using_subcommand test" -s S -l allow-sys -d 'Allow access to OS information. Optionally allow specific APIs by function name' -r
complete -c deno -n "__fish_deno_using_subcommand test" -l deny-sys -d 'Deny access to OS information. Optionally deny specific APIs by function name' -r
complete -c deno -n "__fish_deno_using_subcommand test" -l allow-run -d 'Allow running subprocesses. Optionally specify allowed runnable program names' -r
complete -c deno -n "__fish_deno_using_subcommand test" -l deny-run -d 'Deny running subprocesses. Optionally specify denied runnable program names' -r
complete -c deno -n "__fish_deno_using_subcommand test" -l allow-ffi -d '(Unstable) Allow loading dynamic libraries. Optionally specify allowed directories or files' -r -F
complete -c deno -n "__fish_deno_using_subcommand test" -l deny-ffi -d '(Unstable) Deny loading dynamic libraries. Optionally specify denied directories or files' -r -F
complete -c deno -n "__fish_deno_using_subcommand test" -s I -l allow-import -d 'Allow importing from remote hosts. Optionally specify allowed IP addresses and host names, with ports as necessary. Default value: deno.land:443,jsr.io:443,esm.sh:443,cdn.jsdelivr.net:443,raw.githubusercontent.com:443,user.githubusercontent.com:443' -r
complete -c deno -n "__fish_deno_using_subcommand test" -l inspect -d 'Activate inspector on host:port [default: 127.0.0.1:9229]' -r
complete -c deno -n "__fish_deno_using_subcommand test" -l inspect-brk -d 'Activate inspector on host:port, wait for debugger to connect and break at the start of user script' -r
complete -c deno -n "__fish_deno_using_subcommand test" -l inspect-wait -d 'Activate inspector on host:port and wait for debugger to connect before running user code' -r
complete -c deno -n "__fish_deno_using_subcommand test" -l allow-scripts -d 'Allow running npm lifecycle scripts for the given packages   Note: Scripts will only be executed when using a node_modules directory (`--node-modules-dir`)' -r
complete -c deno -n "__fish_deno_using_subcommand test" -l frozen -d 'Error out if lockfile is out of date' -r -f -a "{true\t'',false\t''}"
complete -c deno -n "__fish_deno_using_subcommand test" -l location -d 'Value of globalThis.location used by some web APIs' -r -f
complete -c deno -n "__fish_deno_using_subcommand test" -l v8-flags -d 'To see a list of all available flags use --v8-flags=--help   Flags can also be set via the DENO_V8_FLAGS environment variable.   Any flags set with this flag are appended after the DENO_V8_FLAGS environment variable' -r
complete -c deno -n "__fish_deno_using_subcommand test" -l seed -d 'Set the random number generator seed' -r
complete -c deno -n "__fish_deno_using_subcommand test" -l strace-ops -d 'Trace low-level op calls' -r
complete -c deno -n "__fish_deno_using_subcommand test" -l check -d 'Set type-checking behavior. This subcommand type-checks local modules by default, so adding --check is redundant   If the value of "all" is supplied, remote modules will be included.   Alternatively, the \'deno check\' subcommand can be used' -r
complete -c deno -n "__fish_deno_using_subcommand test" -l ignore -d 'Ignore files' -r -F
complete -c deno -n "__fish_deno_using_subcommand test" -l fail-fast -d 'Stop after N errors. Defaults to stopping after first failure' -r
complete -c deno -n "__fish_deno_using_subcommand test" -l filter -d 'Run tests with this string or regexp pattern in the test name' -r
complete -c deno -n "__fish_deno_using_subcommand test" -l shuffle -d 'Shuffle the order in which the tests are run' -r
complete -c deno -n "__fish_deno_using_subcommand test" -l coverage -d 'Collect coverage profile data into DIR. If DIR is not specified, it uses \'coverage/\'' -r
complete -c deno -n "__fish_deno_using_subcommand test" -l watch -d 'Watch for file changes and restart process automatically.   Local files from entry point module graph are watched by default.   Additional paths might be watched by passing them as arguments to this flag.' -r -F
complete -c deno -n "__fish_deno_using_subcommand test" -l watch-exclude -d 'Exclude provided files/patterns from watch mode' -r -F
complete -c deno -n "__fish_deno_using_subcommand test" -l junit-path -d 'Write a JUnit XML test report to PATH. Use \'-\' to write to stdout which is the default when PATH is not provided' -r -F
complete -c deno -n "__fish_deno_using_subcommand test" -l reporter -d 'Select reporter to use. Default to \'pretty\'' -r -f -a "{pretty\t'',dot\t'',junit\t'',tap\t''}"
complete -c deno -n "__fish_deno_using_subcommand test" -l env-file -d 'Load environment variables from local file   Only the first environment variable with a given key is used.   Existing process environment variables are not overwritten.' -r -F
complete -c deno -n "__fish_deno_using_subcommand test" -l ext -d 'Set content type of the supplied file' -r -f -a "{ts\t'',tsx\t'',js\t'',jsx\t''}"
complete -c deno -n "__fish_deno_using_subcommand test" -l unstable -d 'Enable all unstable features and APIs. Instead of using this flag, consider enabling individual unstable features   To view the list of individual unstable feature flags, run this command again with --help=unstable'
complete -c deno -n "__fish_deno_using_subcommand test" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_deno_using_subcommand test" -l unstable-detect-cjs -d 'Reads the package.json type field in a project to treat .js files as .cjs'
complete -c deno -n "__fish_deno_using_subcommand test" -l unstable-byonm
complete -c deno -n "__fish_deno_using_subcommand test" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing'
complete -c deno -n "__fish_deno_using_subcommand test" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_deno_using_subcommand test" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_deno_using_subcommand test" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_deno_using_subcommand test" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_deno_using_subcommand test" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_deno_using_subcommand test" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_deno_using_subcommand test" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_deno_using_subcommand test" -l unstable-process -d 'Enable unstable process APIs'
complete -c deno -n "__fish_deno_using_subcommand test" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_deno_using_subcommand test" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_deno_using_subcommand test" -l unstable-webgpu -d 'Enable unstable `WebGPU` APIs'
complete -c deno -n "__fish_deno_using_subcommand test" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_deno_using_subcommand test" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand test" -l no-remote -d 'Do not resolve remote modules'
complete -c deno -n "__fish_deno_using_subcommand test" -l no-npm -d 'Do not resolve npm modules'
complete -c deno -n "__fish_deno_using_subcommand test" -l no-config -d 'Disable automatic loading of the configuration file'
complete -c deno -n "__fish_deno_using_subcommand test" -l no-lock -d 'Disable auto discovery of the lock file'
complete -c deno -n "__fish_deno_using_subcommand test" -s A -l allow-all -d 'Allow all permissions'
complete -c deno -n "__fish_deno_using_subcommand test" -l allow-hrtime -d 'REMOVED in Deno 2.0'
complete -c deno -n "__fish_deno_using_subcommand test" -l deny-hrtime -d 'REMOVED in Deno 2.0'
complete -c deno -n "__fish_deno_using_subcommand test" -l no-prompt -d 'Always throw if required permission wasn\'t passed'
complete -c deno -n "__fish_deno_using_subcommand test" -l cached-only -d 'Require that remote dependencies are already cached'
complete -c deno -n "__fish_deno_using_subcommand test" -l enable-testing-features-do-not-use -d 'INTERNAL: Enable internal features used during integration testing'
complete -c deno -n "__fish_deno_using_subcommand test" -l no-run -d 'Cache test modules, but don\'t run tests'
complete -c deno -n "__fish_deno_using_subcommand test" -l trace-leaks -d 'Enable tracing of leaks. Useful when debugging leaking ops in test, but impacts test execution time'
complete -c deno -n "__fish_deno_using_subcommand test" -l doc -d 'Evaluate code blocks in JSDoc and Markdown'
complete -c deno -n "__fish_deno_using_subcommand test" -l permit-no-files -d 'Don\'t return an error code if no test files were found'
complete -c deno -n "__fish_deno_using_subcommand test" -l clean -d 'Empty the temporary coverage profile data directory before running tests.   Note: running multiple `deno test --clean` calls in series or parallel for the same coverage directory may cause race conditions.'
complete -c deno -n "__fish_deno_using_subcommand test" -l parallel -d 'Run test modules in parallel. Parallelism defaults to the number of available CPUs or the value of the DENO_JOBS environment variable'
complete -c deno -n "__fish_deno_using_subcommand test" -l no-clear-screen -d 'Do not clear terminal screen when under watch mode'
complete -c deno -n "__fish_deno_using_subcommand test" -l hide-stacktraces -d 'Hide stack traces for errors in failure test results.'
complete -c deno -n "__fish_deno_using_subcommand types" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand types" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand types" -l unstable -d 'Enable all unstable features and APIs. Instead of using this flag, consider enabling individual unstable features   To view the list of individual unstable feature flags, run this command again with --help=unstable'
complete -c deno -n "__fish_deno_using_subcommand types" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_deno_using_subcommand types" -l unstable-detect-cjs -d 'Reads the package.json type field in a project to treat .js files as .cjs'
complete -c deno -n "__fish_deno_using_subcommand types" -l unstable-byonm
complete -c deno -n "__fish_deno_using_subcommand types" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing'
complete -c deno -n "__fish_deno_using_subcommand types" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_deno_using_subcommand types" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_deno_using_subcommand types" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_deno_using_subcommand types" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_deno_using_subcommand types" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_deno_using_subcommand types" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_deno_using_subcommand types" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_deno_using_subcommand types" -l unstable-process -d 'Enable unstable process APIs'
complete -c deno -n "__fish_deno_using_subcommand types" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_deno_using_subcommand types" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_deno_using_subcommand types" -l unstable-webgpu -d 'Enable unstable `WebGPU` APIs'
complete -c deno -n "__fish_deno_using_subcommand types" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_deno_using_subcommand types" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand upgrade" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand upgrade" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand upgrade" -l version -d 'The version to upgrade to' -r
complete -c deno -n "__fish_deno_using_subcommand upgrade" -l output -d 'The path to output the updated version to' -r -F
complete -c deno -n "__fish_deno_using_subcommand upgrade" -l cert -d 'Load certificate authority from PEM encoded file' -r -F
complete -c deno -n "__fish_deno_using_subcommand upgrade" -l unsafely-ignore-certificate-errors -d 'DANGER: Disables verification of TLS certificates' -r
complete -c deno -n "__fish_deno_using_subcommand upgrade" -l unstable -d 'Enable all unstable features and APIs. Instead of using this flag, consider enabling individual unstable features   To view the list of individual unstable feature flags, run this command again with --help=unstable'
complete -c deno -n "__fish_deno_using_subcommand upgrade" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_deno_using_subcommand upgrade" -l unstable-detect-cjs -d 'Reads the package.json type field in a project to treat .js files as .cjs'
complete -c deno -n "__fish_deno_using_subcommand upgrade" -l unstable-byonm
complete -c deno -n "__fish_deno_using_subcommand upgrade" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing'
complete -c deno -n "__fish_deno_using_subcommand upgrade" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_deno_using_subcommand upgrade" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_deno_using_subcommand upgrade" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_deno_using_subcommand upgrade" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_deno_using_subcommand upgrade" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_deno_using_subcommand upgrade" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_deno_using_subcommand upgrade" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_deno_using_subcommand upgrade" -l unstable-process -d 'Enable unstable process APIs'
complete -c deno -n "__fish_deno_using_subcommand upgrade" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_deno_using_subcommand upgrade" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_deno_using_subcommand upgrade" -l unstable-webgpu -d 'Enable unstable `WebGPU` APIs'
complete -c deno -n "__fish_deno_using_subcommand upgrade" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_deno_using_subcommand upgrade" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand upgrade" -l dry-run -d 'Perform all checks without replacing old exe'
complete -c deno -n "__fish_deno_using_subcommand upgrade" -s f -l force -d 'Replace current exe even if not out-of-date'
complete -c deno -n "__fish_deno_using_subcommand upgrade" -l canary -d 'Upgrade to canary builds'
complete -c deno -n "__fish_deno_using_subcommand upgrade" -l rc -d 'Upgrade to a release candidate'
complete -c deno -n "__fish_deno_using_subcommand vendor" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand vendor" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand vendor" -l unstable -d 'Enable all unstable features and APIs. Instead of using this flag, consider enabling individual unstable features   To view the list of individual unstable feature flags, run this command again with --help=unstable'
complete -c deno -n "__fish_deno_using_subcommand vendor" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_deno_using_subcommand vendor" -l unstable-detect-cjs -d 'Reads the package.json type field in a project to treat .js files as .cjs'
complete -c deno -n "__fish_deno_using_subcommand vendor" -l unstable-byonm
complete -c deno -n "__fish_deno_using_subcommand vendor" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing'
complete -c deno -n "__fish_deno_using_subcommand vendor" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_deno_using_subcommand vendor" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_deno_using_subcommand vendor" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_deno_using_subcommand vendor" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_deno_using_subcommand vendor" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_deno_using_subcommand vendor" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_deno_using_subcommand vendor" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_deno_using_subcommand vendor" -l unstable-process -d 'Enable unstable process APIs'
complete -c deno -n "__fish_deno_using_subcommand vendor" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_deno_using_subcommand vendor" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_deno_using_subcommand vendor" -l unstable-webgpu -d 'Enable unstable `WebGPU` APIs'
complete -c deno -n "__fish_deno_using_subcommand vendor" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_deno_using_subcommand vendor" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add remove bench bundle cache check clean compile completions coverage doc eval fmt init info install json_reference jupyter uninstall lsp lint publish repl task test types upgrade vendor" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add remove bench bundle cache check clean compile completions coverage doc eval fmt init info install json_reference jupyter uninstall lsp lint publish repl task test types upgrade vendor" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add remove bench bundle cache check clean compile completions coverage doc eval fmt init info install json_reference jupyter uninstall lsp lint publish repl task test types upgrade vendor" -l unstable -d 'Enable all unstable features and APIs. Instead of using this flag, consider enabling individual unstable features   To view the list of individual unstable feature flags, run this command again with --help=unstable'
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add remove bench bundle cache check clean compile completions coverage doc eval fmt init info install json_reference jupyter uninstall lsp lint publish repl task test types upgrade vendor" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add remove bench bundle cache check clean compile completions coverage doc eval fmt init info install json_reference jupyter uninstall lsp lint publish repl task test types upgrade vendor" -l unstable-detect-cjs -d 'Reads the package.json type field in a project to treat .js files as .cjs'
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add remove bench bundle cache check clean compile completions coverage doc eval fmt init info install json_reference jupyter uninstall lsp lint publish repl task test types upgrade vendor" -l unstable-byonm
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add remove bench bundle cache check clean compile completions coverage doc eval fmt init info install json_reference jupyter uninstall lsp lint publish repl task test types upgrade vendor" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing'
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add remove bench bundle cache check clean compile completions coverage doc eval fmt init info install json_reference jupyter uninstall lsp lint publish repl task test types upgrade vendor" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add remove bench bundle cache check clean compile completions coverage doc eval fmt init info install json_reference jupyter uninstall lsp lint publish repl task test types upgrade vendor" -l unstable-cron -d 'Enable unstable Deno.cron API'
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add remove bench bundle cache check clean compile completions coverage doc eval fmt init info install json_reference jupyter uninstall lsp lint publish repl task test types upgrade vendor" -l unstable-ffi -d 'Enable unstable FFI APIs'
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add remove bench bundle cache check clean compile completions coverage doc eval fmt init info install json_reference jupyter uninstall lsp lint publish repl task test types upgrade vendor" -l unstable-fs -d 'Enable unstable file system APIs'
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add remove bench bundle cache check clean compile completions coverage doc eval fmt init info install json_reference jupyter uninstall lsp lint publish repl task test types upgrade vendor" -l unstable-http -d 'Enable unstable HTTP APIs'
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add remove bench bundle cache check clean compile completions coverage doc eval fmt init info install json_reference jupyter uninstall lsp lint publish repl task test types upgrade vendor" -l unstable-kv -d 'Enable unstable Key-Value store APIs'
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add remove bench bundle cache check clean compile completions coverage doc eval fmt init info install json_reference jupyter uninstall lsp lint publish repl task test types upgrade vendor" -l unstable-net -d 'Enable unstable net APIs'
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add remove bench bundle cache check clean compile completions coverage doc eval fmt init info install json_reference jupyter uninstall lsp lint publish repl task test types upgrade vendor" -l unstable-process -d 'Enable unstable process APIs'
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add remove bench bundle cache check clean compile completions coverage doc eval fmt init info install json_reference jupyter uninstall lsp lint publish repl task test types upgrade vendor" -l unstable-temporal -d 'Enable unstable Temporal API'
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add remove bench bundle cache check clean compile completions coverage doc eval fmt init info install json_reference jupyter uninstall lsp lint publish repl task test types upgrade vendor" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add remove bench bundle cache check clean compile completions coverage doc eval fmt init info install json_reference jupyter uninstall lsp lint publish repl task test types upgrade vendor" -l unstable-webgpu -d 'Enable unstable `WebGPU` APIs'
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add remove bench bundle cache check clean compile completions coverage doc eval fmt init info install json_reference jupyter uninstall lsp lint publish repl task test types upgrade vendor" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add remove bench bundle cache check clean compile completions coverage doc eval fmt init info install json_reference jupyter uninstall lsp lint publish repl task test types upgrade vendor" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add remove bench bundle cache check clean compile completions coverage doc eval fmt init info install json_reference jupyter uninstall lsp lint publish repl task test types upgrade vendor" -f -a "run"
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add remove bench bundle cache check clean compile completions coverage doc eval fmt init info install json_reference jupyter uninstall lsp lint publish repl task test types upgrade vendor" -f -a "serve"
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add remove bench bundle cache check clean compile completions coverage doc eval fmt init info install json_reference jupyter uninstall lsp lint publish repl task test types upgrade vendor" -f -a "add"
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add remove bench bundle cache check clean compile completions coverage doc eval fmt init info install json_reference jupyter uninstall lsp lint publish repl task test types upgrade vendor" -f -a "remove"
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add remove bench bundle cache check clean compile completions coverage doc eval fmt init info install json_reference jupyter uninstall lsp lint publish repl task test types upgrade vendor" -f -a "bench"
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add remove bench bundle cache check clean compile completions coverage doc eval fmt init info install json_reference jupyter uninstall lsp lint publish repl task test types upgrade vendor" -f -a "bundle"
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add remove bench bundle cache check clean compile completions coverage doc eval fmt init info install json_reference jupyter uninstall lsp lint publish repl task test types upgrade vendor" -f -a "cache"
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add remove bench bundle cache check clean compile completions coverage doc eval fmt init info install json_reference jupyter uninstall lsp lint publish repl task test types upgrade vendor" -f -a "check"
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add remove bench bundle cache check clean compile completions coverage doc eval fmt init info install json_reference jupyter uninstall lsp lint publish repl task test types upgrade vendor" -f -a "clean"
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add remove bench bundle cache check clean compile completions coverage doc eval fmt init info install json_reference jupyter uninstall lsp lint publish repl task test types upgrade vendor" -f -a "compile"
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add remove bench bundle cache check clean compile completions coverage doc eval fmt init info install json_reference jupyter uninstall lsp lint publish repl task test types upgrade vendor" -f -a "completions"
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add remove bench bundle cache check clean compile completions coverage doc eval fmt init info install json_reference jupyter uninstall lsp lint publish repl task test types upgrade vendor" -f -a "coverage"
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add remove bench bundle cache check clean compile completions coverage doc eval fmt init info install json_reference jupyter uninstall lsp lint publish repl task test types upgrade vendor" -f -a "doc"
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add remove bench bundle cache check clean compile completions coverage doc eval fmt init info install json_reference jupyter uninstall lsp lint publish repl task test types upgrade vendor" -f -a "eval"
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add remove bench bundle cache check clean compile completions coverage doc eval fmt init info install json_reference jupyter uninstall lsp lint publish repl task test types upgrade vendor" -f -a "fmt"
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add remove bench bundle cache check clean compile completions coverage doc eval fmt init info install json_reference jupyter uninstall lsp lint publish repl task test types upgrade vendor" -f -a "init"
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add remove bench bundle cache check clean compile completions coverage doc eval fmt init info install json_reference jupyter uninstall lsp lint publish repl task test types upgrade vendor" -f -a "info"
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add remove bench bundle cache check clean compile completions coverage doc eval fmt init info install json_reference jupyter uninstall lsp lint publish repl task test types upgrade vendor" -f -a "install"
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add remove bench bundle cache check clean compile completions coverage doc eval fmt init info install json_reference jupyter uninstall lsp lint publish repl task test types upgrade vendor" -f -a "json_reference"
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add remove bench bundle cache check clean compile completions coverage doc eval fmt init info install json_reference jupyter uninstall lsp lint publish repl task test types upgrade vendor" -f -a "jupyter"
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add remove bench bundle cache check clean compile completions coverage doc eval fmt init info install json_reference jupyter uninstall lsp lint publish repl task test types upgrade vendor" -f -a "uninstall"
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add remove bench bundle cache check clean compile completions coverage doc eval fmt init info install json_reference jupyter uninstall lsp lint publish repl task test types upgrade vendor" -f -a "lsp"
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add remove bench bundle cache check clean compile completions coverage doc eval fmt init info install json_reference jupyter uninstall lsp lint publish repl task test types upgrade vendor" -f -a "lint"
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add remove bench bundle cache check clean compile completions coverage doc eval fmt init info install json_reference jupyter uninstall lsp lint publish repl task test types upgrade vendor" -f -a "publish"
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add remove bench bundle cache check clean compile completions coverage doc eval fmt init info install json_reference jupyter uninstall lsp lint publish repl task test types upgrade vendor" -f -a "repl"
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add remove bench bundle cache check clean compile completions coverage doc eval fmt init info install json_reference jupyter uninstall lsp lint publish repl task test types upgrade vendor" -f -a "task"
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add remove bench bundle cache check clean compile completions coverage doc eval fmt init info install json_reference jupyter uninstall lsp lint publish repl task test types upgrade vendor" -f -a "test"
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add remove bench bundle cache check clean compile completions coverage doc eval fmt init info install json_reference jupyter uninstall lsp lint publish repl task test types upgrade vendor" -f -a "types"
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add remove bench bundle cache check clean compile completions coverage doc eval fmt init info install json_reference jupyter uninstall lsp lint publish repl task test types upgrade vendor" -f -a "upgrade"
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add remove bench bundle cache check clean compile completions coverage doc eval fmt init info install json_reference jupyter uninstall lsp lint publish repl task test types upgrade vendor" -f -a "vendor"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from run" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from run" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from run" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from serve" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from serve" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from serve" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from add" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from add" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from add" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from remove" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from remove" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from remove" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from bench" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from bench" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from bench" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from bundle" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from bundle" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from bundle" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from cache" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from cache" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from cache" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from check" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from check" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from check" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from clean" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from clean" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from clean" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from compile" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from compile" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from compile" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from completions" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from completions" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from completions" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from coverage" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from coverage" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from coverage" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from doc" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from doc" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from doc" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from eval" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from eval" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from eval" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from fmt" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from fmt" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from fmt" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from init" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from init" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from init" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from info" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from info" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from info" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from install" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from install" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from install" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from json_reference" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from json_reference" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from json_reference" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from jupyter" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from jupyter" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from jupyter" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from uninstall" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from uninstall" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from uninstall" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from lsp" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from lsp" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from lsp" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from lint" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from lint" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from lint" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from publish" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from publish" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from publish" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from repl" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from repl" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from repl" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from task" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from task" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from task" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from test" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from test" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from test" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from types" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from types" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from types" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from upgrade" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from upgrade" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from upgrade" -s q -l quiet -d 'Suppress diagnostic output'
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from vendor" -s h -l help -r -f -a "{unstable\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from vendor" -s L -l log-level -d 'Set log level' -r -f -a "{trace\t'',debug\t'',info\t''}"
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from vendor" -s q -l quiet -d 'Suppress diagnostic output'
