# Changelog

## v1.4.0 (2026-09-30) - release

### Features
- Added `zip` and `unzip` to the image so build artefacts can be packaged into archives, and third-party assets distributed as `.zip` files can be unpacked, without leaving the toolkit; see [Dockerfile](Dockerfile).

### Fixes
- git now works in the project folder: `stcmd` mounts it with the host user's id, which git inside the container did not see as the owner, so every git command a build ran (version strings, submodules...) failed with "detected dubious ownership". The image now trusts repositories at and below `/tmp` through `safe.directory`; see [Dockerfile](Dockerfile).
- git no longer warns `unable to access '/root/.config/git/...': Permission denied`: `HOME` is `/root`, which the host user `stcmd` runs as could not enter. It can now pass through it, without being able to read it; see [Dockerfile](Dockerfile).
- Restored the ability to build the image at all: the AGT tools were cloned from a fork that has since been deleted from Bitbucket, breaking every build. They now come from `d_m_l/agtools`, the original upstream already credited in the README, whose prebuilt Linux binaries are identical; see [Dockerfile](Dockerfile).

## v1.3.0 (2026-04-13) - release

### Features
- Added the GNU autotools (`autoconf`, `automake`, `libtool`, `pkg-config`) so projects that use the autotools build system can be configured and built inside the toolkit; see [Dockerfile](Dockerfile) and [README.md](README.md).
- Added the `gemlib` and `pml` MiNT libraries to the image; see [Dockerfile](Dockerfile).

### Fixes
- The installed `stcmd` wrapper now keeps the `DOCKER_ACCOUNT` and image tag the installer was run with, instead of always falling back to `logronoide` and `latest`; see [install/install_atarist_toolkit_docker.sh](install/install_atarist_toolkit_docker.sh) and [install/install_atarist_toolkit_docker.cmd](install/install_atarist_toolkit_docker.cmd).

## v1.2.1 (2026-02-24) - bugfix release

### Fixes
- Replaced the installer `VERSION` variable with `STCMD_IMAGE_TAG` (and updated the generated `stcmd` wrappers) to avoid clobbering host environment variables.
- README now references the `latest` release assets and documents the `STCMD_QUIET` / `STCMD_NO_TTY` runtime flags so automation is easier to configure.
- The publish Make target pushes the `latest` Docker tag alongside versioned tags, ensuring Docker Hub always exposes a rolling build.

## v1.2.0 (2026-02-23) - release

### Features
- Added the `STCMD_NO_TTY` environment variable so `stcmd` can run from CI scripts and other non-interactive contexts without allocating a TTY.

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

## v1.0.0 (2024-10-28) - release

### Features
- First public release.

---