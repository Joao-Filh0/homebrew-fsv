class Fsv < Formula
  include Language::Python::Virtualenv

  url "https://github.com/Joao-Filh0/fsv/archive/refs/tags/0.0.23.tar.gz"
  sha256 "49c52309be660f6cb7a51c164631ca37d075ff0557a3347f1fb924560f8f5ad8"
  version "1.0.23"
  head "https://github.com/Joao-Filh0/fsv.git", branch: "main"

  depends_on "python@3.10"

  def install
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install_and_link buildpath
    venv.pip_install "colorama"
    venv.pip_install "requests"
    venv.pip_install "argparse"
    venv.pip_install "urllib3"
    venv.pip_install "chardet"
    venv.pip_install "certifi"
    venv.pip_install "idna"


    (buildpath/"fsv").write <<~EOS
      #!/bin/bash
      exec "#{libexec}/bin/python3" "#{libexec}/main.py" "$@"
    EOS

    chmod 0755, buildpath/"fsv"
    bin.install buildpath/"fsv"
    libexec.install "main.py"
    cp_r "#{buildpath}/src", "#{libexec}"
  end

  test do
    system "#{bin}/fsv", "-pg"
  end

  def caveats
    <<~EOS
        export FSV_HOME="#{libexec}"
    EOS
  end
end
