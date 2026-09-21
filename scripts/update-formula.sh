#!/bin/sh

set -eu

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 VERSION" >&2
  exit 1
fi

VERSION="$1"
if ! printf '%s\n' "${VERSION}" | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+(-[0-9A-Za-z]+([.-][0-9A-Za-z]+)*)?(\+[0-9A-Za-z]+([.-][0-9A-Za-z]+)*)?$'; then
  echo "VERSION must be plain SemVer without a leading v, for example 0.1.0." >&2
  exit 1
fi

if ! command -v gh >/dev/null 2>&1; then
  echo "GitHub CLI (gh) is required." >&2
  exit 1
fi

SCRIPT_DIR=$(CDPATH= cd "$(dirname "$0")" && pwd)
REPOSITORY_ROOT=$(CDPATH= cd "${SCRIPT_DIR}/.." && pwd)
FORMULA="${REPOSITORY_ROOT}/Formula/keeperd.rb"
REPOSITORY="craftdio/keeperd"
TAG="v${VERSION}"
ARCHIVE="keeperd-v${VERSION}.tar.gz"
CHECKSUM="${ARCHIVE}.sha256"
URL="https://github.com/${REPOSITORY}/releases/download/${TAG}/${ARCHIVE}"
TEMP_DIR=$(mktemp -d "${TMPDIR:-/tmp}/keeperd-formula.XXXXXX")

cleanup() {
  rm -rf "${TEMP_DIR}"
}
trap cleanup EXIT HUP INT TERM

gh release download "${TAG}" \
  --repo "${REPOSITORY}" \
  --pattern "${ARCHIVE}" \
  --pattern "${CHECKSUM}" \
  --dir "${TEMP_DIR}"

EXPECTED_SHA=$(awk 'NR == 1 { print $1; exit }' "${TEMP_DIR}/${CHECKSUM}")
if ! printf '%s\n' "${EXPECTED_SHA}" | grep -Eq '^[0-9a-fA-F]{64}$'; then
  echo "Published checksum file is invalid: ${CHECKSUM}" >&2
  exit 1
fi

ACTUAL_SHA=$(shasum -a 256 "${TEMP_DIR}/${ARCHIVE}" | awk '{ print $1 }')
if [ "${EXPECTED_SHA}" != "${ACTUAL_SHA}" ]; then
  echo "Published checksum does not match ${ARCHIVE}." >&2
  exit 1
fi

ruby - "${FORMULA}" "${URL}" "${ACTUAL_SHA}" > "${TEMP_DIR}/keeperd.rb" <<'RUBY'
formula_path, url, sha256 = ARGV
source = File.read(formula_path)

unless source.sub!(/^  url ".*"$/, "  url \"#{url}\"")
  abort "Could not update Formula URL."
end
unless source.sub!(/^  sha256 ".*"$/, "  sha256 \"#{sha256}\"")
  abort "Could not update Formula SHA-256."
end

print source
RUBY

ruby -c "${TEMP_DIR}/keeperd.rb"
mv "${TEMP_DIR}/keeperd.rb" "${FORMULA}"
ruby -c "${FORMULA}"

echo "Updated Formula/keeperd.rb for ${TAG}."
