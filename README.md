# Icinga Powershell Framework Kickstarter

This PowerShell Script provides an easy way to get the Icinga Powershell Framework with plugins and the Icinga Agent fully installed and configured on your system.

This script downloads a PowerShell script file from either GitHub or from a custom source you provide.

Once loaded, it will be executed and asks all required questions on how and where to install the PowerShell Framework for Icinga and where to get it.

## Installation

1. Start a PowerShell with administrative privileges
2. Run the following command

```powershell
[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11";
$ProgressPreference                         = "SilentlyContinue";

Invoke-WebRequest `
    -UseBasicParsing `
    -Uri 'https://packages.icinga.com/IcingaForWindows/IcingaForWindows.ps1' `
    -OutFile 'C:\Users\Public\IcingaForWindows.ps1';

& 'C:\Users\Public\IcingaForWindows.ps1'
```

More details and examples can be found on the [Icinga documentation](https://icinga.com/docs/icinga-for-windows/latest/doc/110-Installation/01-Getting-Started/).

## Documentation

Please take a look on the following content for installation and documentation:

* [Introduction](doc/01-Introduction.md)
* [Changelog](doc/31-Changelog.md)
