FROM debian:bookworm

RUN apt-get update && \
    apt-get -y upgrade && \
    # 1. Install prerequisites
    apt-get install -y --no-install-recommends \
        curl ca-certificates gnupg lsb-release bash-completion \
        tar git make gcc libcap2-bin && \
    # 2. Add GitHub CLI Repo
    mkdir -p -m 755 /etc/apt/keyrings && \
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null && \
    chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" > /etc/apt/sources.list.d/github-cli.list && \
    # 3. Add Azure CLI Repo
    curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/keyrings/microsoft.gpg && \
    chmod go+r /etc/apt/keyrings/microsoft.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" > /etc/apt/sources.list.d/azure-cli.list && \
    # 4. Install GH and AZ CLI
    apt-get update && \
    apt-get install -y --no-install-recommends gh azure-cli && \
    # 5. Install Neovim
    curl -fsSL https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz -o /tmp/nvim.tar.gz && \
    mkdir -p /opt/nvim && tar -xzf /tmp/nvim.tar.gz --strip-components=1 -C /opt/nvim && \
    ln -s /opt/nvim/bin/nvim /usr/local/bin/nvim && rm /tmp/nvim.tar.gz && \
    # 6. Install Kubectl via az cli (installs to /usr/local/bin/kubectl by default)
    az aks install-cli && \
    # 7. Install K9s
    curl -fsSL https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_amd64.tar.gz -o /tmp/k9s.tar.gz && \
    tar -xzf /tmp/k9s.tar.gz -C /usr/local/bin k9s && rm /tmp/k9s.tar.gz && \
    # 8. Clean up apt cache only 
    rm -rf /var/lib/apt/lists/* && \
    # 9. Install LazyVim
    git clone https://github.com/LazyVim/starter ~/.config/nvim && \
    rm -rf ~/.config/nvim/.git

CMD ["/bin/bash"]
