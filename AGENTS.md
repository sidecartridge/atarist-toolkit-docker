# AGENTS.md — Atari ST Toolkit Docker

Quick notes for anyone hacking on this repo:

> `CLAUDE.md` only imports this file (`@AGENTS.md`). Edit `AGENTS.md`, never `CLAUDE.md`, so both stay in sync.

## Repo overview
- **Purpose:** Provides the `stcmd` CLI + Docker images for Atari ST cross-development (vasm, gcc, libcmini, AGT, etc.).
- **Images:** Multi-arch builds (x86_64 + arm64) tagged by version, date, and `latest`.
- **Installers:** `install/install_atarist_toolkit_docker.sh` (Unix) and `.cmd` (Windows) generate the `stcmd` helper on the host.

## Build & CI
- `Makefile` drives builds/publish; CI (publish.yml) tags/pushes to Docker Hub + GitHub releases.

## Two cross toolchains
- **`m68k-atari-mint`**: gcc 4.6.4, binutils 2.30 (a.out), from `ppa:vriviere/ppa` (and
  `ppa:vriviere/arm` on arm64). The entrypoint's `gcc` shortcut runs it: keep it that way, so
  existing projects build exactly as before.
- **`m68k-atari-mintelf`**: gcc 13.3, binutils 2.42 (ELF), from `ppa:vriviere/mintelf`, in the
  `mintelf` stage. Every file it installs has the `mintelf` name, so it can't replace any of the
  old toolchain's (dpkg would refuse the install).
- **arm64 gets gcc 13 prebuilt.** The mintelf PPA builds gcc, binutils and mintbin for amd64
  only (its arm64 index has only the architecture-independent libraries).
  [atarist-mintelf-arm64](https://github.com/neilrackett/atarist-mintelf-arm64) rebuilds them
  from the PPA's own source packages on GitHub's arm64 runner and publishes them as releases,
  with their sources. The `mintelf` stage downloads them on arm64 (`MINTELF_ARM64`) and checks
  them against the SHA-256 hashes written into the Dockerfile. For a new PPA version: run that
  repo's workflow with a new release tag, then update `MINTELF_ARM64` and the hashes. GitHub
  turns the `~` in a version into a `.` in asset names.

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

## Release workflow

These rules apply to every new version:

- **A version starts with a release branch.** Create `release/vX.Y.Z` from `main`, where `vX.Y.Z`
  is exactly what `version.txt` will contain for that release.
- **One branch per epic, cut from the release branch**, named `epic/NN-<slug>`. All work for the
  epic is committed there, including the `version.txt` bump in the first epic of a release.
- **An epic's pull request targets `release/vX.Y.Z`, never `main`.** It is merged only after
  the epic has been verified on real hardware (build, flash, run on an Atari ST).
- **`main` receives the release branch once**, when the whole version is done and verified. Only
  then is the tag pushed (`make tag`), which triggers the release workflow.
- Before tagging: the release build (not a debug build) passes on real hardware, and
  `CHANGELOG.md` describes the release for its users.
- Commit, push, open and merge pull requests only when the user asks.

## Working style

These behavioral guidelines bias toward caution over speed. For trivial tasks, use judgment.

### 1. Think before coding

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them — don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

### 2. Simplicity first

Minimum code that solves the problem. Nothing speculative.
- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

### 3. Surgical changes

Touch only what you must. Clean up only your own mess.
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it — don't delete it.
- When your changes orphan an import/variable/function, remove it. Don't remove pre-existing dead code unless asked.

The test: every changed line should trace directly to the user's request.

### 4. Goal-driven execution

Define success criteria. Loop until verified.
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan with a verification check per step.

### 5. No AI attribution

Never add AI-tool attribution to commits, PR descriptions, code comments,
docs, or any other artifact. This means **no**:
- "Generated with Claude Code", "Co-authored by Claude", "Made with ChatGPT",
  or any similar phrasing.
- `Co-Authored-By: Claude …`, `Co-Authored-By: ChatGPT …`, or any other
  AI co-author trailer.
- "AI-assisted", "written with the help of an LLM", etc., as comments or
  changelog entries.

Write the message as the human author. Do not mention AI tools used to
produce the work.

Document any major decisions or gotchas here so future agents ramp quickly.
