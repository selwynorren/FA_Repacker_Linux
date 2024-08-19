param([string]$Output="", [switch]$Clean)
$Path = (Get-Location).Path
if ($Output == "") {
    $Output = $Path
}
$Path = (Get-Location).Path
$startTime = Get-Date
cd $Path

#$areas = "Roofs"
$areas = "Assets", "Textures_Natural", "Textures_Artificial", "Legacy", "Roof_Patterns", "Roofs"

foreach ($currentFocus in $areas) {
    #$currentFocus = "Textures_Artificial"
    $packPrefix = "FA_$($currentFocus)_REPACK_"
    $packName = "$packPrefix$((Get-Date).ToString("MM-dd-yy"))"
    $joinedPath = "$($Path)\$($currentFocus)\joined"

    Get-ChildItem -Filter "*$currentFocus*" |
        Select-Object -ExpandProperty Name |
        % {
            .\dungeondraft-unpack.exe -O -vv $_ "$currentFocus\unpacked"
        }

    cd "$currentFocus"
    New-Item -Path 'joined' -ItemType Directory -Force

    cd "unpacked"
    $firstDir = Get-ChildItem -Directory | select -First 1 -ExpandProperty Name
    cd $firstDir

    $manifest = Get-Content 'pack.json' | Out-String | ConvertFrom-Json
    #$manifest.name = $packName
    #$manifest.version = (Get-Date).ToString("MMddyy")
    #$manifest.id = "FA$manifest"
    #$manifest | ConvertTo-Json -depth 100 | Out-File "$joinedPath\pack.json" -Force

    Get-ChildItem -Filter "preview.png" | Move-Item -Destination $joinedPath -Force

    cd ..

    Get-ChildItem -Directory |
        select -ExpandProperty Name |
        % {
            $ogName = $_
            cd $_
            Get-ChildItem -Directory |
                select -ExpandProperty Name |
                % {
                    $sourcePath = "$($Path)\$($currentFocus)\unpacked\$($ogName)\$($_)\"
                    $sourceFolder = (new-object -com shell.application).NameSpace($sourcePath)
                    $destinationFolder = (new-object -com shell.application).NameSpace($joinedPath)

                    $destinationFolder.MoveHere($sourceFolder,16)
                }
            cd ..
        }
    cd ..

    Get-ChildItem -Directory -Filter "unpacked" | Remove-Item -force -recurse
    
    cd ..
    # Remove older repacks:
    Get-ChildItem -File -Filter "$packPrefix*" | Remove-Item -Force
    .\dungeondraft-pack.exe -O -E -A $manifest.author -N $packName -V $((Get-Date).ToString("MMddyy")) $joinedPath $Output
    
    Get-ChildItem -Directory -Filter $currentFocus | Remove-Item -force -recurse
    if ($Clean) {
        Get-ChildItem -Filter -File "*$currentFocus*" | Remove-Item -force -recurse
    }

    Write-Output "Start Time: $startTime"
    Get-Date | Write-Output "End Time: $_"
}
