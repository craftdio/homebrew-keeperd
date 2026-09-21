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

Update the Formula only after a KeepERD GitHub Release is published:

```sh
./scripts/update-formula.sh X.Y.Z
ruby -c Formula/keeperd.rb
```
