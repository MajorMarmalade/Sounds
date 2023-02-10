$start = Get-Date
$i = 0

while ((Get-Date) - $start).TotalSeconds -lt 30) {
  $fileC = "unfortunateC$i.txt"
  $fileDesktop = "unfortunateDesktop$i.txt"

  # Remove the file from the Desktop
  Remove-Item "$env:USERPROFILE\Desktop\$fileDesktop"

  # Remove the file from the C drive
  Remove-Item "C:\$fileC"

  $i++
}
