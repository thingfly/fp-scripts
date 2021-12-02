$source = "source"
$destination = "output"

# Make new directories from the clipboard
Get-Clipboard | New-Item -Force -Path $Destination -Name {$_} -ItemType "directory" | Out-Null

# Get source files
$sourceFiles = Get-ChildItem -Path $source -Force

# Get destination directories
$directories = Get-ChildItem -Path $destination -Recurse -Directory

# Copy and rename source files
Foreach ($directory in $directories) {
    $sourceFiles | Copy-Item -Destination {$directory.FullName + "\" + $directory.Name + $_.Name}
}