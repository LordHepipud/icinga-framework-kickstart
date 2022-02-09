@{
    ModuleVersion     = '1.5.0'
    GUID              = '875189b7-cfc2-44c0-817d-f754f40aae64'
    Author            = 'Lord Hepipud'
    CompanyName       = 'Icinga GmbH'
    Copyright         = '(c) 2021 Icinga GmbH | MIT'
    Description       = 'Icinga for Windows kickstart for easier deployment of the Icinga PowerShell Framework.'
    PowerShellVersion = '4.0'
    NestedModules     = @()
    FunctionsToExport = @( '*' )
    CmdletsToExport   = @( '*' )
    VariablesToExport = '*'
    AliasesToExport   = @( '*' )
    PrivateData       = @{
        PSData     = @{
            Tags         = @( 'icinga', 'icinga2', 'IcingaKickstart', 'IcingaPowerShell', 'IcingaforWindows', 'IcingaWindows')
            LicenseUri   = 'https://github.com/Icinga/icinga-powershell-kickstart/blob/master/LICENSE'
            ProjectUri   = 'https://github.com/Icinga/icinga-powershell-kickstart'
            ReleaseNotes = 'https://github.com/Icinga/icinga-powershell-kickstart/releases'
        };
        Version    = 'v1.5.0';
        Name       = 'Windows Kickstart';
        Type       = 'kickstart';
        Function   = 'Start-IcingaFrameworkWizard';
        Endpoint   = '';
        ScriptFile = 'script\icinga-powershell-kickstart.ps1';
    }
    HelpInfoURI       = 'https://github.com/Icinga/icinga-powershell-kickstart'
}
