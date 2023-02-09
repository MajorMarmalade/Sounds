#Deletes all text files created by the previous script. NOTE:you may need to let it run twice if there are many ufortunate.txt files as this script runs 30s.

$start = Get-Date
$i = 0

while ((Get-Date) - $start).TotalSeconds -lt 30) {
  $fileC = "unfortunateC$i.txt"
  $fileD = "unfortunateD$i.txt"
  $fileE = "unfortunateE$i.txt"

  # Remove the file from the C drive
  Remove-Item "C:\$fileC"

  # Remove the file from the D drive
  Remove-Item "D:\$fileD"

  # Remove the file from the E drive
  Remove-Item "E:\$fileE"

  $i++
}
