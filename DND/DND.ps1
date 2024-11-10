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

# Ensure the script is running in STA mode required for MediaPlayer
if ($Host.Runspace.ApartmentState -ne 'STA') {
    Write-Warning "Script is not running in Single Threaded Apartment (STA) mode. Relaunching in STA mode..."
    # Relaunch the script in STA mode
    $scriptPath = $MyInvocation.MyCommand.Path
    powershell.exe -sta -File $scriptPath
    exit
}

# Load necessary assemblies
Add-Type -AssemblyName PresentationCore
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Media")

function Show-ChoiceDialog {
    param (
        [string]$Title,
        [string]$Message,
        [string[]]$Choices,
        [string]$BackgroundImageFile
    )

    [void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
    [void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
    [void][System.Reflection.Assembly]::LoadWithPartialName("System.Media")

    $form = New-Object System.Windows.Forms.Form
    $form.Text = $Title
    $form.Size = New-Object System.Drawing.Size(600, 300)
    $form.StartPosition = "CenterScreen"
    $form.FormBorderStyle = 'FixedDialog'
    $form.MaximizeBox = $false
    $form.MinimizeBox = $false
    $form.ShowInTaskbar = $false
    $form.TopMost = $true

    # Set the background image using the parameter
    if (Test-Path $BackgroundImageFile) {
        $form.BackgroundImage = [System.Drawing.Image]::FromFile($BackgroundImageFile)
        $form.BackgroundImageLayout = 'Stretch'
    } else {
        $form.BackColor = 'DarkGreen'
    }

    # Add the message label directly to the form
    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(20, 20)
    $label.Size = New-Object System.Drawing.Size(560, 80)
    $label.Text = $Message
    $label.ForeColor = 'WhiteSmoke'
    $label.Font = New-Object System.Drawing.Font("Papyrus", 12, [System.Drawing.FontStyle]::Bold)
    $label.BackColor = [System.Drawing.Color]::FromArgb(180, 0, 0, 0) # Semi-transparent black
    $label.AutoSize = $false
    $label.TextAlign = 'MiddleCenter'
    $label.BorderStyle = 'FixedSingle'
    $form.Controls.Add($label)

    $buttons = @()
    $buttonWidth = 160
    $buttonHeight = 40
    $spacing = 10

    $choiceCount = [int]$Choices.Count

    $totalButtonWidth = (($buttonWidth + $spacing) * $choiceCount) - $spacing
    $startX = [int](($form.ClientSize.Width - $totalButtonWidth) / 2)
    $startY = 120

    for ($i = 0; $i -lt $choiceCount; $i++) {
        $button = New-Object System.Windows.Forms.Button
        $xPosition = $startX + ($i * ($buttonWidth + $spacing))
        $button.Location = New-Object System.Drawing.Point($xPosition, $startY)
        $button.Size = New-Object System.Drawing.Size($buttonWidth, $buttonHeight)
        $button.Text = $Choices[$i]
        $button.Tag = $Choices[$i]
        $button.Font = New-Object System.Drawing.Font("Papyrus", 10, [System.Drawing.FontStyle]::Regular)
        $button.ForeColor = 'White'
        $button.BackColor = [System.Drawing.Color]::FromArgb(180, 0, 0, 0) # Semi-transparent black
        $button.FlatStyle = 'Flat'
        $button.FlatAppearance.BorderSize = 1
        $button.FlatAppearance.BorderColor = 'WhiteSmoke'

        $currentButton = $button  # Capture current button in a local variable

        $button.Add_Click({
            param($sender, $eventArgs)
            # Play selection sound
            if ($global:selectionPlayer -ne $null) {
                $global:selectionPlayer.Stop()
                $global:selectionPlayer.Play()
            }
            $form.Tag = $sender.Tag
            $form.DialogResult = [System.Windows.Forms.DialogResult]::OK
            $form.Close()
        })

        $form.Controls.Add($button)
        $buttons += $button
    }

    # Handle form closing without selection
    $form.Add_FormClosing({
        if ($form.DialogResult -ne [System.Windows.Forms.DialogResult]::OK) {
            $form.Tag = $null
            # Optionally, play a sound when closing without selection
            if ($global:exitPlayer -ne $null) {
                $global:exitPlayer.Stop()
                $global:exitPlayer.Play()
            }
        }
    })

    $dialogResult = $form.ShowDialog()
    return $form.Tag
}

function EndGame {
    param (
        [string]$message,
        [string]$endingType,
        [string]$BackgroundImageFile
    )

    # Create a custom message box with the same theme
    $endForm = New-Object System.Windows.Forms.Form
    $endForm.Text = "The End"
    $endForm.Size = New-Object System.Drawing.Size(400, 200)
    $endForm.StartPosition = "CenterScreen"
    $endForm.FormBorderStyle = 'FixedDialog'
    $endForm.MaximizeBox = $false
    $endForm.MinimizeBox = $false
    $endForm.ShowInTaskbar = $false
    $endForm.TopMost = $true

    # Set background using the parameter
    if (Test-Path $BackgroundImageFile) {
        $endForm.BackgroundImage = [System.Drawing.Image]::FromFile($BackgroundImageFile)
        $endForm.BackgroundImageLayout = 'Stretch'
    } else {
        $endForm.BackColor = 'DarkGreen'
    }

    # Add the message label directly to the form
    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(20, 20)
    $label.Size = New-Object System.Drawing.Size(360, 80)
    $label.Text = $message
    $label.ForeColor = 'WhiteSmoke'
    $label.Font = New-Object System.Drawing.Font("Papyrus", 12, [System.Drawing.FontStyle]::Bold)
    $label.BackColor = [System.Drawing.Color]::FromArgb(180, 0, 0, 0) # Semi-transparent black
    $label.AutoSize = $false
    $label.TextAlign = 'MiddleCenter'
    $label.BorderStyle = 'FixedSingle'
    $endForm.Controls.Add($label)

    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Location = New-Object System.Drawing.Point(160, 120)
    $okButton.Size = New-Object System.Drawing.Size(80, 30)
    $okButton.Text = "OK"
    $okButton.Font = New-Object System.Drawing.Font("Papyrus", 10, [System.Drawing.FontStyle]::Regular)
    $okButton.ForeColor = 'White'
    $okButton.BackColor = [System.Drawing.Color]::FromArgb(180, 0, 0, 0)
    $okButton.FlatStyle = 'Flat'
    $okButton.FlatAppearance.BorderSize = 1
    $okButton.FlatAppearance.BorderColor = 'WhiteSmoke'

    $okButton.Add_Click({
        $endForm.DialogResult = [System.Windows.Forms.DialogResult]::OK
        $endForm.Close()
    })

    $endForm.Controls.Add($okButton)

    # Play ending sound based on the ending type
    if ($endingType -eq "good") {
        if ($global:goodEndingPlayer -ne $null) {
            $global:goodEndingPlayer.Stop()
            $global:goodEndingPlayer.Play()
        }
    } elseif ($endingType -eq "bad") {
        if ($global:badEndingPlayer -ne $null) {
            $global:badEndingPlayer.Stop()
            $global:badEndingPlayer.Play()
        }
    }

    # Show the end game dialog and wait for the user to close it
    $endForm.ShowDialog() | Out-Null

    # Stop and close the background music
    if ($global:player -ne $null) {
        $global:player.Stop()
        $global:player.Close()
    }

    exit
}

# Set the background image
$backgroundImageUrl = "https://raw.githubusercontent.com/MajorMarmalade/Sounds/main/DND/background.png"
$backgroundImageFile = "$env:TEMP\background.png"

if (-Not (Test-Path $backgroundImageFile)) {
    try {
        Invoke-WebRequest -Uri $backgroundImageUrl -OutFile $backgroundImageFile
    } catch {
        # If the image can't be downloaded, proceed without it
        [System.Windows.Forms.MessageBox]::Show("Failed to download the background image. The game will proceed without it.", "Image Error")
    }
}

# Add background music using the provided audio link
$audioUrl = "https://raw.githubusercontent.com/MajorMarmalade/Sounds/main/DND/fantasybackground.wav"
$audioFile = "$env:TEMP\fantasybackground.wav"

# Download the audio file if it doesn't already exist
if (-Not (Test-Path $audioFile)) {
    try {
        Invoke-WebRequest -Uri $audioUrl -OutFile $audioFile
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Failed to download the audio file. The game will proceed without background music.", "Audio Error")
    }
}

# Initialize the background music using MediaPlayer
if (Test-Path $audioFile) {
    $global:player = New-Object System.Windows.Media.MediaPlayer
    $uri = New-Object System.Uri("file:///" + (Resolve-Path $audioFile).Path.Replace('\', '/'))
    $global:player.Open($uri)
    $global:player.Volume = 0.5  # Adjust volume as needed
    $global:player.MediaEnded += { $global:player.Position = [TimeSpan]::Zero; $global:player.Play() }
    $global:player.Play()
}

# Add custom sound effects
# Define URLs for the custom sound effects
$selectionSoundUrl = "https://github.com/MajorMarmalade/Sounds/raw/refs/heads/main/DND/selection.wav"
$goodEndingSoundUrl = "https://github.com/MajorMarmalade/Sounds/raw/refs/heads/main/DND/winner.wav"
$badEndingSoundUrl = "https://github.com/MajorMarmalade/Sounds/raw/refs/heads/main/DND/loser.wav"

# Define file paths for the custom sound effects
$selectionSoundFile = "$env:TEMP\selection.wav"
$goodEndingSoundFile = "$env:TEMP\winner.wav"
$badEndingSoundFile = "$env:TEMP\loser.wav"

# Download the custom sound files if they don't exist
foreach ($sound in @(
    @{Url=$selectionSoundUrl; File=$selectionSoundFile},
    @{Url=$goodEndingSoundUrl; File=$goodEndingSoundFile},
    @{Url=$badEndingSoundUrl; File=$badEndingSoundFile}
)) {
    if (-Not (Test-Path $sound.File)) {
        try {
            Invoke-WebRequest -Uri $sound.Url -OutFile $sound.File
        } catch {
            # If the sound can't be downloaded, proceed without it
            [System.Windows.Forms.MessageBox]::Show("Failed to download a sound effect. The game will proceed without it.", "Sound Error")
        }
    }
}

# Initialize SoundPlayers for custom sounds
if (Test-Path $selectionSoundFile) {
    $global:selectionPlayer = New-Object System.Media.SoundPlayer $selectionSoundFile
}

if (Test-Path $goodEndingSoundFile) {
    $global:goodEndingPlayer = New-Object System.Media.SoundPlayer $goodEndingSoundFile
}

if (Test-Path $badEndingSoundFile) {
    $global:badEndingPlayer = New-Object System.Media.SoundPlayer $badEndingSoundFile
}

$gameState = "start"

while ($true) {
    switch ($gameState) {
        "start" {
            $message = "You find yourself alone in a dark forest. The full moon shines through the trees, casting eerie shadows on the ground. You hear a rustling in the distance. Do you:"
            $choices = @("Head towards the noise", "Walk away from the noise", "Climb a tree to get a better view")

            $result = Show-ChoiceDialog -Title "Horror Adventure" -Message $message -Choices $choices -BackgroundImageFile $backgroundImageFile

            if ($result -eq $null) {
                EndGame "Game Over. You exited the game." "bad" -BackgroundImageFile $backgroundImageFile
            }

            switch ($result) {
                "Head towards the noise" { $gameState = "creepyHouse" }
                "Walk away from the noise" { $gameState = "forestPath" }
                "Climb a tree to get a better view" { $gameState = "climbTree" }
            }
        }

        "climbTree" {
            $message = "You climb a nearby tree to get a better view. From the top, you see the outline of a village to the east and a creepy house to the north. You also notice strange lights flickering in the distance. Do you:"
            $choices = @("Head towards the village", "Investigate the strange lights", "Go to the creepy house")

            $result = Show-ChoiceDialog -Title "Horror Adventure" -Message $message -Choices $choices -BackgroundImageFile $backgroundImageFile

            if ($result -eq $null) {
                EndGame "Game Over. You exited the game." "bad" -BackgroundImageFile $backgroundImageFile
            }

            switch ($result) {
                "Head towards the village" { $gameState = "villageEntrance" }
                "Investigate the strange lights" { $gameState = "strangeLights" }
                "Go to the creepy house" { $gameState = "creepyHouse" }
            }
        }

        "villageEntrance" {
            $message = "You make your way to the village. The streets are empty, and the houses look abandoned. Do you:"
            $choices = @("Search the houses", "Call out for help", "Leave the village")

            $result = Show-ChoiceDialog -Title "Horror Adventure" -Message $message -Choices $choices -BackgroundImageFile $backgroundImageFile

            if ($result -eq $null) {
                EndGame "Game Over. You exited the game." "bad" -BackgroundImageFile $backgroundImageFile
            }

            switch ($result) {
                "Search the houses" { $gameState = "searchHouses" }
                "Call out for help" { $gameState = "callForHelp" }
                "Leave the village" { $gameState = "forestPath" }
            }
        }

        "searchHouses" {
            $message = "You search the houses and find supplies and a map. The map shows a hidden path through the forest. Do you:"
            $choices = @("Take the hidden path", "Stay in the village", "Return to the forest")

            $result = Show-ChoiceDialog -Title "Horror Adventure" -Message $message -Choices $choices -BackgroundImageFile $backgroundImageFile

            if ($result -eq $null) {
                EndGame "Game Over. You exited the game." "bad" -BackgroundImageFile $backgroundImageFile
            }

            switch ($result) {
                "Take the hidden path" { $gameState = "hiddenPath" }
                "Stay in the village" { $gameState = "stayInVillage" }
                "Return to the forest" { $gameState = "forestPath" }
            }
        }

        "hiddenPath" {
            EndGame "You follow the hidden path and safely reach a nearby town. You survive, and the mystery of the forest remains unsolved." "good" -BackgroundImageFile $backgroundImageFile
        }

        "stayInVillage" {
            EndGame "As night falls, strange creatures emerge in the village. You are overwhelmed and do not survive the night." "bad" -BackgroundImageFile $backgroundImageFile
        }

        "callForHelp" {
            $message = "Your voice echoes through the empty streets. Suddenly, you hear footsteps approaching. Do you:"
            $choices = @("Hide", "Wait to see who it is")

            $result = Show-ChoiceDialog -Title "Horror Adventure" -Message $message -Choices $choices -BackgroundImageFile $backgroundImageFile

            if ($result -eq $null) {
                EndGame "Game Over. You exited the game." "bad" -BackgroundImageFile $backgroundImageFile
            }

            switch ($result) {
                "Hide" { $gameState = "hideInVillage" }
                "Wait to see who it is" { $gameState = "meetStranger" }
            }
        }

        "hideInVillage" {
            EndGame "You hide, but the footsteps pass by without incident. You decide it's best to leave the village. You survive but find no help here." "good" -BackgroundImageFile $backgroundImageFile
        }

        "meetStranger" {
            $message = "A mysterious stranger approaches. He offers to guide you out of the forest. Do you:"
            $choices = @("Accept his help", "Decline and go alone")

            $result = Show-ChoiceDialog -Title "Horror Adventure" -Message $message -Choices $choices -BackgroundImageFile $backgroundImageFile

            if ($result -eq $null) {
                EndGame "Game Over. You exited the game." "bad" -BackgroundImageFile $backgroundImageFile
            }

            switch ($result) {
                "Accept his help" { $gameState = "guidedOut" }
                "Decline and go alone" { $gameState = "goAlone" }
            }
        }

        "guidedOut" {
            EndGame "The stranger leads you safely out of the forest. You survive and escape the dangers within." "good" -BackgroundImageFile $backgroundImageFile
        }

        "goAlone" {
            EndGame "You venture alone and get lost in the forest. Eventually, you succumb to the elements." "bad" -BackgroundImageFile $backgroundImageFile
        }

        "strangeLights" {
            $message = "You approach the strange lights and find an ancient shrine emitting a ghostly glow. Do you:"
            $choices = @("Investigate the shrine", "Leave immediately")

            $result = Show-ChoiceDialog -Title "Horror Adventure" -Message $message -Choices $choices -BackgroundImageFile $backgroundImageFile

            if ($result -eq $null) {
                EndGame "Game Over. You exited the game." "bad" -BackgroundImageFile $backgroundImageFile
            }

            switch ($result) {
                "Investigate the shrine" { $gameState = "investigateShrine" }
                "Leave immediately" { $gameState = "forestPath" }
            }
        }

        "investigateShrine" {
            EndGame "As you touch the shrine, you're engulfed in a blinding light. You gain mystical powers and become the guardian of the forest." "good" -BackgroundImageFile $backgroundImageFile
        }

        "creepyHouse" {
            $message = "As you approach the source of the noise, you see a creepy, abandoned house. Do you:"
            $choices = @("Enter the house", "Leave the house", "Circle around the house")

            $result = Show-ChoiceDialog -Title "Horror Adventure" -Message $message -Choices $choices -BackgroundImageFile $backgroundImageFile

            if ($result -eq $null) {
                EndGame "Game Over. You exited the game." "bad" -BackgroundImageFile $backgroundImageFile
            }

            switch ($result) {
                "Enter the house" { $gameState = "insideHouse" }
                "Leave the house" { $gameState = "forestPath" }
                "Circle around the house" { $gameState = "aroundHouse" }
            }
        }

        "aroundHouse" {
            $message = "You circle around the house and find a cellar door slightly ajar. Do you:"
            $choices = @("Enter the cellar", "Return to the front door", "Leave the house")

            $result = Show-ChoiceDialog -Title "Horror Adventure" -Message $message -Choices $choices -BackgroundImageFile $backgroundImageFile

            if ($result -eq $null) {
                EndGame "Game Over. You exited the game." "bad" -BackgroundImageFile $backgroundImageFile
            }

            switch ($result) {
                "Enter the cellar" { $gameState = "cellar" }
                "Return to the front door" { $gameState = "insideHouse" }
                "Leave the house" { $gameState = "forestPath" }
            }
        }

        "cellar" {
            $message = "In the cellar, you find old books and artifacts. There's also a hidden passage. Do you:"
            $choices = @("Explore the hidden passage", "Take an artifact", "Leave the cellar")

            $result = Show-ChoiceDialog -Title "Horror Adventure" -Message $message -Choices $choices -BackgroundImageFile $backgroundImageFile

            if ($result -eq $null) {
                EndGame "Game Over. You exited the game." "bad" -BackgroundImageFile $backgroundImageFile
            }

            switch ($result) {
                "Explore the hidden passage" { $gameState = "hiddenPassage" }
                "Take an artifact" { $gameState = "takeArtifact" }
                "Leave the cellar" { $gameState = "aroundHouse" }
            }
        }

        "hiddenPassage" {
            EndGame "You follow the hidden passage and find yourself in a secret chamber filled with treasure. You have uncovered a great secret but are now trapped forever." "bad" -BackgroundImageFile $backgroundImageFile
        }

        "takeArtifact" {
            EndGame "You take an ancient artifact. As you leave, the house collapses. You survive and later sell the artifact, becoming wealthy but haunted by nightmares." "good" -BackgroundImageFile $backgroundImageFile
        }

        "insideHouse" {
            $message = "Inside the house, you find a dimly lit room with a locked door and a staircase leading upstairs. Do you:"
            $choices = @("Try to open the door", "Search for another way out", "Go upstairs")

            $result = Show-ChoiceDialog -Title "Horror Adventure" -Message $message -Choices $choices -BackgroundImageFile $backgroundImageFile

            if ($result -eq $null) {
                EndGame "Game Over. You exited the game." "bad" -BackgroundImageFile $backgroundImageFile
            }

            switch ($result) {
                "Try to open the door" {
                    EndGame "The door suddenly opens, revealing a horrifying creature. It lunges at you, and everything goes black. You are dead." "bad" -BackgroundImageFile $backgroundImageFile
                }
                "Search for another way out" {
                    EndGame "You find a hidden passage that leads outside. You escape the house, but you'll never forget the terror you experienced." "good" -BackgroundImageFile $backgroundImageFile
                }
                "Go upstairs" {
                    $gameState = "upstairs"
                }
            }
        }

        "upstairs" {
            $message = "Upstairs, you find a dusty bedroom and a study with strange symbols on the walls. Do you:"
            $choices = @("Investigate the bedroom", "Examine the study", "Go back downstairs")

            $result = Show-ChoiceDialog -Title "Horror Adventure" -Message $message -Choices $choices -BackgroundImageFile $backgroundImageFile

            if ($result -eq $null) {
                EndGame "Game Over. You exited the game." "bad" -BackgroundImageFile $backgroundImageFile
            }

            switch ($result) {
                "Investigate the bedroom" { $gameState = "bedroom" }
                "Examine the study" { $gameState = "study" }
                "Go back downstairs" { $gameState = "insideHouse" }
            }
        }

        "bedroom" {
            EndGame "In the bedroom, you find an old diary revealing dark secrets about the house. Suddenly, the door slams shut, and you're trapped forever." "bad" -BackgroundImageFile $backgroundImageFile
        }

        "study" {
            $message = "In the study, you decipher the symbols and find a spell book. Do you:"
            $choices = @("Read a spell aloud", "Take the book and leave", "Leave the study")

            $result = Show-ChoiceDialog -Title "Horror Adventure" -Message $message -Choices $choices -BackgroundImageFile $backgroundImageFile

            if ($result -eq $null) {
                EndGame "Game Over. You exited the game." "bad" -BackgroundImageFile $backgroundImageFile
            }

            switch ($result) {
                "Read a spell aloud" {
                    EndGame "You read a spell aloud, and the house begins to shake. You've awakened ancient spirits. You don't survive." "bad" -BackgroundImageFile $backgroundImageFile
                }
                "Take the book and leave" {
                    EndGame "You take the book and escape the house. With the knowledge inside, you become a powerful sorcerer." "good" -BackgroundImageFile $backgroundImageFile
                }
                "Leave the study" {
                    $gameState = "upstairs"
                }
            }
        }

        "forestPath" {
            $message = "You keep walking through the dark forest. You feel like you're being watched. Do you:"
            $choices = @("Keep walking", "Hide in the bushes", "Climb a tree to rest")

            $result = Show-ChoiceDialog -Title "Horror Adventure" -Message $message -Choices $choices -BackgroundImageFile $backgroundImageFile

            if ($result -eq $null) {
                EndGame "Game Over. You exited the game." "bad" -BackgroundImageFile $backgroundImageFile
            }

            switch ($result) {
                "Keep walking" { $gameState = "continueWalking" }
                "Hide in the bushes" { $gameState = "hideInBushes" }
                "Climb a tree to rest" { $gameState = "restInTree" }
            }
        }

        "continueWalking" {
            $message = "You continue walking and come across a river blocking your path. Do you:"
            $choices = @("Attempt to cross the river", "Follow the river downstream", "Look for a bridge")

            $result = Show-ChoiceDialog -Title "Horror Adventure" -Message $message -Choices $choices -BackgroundImageFile $backgroundImageFile

            if ($result -eq $null) {
                EndGame "Game Over. You exited the game." "bad" -BackgroundImageFile $backgroundImageFile
            }

            switch ($result) {
                "Attempt to cross the river" { $gameState = "crossRiver" }
                "Follow the river downstream" { $gameState = "downstream" }
                "Look for a bridge" { $gameState = "findBridge" }
            }
        }

        "crossRiver" {
            EndGame "You attempt to cross the river, but the current is too strong. You are swept away and drown." "bad" -BackgroundImageFile $backgroundImageFile
        }

        "downstream" {
            EndGame "You follow the river downstream and find a small fishing village. The villagers help you, and you survive." "good" -BackgroundImageFile $backgroundImageFile
        }

        "findBridge" {
            $message = "You find a rickety old bridge. It looks unstable. Do you:"
            $choices = @("Cross the bridge", "Find another way")

            $result = Show-ChoiceDialog -Title "Horror Adventure" -Message $message -Choices $choices -BackgroundImageFile $backgroundImageFile

            if ($result -eq $null) {
                EndGame "Game Over. You exited the game." "bad" -BackgroundImageFile $backgroundImageFile
            }

            switch ($result) {
                "Cross the bridge" {
                    EndGame "As you cross, the bridge collapses. You fall into the river but manage to swim to safety. You survive." "good" -BackgroundImageFile $backgroundImageFile
                }
                "Find another way" {
                    $gameState = "downstream"
                }
            }
        }

        "hideInBushes" {
            $message = "As you hide, a terrifying creature slowly walks past you. It doesn't notice you. Do you:"
            $choices = @("Follow the creature", "Wait until it's gone", "Attack the creature")

            $result = Show-ChoiceDialog -Title "Horror Adventure" -Message $message -Choices $choices -BackgroundImageFile $backgroundImageFile

            if ($result -eq $null) {
                EndGame "Game Over. You exited the game." "bad" -BackgroundImageFile $backgroundImageFile
            }

            switch ($result) {
                "Follow the creature" { $gameState = "followCreature" }
                "Wait until it's gone" { $gameState = "waitCreatureGone" }
                "Attack the creature" { $gameState = "attackCreature" }
            }
        }

        "followCreature" {
            $message = "You follow the creature to a hidden cave. Do you:"
            $choices = @("Enter the cave", "Mark the location and leave")

            $result = Show-ChoiceDialog -Title "Horror Adventure" -Message $message -Choices $choices -BackgroundImageFile $backgroundImageFile

            if ($result -eq $null) {
                EndGame "Game Over. You exited the game." "bad" -BackgroundImageFile $backgroundImageFile
            }

            switch ($result) {
                "Enter the cave" {
                    EndGame "Inside the cave, you discover the creature's lair. You are attacked and do not survive." "bad" -BackgroundImageFile $backgroundImageFile
                }
                "Mark the location and leave" {
                    EndGame "You mark the cave's location and escape the forest. Later, you report your findings to authorities. You survive." "good" -BackgroundImageFile $backgroundImageFile
                }
            }
        }

        "waitCreatureGone" {
            EndGame "After the creature leaves, you find your way out of the forest. You are safe now, but the terror lingers." "good" -BackgroundImageFile $backgroundImageFile
        }

        "attackCreature" {
            EndGame "You bravely attack the creature, but it overpowers you. You do not survive." "bad" -BackgroundImageFile $backgroundImageFile
        }

        "restInTree" {
            EndGame "You climb a tree to rest. While you sleep, creatures below surround the tree. You are trapped until dawn but survive." "good" -BackgroundImageFile $backgroundImageFile
        }

        default {
            # Handle any unexpected game states
            EndGame "An unexpected error occurred. The game will now exit." "bad" -BackgroundImageFile $backgroundImageFile
        }
    }
}

