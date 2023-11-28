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
    $choice = Read-Host "Enter your choice"

    switch ($choice) {
        '1' { Option1 }
        '2' { Option2 }
    }

} while ($choice -ne '3')
