class Repon < Formula
  desc "A terminal UI for the outer loop: seeing many git repos at once and acting on many in one gesture"
  homepage "https://github.com/paulchiu/repon"
  version "0.30.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/paulchiu/repon/releases/download/v0.30.0/repon-aarch64-apple-darwin.tar.xz"
      sha256 "2d054075455661cd99702f573808954529e357de647477f841c09778b628e699"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paulchiu/repon/releases/download/v0.30.0/repon-x86_64-apple-darwin.tar.xz"
      sha256 "72cac953b4d0de8ac6ed7249d5510153e5185c6482388e586b9cdff6830ca2ff"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/paulchiu/repon/releases/download/v0.30.0/repon-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "2e5d89424f8517b941d3c0eac55ce654d6418816509e8df71a94ce72a70064ec"
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
