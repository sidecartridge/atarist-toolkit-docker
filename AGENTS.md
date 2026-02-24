# AGENTS.md — Atari ST Toolkit Docker

Quick notes for anyone hacking on this repo:

## Repo overview
- **Purpose:** Provides the `stcmd` CLI + Docker images for Atari ST cross-development (vasm, gcc, libcmini, AGT, etc.).
- **Images:** Multi-arch builds (x86_64 + arm64) tagged by version, date, and `latest`.
- **Installers:** `install/install_atarist_toolkit_docker.sh` (Unix) and `.cmd` (Windows) generate the `stcmd` helper on the host.

## Branch workflow
- No direct pushes to `sidecartridge/atarist-toolkit-docker` main. Fork + branch (e.g., `chati/<feature>`), PR back upstream.
- `Makefile` drives builds/publish; CI (publish.yml) tags/pushes to Docker Hub + GitHub releases.

## Key env vars in scripts
- `DOCKER_ACCOUNT` (default `logronoide`) controls image destination.
- `STCMD_IMAGE_TAG` replaces earlier `VERSION` usage to avoid OS env clashes.
- `ST_WORKING_FOLDER` mounts host source dir; `STCMD_QUIET` and `STCMD_NO_TTY` control wrapper behavior.

## Useful commands
```bash
# Build + push (needs DOCKERHUB creds)
make DOCKER_ACCOUNT=<you> publish

# Re-generate installers
make release

# Tag release
make tag
```

## Current branch
- `chati/prep-work`: staging Installer/env var fixes + publish workflow tweaks + README updates.

Document any major decisions or gotchas here so future agents ramp quickly.
