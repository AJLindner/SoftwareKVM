$Config = Get-Content "\\AJPC\KVM\Config.json" | convertfrom-json

function Switch-Monitors {
    
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $false, ValueFromPipeline = $true, Position = 0)]
        [String]$TargetPC = ($config.computers | get-member -MemberType noteproperty | where name -ne $env:COMPUTERNAME | select -expand name),

        [Parameter(Mandatory = $false, ValueFromPipeline = $true, Position = 1)]
        [String]$ControlMyMonitorPath = $Config.CMMPath,

        [Parameter(Mandatory = $false, ValueFromPipeline = $true, Position = 2)]
        $LogFile = $Config.LogFilePath
    )

    if (!(test-path $LogFile)) {
        new-item $LogFile
    }

    "[$(get-date)] Switching to $TargetPC" | Add-Content $LogFile

    foreach ($monitor in $config.Monitors) {
    
        $Name = $monitor.Name
        $Inputs = $monitor.Inputs

        $TargetInput = ($Inputs | select -expand $TargetPC)


        & $ControlMyMonitorPath /setValue "$Name" 60 $TargetInput
        
        $info = "[$(get-date)] $Name switched to Input $targetInput"
        write-host $info
        $info | Add-Content $logfile

    }

"
------------------
" | Add-Content $LogFile

}

Switch-Monitors
