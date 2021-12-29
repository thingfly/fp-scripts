$source = "source"

# Get new names
$newNames = Get-Clipboard

# Get source files
$sourceFiles = Get-ChildItem -Path $source -Force

# Copy and rename source files
Foreach ($sourceFile in $sourceFiles) {
    $match = $newNames -match $sourceFile.BaseName
    
    if (!$match)
    {
        Write-Output ("Unable to find a match for " + $sourceFile.Name)
        continue
    }
    $sourceFile.MoveTo($sourceFile.DirectoryName + '/' + $match + $sourceFile.Extension)
}