# Changelog

## v1.1.0 (2025-12-24) - release

### Features
- Added a native Windows installer so the toolkit can be installed without relying on WSL; see [install/install_atarist_toolkit_docker.cmd](install/install_atarist_toolkit_docker.cmd).
- Enhanced the stcmd wrapper to auto-select the working folder and support the STCMD_QUIET flag for silent startup; see [install/install_atarist_toolkit_docker.sh](install/install_atarist_toolkit_docker.sh).
- Allow installers to override the Docker account when pulling images, making it easier to consume custom builds; see [install/install_atarist_toolkit_docker.sh](install/install_atarist_toolkit_docker.sh).

### Changes
- Upgraded the Docker base image to Ubuntu 24.04, added extra MiNT libraries, and now publish native arm64 images; see [Dockerfile](Dockerfile) and [Makefile](Makefile).
- Hardened the build scripts to normalise architecture detection and document the new installation workflow; see [Makefile](Makefile) and [README.md](README.md).

### Fixes
- Corrected the default working folder passed to stcmd so builds start in the current directory when ST_WORKING_FOLDER is unset; see [install/install_atarist_toolkit_docker.sh](install/install_atarist_toolkit_docker.sh).
- Ensured arm64 hosts select a compatible Docker platform when running stcmd; see [install/install_atarist_toolkit_docker.sh](install/install_atarist_toolkit_docker.sh).

---

## v1.0.0 (2024-12-01) - release

### Features
- First public release.

---