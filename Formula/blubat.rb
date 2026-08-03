class Blubat < Formula
  desc "Bluetooth battery monitor for macOS: one-shot CLI readings, JSON output and a live TUI"
  homepage "https://github.com/paulchiu/blubat"
  version "0.8.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/paulchiu/blubat/releases/download/v0.8.2/blubat-aarch64-apple-darwin.tar.xz"
      sha256 "77dcccf40923958526d22366d3a12d205863662d4a9502cf5b545785a5f5b03d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paulchiu/blubat/releases/download/v0.8.2/blubat-x86_64-apple-darwin.tar.xz"
      sha256 "69688ac4a9cb3d6987219edf2a889dbfc004a4bf1ace992e7d8e5e908a45a14f"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin":  {},
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
    bin.install "blubat" if OS.mac? && Hardware::CPU.arm?
    bin.install "blubat" if OS.mac? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
