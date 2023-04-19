#!/bin/bash

#!/bin/bash

install_dir="${HOME}/.dwarf/installations/first"

# Linux Example (change download URL for MacOs)
echo "Instaling dwarf in directory: ${install_dir}"
mkdir -p ${install_dir}

# Download Dwarf
echo "Downloading..."
cd ${install_dir} && curl -s https://www.dwarf.dev/releases/cli/latest/linux/dwarf.zip > dwarf.zip

# Unzip Dwarf
echo "Unzipping (silently to prevent spam)..."
unzip dwarf.zip > /dev/null

# Symlink dwarf
echo "Creating symlink at /usr/local/bin/dwarf"
sudo ln -snf ${install_dir}/dwarf/dwarf /usr/local/bin/dwarf


# Test Dwarf
echo "Testing install with:  'dwarf --version'"
dwarf --version

