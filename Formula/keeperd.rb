class Keeperd < Formula
  desc "Local ERD synchronization CLI for KeepERD"
  homepage "https://github.com/craftdio/keeperd"
  url "https://github.com/craftdio/keeperd/releases/download/v0.1.2/keeperd-v0.1.2.tar.gz"
  sha256 "cba24178e6bc8290da82455b686150c5d575e49dea2424e6e1db2fe40bfab6c9"
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
