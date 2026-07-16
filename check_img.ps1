Add-Type -AssemblyName System.Drawing

$srcPath = (Get-Item ".\Jungle_background_Korean_text_chal_202607152250.jpeg").FullName
$img = [System.Drawing.Image]::FromFile($srcPath)
$bmp = New-Object System.Drawing.Bitmap($img)
$scaleX = $img.Width / 1280.0
$scaleY = $img.Height / 720.0

Write-Output "Image: $($img.Width)x$($img.Height), Scale: ${scaleX}x${scaleY}"

Write-Output ""
Write-Output "=== TIMER NUMBER '13' AREA ==="
# Timer number '13' is around the right end of the timer bar
foreach ($dispY in @(575, 580, 585, 590, 595)) {
    $line = "y=$dispY | "
    foreach ($dispX in @(1030, 1035, 1040, 1045, 1050, 1055, 1060, 1065, 1070, 1075, 1080, 1085, 1090)) {
        $realX = [int]($scaleX * $dispX)
        $realY = [int]($scaleY * $dispY)
        if ($realX -ge $bmp.Width -or $realY -ge $bmp.Height) { 
            $line += "OOB "
            continue 
        }
        $pixel = $bmp.GetPixel($realX, $realY)
        # Check if it's yellow/gold text (R > 200, G > 150, B < 100) 
        if ($pixel.R -gt 180 -and $pixel.G -gt 120 -and $pixel.B -lt 120) {
            $line += "GOLD(x=$dispX) "
        } else {
            $hex = "#" + $pixel.R.ToString("X2") + $pixel.G.ToString("X2") + $pixel.B.ToString("X2")
            $line += "${hex}(x=$dispX) "
        }
    }
    Write-Output $line
}

Write-Output ""
Write-Output "=== TIMER BAR AREA ==="
foreach ($dispY in @(583, 586, 589, 592)) {
    $line = "y=$dispY | "
    foreach ($dispX in @(790, 800, 810, 850, 900, 950, 1000, 1020, 1030)) {
        $realX = [int]($scaleX * $dispX)
        $realY = [int]($scaleY * $dispY)
        if ($realX -ge $bmp.Width -or $realY -ge $bmp.Height) { continue }
        $pixel = $bmp.GetPixel($realX, $realY)
        $hex = "#" + $pixel.R.ToString("X2") + $pixel.G.ToString("X2") + $pixel.B.ToString("X2")
        $line += "${hex}(x=$dispX) "
    }
    Write-Output $line
}

$bmp.Dispose()
$img.Dispose()
