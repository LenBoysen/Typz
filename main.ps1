# Install-Module -Name PSReadLine -Force -SkipPublisherCheck  # Uncomment and run to install PSReadLine if not installed
[Console]::CursorVisible = $false

Import-Module PSReadLine

function Show-Menu {
    Clear-Host
    Write-Host "======================"
    Write-Host "      Typz Menu       "
    Write-Host "======================"
}

enum MenuOption {
    Play
    Options
    Quit
}



function Option1 {
    Clear-Host
    Write-Host "You selected $selectedOption"
    Read-Host -Prompt "Press Enter to continue"

    # Clear the screen
    Clear-Host





    # Record the start time
    $startTime = Get-Date
    # Create a runspace
    $runspace = [runspacefactory]::CreateRunspace()
    $runspace.Open()
    # Create a PowerShell instance within the runspace
    $powerShell = [powershell]::Create()
    # Add the script to the PowerShell instance
    $powerShell.AddScript({
        param($startTime)
    
        while ($true) {
            # Calculate the elapsed time
            $elapsedTime = (Get-Date) - $startTime
            $positonLeft = [Console]::CursorLeft
            $positonTop  = [Console]::CursorTop
    
            # Clear the console and update the elapsed time
            [Console]::SetCursorPosition(15, 0)
            Write-Host "Elapsed Time: $($elapsedTime.ToString())"
            [Console]::SetCursorPosition($positonLeft, $positonTop)
            # Sleep for a short duration before updating again
            Start-Sleep -Milliseconds 500
        }
    }) | Out-Null
    
    # Pass the $startTime variable as an argument to the script
    $powerShell.AddArgument($startTime) | Out-Null
    
    # Associate the PowerShell instance with the runspace
    $powerShell.Runspace = $runspace

    # Start the PowerShell script in the background
    $asyncObject = $powerShell.BeginInvoke()





    # Set the cursor position to the beginning
    [Console]::SetCursorPosition(1, 0)

    
    # Display the English text with all letters in light grey
    $originalColor = $Host.UI.RawUI.ForegroundColor
    $Host.UI.RawUI.ForegroundColor = [ConsoleColor]::DarkGray

    $englishText = "The quick brown fox jumps over the lazy dog."
    [Console]::Write($englishText)

    # Initialize the mistake variable
    $mistake = 0
    


    # Enable the cursor
    [Console]::CursorVisible = $true

    # Initialize the position variable
    $position = 0


    
    # Capture user input and process it
    $input = [Console]::ReadKey($true)
    while ($input.Key -ne 'Enter') {
    if ($input.Key -eq 'Backspace') {

        if ([Console]::CursorLeft -le 0) {
            # If Console]::CursorLeft is less than or equal to 0, exit the if statement
            [Console]::Write($input.KeyChar)
            $input = [Console]::ReadKey($true)
            continue
        }
    
        [Console]::SetCursorPosition([Console]::CursorLeft - 1, [Console]::CursorTop)
        
        $position = [math]::Max(0, $position - 1)
        
        [Console]::ForegroundColor = [ConsoleColor]::DarkGray
        [Console]::Write($englishText[$position])

    
        # If backspace is pressed, restore the original color and decrement the position
        [Console]::ForegroundColor = $originalColor
        [Console]::Write($input.KeyChar)

        
        $input = [Console]::ReadKey($true)
        
    } elseif ($position -ge $englishText.Length) {
        $input = [Console]::ReadKey($true)
    } else {
        # Calculate the expected character based on the position
        $expectedChar = $englishText[$position]
        
        # Increment the position
        $position++
        
        if ($input.KeyChar -eq $expectedChar) {
            # If the input matches the expected character, display in white
            [Console]::ForegroundColor = [ConsoleColor]::White
            [Console]::Write($input.KeyChar)
        } else {
            # If the input does not match, display in red
            [Console]::ForegroundColor = [ConsoleColor]::Red
            [Console]::Write($expectedChar)
        }

        
        $input = [Console]::ReadKey($true)
    }


    }
    # Stop the runspace
    $powerShell.EndInvoke($asyncObject)

    # Close the runspace
    $runspace.Close()

    
    # Reset the console color and hide the cursor
    #[Console]::ReadKey($false) | Out-Null
    [Console]::ForegroundColor = $originalColor
    [Console]::CursorVisible = $false

    
}






function Option2 {
    Clear-Host

    
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
        { $selectedOption -lt 0 } { $selectedOption = [MenuOption]::GetValues([MenuOption])[[MenuOption]::GetValues([MenuOption]).Length - 1] }
        { $selectedOption -gt [MenuOption]::GetValues([MenuOption]).Length - 1 } { $selectedOption = [MenuOption]::GetValues([MenuOption])[0] }
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




