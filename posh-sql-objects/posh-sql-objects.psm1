# Load module scripts
Push-Location $psScriptRoot
Try {
    . .\posh-sql-objects.ps1
} Finally {
    Pop-Location
}

$local:exportfunctions = @(
    'Find-DbObjects',
    'Get-DbFunctionDefinitions',
    'Get-DbFunctions',
    'Get-DbObjectDefinition',
    'Get-DbObjects',
    'Get-Dbs',
    'Get-DbSchemas',
    'Get-DbStoredProcedureDefinitions',
    'Get-DbStoredProcedures',
    'Get-DbTriggerDefinitions',
    'Get-DbTriggers',
    'Get-DbViewDefinitions',
    'Get-DbViews'
);

Export-ModuleMember -function $local:exportfunctions;