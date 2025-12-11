FROM debian:bookworm

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y --no-install-recommends curl ca-certificates git tar git make gcc libcap2-bin && \
    curl -fsSL https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz -o /tmp/nvim.tar.gz && \
    mkdir -p /opt/nvim && \
    tar -xzf /tmp/nvim.tar.gz --strip-components=1 -C /opt/nvim && \
    ln -s /opt/nvim/bin/nvim /usr/local/bin/nvim && \
    rm /tmp/nvim.tar.gz && \
    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/LazyVim/starter ~/.config/nvim

RUN rm -rf ~/.config/nvim/.git


CMD ["/bin/bash"]
