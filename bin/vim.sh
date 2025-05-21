#!/bin/sh
# VALSORYM/XVIMRC INSTALL
# Author: valsorym <valsorym.e@gmail.com>
# This script installs and configures Vim with necessary plugins and dependencies

# Set sudo.
if sudo -v; then
    echo "Run..."
else
    echo "Have no permission to run this script. Please run as root or use sudo."
    exit 1
fi

# Get base directory
SCRIPT_DIR=`dirname $0`
cd $SCRIPT_DIR/../
BASE_DIR=`pwd -P`

echo "Starting Vim configuration setup..."

# Copy the basic settings
echo "Removing old configuration files..."
rm -Rf $HOME/.vim \
       $HOME/.vimrc \
       $HOME/.gvimrc

echo "Creating directory structure..."
mkdir -p $HOME/.vim/bundle

echo "Copying configuration files..."
cp -Rf $BASE_DIR/vimrc/.vimrc $HOME/.vimrc
cp -Rf $BASE_DIR/vimrc/.gvimrc $HOME/.gvimrc

# Create CoC configuration directory and copy settings
mkdir -p $HOME/.vim
cp -Rf $BASE_DIR/vimrc/coc-settings.json $HOME/.vim/coc-settings.json

# Install Vundle plugins
echo "Installing Vundle plugins..."
PLUGINS=`cat $HOME/.vimrc | grep "Plugin '*'" | cut -d"'" -f2`
for plugin in $PLUGINS
do
    name=`echo $plugin | cut -d"/" -f2`
    echo "Installing plugin: $name"
    git clone https://github.com/${plugin} $HOME/.vim/bundle/$name
done

# Install system dependencies
echo "Installing system dependencies..."
sudo apt update
sudo apt install -y \
    vim \
    vim-gtk3 \
    python3-pip \
    python3-neovim \
    nodejs \
    npm \
    curl \
    wget \
    unzip \
    universal-ctags \
    git

# Install GoLang tools
echo "Installing GoLang tools..."
if command -v go > /dev/null 2>&1; then
    go install github.com/segmentio/golines@latest
    go install github.com/jstemmer/gotags@latest
    go install golang.org/x/tools/cmd/guru@latest
    # Commented out as noted in original script
    # go install mvdan.cc/gofumpt@latest
else
    echo "Warning: Go is not installed. Skipping Go tools installation."
fi

# Install Nerd Fonts
echo "Installing fonts..."
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p $FONT_DIR
TEMP_DIR=$(mktemp -d)

# Install standard code fonts
echo "Installing editor code fonts..."
git clone https://github.com/valsorym/editor-code-fonts $TEMP_DIR/editor-code-fonts
cp $TEMP_DIR/editor-code-fonts/fonts/* $FONT_DIR/

# Install Nerd Fonts - without using arrays (sh compatible)
echo "Installing Nerd Fonts..."
# Download and install AdwaitaMono
echo "Downloading AdwaitaMono..."
wget -q "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/AdwaitaMono.zip" -O "$TEMP_DIR/AdwaitaMono.zip"
echo "Extracting AdwaitaMono..."
mkdir -p "$TEMP_DIR/extracted_adwaita"
unzip -q "$TEMP_DIR/AdwaitaMono.zip" -d "$TEMP_DIR/extracted_adwaita"
echo "Installing AdwaitaMono fonts..."
cp $TEMP_DIR/extracted_adwaita/*.ttf $FONT_DIR/ 2>/dev/null || true
cp $TEMP_DIR/extracted_adwaita/*.otf $FONT_DIR/ 2>/dev/null || true

# Download and install AnonymousPro
echo "Downloading AnonymousPro..."
wget -q "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/AnonymousPro.zip" -O "$TEMP_DIR/AnonymousPro.zip"
echo "Extracting AnonymousPro..."
mkdir -p "$TEMP_DIR/extracted_anonymous"
unzip -q "$TEMP_DIR/AnonymousPro.zip" -d "$TEMP_DIR/extracted_anonymous"
echo "Installing AnonymousPro fonts..."
cp $TEMP_DIR/extracted_anonymous/*.ttf $FONT_DIR/ 2>/dev/null || true
cp $TEMP_DIR/extracted_anonymous/*.otf $FONT_DIR/ 2>/dev/null || true

# Update font cache
echo "Updating font cache..."
fc-cache -f

# Install and configure Vim plugins
echo "Configuring Vim plugins..."


# Compile CoC
echo "Compiling CoC plugin..."
cd $HOME/.vim/bundle/coc.nvim && npm ci

# Update and install Vim plugins
echo "Running plugin updates and installations..."
vim +PluginUpdate +qall
vim +CocInstall coc-pyright coc-tsserver +qall
vim +Copilot setup +qall

# vim +GoInstallBinaries +qall
# vim +GoUpdateBinaries +qall

# Fix package versions
echo "Fixing package versions for compatibility..."

# Deoplete - fix specific version
echo "Setting Deoplete to compatible version..."
cd $HOME/.vim/bundle/deoplete.nvim && git reset --hard 8249a0f 2>/dev/null || echo "Warning: Could not set Deoplete version"

# Clean up temporary files
echo "Cleaning up..."
rm -rf $TEMP_DIR

echo ""
echo "Installation complete! Your Vim environment is now ready."

echo ""
echo "Select default editor: vim-gtk3"
select-editor

exit 0