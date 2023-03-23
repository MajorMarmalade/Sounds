function Show-ChoiceDialog {
    param (
        [string]$Title,
        [string]$Message,
        [string]$Choice1,
        [string]$Choice2
    )

    $form = New-Object System.Windows.Forms.Form
    $form.Text = $Title
    $form.Size = New-Object System.Drawing.Size(300, 200)
    $form.StartPosition = "CenterScreen"

    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(10, 10)
    $label.Size = New-Object System.Drawing.Size(280, 50)
    $label.Text = $Message
    $form.Controls.Add($label)

    $button1 = New-Object System.Windows.Forms.Button
    $button1.Location = New-Object System.Drawing.Point(10, 70)
    $button1.Size = New-Object System.Drawing.Size(120, 40)
    $button1.Text = $Choice1
    $button1.DialogResult = "OK"
    $form.Controls.Add($button1)

    $button2 = New-Object System.Windows.Forms.Button
    $button2.Location = New-Object System.Drawing.Point(150, 70)
    $button2.Size = New-Object System.Drawing.Size(120, 40)
    $button2.Text = $Choice2
    $button2.DialogResult = "Cancel"
    $form.Controls.Add($button2)

    $form.AcceptButton = $button1
    $form.CancelButton = $button2

    $result = $form.ShowDialog()

    if ($result -eq "OK") {
        return $Choice1
    } else {
        return $Choice2
    }
}

function EndGame($message) {
    [System.Windows.Forms.MessageBox]::Show($message)
    exit
}

[void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

$gameState = "start"

while ($true) {
    switch ($gameState) {
        "start" {
            $message = "You find yourself alone in a dark forest. The full moon shines through the trees, casting eerie shadows on the ground. You hear a rustling in the distance. Do you:"
            $choice1 = "Head towards the noise"
            $choice2 = "Walk away from the noise"

            $result = Show-ChoiceDialog -Title "Horror Adventure" -Message $message -Choice1 $choice1 -Choice2 $choice2

            if ($result -eq $choice1) {
                $gameState = "creepyHouse"
            } else {
                $gameState = "forestPath"
            }
        }

        "creepyHouse" {
            $message = "As you approach the source of the noise, you see a creepy, abandoned house. Do you:"
            $choice1 = "Enter the house"
            $choice2 = "Leave the house"

            $result = Show-ChoiceDialog -Title "Horror Adventure" -Message $message -Choice1 $choice1 -Choice2 $choice2

            if ($result -eq $choice1) {
                $gameState = "insideHouse"
            } else {
                $gameState = "forestPath"
            }
        }

        "forestPath" {
            $message = "You keep walking through the dark forest. You feel like you're being watched. Do you:"
            $choice1 = "Keep walking"
            $choice2 = "Hide in the bushes"

            $result = Show-ChoiceDialog -Title "Horror Adventure" -Message $message -Choice1 $choice1 -Choice2 $choice2

            if ($result -eq $choice1) {
                $gameState = "continueWalking"
            } else {
                $gameState = "hideInBushes"
            }
        }

        "insideHouse" {
            $message = "Inside the house, you find a dimly lit room with a locked door. Do you:"
            $choice1 = "Try to open the door"
            $choice2 = "Search for another way out"

            $result = Show-ChoiceDialog -Title "Horror Adventure" -Message $message -Choice1 $choice1 -Choice2 $choice2

            if ($result -eq $choice1) {
                EndGame "The door suddenly opens, revealing a horrifying creature. It lunges at you, and everything goes black. You are dead."
            } else {
                EndGame "You find a hidden passage that leads outside. You escape the house, but you'll never forget the terror you experienced."
            }
        }

        "continueWalking" {
            EndGame "You continue walking and eventually find a small village where you can rest for the night. You survive, but the haunting memories of the forest will stay with you forever."
        }

        "hideInBushes" {
            EndGame "As you hide, a terrifying creature slowly walks past you. It doesn't notice you, and after it's gone, you manage to find your way out of the forest. You are safe now, but the terror lingers."
        }
    }
}

