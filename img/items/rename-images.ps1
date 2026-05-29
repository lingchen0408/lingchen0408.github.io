$ErrorActionPreference = "Stop"

$scriptPath = $PSCommandPath
$imageExtensions = @(
    ".jpg", ".jpeg", ".png", ".gif", ".webp",
    ".bmp", ".tif", ".tiff", ".heic", ".avif"
)

$images = @(
    Get-ChildItem -LiteralPath $PSScriptRoot -File |
        Where-Object {
            $_.FullName -ne $scriptPath -and
            $imageExtensions -contains $_.Extension.ToLowerInvariant()
        }
)

$existingPicImages = @(
    $images | Where-Object { $_.BaseName -match '^pic(\d+)$' }
)

$maxNumber = 0
foreach ($image in $existingPicImages) {
    if ($image.BaseName -match '^pic(\d+)$') {
        $number = [int]$Matches[1]
        if ($number -gt $maxNumber) {
            $maxNumber = $number
        }
    }
}

$imagesToRename = @(
    $images |
        Where-Object { $_.BaseName -notmatch '^pic\d+$' } |
        Sort-Object Name
)

if ($imagesToRename.Count -eq 0) {
    Write-Host "No images need renaming. Current max pic number: $maxNumber"
    exit 0
}

$tempPrefix = "__rename_tmp_$([guid]::NewGuid().ToString('N'))__"
$renames = @()

for ($i = 0; $i -lt $imagesToRename.Count; $i++) {
    $image = $imagesToRename[$i]
    $nextNumber = $maxNumber + $i + 1
    $targetName = "pic$nextNumber$($image.Extension.ToLowerInvariant())"
    $targetPath = Join-Path $PSScriptRoot $targetName

    if (Test-Path -LiteralPath $targetPath) {
        throw "Target already exists: $targetName"
    }

    $tempName = "$tempPrefix$i$($image.Extension)"
    Rename-Item -LiteralPath $image.FullName -NewName $tempName

    $renames += [pscustomobject]@{
        TempPath = Join-Path $PSScriptRoot $tempName
        TargetName = $targetName
        OriginalName = $image.Name
    }
}

foreach ($rename in $renames) {
    Rename-Item -LiteralPath $rename.TempPath -NewName $rename.TargetName
    Write-Host "$($rename.OriginalName) -> $($rename.TargetName)"
}
