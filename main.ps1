# Install-Module -Name PSReadLine -Force -SkipPublisherCheck  # Uncomment and run to install PSReadLine if not installed
[Console]::CursorVisible = $false

Import-Module PSReadLine

function Show-Menu {
    Clear-Host
    Write-Host "======================"
    Write-Host "   ASCII GUI Menu"
    Write-Host "======================"
}

enum MenuOption {
    Play
    Options
    Quit
}



function Option1 {
    Clear-Host
    Write-Host "You selected Option 1"
    Read-Host -Prompt "Press Enter to continue"

    # Clear the screen
    Clear-Host

    # Display the English text with all letters in light grey
    $originalColor = $Host.UI.RawUI.ForegroundColor
    $Host.UI.RawUI.ForegroundColor = [ConsoleColor]::DarkGray

    $englishText = "The quick brown fox jumps over the lazy dog."
    [Console]::Write($englishText)

    # Set the cursor position to the beginning
    [Console]::SetCursorPosition(0, 0)

    # Enable the cursor
    [Console]::CursorVisible = $true

    # Capture user input and process it
    $input = [Console]::ReadKey($true)
    while ($input.Key -ne 'Enter') {
        if ($input.KeyChar -in 'a'..'z') {
            # If the input is a lowercase letter, make it red
            [Console]::ForegroundColor = [ConsoleColor]::Red
        } elseif ($input.Key -eq 'Backspace') {
            # If backspace is pressed, restore the original color
            [Console]::ForegroundColor = $originalColor
        }

        # Overwrite the existing text with the user input
        [Console]::Write($input.KeyChar)

        # Read the next key
        $input = [Console]::ReadKey($true)
    }

    # Reset the console color and hide the cursor
    [Console]::ForegroundColor = $originalColor
    [Console]::CursorVisible = $false
}





function Option2 {
    Clear-Host
    Write-Host "You selected $selectedOption"
    # Add your logic for Option 2 here
    Read-Host -Prompt "Press Enter to continue"
}

function Quit {
    Clear-Host
    
}

$selectedOption = [MenuOption]::GetValues([MenuOption])[0]

do {
    Show-Menu

    foreach ($option in [MenuOption]::GetValues([MenuOption])) {
        if ($option -eq $selectedOption) {
            Write-Host "$option" -BackgroundColor 'Green'
        } else {
            Write-Host "$option"
        }
    }

    $key = $host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown').VirtualKeyCode

    switch ($key) {
        38 { $selectedOption-- } # Up arrow
        40 { $selectedOption++ } # Down arrow

        # Ensure the selected option stays within bounds
        { $selectedOption -lt 0 } { $selectedOption = 2 }
        { $selectedOption -gt 2 } { $selectedOption = 0 }
    }
    
    switch ($key) {
        13 {
            # Enter key
            
            switch ($selectedOption) {
                ([MenuOption]::Play) { Option1 }
                ([MenuOption]::Options) { Option2 }
                ([MenuOption]::Quit) { Quit; return }
            }
        }
    }

} while ($true)




