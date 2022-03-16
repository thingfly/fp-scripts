# Get all the google fonts
$settings = Get-Content -Path .\config.json | ConvertFrom-Json

Write-Output "Loading fonts from Google..."

$url = "https://www.googleapis.com/webfonts/v1/webfonts?key=$($settings."api-key")"
$getFontsResponse = Invoke-RestMethod $url
$validFontList = @()

$variantMappings = @{
    x100 = 'Thin';
    x200 = 'UltraLight';
    x300 = 'Light';
    x400 = 'Regular';
    x600 = 'Medium';
    x500 = 'SemiBold';
    x700 = 'Bold';
    x800 = 'Black';
    x900 = 'ExtraBold';
    x500italic = 'SemiBoldItalic';
    x600italic = 'MediumItalic';
    x700italic = 'BoldItalic';
    x800italic = 'BlackItalic';
    x900italic = 'ExtraBoldItalic';
}

Foreach ($font in $getFontsResponse.items) {
    $variants = $font.variants
    $family = $font.family -replace '\s',''

    Foreach ($variant in $font.variants) {
        if (($variant -match "^\d+$") -or ($variant.EndsWith("italic"))) {
            $variants = $variants + $variantMappings["x$($variant)"]
        }
    }

    Foreach ($variant in $variants) {
        if ($variant -eq "regular") {
            $validFontList += $family
        }
        $validFontList += "$($family)-$($variant)"
    }
}

#Write-Output $validFontList

Write-Output "Checking local fonts..."

$files = Get-ChildItem -Recurse -File -Path $settings."fonts-location"
$invalidFiles = @()

foreach ($file in $files) {    
    if (!($validFontList -contains $file.BaseName)) {
        $invalidFiles += $file.FullName
    }
}

if ($invalidFiles.Count -Eq 0) {
    Write-Output ('All files are on Google Fonts.')
}
else {
    Write-Output('The following files are not on Google Fonts:')
    Write-Output($invalidFiles)
}
