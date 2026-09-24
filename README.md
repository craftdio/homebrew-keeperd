# Homebrew Tap for KeepERD

KeepERD is an independent, unofficial fork based on [ChartDB](https://github.com/chartdb/chartdb). It is not affiliated with or endorsed by ChartDB.

This tap installs the prebuilt, immutable KeepERD runtime asset published by the [official KeepERD GitHub Release](https://github.com/craftdio/keeperd). Homebrew does not rebuild the frontend during installation.

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

## Maintainers

After publishing a KeepERD GitHub Release, run **Actions → Update KeepERD Formula → Run workflow** on the default branch. Enter the version without `v` (for example, `0.1.3`). The workflow downloads the release archive and checksum, verifies the archive, and opens a Formula pull request. Review and merge that PR to publish the tap update; running the workflow does not update `main` directly.

Only `EunjinWoo` is authorized to start or re-run this workflow. In addition to the workflow's actor check, keep the repository Actions execution policy scoped to `.github/workflows/update-formula.yml` with `EunjinWoo` as its sole allowed actor. The repository must also allow GitHub Actions to create pull requests while retaining the default read-only `GITHUB_TOKEN` permissions; this workflow requests write access only for its update job.

To update the Formula locally instead:

```sh
./scripts/update-formula.sh X.Y.Z
ruby -c Formula/keeperd.rb
```
