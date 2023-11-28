function Update-Date {
    param (
        [int]$DelayMilliseconds
    )

    while ($true) {
        $date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        Write-Host "Current Date: $date"
        Start-Sleep -Milliseconds $DelayMilliseconds
    }
}

function GetUserInput {
    while ($true) {
        Write-Host "User Input:"
        Write-Host "-----------------------"
        Write-Host $global:userInput
        Write-Host "-----------------------"

        $userInput = Read-Host "Enter something:"
        $global:userInput = $userInput
        Start-Sleep -Milliseconds 100
    }
}

# Initialize the userInput variable
$global:userInput = ""

# Start background jobs
$jobDate = Start-Job -ScriptBlock ${function:Update-Date} -ArgumentList 500
$jobUserInput = Start-Job -ScriptBlock ${function:GetUserInput}

# Wait for user to exit the script
do {
    Start-Sleep -Seconds 1
} while ($true)

# Cleanup jobs
Stop-Job -Job $jobDate
Stop-Job -Job $jobUserInput
