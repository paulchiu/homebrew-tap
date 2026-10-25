class Teamzones < Formula
  desc "Who's available and where it's busy, on one time axis. A Rust TUI."
  homepage "https://github.com/paulchiu/teamzones-tui"
  version "0.12.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/paulchiu/teamzones-tui/releases/download/v0.12.0/teamzones-aarch64-apple-darwin.tar.xz"
      sha256 "a5c57cdc27b476a0aafd40ca628d71f3df1f82b6f4f545eb41971806b5c5b9b6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paulchiu/teamzones-tui/releases/download/v0.12.0/teamzones-x86_64-apple-darwin.tar.xz"
      sha256 "90674be8e5b66ef842ce513785d5167f7ec178c18bc07cff7f6b60dbef81e061"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/paulchiu/teamzones-tui/releases/download/v0.12.0/teamzones-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "7c49e3b5a18d6363ce0493d8f66af8ae4c7669c6f316402ab5e2ddd45cf36c0e"
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
