$Source = "source"
$Destination = "destination"

$files = Get-ChildItem -Path $Source -Force  | Select-Object FullName
$directories = Get-ChildItem -Path Destination -Recurse -Directory | Select-Object FullName

Foreach ($directory in $directories)
{    
    Copy-item -Force -Recurse -Verbose $files.FullName   -Destination $directory.FullName
}