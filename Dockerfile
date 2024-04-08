# Build args are scoped weridly in docker, so it needs to be redeclared after
# each FROM. We need to set this manually because the releases don't come out
# immediately at the beginning of the year
ARG TL_YEAR=2024

FROM mcr.microsoft.com/devcontainers/base:bookworm as base
RUN apt-get update && apt-get install -y
RUN apt-get install -y fontconfig wget

FROM base as builder
ARG TL_YEAR

RUN mkdir /tmp/texlive
WORKDIR /tmp/texlive
RUN wget https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
RUN tar -xzf install-tl-unx.tar.gz
RUN cd install-tl-2* && perl ./install-tl --no-interaction --scheme=small
# Additional packages beyond the scheme we just installed
RUN /usr/local/texlive/${TL_YEAR}/bin/$(uname -m)-linux/tlmgr install latexmk subfiles placeins

FROM base as final
ARG TL_YEAR
COPY --from=builder /usr/local/texlive /usr/local/texlive
USER vscode
RUN echo "export PATH=/usr/local/texlive/${TL_YEAR}/bin/$(uname -m)-linux:$PATH" >> ~/.bashrc
