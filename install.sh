#!/bin/bash

clear

GO_VERSION="1.18"
NODE_VERSION="16.15.1"
TF_VERSION='1.2.3'
TG_VERSION='0.38.1'
TERRAFILE_VERSION='0.7'
TF_DOCS_VERSION='0.16.0'

mkdir -p ~/.profile.d
mkdir -p ~/packages

ID=6e27d6adfc51a167384608b16d136a29;
REV=287d4acbc35f0dfe7d29513cb53d20af3f283aa0;
eval "$(curl -s -o- https://gist.githubusercontent.com/JeanMGirard/$ID/raw/$REV/install-tools.sh)";



echo -e "\n* Verifying requirements... \n"
install-pkgs \
	python3-pip curl openssl git unzip \
	gnupg pass

# Examples
# install-pkg pkg1 <(echo 'echo "[cmd]"')
# install-pkg pkg1 'echo "[cmd]"'
# install-pkg pkg1 <(cat << EOF
# echo "[cmd]"
# EOF
# )



# ===================================================================
# Go
if ! command -v go &> /dev/null; then
  curl "https://dl.google.com/go/go${GO_VERSION:-1.18}.linux-amd64.tar.gz" -o go.linux-amd64.tar.gz
  sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go.linux-amd64.tar.gz
  rm go.linux-amd64.tar.gz
  SCR="
# ====== GOLANG ====================
export GOVERSION=go${GO_VERSION:-1.18}
export GO_INSTALL_DIR=/usr/local/go
export GOROOT=/usr/local/go
export GOPATH=\$HOME/go
export GO111MODULE=\"on\"
export GOSUMDB=off
export PATH=\$PATH:/usr/local/go/bin
# =================================="
  eval "$SCR"
  echo "$SCR" >> ~/.profile.d/mod.go
fi
install-pkg goreleaser "curl -sfL https://goreleaser.com/static/run | bash"
install-pkg dep "curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh"

echo " 'go' Installed "
# ===================================================================
# node
if ! command -v node &> /dev/null; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  . "$NVM_DIR/nvm.sh"


  echo 'export NVM_DIR="$HOME/.nvm"' > ~/.profile.d/mod.nvm
  echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm' >> ~/mod.nvm

  nvm install "${NODE_VERSION:-16.15.1}"
  nvm use "${NODE_VERSION:-16.15.1}"
  nvm alias default "${NODE_VERSION:-16.15.1}"
fi
echo " 'nvm' Installed "
echo " 'node' Installed "
# ===================================================================
install-pkg task 'sudo sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin'
# ===================================================================
echo -e "\n* Installing terraform tools... \n" && (
  install-pkg tfenv <(cat << EOF
  git clone https://github.com/tfutils/tfenv.git ~/.tfenv
  sudo ln -s ~/.tfenv/bin/* /usr/local/bin
EOF
)
  install-pkg terraform "tfenv install ${TF_VERSION:=1.2.3}"
  install-pkg tgenv <(cat << EOF
  git clone https://github.com/cunymatthieu/tgenv.git ~/.tgenv
  sudo ln -s ~/.tgenv/bin/* /usr/local/bin
EOF
)
  install-pkg terragrunt "tgenv install $TG_VERSION"
  install-pkg tfsec "go install github.com/aquasecurity/tfsec/cmd/tfsec@latest"
  install-pkg terrafile <(cat << EOF
  curl -L "https://github.com/coretech/terrafile/releases/download/v${TERRAFILE_VERSION:-0.7}/terrafile_${TERRAFILE_VERSION:-0.7}_Linux_x86_64.tar.gz" | sudo tar xz -C /usr/local/bin/
  sudo chmod +x /usr/local/bin/terrafile
EOF
)
  install-pkg terraform-docs <(cat << EOF
  curl -L "https://github.com/terraform-docs/terraform-docs/releases/download/v${TF_DOCS_VERSION:-0.16.0}/terraform-docs-v${TF_DOCS_VERSION:-0.16.0}-$(uname)-amd64.tar.gz" | sudo tar xz -C /usr/local/bin/
  sudo chmod +x /usr/local/bin/terraform-docs
EOF
)
  install-pkg tflint "curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash"


  echo "" > ~/.profile.d/mod.terraform
  echo 'export PATH=$PATH:$HOME/.tfenv/bin' >> ~/.profile.d/mod.terraform
  echo "" >> ~/.profile.d/mod.terraform
  echo "alias tg='terragrunt'" >> ~/.profile.d/mod.terraform
  echo "alias tf='terraform'"  >> ~/.profile.d/mod.terraform
  echo "alias tfdocs='terraform-docs'" >> ~/.profile.d/mod.terraform

)

# ===================================================================
echo -e "\n* Installing common tools... \n" && (
  install-pkgs jq
)
echo -e "\n* Installing terminal tools... \n" && (
  install-pkgs peco nano fzf
)
echo -e "\n* Installing developer tools... \n" && (
  install-pkgs jsonnet
  install-pkg ytt "curl -s -L https://carvel.dev/install.sh | sudo K14SIO_INSTALL_BIN_DIR=/usr/local/bin bash"
  install-pkg pre-commit "pip_install pre-commit --upgrade"
  install-pkg hygen "npm_install hygen"
  install-pkg codemod "pip_install codemod --upgrade"
  # install-pkg codemod "npm_install @codemod/cli"
  # install-pkg codemod-cli "npm_install codemod-cli"


  install-pkg cheat 'sudo curl -s -o /usr/local/bin/cheat -L https://raw.githubusercontent.com/alexanderepstein/Bash-Snippets/master/cheat/cheat && sudo chmod +x /usr/local/bin/cheat'
  install-pkg notes 'curl -Ls https://raw.githubusercontent.com/pimterry/notes/latest-release/install.sh | sudo bash'
  install-pkg pet <(cat << EOF
    if command -v dpkg &> /dev/null; then
      curl -s -o /tmp/pet_0.3.6.deb -L https://github.com/knqyf263/pet/releases/download/v0.3.6/pet_0.3.6_linux_amd64.deb && \
        sudo dpkg -i /tmp/pet_0.3.6.deb && \
        rm /tmp/pet_0.3.6.deb
    elif command -v rpm &> /dev/null; then
      sudo rpm -ivh https://github.com/knqyf263/pet/releases/download/v0.3.0/pet_0.3.0_linux_amd64.rpm
    fi

    # .bashrc
    echo 'function pet-prev() {
      PREV=$(echo `history | tail -n2 | head -n1` | sed 's/[0-9]* //')
      sh -c "pet new `printf %q "$PREV"`"
    }' >> ~/.bashrc
    echo 'function pet-select() {
      BUFFER=$(pet search --query "$READLINE_LINE");
      READLINE_LINE=$BUFFER;
      READLINE_POINT=${#BUFFER};
    }' >> ~/.bashrc
    echo "bind -x '\"\C-x\C-r\": pet-select'" >> ~/.bashrc
    # .zshrc
    echo 'function pet-prev() {
      PREV=$(fc -lrn | head -n 1)
      sh -c "pet new `printf %q "$PREV"`"
    }' >> ~/.zshrc
    echo 'function pet-select() {
      BUFFER=$(pet search --query "$LBUFFER");
      CURSOR=$#BUFFER; zle redisplay;
    }' >> ~/.zshrc
    echo -e "zle -N pet-select;\nstty -ixon;\nbindkey '^s' pet-select;" >> ~/.zshrc
EOF
)
  install-pkg snipkit <(cat << EOF
    registerRepo --try -y snipkit 'https://apt.fury.io/lemoony/';
    registerRepo --try -y snipkit 'https://yum.fury.io/lemoony/';
    install-pkg snipkit
    #  writeToAliases "\n# [snippets]"
    registerAlias sn snipkip
EOF
)

  [[ ! -d ~/packages/git-extra-commands ]] && install-pkg git-extra-commands <(cat << EOF
    git clone https://github.com/unixorn/git-extra-commands.git ~/packages/git-extra-commands
    echo 'export PATH=$PATH:$HOME/packages/git-extra-commands/bin' > ~/.profile.d/mod.git-extra-commands
    echo "alias git-extra-commands='ls -a \$HOME/packages/git-extra-commands/bin'" >> ~/.profile.d/mod.git-extra-commands
EOF
)

)
echo -e "\n* Installing sysadmin tools... \n" && (
  install-pkg ergo 'curl -s https://raw.githubusercontent.com/cristianoliveira/ergo/master/install.sh | sh'
  install-pkg kubebox 'curl -Lo kubebox https://github.com/astefanutti/kubebox/releases/download/v0.10.0/kubebox-linux && chmod +x kubebox && sudo mv kubebox /usr/local/bin/'
)
echo -e "\n* Installing team collab tools... \n" && (
  install-pkg termchat "pip_install termchat --upgrade"
)


# ===================================================================
# Setup
echo -e "\n* Starting setup \n"
pre-commit install
# pet configure
# snipkit config init
# snipkit manager add

echo -e "\n* installation completed \n"


# [ -d ~/.profile.d/ ] && for file in $(find ~/.profile.d/ -type f) ; do source "$file"; done
