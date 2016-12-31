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

## Methods / Usage ##

### Find-DbObjects ###
Find objects whose definitions contain the string "text" in a database:

`Find-DbObjects -Server ServerName -Database DbName -DefinitionText "text"`

### Get-Dbs ###
List a server's databases:

`Get-Dbs -Server ServerName`

### Get-DbSchemas ###
List schemas on a database:

`Get-DbSchemas -Server ServerName -Database DbName`

### Get-DbObjects ###
List all the objects on a database:

`Get-DbObjects -Server ServerName -Database DbName`

### Get-DbObjects ###
List all the objects in a particular database schema:

`Get-DbObjects -Server ServerName -Database DbName -Schema SchemaName`

### Get-DbObjectDefinition ###
Get the definition (source code) of a particular object:

`Get-DbObjectDefinition -Server ServerName -Database DbName -Name ObjectName`

### Get-DbFunctions ###
List all the functions on a database:

`Get-DbFunctions -Server ServerName -Database DbName`

### Get-DbFunctionDefinitions ###
Get the definition (source code) for all functions on a database:

`Get-DbFunctionDefinitions -Server ServerName -Database DbName`

### Get-DbStoredProcedures ###
List all the stored procedures on a database:

`Get-DbStoredProcedures -Server ServerName -Database DbName`

### Get-DbStoredProcedureDefinitions ###
Get the definition (source code) for all stored procedures on a database:

`Get-DbStoredProcedureDefinitions -Server ServerName -Database DbName`

### Get-DbTriggers ###
List all the triggers on a databse:

`Get-DbTriggers -Server ServerName -Database DbName`

### Get-DbTriggersDefinitions ###
Get the definition (source code) for all triggers on a database:

`Get-DbTriggersDefinitions -Server ServerName -Database DbName`

### Get-DbViews ###
List all the views on a databse:

`Get-DbViews -Server ServerName -Database DbName`

### Get-DbViewDefinitions ###
Get the definition (source code) for all views on a database:

`Get-DbViewDefinitions -Server ServerName -Database DbName`
