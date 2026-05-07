# AGENTS.md — docker (islasgeci/base)

This repo defines the `islasgeci/base` Docker image, a reproducible data-science
environment built on `rocker/tidyverse` (Ubuntu 24.04 + R + Python 3.12 + LaTeX)
for Grupo de Ecología y Conservación de Islas (GECI). It produces dynamic PDF
reports via LaTeX/PythonTeX and verifies all installed tooling through Makefile
targets.

## Build and run

```shell
docker build --tag islasgeci/base:latest .
docker run -it islasgeci/base:latest          # interactive shell
```

## Test

All tests run **inside the container** — they verify versions of system packages,
Python modules, R packages, and tools:

```shell
# Full suite:
docker run --volume ${PWD}:/workdir islasgeci/base:latest make tests

# Single targets (list available with `make` or read Makefile):
docker run --volume ${PWD}:/workdir islasgeci/base:latest make test_os_packages
docker run --volume ${PWD}:/workdir islasgeci/base:latest make test_python_version
docker run --volume ${PWD}:/workdir islasgeci/base:latest make test_pythontex
```

## CI / Deploy

Only the `develop` branch triggers CI (`.github/workflows/develop.yml`).
The workflow builds the image, runs `make tests`, then pushes to Docker Hub
with tags: `latest`, `<ubuntu-version>`, `<ubuntu-version>.<YY><week>`.

Manual trigger available via `workflow_dispatch`.

## Dockerfile quirks

- `PIP_BREAK_SYSTEM_PACKAGES=1` — pip installs system-wide without warning.
- `QT_QPA_PLATFORM=offscreen` — Qt offscreen mode for headless environments.
- `ENV TZ=US/Pacific` — timezone set during build.
- `python3` is symlinked to `/usr/bin/python`.
- `cambia_formato_fecha` is installed from `IslasGECI/queries` via `make install`.
- ShellSpec (shell-script test framework) is installed via `src/install_shellspec.sh`.

## Clean

```
make clean   # removes reports/ artifacts (.aux, .log, .pdf, .pytxcode)
```

## Layout

- `Dockerfile` — image definition.
- `Makefile` — test and maintenance targets.
- `src/` — install scripts (e.g. `install_shellspec.sh`).
- `reports/` — LaTeX/PythonTeX templates for PDF-generation validation.
- `tests/data/` — test fixtures (e.g. `test.csv` for `cambia_formato_fecha`).

## Style

- Commit messages use emoji prefixes (🏷️, 📋, 🔄, etc.).
- Docs are in Spanish.
