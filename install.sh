#!/usr/bin/env bash

TF_VERSION='1.2.3'
TG_VERGION='0.38.1'

# ===================================================================
# tfenv
if ! command -v tfenv &> /dev/null; then
  echo " tfenv could not be found, installing..."
  git clone https://github.com/tfutils/tfenv.git ~/.tfenv
  echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.bash_profile
  sudo ln -s ~/.tfenv/bin/* /usr/local/bin
fi
tfenv install $TF_VERSION
# ===================================================================
# tgenv
if ! command -v tgenv &> /dev/null; then
  echo " tgenv could not be found, installing..."
  git clone https://github.com/cunymatthieu/tgenv.git ~/.tgenv
  echo 'export PATH="$HOME/.tgenv/bin:$PATH"' >> ~/.bash_profile
  sudo ln -s ~/.tgenv/bin/* /usr/local/bin
fi
tgenv install $TG_VERGION
# ===================================================================
# tfsec
if ! command -v tfsec &> /dev/null; then
  echo " tfsec could not be found, installing..."
  go install github.com/aquasecurity/tfsec/cmd/tfsec@latest
fi
# ===================================================================
# terraform-docs
if ! command -v terraform-docs &> /dev/null; then
  echo " terraform-docs could not be found, installing..."
  curl -Lo ./terraform-docs.tar.gz https://github.com/terraform-docs/terraform-docs/releases/download/v0.16.0/terraform-docs-v0.16.0-$(uname)-amd64.tar.gz
  tar -xzf terraform-docs.tar.gz && rm terraform-docs.tar.gz
  chmod +x terraform-docs
  sudo mv terraform-docs /usr/local/bin/terraform-docs
fi
# ===================================================================
# tflint
if ! command -v tflint &> /dev/null; then
  echo " tflint could not be found, installing..."
  curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
fi
# ===================================================================
# ytt
if ! command -v ytt  &> /dev/null; then
  echo " ytt  could not be found, installing..."
  curl -L https://carvel.dev/install.sh | sudo K14SIO_INSTALL_BIN_DIR=/usr/local/bin bash
fi
# ===================================================================
pip install jsonnet
pip install pre-commit
npm i -g hygen
# ===================================================================
# ===================================================================
# ===================================================================
# Setup


pre-commit install
