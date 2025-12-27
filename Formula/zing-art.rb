class ZingArt < Formula
  desc " A TUI for physical string art placement. It takes a sequence, you pull the thread. ZING: Zing Is Not Generating."
  homepage "https://github.com/000volk000/zing"
  version "1.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/000volk000/zing/releases/download/v1.0.0/zing-art-aarch64-apple-darwin.tar.xz"
      sha256 "01ca6a800580715d0aa67c9042d30fbe84dd3af0d5bac5110d09e39be390b8c1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/000volk000/zing/releases/download/v1.0.0/zing-art-x86_64-apple-darwin.tar.xz"
      sha256 "54eacc0f91f9a769c1bd875569284939214c13b4eaf63278b32160019cb5189f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/000volk000/zing/releases/download/v1.0.0/zing-art-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a107e9cf68c0b5fabb6b9641f4d1377c446cd338fe3c0fa7432ae174144e23c5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/000volk000/zing/releases/download/v1.0.0/zing-art-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fb018d004c0d3036252150ff7c8c85ba8bdb2893f303aa5c7f9479863c69ae70"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
    bin.install "zing-art" if OS.mac? && Hardware::CPU.arm?
    bin.install "zing-art" if OS.mac? && Hardware::CPU.intel?
    bin.install "zing-art" if OS.linux? && Hardware::CPU.arm?
    bin.install "zing-art" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
