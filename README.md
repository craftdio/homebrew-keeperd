# Homebrew Tap for KeepERD

KeepERD is an independent, unofficial fork based on [ChartDB](https://github.com/chartdb/chartdb). It is not affiliated with or endorsed by ChartDB.

This tap installs the prebuilt, immutable KeepERD runtime asset published by the [official KeepERD GitHub Release](https://github.com/craftdio/keeperd). Homebrew does not rebuild the frontend during installation. The formula installs the exact official Node.js 26.12.1 runtime privately with SHA-256-pinned resources for macOS/Linux on ARM64/x64. It does not replace or depend on the user's system Node. SQLite storage requires this exact runtime.

## Install

```sh
brew tap craftdio/keeperd
brew install keeperd
```

## Use

```sh
keeperd init
keeperd start
```

Docker is not installed by this Formula. Install and start Docker Desktop or another compatible Docker runtime separately when KeepERD needs to reproduce schemas with PostgreSQL.

## Upgrade

```sh
keeperd stop
brew update
brew upgrade craftdio/keeperd/keeperd
keeperd --version
keeperd start
```

Keep the original browser address/port for the first upgraded visit so existing IndexedDB data can migrate automatically. Each original browser/profile must visit once; originals are preserved. The latest complete ERD is selected by its saved timestamp. See the [migration and recovery guide](https://github.com/craftdio/keeperd/blob/main/tools/local-erd/SQLITE.md).

## Maintainers

After publishing a KeepERD GitHub Release, run **Actions → Update KeepERD Formula → Run workflow** with `main` selected. Other branches are rejected. Enter the version without `v` (for example, `0.1.3`). The workflow checks the maintainer's GitHub identity, verifies the release archive against its published checksum, then installs and tests the updated Formula on macOS ARM64 and Intel. Pull requests run the same read-only validation for the maintainer; only manual runs publish a version branch. Validation and branch creation use the same `main` commit from the start of the run. Only after those checks pass does it commit the Formula to a `formula/keeperd-vX.Y.Z` branch. Review the branch and open a pull request manually before merging it into `main`.

Only `EunjinWoo` is authorized to start or re-run this workflow. In addition to the workflow's actor check, keep the repository Actions execution policy scoped to `.github/workflows/update-formula.yml` with `EunjinWoo` as its sole allowed actor. The repository's default `GITHUB_TOKEN` permissions remain read-only; only the final branch-update job requests write access. GitHub Actions does not need permission to create or approve pull requests.

To update the Formula locally instead:

```sh
./scripts/update-formula.sh X.Y.Z
ruby -c Formula/keeperd.rb
```

The updater also reads the exact Node engine from the verified release archive and rejects a formula whose four runtime resources use another version. A Node upgrade requires explicitly updating all resource URLs/checksums and rerunning the installation and SQLite persistence tests.
