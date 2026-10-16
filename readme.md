<div align="center">
  <img alt="mflibs" src="docs/img/logo_light.png#gh-light-mode-only" />
  <img alt="mflibs" src="docs/img/logo_dark.png#gh-dark-mode-only" />

  <p>A Bash library to make life a little bit easier.</p>

  <img alt="Bash 4.0+" src="https://img.shields.io/badge/BASH-4.0%2B-blueviolet?style=for-the-badge">
  <img alt="License: BSD-3-Clause and MIT" src="https://img.shields.io/badge/LICENSE-BSD--3--CLAUSE%2FMIT-brightgreen?style=for-the-badge">
</div>

## About

mflibs is a set of small, importable Bash libraries for scripts that run on Debian and Ubuntu: output and status messages, logging, array and directory helpers, input checks, and distro and network information. It needs Bash 4.0 or newer.

It was written by Jamie Dobbs ([mschf-dev/mflibs](https://github.com/mschf-dev/mflibs)). This repository is the version maintained by QuickBox, which uses it in [QuickBox](https://quickbox.io) and in [qb-compile](https://github.com/QuickBox/qb-compile).

## Install

```bash
sudo git clone https://github.com/QuickBox/mflibs /opt/mflibs
```

Any location works; `/opt/mflibs` is the path QuickBox tools expect.

## Use

Source the loader, then import the libraries you need, separated by commas:

```bash
#!/usr/bin/env bash
. /opt/mflibs/src/init.sh
mflibs::import shell,status,log

mflibs::status::info "starting"
mflibs::log "apt-get update"
```

Import `verbose` to print a line for every library loaded:

```bash
mflibs::import verbose,shell
```

If a name is not found in `src/libs/`, the loader looks for `src/custom/<name>.sh`. Put your own libraries in `src/custom/` and import them the same way; that directory is not part of this repository.

Logging goes to the file named by `mflibs_log_location`. Set and `export` it before loading mflibs. The full contract (rotation, fallbacks, repeated initialization) is in [docs/libs/log.sh.md](docs/libs/log.sh.md).

## Libraries

| Library | What it covers | Reference |
|---------|----------------|-----------|
| `array` | search, join, merge and test arrays | [docs/libs/array.sh.md](docs/libs/array.sh.md) |
| `dir` | directory helpers | [docs/libs/dir.sh.md](docs/libs/dir.sh.md) |
| `distro` | distro codename and version | [docs/libs/distro.sh.md](docs/libs/distro.sh.md) |
| `file` | file helpers such as archive extraction | [docs/libs/file.sh.md](docs/libs/file.sh.md) |
| `info` | local and public IPv4 address | [docs/libs/info.sh.md](docs/libs/info.sh.md) |
| `log` | run a command and log it | [docs/libs/log.sh.md](docs/libs/log.sh.md) |
| `shell` | colored and styled terminal output, icons | [docs/libs/shell.sh.md](docs/libs/shell.sh.md) |
| `status` | error, warning, success and info messages | [docs/libs/status.sh.md](docs/libs/status.sh.md) |
| `verify` | validate email, IP, numbers, versions, commands, root | [docs/libs/verify.sh.md](docs/libs/verify.sh.md) |

The loader itself is documented in [docs/init.sh.md](docs/init.sh.md). Every function carries its usage in the source comments above it.

## Community and support

Questions, help and general discussion happen on the [QuickBox Discord](https://discord.gg/mca7RSv5pa). Use GitHub issues for bugs and feature requests so they can be tracked.

## Contributing

Issues and pull requests are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md). Report security problems as described in [security.md](security.md).

## License

BSD 3-Clause, copyright (c) 2021-2022 Jamie Dobbs. Parts adapted from [labbots/bash-utility](https://github.com/labbots/bash-utility) are MIT licensed, copyright (c) 2020 labbots. Both notices are in [license](license).

## Acknowledgements

- [bash-utility](https://github.com/labbots/bash-utility) by labbots, from which some functions are used or adapted.
