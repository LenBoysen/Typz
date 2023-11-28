function Show-AsciiGui {
    param (
        [string]$inputText
    )

    $runspace = [runspacefactory]::CreateRunspace()
    $runspace.ApartmentState = "STA"
    $runspace.ThreadOptions = "ReuseThread"
    $runspace.Open()
    $runspace.SessionStateProxy.SetVariable("inputText", $inputText)

    $dateScriptBlock = {
        while ($true) {
            $date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            Write-Host "Current Date: $date"

            Start-Sleep -Milliseconds 500
        }
    }

    $userInputScriptBlock = {
        while ($true) {
            Write-Host "User Input:"
            Write-Host "-----------------------"
            Write-Host $using:userInput
            Write-Host "-----------------------"

            $userInput = Read-Host "Enter something:"
            $script:global:userInput = $userInput

            Start-Sleep -Milliseconds 100
        }
    }

    $dateJob = [powershell]::Create().AddScript($dateScriptBlock).AddArgument($runspace)
    $userInputJob = [powershell]::Create().AddScript($userInputScriptBlock)

    $runspace.SessionStateProxy.SetVariable("userInputJob", $userInputJob)

    $dateJob.Runspace = $runspace
    $userInputJob.Runspace = $runspace

    $dateJob.BeginInvoke()
    $userInputJob.BeginInvoke()

    # Wait for user to exit the script
    do {
        Start-Sleep -Seconds 1
    } while ($true)
}

# Start the ASCII GUI
Show-AsciiGui
