class Keeperd < Formula
  desc "Local ERD synchronization CLI for KeepERD"
  homepage "https://github.com/craftdio/keeperd"
  url "https://github.com/craftdio/keeperd/releases/download/v0.1.4/keeperd-v0.1.4.tar.gz"
  sha256 "565de8d4cce0a0d5d5cadec8b6437c2afd9fea8135cbd2dfb4de3471b25cf81b"
  license "AGPL-3.0-only"

  depends_on "gh"
  depends_on "git"

  on_macos do
    on_arm do
      resource "node-runtime" do
        url "https://nodejs.org/dist/v26.12.1/node-v26.12.1-darwin-arm64.tar.gz"
        sha256 "1901d539912c02afa10d1cc126943a8855a7eedebe830119463470db5e6c59e8"
      end
    end

    on_intel do
      resource "node-runtime" do
        url "https://nodejs.org/dist/v26.12.1/node-v26.12.1-darwin-x64.tar.gz"
        sha256 "b85c2ea4420ad0bc4abf2dc6cf1f55130ed681f1cabf60cf3f526e4c9e2712ff"
      end
    end
  end

  on_linux do
    on_arm do
      resource "node-runtime" do
        url "https://nodejs.org/dist/v26.12.1/node-v26.12.1-linux-arm64.tar.gz"
        sha256 "a6c01af459dd8972ab3fb08ee5da81244d26ba8c4944a62d5bbba8c597ae154f"
      end
    end

    on_intel do
      resource "node-runtime" do
        url "https://nodejs.org/dist/v26.12.1/node-v26.12.1-linux-x64.tar.gz"
        sha256 "0fd1eb7770598f52a21995edf6ed35fc690400fa437c2386af329519e9143132"
      end
    end
  end

  def install
    runtime_root = buildpath/"keeperd-v#{version}"
    runtime_root = buildpath unless runtime_root.directory?

    libexec.install runtime_root.children
    resource("node-runtime").stage do
      (libexec/"node-runtime").install Dir["*"]
    end

    (bin/"keeperd").write <<~SH
      #!/bin/sh
      exec "#{libexec}/node-runtime/bin/node" "#{libexec}/bin/keeperd.mjs" "$@"
    SH
    (bin/"keeperd").chmod 0755
  end

  test do
    assert_equal "v26.12.1", shell_output("#{libexec}/node-runtime/bin/node --version").strip
    assert_match "KeepERD #{version}", shell_output("#{bin}/keeperd --version")
    assert_match "keeperd <command> [options]", shell_output("#{bin}/keeperd --help")

    (testpath/"workspace.mjs").write <<~JS
      import assert from 'node:assert/strict';
      import { openWorkspace } from '#{libexec}/tools/local-erd/workspace-store.mjs';
      const diagram = {
        id: 'brew-test', name: 'Homebrew workspace', databaseType: 'postgresql',
        createdAt: '2026-01-01T00:00:00.000Z', updatedAt: '2026-01-01T00:00:00.000Z',
        tables: [], notes: [{ id: 'note', content: 'persists' }],
      };
      let store = openWorkspace('state');
      assert.equal(store.db.prepare('SELECT sqlite_version() version').get().version, '3.54.0');
      store.migrate({ diagrams: [diagram] });
      store.close();
      store = openWorkspace('state');
      assert.deepEqual(store.view().diagrams, [diagram]);
      store.close();
    JS
    system libexec/"node-runtime/bin/node", testpath/"workspace.mjs"
  end
end
