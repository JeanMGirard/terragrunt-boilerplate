#!/usr/bin/env bash

clear

GO_VERSION="1.18"
NODE_VERSION="16.15.1"
TF_VERSION='1.2.3'
TG_VERSION='0.38.1'
TERRAFILE_VERSION='0.7'
TF_DOCS_VERSION='0.16.0'



function getInstallCmd() {
  if   command -v apt-get &> /dev/null; then echo "apt-get install -y"
  elif command -v yum &> /dev/null; then echo "yum install -y"
  elif command -v zypper &> /dev/null; then echo "zypper install -y"
  elif command -v pacman &> /dev/null; then echo "pacman -Syu"
  elif command -v dnf &> /dev/null; then echo "dnf install -y"
  fi
}

echo -e "\n* Verifying requirements... \n"
sudo `getInstallCmd`  curl unzip python3-pip openssl gnupg git
echo -e "\n* Installing... \n"

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
  echo "$SCR" >> ~/.profile
fi
echo " 'go' Installed "
# ===================================================================
# node
if ! command -v node &> /dev/null; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  . "$NVM_DIR/nvm.sh"

  echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc
  echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm' >> ~/.zshrc

  nvm install "${NODE_VERSION:-16.15.1}"
  nvm use "${NODE_VERSION:-16.15.1}"
  nvm alias default "${NODE_VERSION:-16.15.1}"
fi
echo " 'nvm' Installed "
echo " 'node' Installed "
# ===================================================================
# go-task
if ! command -v task &> /dev/null; then
  sudo sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin
fi
echo " 'task' Installed "
# ===================================================================
# tfenv
if ! command -v tfenv &> /dev/null; then
  echo " tfenv could not be found, installing..."
  git clone https://github.com/tfutils/tfenv.git ~/.tfenv
  echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.bash_profile
  sudo ln -s ~/.tfenv/bin/* /usr/local/bin
fi
echo " 'tfenv' Installed "
if ! command -v terraform &> /dev/null; then
  tfenv install $TF_VERSION
fi
echo " 'terraform' Installed "
# ===================================================================
# tgenv
if ! command -v tgenv &> /dev/null; then
  echo " tgenv could not be found, installing..."
  git clone https://github.com/cunymatthieu/tgenv.git ~/.tgenv
  echo 'export PATH="$HOME/.tgenv/bin:$PATH"' >> ~/.bash_profile
  sudo ln -s ~/.tgenv/bin/* /usr/local/bin
fi
echo " 'tgenv' Installed "
if ! command -v terragrunt &> /dev/null; then
  tgenv install $TG_VERSION
fi
echo " 'terragrunt' Installed "
# ===================================================================
# tfsec
if ! command -v tfsec &> /dev/null; then
  echo " tfsec could not be found, installing..."
  go install github.com/aquasecurity/tfsec/cmd/tfsec@latest
fi
echo " 'tfsec' Installed "
# ===================================================================
# terrafile
if ! command -v terrafile &> /dev/null; then
  echo " terrafile could not be found, installing..."
  curl -L "https://github.com/coretech/terrafile/releases/download/v${TERRAFILE_VERSION:-0.7}/terrafile_${TERRAFILE_VERSION:-0.7}_Linux_x86_64.tar.gz" | sudo tar xz -C /usr/local/bin/
  sudo chmod +x /usr/local/bin/terrafile
fi
echo " 'terrafile' Installed "
# ===================================================================
# terraform-docs
if ! command -v terraform-docs &> /dev/null; then
  echo " terraform-docs could not be found, installing..."
  curl -L "https://github.com/terraform-docs/terraform-docs/releases/download/v${TF_DOCS_VERSION:-0.16.0}/terraform-docs-v${TF_DOCS_VERSION:-0.16.0}-$(uname)-amd64.tar.gz" | sudo tar xz -C /usr/local/bin/
  sudo chmod +x /usr/local/bin/terraform-docs
fi
echo " 'terraform-docs' Installed "
# ===================================================================
# tflint
if ! command -v tflint &> /dev/null; then
  echo " tflint could not be found, installing..."
  curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
fi
echo " 'tflint' Installed "
# ===================================================================
# ytt
if ! command -v ytt  &> /dev/null; then
  echo " ytt  could not be found, installing..."
  curl -L https://carvel.dev/install.sh | sudo K14SIO_INSTALL_BIN_DIR=/usr/local/bin bash
fi
echo " 'ytt' Installed "
# ===================================================================
if ! command -v jsonnet  &> /dev/null; then sudo `getInstallCmd` jsonnet;fi
echo " 'jsonnet' Installed "

if ! command -v pre-commit  &> /dev/null; then sudo -H pip3 install pre-commit --upgrade;fi
echo " 'pre-commit' Installed "

if ! command -v hygen  &> /dev/null; then npm i --location=global hygen; fi
echo " 'hygen' Installed "

# ===================================================================
# ===================================================================
# ===================================================================
# Setup
echo -e "\n* Starting setup \n"
pre-commit install
echo -e "\n* installation completed \n"
