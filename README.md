# PoSh SQL Objects #

Convenience functions for interacting with MS SQL Server's system tables.

Useful for:
* Searching a database for objects (stored procedures, functions, views) where the source definition contains arbitrary text
* Getting object definitions of all objects in a database
* Getting the names of all objects in a database

## Installation ##

Run the following in a command prompt:

`Powershell.exe -file install.ps1`

This just copies the posh-sql-objects folder to your modules folder.

Import the module into powershell:

`Import-Module -Name posh-sql-objects`

## Usage ##

Find objects containing "text" in a database:

`Find-DbObjects -Server ServerName -Database DbName -DefinitionText "text"`

List a server's databases:

`Get-Dbs -Server ServerName`

List schemas on a database:

`Get-DbSchemas -Server ServerName -Database DbName`

List all the objects on a database:

`Get-DbObjects -Server ServerName -Database DbName`

List all the objects in a particular database schema:

`Get-DbObjects -Server ServerName -Database DbName -Schema SchemaName`

Get the definition (source code) of a particular object:

`Get-DbObjectDefinition -Server ServerName -Database DbName -Name ObjectName`

List all the functions on a database:

`Get-DbFunctions -Server ServerName -Database DbName`

Get the definition (source code) for all functions on a database:

`Get-DbFunctionDefinitions -Server ServerName -Database DbName`

List all the stored procedures on a database:

`Get-DbStoredProcedures -Server ServerName -Database DbName`

Get the definition (source code) for all stored procedures on a database:

`Get-DbStoredProcedureDefinitions -Server ServerName -Database DbName`

List all the triggers on a databse:

`Get-DbTriggers -Server ServerName -Database DbName`

Get the definition (source code) for all triggers on a database:

`Get-DbTriggersDefinitions -Server ServerName -Database DbName`

List all the views on a databse:

`Get-DbViews -Server ServerName -Database DbName`

Get the definition (source code) for all views on a database:

`Get-DbViewDefinitions -Server ServerName -Database DbName`
