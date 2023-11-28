# Install-Module -Name PSReadLine -Force -SkipPublisherCheck  # Uncomment and run to install PSReadLine if not installed

Import-Module PSReadLine

function Show-Menu {
    Clear-Host
    Write-Host "======================"
    Write-Host "   ASCII GUI Menu"
    Write-Host "======================"
    Write-Host "1. Option 1"
    Write-Host "2. Option 2"
    Write-Host "3. Exit"
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

do {
    Show-Menu
    $choice = $null

    $key = $host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown').VirtualKeyCode

    switch ($key) {
        49 { $choice = '1' } # '1' key
        50 { $choice = '2' } # '2' key
        51 { $choice = '3' } # '3' key
    }

    switch ($choice) {
        '1' { Option1 }
        '2' { Option2 }
    }

} while ($choice -ne '3')

# Remove PSReadLine key handlers
Remove-Module PSReadLine -Force
