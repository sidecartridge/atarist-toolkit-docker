# Changelog

All notable changes to this project will be documented in this file.

## [1.2.1] - 2026-02-24
### Fixed
- Installer scripts now use `STCMD_IMAGE_TAG` instead of the generic `VERSION` environment variable to avoid collisions with host shells.
- GitHub Publish workflow pushes `latest` Docker tags alongside versioned tags, and release assets overwrite the `latest` draft for installers.
- README now references the `latest` installer URLs and documents the `STCMD_QUIET` / `STCMD_NO_TTY` runtime flags.

## [1.2.0] - 2026-02-??
### Added
- Introduced the `STCMD_NO_TTY` environment variable so non-interactive automation can run `stcmd` without allocating a TTY.
