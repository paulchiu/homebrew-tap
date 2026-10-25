class Teamzones < Formula
  desc "Who's available and where it's busy, on one time axis. A Rust TUI."
  homepage "https://github.com/paulchiu/teamzones-tui"
  version "0.14.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/paulchiu/teamzones-tui/releases/download/v0.14.0/teamzones-aarch64-apple-darwin.tar.xz"
      sha256 "74667fd2d2867dbd0a8e31155b8296fe35051a47d78e509219c82a533e8c5804"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paulchiu/teamzones-tui/releases/download/v0.14.0/teamzones-x86_64-apple-darwin.tar.xz"
      sha256 "3f1be7a7c1a77cdb18c9e472677a229cbd4604584b31c0768cff5a5eb03389ed"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/paulchiu/teamzones-tui/releases/download/v0.14.0/teamzones-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "0197c5d459062c90d426d3e8def880dafa3fe79113c15d98eeccc9286f949260"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "teamzones"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "teamzones"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "teamzones"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
