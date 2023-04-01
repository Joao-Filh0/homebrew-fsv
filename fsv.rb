class Fsv < Formula
  include Language::Python::Virtualenv

  url "https://github.com/Joao-Filh0/fsv/archive/refs/tags/0.0.13.tar.gz"
  sha256 "08f706e8627f6207725fd997d314636b279d7eaa8e7a0d61d4e6905dc2a5670a"
  version "1.0.13"
  head "https://github.com/Joao-Filh0/fsv.git", branch: "main"

  depends_on "python@3.10"

  def install
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install_and_link buildpath

    (buildpath/"fsv").write <<~EOS
      #!/bin/bash
      exec "#{libexec}/bin/python" "#{libexec}/main.py" "$@"
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
      You should add the following to your shell configuration file:
        export FSV_HOME="#{libexec}"
    EOS
  end
end
