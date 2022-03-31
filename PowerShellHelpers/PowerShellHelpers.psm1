function Test-Administrator {  
    $user = [Security.Principal.WindowsIdentity]::GetCurrent()
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)  
}
  
function Elevate { 
    param (
    [switch]$noExit
    )

    if ( ! (Test-Administrator) ) {
        start-process wt -Verb runas -ArgumentList "-d ."
        if (!$noExit) {
            exit
        }
    }
    else { Write-Warning "Session is already elevated" }
}

function sudo {
    Start-Process @args -verb runas
}

Set-Alias -name su -Value Elevate