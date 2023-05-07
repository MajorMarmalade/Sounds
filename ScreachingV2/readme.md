Description: This PowerShell script is designed to give users a sudden scare by playing a very loud and long scream when they move their cursor. The volume will be locked at 100% for the entire duration of the audio, making it impossible to mute. To stop the audio, the user will have to find and close the PowerShell window in time.

The script works by downloading the scream audio file from a GitHub repository and playing it with the System.Windows.Media.MediaPlayer. Once the cursor position changes, the audio is triggered, and the volume is raised to maximum using the Raise-Volume function. The script will loop through the audio, ensuring the volume stays at 100% until the audio is finished.

After the audio has played, the script will clean up traces of its execution by deleting the contents of the Temp folder, removing run box history, clearing PowerShell history, and emptying the recycle bin.

This prank is intended for users who enjoy a good scare and can handle the intensity. Please use responsibly and consider the comfort levels of your friends before sharing!
