Add-Type -AssemblyName PresentationFramework

function Show-AsciiGui {
    param (
        [string]$inputText
    )

    $initialDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    $xaml = @'
<Window
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="ASCII GUI" Height="150" Width="400" ResizeMode="NoResize">
    <Grid>
        <TextBlock x:Name="DateText" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="10,10,0,0" TextWrapping="Wrap" Text="{Binding DateText}"/>
        <TextBlock x:Name="UserInputText" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="10,50,0,0" TextWrapping="Wrap" Text="{Binding UserInputText}"/>
    </Grid>
</Window>
'@

    $reader = (New-Object System.Xml.XmlNodeReader $xaml)
    $window = [Windows.Markup.XamlLoader]::Load($reader)

    $dateTextBlock = $window.FindName('DateText')
    $userInputTextBlock = $window.FindName('UserInputText')

    $runspace = [runspacefactory]::CreateRunspace()
    $runspace.ApartmentState = "STA"
    $runspace.ThreadOptions = "ReuseThread"
    $runspace.Open()

    $powerShell = [PowerShell]::Create()
    $powerShell.Runspace = $runspace

    $powerShell.AddScript({
        while ($true) {
            $script:date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            $script:userInput = $using:userInput

            $window.Dispatcher.Invoke([Windows.Threading.DispatcherPriority]::Background, [Windows.Threading.DispatcherOperationCallback]{
                $dateTextBlock.Text = "Current Date: $script:date"
                $userInputTextBlock.Text = "User Input:`n-----------------------`n$script:userInput`n-----------------------"
                $null
            }, $null)
            
            Start-Sleep -Milliseconds 500
        }
    })

    $runspace.SessionStateProxy.SetVariable("userInput", $inputText)
    $powerShell.BeginInvoke()

    [Windows.Markup.ComponentDispatcher]::Run()
}

# Start the ASCII GUI
Show-AsciiGui
