Add-Type -AssemblyName System.Windows.Forms

if(Test-Path "$($env:Userprofile)\XMC_Cred.xml") {
    $credential = Import-CliXml -Path  "$($env:Userprofile)\XMC_Cred.xml"
    $clientid = $credential.UserName
    $clientsecret = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR((($credential.password))))  
}else{
    $creds = Get-Credential
    $creds | Export-CliXml  -Path "$($env:Userprofile)\XMC_Cred.xml"
}

# Get banner
Get-Content -Path "Ascii.txt" -raw 

# Defining variables
$server = "YourServer:Port"
$group = "YourGroup"
# Client vostname prefix for validation (Wildcard needed)
$prefix = "YourPrefix*"

$user = ([System.Security.Principal.WindowsIdentity]::GetCurrent().Name).split("\")[1]

# Get API Token / Creates the session
Get-XMCToken -ClientID $clientid -ClientSecret $clientsecret -XMCFQDN $server | out-null

$exit = $false


do{
    Write-Host ""
    Write-Host "---------------- Menu ----------------"
    Write-Host "1) Add device"
    Write-Host "2) Remove device"
    Write-Host "3) List all devices"
    Write-Host "4) Exit"
    Write-Host ""
    $userInput = Read-Host -Prompt "Please make a selection: "

    Write-Host ""

    if($userInput -eq 1) {
        Write-Host "---------------- Add device ----------------"
        Write-Host "1) Add single device"
        Write-Host "2) Add multiple devices from CSV"

        $userInput1 = Read-Host -Prompt "Please make a selection: "

        if($userInput1 -eq 1) {
                Write-Host "---------------- Add single device ----------------"
                do{
                    $Hostname = Read-Host -Prompt "Enter Hostname"
                }until($Hostname -like $prefix)

                do{
                    $macAddress = Read-Host -Prompt "Enter Mac Address"
                }until($macAddress -match "^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$")

                $resp = Update-XMCAccessControlGroups -MacAddress $macAddress -Operation Add -XMCFQDN $server -TargetGroup $group -Description "[$user] added $Hostname with XMC SAS Script at $(get-date -Format "dd.MM.yy HH:mm:ss")"
            }
            elseif ($userInput1 -eq 2) {
                Write-Host "---------------- Add multiple devices ----------------"
                $FileBrowser = $null
                $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ InitialDirectory = [Environment]::GetFolderPath('Desktop') }
                $FileBrowser.ShowDialog()

                if($FileBrowser.FileName -eq ""){
                    Write-Host "File selection canceled"
                }else{
                    $FileContent = Get-Content -Path $FileBrowser.FileName | ConvertFrom-Csv

                    foreach($entry in $FileContent){
                        $resp = Update-XMCAccessControlGroups -MacAddress $entry.MacAddress -Operation Add -XMCFQDN $server -TargetGroup $group -Description "[$user] added $($entry.Hostname) with XMC SAS Script at $(get-date -Format "dd.MM.yy HH:mm:ss")"
                    }
                }
            }
        
        
    }
    elseif ($userInput -eq 2) {
        Write-Host "---------------- Remove single device ----------------"
        do{
            $macAddress = Read-Host -Prompt "Enter Mac Address"
        }until($macAddress -match "^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$")

        $resp = Update-XMCAccessControlGroups -MacAddress $macAddress -OperationType Remove -XMCFQDN $server -TargetGroup $group
    }
    elseif ($userInput -eq 3) {
        Write-Host "---------------- List all devices ----------------"
        Write-Host ""
        $resp = Get-XMCEndSystemsOfGroup -Group $group -XMCFQDN $server
        $resp | ForEach-Object {
            '{0}  {1}' -f $_.Mac, $_.Description
          }

    }
    elseif ($userInput -eq 4) {
        Write-Host "Bye Bye"
        $exit = $true
    }
    else {
        Write-Host "$userInput selection out of menu range"
        
    }
}until($exit -eq $true)
