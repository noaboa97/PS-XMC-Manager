# PS XMC Manager

This is a CLI tool which is based on the [XMCmdlets](https://github.com/noaboa97/XMCmdlets) to easily list, add and remove mac addresses from end system groups in.

## Features

An end system is a device 

- Add single end system
- Add multiple end systems from CSV file (with file choosing pop-up)
- Remove single end system
- List all devices

### Manual
XMCmdlets need to be installed in one of the PSModulePath destination
```
$env:PSMODULEPATH -split ";"
```


## Shortcut
There is a shortcut located in the directory. But the path of the shortcut may need to be changed depending where. The path in the shortcut is ```"C:\Scripts\ps-xmc-manager\ps-xmc-manager.ps1"```

### Manual
You will also need to create a shortcut which bypasses the powershell execution policy.
The shortcut is also in the project but you will need to edit it if the script is saved somewhere else than the link. 
You will need to edit:
```C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -File "C:\path_to_where_you_saved_it\PS-XMC-Manager.ps1"```

Start in: ``C:\path_to_where_you_saved_it\``

## Access Rights / API Credentials
Somebody of the Operations Team (or admin of XMC) needs to create and add the API credentials when the script is run the first time. DOES NOT WORK WITH DOMAIN CREDENTIALS

The credentialstore is ``"C:\Users\YOUR_USERPROFILE\XMC_Cred.xml"``

Delete this file if you have entered nonesense. 



