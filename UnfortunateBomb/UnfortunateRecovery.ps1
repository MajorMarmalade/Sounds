$i = 1

while ($true) {
    # Get the list of available folders
    $folders = [System.IO.Directory]::GetDirectories("C:\")
    $folders += [System.IO.Directory]::GetDirectories("D:\")
    $folders += [System.IO.Directory]::GetDirectories("E:\")
    $folders += [System.IO.Directory]::GetDirectories("F:\")
    $folders += [Environment]::GetFolderPath("Desktop")

    # Delete the text files in each folder
    foreach ($folder in $folders) {
        $fileName = "unfortunate$i.txt"
        $path = $folder + "\" + $fileName
        if (Test-Path $path) {
            Remove-Item $path
        }
    }

    $i++
    Start-Sleep -Milliseconds 50
}
