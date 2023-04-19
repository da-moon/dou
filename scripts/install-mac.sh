#!/bin/bash

install_dir="${HOME}/.dwarf/installations/first"

# Linux Example (change download URL for MacOs)
echo "Installing dwarf in directory: ${install_dir}"
mkdir -p ${install_dir}

# Download Dwarf
echo "Downloading..."
cd ${install_dir} && curl -s https://www.dwarf.dev/releases/cli/latest/darwin/dwarf.zip > dwarf.zip

# Unzip Dwarf
echo "Unzipping..."
unzip dwarf.zip > /dev/null

# Symlink dwarf
ln -snf ${install_dir}/dwarf/dwarf /usr/local/bin/dwarf


# Test Dwarf
echo "Testing install with:  'dwarf --version'"
dwarf --version
