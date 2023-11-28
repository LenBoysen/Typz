# Install-Module -Name PSReadLine -Force -SkipPublisherCheck  # Uncomment and run to install PSReadLine if not installed

Import-Module PSReadLine

function Show-Menu {
    Clear-Host
    Write-Host "======================"
    Write-Host "   ASCII GUI Menu"
    Write-Host "======================"
}

enum MenuOption {
    Option1
    Option2
    Exit
}


function Set-OptionColor {
    param(
        [string]$option,
        [string]$bgColor
    )

    $escape = [char]27
    Write-Host "$option" -BackgroundColor $bgColor
}

function Option1 {
    Clear-Host
    Write-Host "You selected Option 1"
    # Add your logic for Option 1 here
    Read-Host -Prompt "Press Enter to continue"
}

function Option2 {
    Clear-Host
    Write-Host "You selected Option 2"
    # Add your logic for Option 2 here
    Read-Host -Prompt "Press Enter to continue"
}

$selectedOption = [MenuOption]::Option1

do {
    Show-Menu

    foreach ($option in [MenuOption]::GetValues([MenuOption])) {
        if ($option -eq $selectedOption) {
            Set-OptionColor "$option" 'Green'
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
                #0 {Option1}
                #1 {Option1}
                #"Option1" {Option1}
                [MenuOption]::Option1 { Option1 }
                #[string][MenuOption]::Option1 { Option2 }
                #[MenuOption]::Option1.ToString() { Option1 }
                #[string][MenuOption]::Option1.ToString() { Option2 }
                #[int][MenuOption]::Option1 { Option1 }
                [int][MenuOption]::Option2 { Option2 }
                [int][MenuOption]::Exit { break }
            }
        }
    }

} while ($true)

# Remove PSReadLine key handlers
Remove-Module PSReadLine -Force
