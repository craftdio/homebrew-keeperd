<p align="center">
  <b>Install and update KeepERD with Homebrew.</b>
</p>

<h5 align="center">
  <a href="#install">Install</a> &bull;
  <a href="#upgrade">Upgrade</a> &bull;
  <a href="#troubleshooting">Troubleshooting</a> &bull;
  <a href="https://github.com/craftdio/keeperd">KeepERD</a>
</h5>

---

<h1 align="center">
  <img src="./docs/assets/keeperd-banner.png" width="760" alt="KeepERD — dark banner with an icy-blue geometric symbol and off-white wordmark">
</h1>

<p align="center">
  <b>Homebrew Tap for KeepERD</b><br>
  Prebuilt app. Managed runtime. Simple upgrades.
</p>

<h3 align="center">
  <a href="#install">Install</a> &bull;
  <a href="#upgrade">Upgrade</a> &bull;
  <a href="https://github.com/craftdio/keeperd/blob/main/tools/local-erd/README.md">Product Guide</a>
</h3>

<p align="center">
  <a href="Formula/keeperd.rb"><img src="https://img.shields.io/badge/Install-Homebrew-91BEC9?logo=homebrew&amp;logoColor=white&amp;labelColor=161B22" alt="Install with Homebrew"></a>
  <a href="Formula/keeperd.rb"><img src="https://img.shields.io/badge/Runtime-Node.js%2026.12.1-91BEC9?logo=nodedotjs&amp;logoColor=white&amp;labelColor=161B22" alt="Homebrew-managed Node.js 26.12.1 runtime"></a>
  <a href="https://github.com/craftdio/keeperd/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-AGPL--3.0-91BEC9?labelColor=161B22" alt="KeepERD is licensed under GNU AGPL v3"></a>
</p>

---

## Install

With [Homebrew](https://brew.sh) available:

```sh
brew tap craftdio/keeperd
brew install keeperd
keeperd init
keeperd start
```

The formula installs the prebuilt app, Git, GitHub CLI, and a private **Node.js 26.12.1** runtime. No source checkout, npm install, or manual Node setup is needed. Your system Node is unchanged.

Install and start Docker Desktop or another Docker-compatible runtime separately for schema replay. Open the address printed by `keeperd start`. See the [setup guide](https://github.com/craftdio/keeperd/blob/main/tools/local-erd/SETUP.md) for GitHub authentication and local repositories.

## Upgrade

```sh
keeperd stop
brew update
brew upgrade keeperd
keeperd start
```

Check the installed version with `keeperd --version`. Your workspace remains in its data directory. When upgrading from browser storage, revisit the original address and port in each original browser or profile once. See [migration and recovery](https://github.com/craftdio/keeperd/blob/main/tools/local-erd/SQLITE.md).

## Troubleshooting

| Issue                        | What to check                                                                                                                           |
| ---------------------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| Formula is not found         | Run `brew update` and confirm `brew tap craftdio/keeperd` succeeds.                                                                     |
| `keeperd` is not found       | Confirm Homebrew is on your shell's `PATH` and check `brew list keeperd`.                                                               |
| Runtime files are missing    | Stop KeepERD, then run `brew reinstall keeperd`.                                                                                        |
| Docker is unavailable        | Start your Docker runtime and check `docker info`.                                                                                      |
| Authentication or Sync fails | Follow the [application troubleshooting guide](https://github.com/craftdio/keeperd/blob/main/tools/local-erd/SETUP.md#troubleshooting). |

Report installation or formula problems in [this tap's issues](https://github.com/craftdio/homebrew-keeperd/issues). Report app behavior in [KeepERD Issues](https://github.com/craftdio/keeperd/issues).

<a id="maintainers"></a>

<details>
<summary>Maintainers: update the formula</summary>

After publishing a [KeepERD release](https://github.com/craftdio/keeperd/releases), run **Actions → Update KeepERD Formula → Run workflow** on `main`, using a version without `v`. Only `EunjinWoo` may start or re-run it.

The workflow verifies the release checksum and exact runtime, then tests installation on macOS ARM64 and Intel. A manual run creates a `formula/keeperd-vX.Y.Z` branch only after validation passes. Review that branch and open a pull request before merging the formula update. Pull-request runs perform validation without publishing a branch.

For a local update:

```sh
./scripts/update-formula.sh X.Y.Z
ruby -c Formula/keeperd.rb
```

Keep the Actions execution policy scoped to `.github/workflows/update-formula.yml` with `EunjinWoo` as the sole allowed actor. Default token permissions remain read-only; only the final branch-update job requests write access. Actions does not need pull-request creation or approval permissions.

A Node upgrade requires updating all four checksum-pinned runtime resources and rerunning installation, runtime, and SQLite persistence checks. The release archive itself does not include Node.

</details>

---

KeepERD is an independent, unofficial fork of [ChartDB](https://github.com/chartdb/chartdb), with no affiliation or endorsement. See the product's [LICENSE](https://github.com/craftdio/keeperd/blob/main/LICENSE) and [NOTICE](https://github.com/craftdio/keeperd/blob/main/NOTICE).
