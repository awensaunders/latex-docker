FROM mcr.microsoft.com/devcontainers/base:bookworm as base

RUN apt-get update && apt-get install -y
RUN apt install -y fontconfig wget
FROM base as builder

RUN mkdir /tmp/texlive
WORKDIR /tmp/texlive
RUN wget https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
RUN tar -xzf install-tl-unx.tar.gz
RUN cd install-tl-2* && perl ./install-tl --no-interaction --scheme=small
RUN export PATH=/usr/local/texlive/$(date -I | cut -c 1-4)/bin/$(uname -m)-linux:$PATH

# Additional packages beyond the scheme we just installed
RUN tlmgr install latexmk subfiles placeins

FROM base as final
COPY --from=builder /usr/local/texlive /usr/local/texlive
USER vscode
RUN echo "export PATH=/usr/local/texlive/$(date -I | cut -c 1-4)/bin/$(uname -m)-linux:$PATH" >> ~/.bashrc
