class HomebrewTap < Formula
    desc "Describe your project"
    homepage "https://github.com/GErP83/homebrew-tap"
    url "https://github.com/GErP83/homebrew-tap/archive/refs/tags/0.0.1.tar.gz"
    sha256 "cd07acd8106d8fbeb1e66d2f2539a598b929d55ae6fc27cfc978a7f646262489"
    def install
      system "swift", "build",
          "--configuration", "release",
          "--disable-sandbox"
      bin.install '.build/release/testify' 
    end
  end