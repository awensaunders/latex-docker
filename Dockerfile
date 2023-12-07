FROM mcr.microsoft.com/devcontainers/base:bookworm

RUN apt-get update && apt-get install -y
RUN mkdir /tmp/texlive
WORKDIR /tmp/texlive
RUN apt-get install -y wget
RUN wget https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
RUN tar -xzf install-tl-unx.tar.gz
RUN cd install-tl-2* && perl ./install-tl --no-interaction --location https://mirror.ox.ac.uk/sites/ctan.org/systems/texlive/tlnet
RUN apt install -y fontconfig
USER vscode
RUN echo "export PATH=/usr/local/texlive/$(date -I | cut -c 1-4)/bin/$(uname -m)-linux:$PATH" >> ~/.bashrc
