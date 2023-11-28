# Install-Module -Name PSReadLine -Force -SkipPublisherCheck  # Uncomment and run to install PSReadLine if not installed

Import-Module PSReadLine

function Show-Menu {
    Clear-Host
    Write-Host "======================"
    Write-Host "   ASCII GUI Menu"
    Write-Host "======================"
}

function Set-OptionColor {
    param(
        [string]$option,
        [string]$bgColor
    )

    $escape = [char]27
    Write-Host "$escape[48;2;40;40;40m $option $escape[0m"
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

$selectedOption = 1

do {
    Show-Menu

    for ($i = 1; $i -le 3; $i++) {
        if ($i -eq $selectedOption) {
            Set-OptionColor "$i. Option $i" 'Green'
        } else {
            Write-Host "$i. Option $i"
        }
    }

    $key = $host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown').VirtualKeyCode

    switch ($key) {
        38 { $selectedOption-- } # Up arrow
        40 { $selectedOption++ } # Down arrow

        # Ensure the selected option stays within bounds
        { $selectedOption -lt 1 } { $selectedOption = 3 }
        { $selectedOption -gt 3 } { $selectedOption = 1 }
    }

    switch ($key) {
        13 {
            # Enter key
            switch ($selectedOption) {
                1 { Option1 }
                2 { Option2 }
            }
        }
    }

} while ($selectedOption -ne 3)

# Remove PSReadLine key handlers
Remove-Module PSReadLine -Force
