# Contributing to mflibs

Issues and pull requests are welcome. mflibs is loaded by other tools (QuickBox and qb-compile among them), so a change here can affect scripts you cannot see. Keep behavior stable and test accordingly.

## Reporting bugs and asking for features

Open an issue with the Bash version (`bash --version`), the distro, a minimal script that reproduces the problem, and the output you expected.

## Security reports

Do not open a public issue for a security problem. Email echo@quickbox.io with `[Security]` at the start of the subject line, and describe the problem and how to reproduce it. We will reply and coordinate a fix with you.

## Making a change

1. Fork the repository and create a branch.
2. Keep the change focused; one fix or feature per pull request.
3. Test it with Bash 4 and with a current Bash 5, on Debian or Ubuntu, including under `set -Eeuo pipefail` and `set -u`, since callers use strict mode.
4. Run `bash -n` and `shellcheck` on every file you touched.
5. Update the matching page under `docs/` when you change a function's arguments, return codes or behavior.
6. Open the pull request and describe what changed and why.

## Code conventions

- Functions are namespaced `mflibs::<library>::<function>`; a library lives in `src/libs/<library>.sh`.
- Quote variables, use `local` (or `declare`) inside functions, and return documented codes.
- Each file starts with a metadata header (`@file_name`, `@version`, `@description`, `@license`). Bump `@version` when you change a file.
- Document each function with `@description`, `@arg`, `@return_code` and `@example` comments directly above it.
- A library must be safe to source more than once.
- Keep comments that explain why the code does something; leave out comments about how you debugged it.

## Commits

Use conventional commits: `type(scope): description`, where the type is one of `feat`, `fix`, `refactor`, `docs`, `test`, `chore`, `perf`, or `style`, and the scope is the library (for example `fix(log): ...`). Keep the subject short and use a few plain bullets in the body if more detail helps.

## License

By contributing you agree that your contribution is licensed under the BSD 3-Clause License in [license](license).
