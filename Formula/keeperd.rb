class Keeperd < Formula
  desc "Local ERD synchronization CLI for KeepERD"
  homepage "https://github.com/craftdio/keeperd"
  url "https://github.com/craftdio/keeperd/releases/download/v0.1.0/keeperd-v0.1.0.tar.gz"
  sha256 "6397b2fe8404807393dd36ebdc5b60292d9d0d96750933e27bea63c1dd0b93ed"
  license "AGPL-3.0-only"

  depends_on "gh"
  depends_on "git"
  depends_on "node"

  def install
    runtime_root = buildpath/"keeperd-v#{version}"
    runtime_root = buildpath unless runtime_root.directory?

    libexec.install runtime_root.children

    (bin/"keeperd").write <<~SH
      #!/bin/sh
      exec "#{formula_opt_bin("node")}/node" "#{libexec}/bin/keeperd.mjs" "$@"
    SH
    (bin/"keeperd").chmod 0755
  end

  test do
    assert_match "KeepERD #{version}", shell_output("#{bin}/keeperd --version")
    assert_match "keeperd <command> [options]", shell_output("#{bin}/keeperd --help")
  end
end
