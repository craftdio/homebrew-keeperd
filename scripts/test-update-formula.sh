#!/bin/sh
set -eu

ROOT=$(CDPATH= cd "$(dirname "$0")/.." && pwd)
FIXTURE=$(mktemp -d "${TMPDIR:-/tmp}/keeperd-formula-test.XXXXXX")
trap 'rm -rf "$FIXTURE"' EXIT HUP INT TERM
mkdir -p "$FIXTURE/repo/scripts" "$FIXTURE/repo/Formula" "$FIXTURE/bin" "$FIXTURE/assets" "$FIXTURE/source/keeperd-v0.1.4"
cp "$ROOT/scripts/update-formula.sh" "$FIXTURE/repo/scripts/"
cp "$ROOT/Formula/keeperd.rb" "$FIXTURE/repo/Formula/"
cat > "$FIXTURE/bin/gh" <<'GH'
#!/bin/sh
set -eu
while [ "$#" -gt 0 ]; do
  if [ "$1" = --dir ]; then
    cp "$KEEPERD_FORMULA_TEST_ASSETS"/* "$2/"
    exit 0
  fi
  shift
done
exit 1
GH
chmod +x "$FIXTURE/bin/gh"
export PATH="$FIXTURE/bin:$PATH"
export KEEPERD_FORMULA_TEST_ASSETS="$FIXTURE/assets"

archive() {
  printf '{"engines":{"node":"%s"}}\n' "$1" > "$FIXTURE/source/keeperd-v0.1.4/package.json"
  tar -czf "$FIXTURE/assets/keeperd-v0.1.4.tar.gz" -C "$FIXTURE/source" keeperd-v0.1.4
  (cd "$FIXTURE/assets" && shasum -a 256 keeperd-v0.1.4.tar.gz > keeperd-v0.1.4.tar.gz.sha256)
}
archive 26.12.1
sh "$FIXTURE/repo/scripts/update-formula.sh" 0.1.4 > "$FIXTURE/result"
grep -q '/v0.1.4/keeperd-v0.1.4.tar.gz' "$FIXTURE/repo/Formula/keeperd.rb"
cp "$FIXTURE/repo/Formula/keeperd.rb" "$FIXTURE/before.rb"

printf '%064d  keeperd-v0.1.4.tar.gz\n' 0 > "$FIXTURE/assets/keeperd-v0.1.4.tar.gz.sha256"
if sh "$FIXTURE/repo/scripts/update-formula.sh" 0.1.4 > "$FIXTURE/result" 2>&1; then
  echo 'Updater accepted a wrong archive checksum.' >&2; exit 1
fi
grep -q 'Published checksum does not match' "$FIXTURE/result"
cmp "$FIXTURE/before.rb" "$FIXTURE/repo/Formula/keeperd.rb"

archive 27.0.0
if sh "$FIXTURE/repo/scripts/update-formula.sh" 0.1.4 > "$FIXTURE/result" 2>&1; then
  echo 'Updater accepted a mismatched Node runtime.' >&2; exit 1
fi
grep -q 'Formula Node resources must match release Node 27.0.0' "$FIXTURE/result"
cmp "$FIXTURE/before.rb" "$FIXTURE/repo/Formula/keeperd.rb"
echo 'Formula updater: valid artifact accepted; checksum and Node mismatches rejected without modifying the formula.'
