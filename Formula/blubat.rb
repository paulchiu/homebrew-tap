class Blubat < Formula
  desc "Bluetooth battery monitor for macOS: one-shot CLI readings, JSON output and a live TUI"
  homepage "https://github.com/paulchiu/blubat"
  version "0.13.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/paulchiu/blubat/releases/download/v0.13.1/blubat-aarch64-apple-darwin.tar.xz"
      sha256 "b9a28481eac8ac7f071ee2be162176ed966d02c58485f04949d8161591459572"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paulchiu/blubat/releases/download/v0.13.1/blubat-x86_64-apple-darwin.tar.xz"
      sha256 "dd5dfb5cb29f16381effde744e83786ba02934ac306757abdd9ea32ff8ad2303"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "blubat"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "blubat"
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
