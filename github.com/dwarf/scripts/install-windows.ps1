# powershell
# Feel free to suggest improvements, my powershell is quite "meh".

$INSTALL_DIR=".dwarf/installations/first"

cd ~

# Create install directory
mkdir $INSTALL_DIR
cd $INSTALL_DIR

# Download Dwarf
echo "Downloading dwarf archive..."
Invoke-WebRequest -Uri https://www.dwarf.dev/releases/cli/latest/windows/dwarf.zip -OutFile dwarf.zip

# Unzip
echo "Unzipping dwarf archive..."
Expand-Archive .\dwarf.zip

# Add DIR to path
cd dwarf/dwarf
$DIR=pwd

# Create symlink for dwarf.exe
New-Item -ItemType SymbolicLink -Path "dwarf" -Target "dwarf.exe"

## Add Dir to path
echo "Adding installation directory [$DIR] to path."
$ENV:PATH="$ENV:PATH;$DIR"

# Permanently add to path for future sessions
setx /M PATH "$($env:path);$DIR"

echo "Cleaning up zip"
rm ../../dwarf.zip

echo "Testing..."
dwarf --version