class Blubat < Formula
  desc "Bluetooth battery monitor for macOS: one-shot CLI readings, JSON output and a live TUI"
  homepage "https://github.com/paulchiu/blubat"
  version "0.10.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/paulchiu/blubat/releases/download/v0.10.0/blubat-aarch64-apple-darwin.tar.xz"
      sha256 "c1d733a5dbe6d6a4c492b3cad6326b30b47065d479eb0e25dbbf3bf65e96e27f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paulchiu/blubat/releases/download/v0.10.0/blubat-x86_64-apple-darwin.tar.xz"
      sha256 "46889e58b0a06649c6adaed575927df63f444e427625471f3c3d8a092b225d86"
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
