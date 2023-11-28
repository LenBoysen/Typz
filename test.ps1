function Show-AsciiGui {
    param (
        [string]$inputText
    )

    $runspace = [runspacefactory]::CreateRunspace()
    $runspace.ApartmentState = "STA"
    $runspace.ThreadOptions = "ReuseThread"
    $runspace.Open()
    $runspace.SessionStateProxy.SetVariable("inputText", $inputText)

    $scriptblock = {
        param (
            [runspace]$runspace
        )

        while ($true) {
            $date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            Write-Host "Current Date: $date"

            Start-Sleep -Milliseconds 500
        }
    }

    $runspace.SessionStateProxy.SetVariable("job", [powershell]::Create().AddScript($scriptblock).AddArgument($runspace))
    $runspace.SessionStateProxy.SetVariable("userInput", "")

    [powershell]::Create().AddScript({
        while ($true) {
            Write-Host "User Input:"
            Write-Host "-----------------------"
            Write-Host $using:userInput
            Write-Host "-----------------------"

            $userInput = Read-Host "Enter something:"
            $using:userInput = $userInput

            Start-Sleep -Milliseconds 100
        }
    }).BeginInvoke()

    $job = $runspace.SessionStateProxy.GetVariable("job").BeginInvoke()

    # Wait for user to exit the script
    do {
        Start-Sleep -Seconds 1
    } while ($true)
}

# Start the ASCII GUI
Show-AsciiGui
