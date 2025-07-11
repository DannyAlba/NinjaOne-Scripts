#Finds all monitors on a given computer, and reports them to the custom fields of NinjaOne for informaiton or budgeting.

$number = 1
Get-CimInstance -Namespace root\wmi -ClassName WmiMonitorID | ForEach-Object {
    $name = ([System.Text.Encoding]::ASCII.GetString(($_.UserFriendlyName | Where-Object { $_ -ne 0 })))
    $serial = ([System.Text.Encoding]::ASCII.GetString(($_.SerialNumberID | Where-Object { $_ -ne 0 })))

    [PSCustomObject]@{
        MonitorName = $name
        SerialNumber = $serial
    }
    
    $info = $info + " Monitor ${number}: " + $name + " [" + $serial + "] "
    
    $number = $number + 1
    
    Ninja-Property-Set monitor $info
    
}
