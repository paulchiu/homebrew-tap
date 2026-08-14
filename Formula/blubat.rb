class Blubat < Formula
  desc "Bluetooth battery monitor for macOS: one-shot CLI readings, JSON output and a live TUI"
  homepage "https://github.com/paulchiu/blubat"
  version "0.14.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/paulchiu/blubat/releases/download/v0.14.2/blubat-aarch64-apple-darwin.tar.xz"
      sha256 "ffbce01db31d541e68ba924568a05402294cb05cd2f0bc118e48ec9ec8b0f2c4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paulchiu/blubat/releases/download/v0.14.2/blubat-x86_64-apple-darwin.tar.xz"
      sha256 "b8dd2f5206a6c7466d91dae62d6420a024d0972d868facf28c5bbf7c3447955b"
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
