#Copies user data from one account to another.

$ErrorActionPreference = 'stop'


set-location C:\Users
Get-ChildItem
$Old = Read-Host "Please enter old profile name"
While (-not (Test-Path "C:\Users\$Old") )
{
    Write-Host "Profile doesn't exist"
    $Old = Read-host "Please enter a valid profile name"
}


$New = Read-Host "Please enter new profile name"
While (-not (Test-Path "C:\Users\$new") )
{
    Write-Host "Profile doesn't exist"
    $New = Read-Host "Please enter a valid profile name"
}
 

Copy-Item -Path C:\Users\$Old\desktop -Destination C:\Users\$New\ -Recurse -Force 
Copy-Item -Path C:\Users\$Old\downloads -Destination C:\Users\$New\ -Recurse -Force
Try
{
Copy-Item -Path C:\Users\$Old\documents -Destination C:\Users\$New\ -Recurse -Force 
}
Catch 
{
Write-host "Junction points can not be copied!" 
}
Copy-Item -Path C:\Users\$Old\Favorites -Destination C:\Users\$New\ -Recurse -Force 
Copy-Item -Path C:\Users\$Old\music -Destination C:\Users\$New\ -Recurse -Force 
Copy-Item -Path C:\Users\$Old\Videos -Destination C:\Users\$New\ -Recurse -Force 
Copy-Item -Path C:\Users\$Old\pictures -Destination C:\Users\$New\ -Recurse -Force
