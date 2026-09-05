class Repon < Formula
  desc "A terminal UI for the outer loop: seeing many git repos at once and acting on many in one gesture"
  homepage "https://github.com/paulchiu/repon"
  version "0.29.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/paulchiu/repon/releases/download/v0.29.3/repon-aarch64-apple-darwin.tar.xz"
      sha256 "c94e9b16b602585c18850c7e922f37eaad0c466ea0d6cc8443fa2e13da3436ab"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paulchiu/repon/releases/download/v0.29.3/repon-x86_64-apple-darwin.tar.xz"
      sha256 "abc4a0753da1e6efedf140db1b7f751fb4cbd877e8f4f22d2d212f5b1a752f3c"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/paulchiu/repon/releases/download/v0.29.3/repon-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "f0cf979022953109bb227da871469f9992c1dd266373eb7e29c29f6dd747d478"
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
      bin.install "repon"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "repon"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "repon"
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
