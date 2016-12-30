Import-Module SQLPS

# given an object of database objects, add the definition for each object
function Add-DefinitionsToObject
{
    param(
        [Parameter(Mandatory=$true)][string]$Database,
        [Parameter(Mandatory=$true)][string]$Server,
        [Parameter(Mandatory=$true)][object]$Object
    )

    foreach ($o in $object)
    {
        if ($o.Schema) {        
            $definition = Get-DbObjectDefinition -Server $Server -Database $Database -Schema $o.Schema -Name $o.Name
            Add-Member -InputObject $o -NotePropertyName Definition -NotePropertyValue $definition
        }
        else
        {
            $definition = Get-DbObjectDefinition -Server $Server -Database $Database -Name $o
            $properties = @{ Definition = $definition; Name = $o }
            $object[$object.IndexOf($o)] = New-Object -TypeName PSObject -Prop $properties
        }
    }

    return $object
}

<#
.SYNOPSIS
 Find objects whose definition text contains a value

.DESCRIPTION
 Find objects whose definition text contains a value

.PARAMETER Database
 The database to find objects in

.PARAMETER Server
 The server where the database resides

.PARAMETER DefinitionText
 The value to search objects for

#>
function Find-DbObjects
{
    param(
        [Parameter(Mandatory=$true)][string]$Database,
        [Parameter(Mandatory=$true)][string]$Server,
        [Parameter(Mandatory=$true)][string]$DefinitionText
    )
    
    $query = @"
        SELECT DISTINCT
            o.name AS Name,
            s.name AS [Schema],
            o.type_desc AS [Type],
            m.[definition] AS [Definition]
        FROM
	        $Database.sys.sql_modules AS m
	        JOIN
		        $Database.sys.objects AS o
		        ON
			        m.[object_id] = o.[object_id]
	        JOIN
		        $Database.sys.schemas AS s
		        ON
			        o.[schema_id] = s.[schema_id]
        WHERE
	        m.definition LIKE '%$DefinitionText%'
"@

    $result = Invoke-Sqlcmd -ServerInstance $Server -Query $query

    return $result
}

<#
.SYNOPSIS
 Get the definition for all functions in a database

.DESCRIPTION
 Get the definition for all functions in a database

.PARAMETER Database
 The database to get function definitions from

.PARAMETER Server
 The server where the database resides

#>
function Get-DbFunctionDefinitions
{
    param(
        [Parameter(Mandatory=$true)][string]$Database,
        [Parameter(Mandatory=$true)][string]$Server
    )

    $functions = Get-DbFunctions -Server $Server -Database $Database

    Add-DefinitionsToObject -Server $Server -Database $Database -Object $functions

    return $functions
}

<#
.SYNOPSIS
 Get the name of all functions in a database

.DESCRIPTION
 Get the name of all functions in a database

.PARAMETER Database
 The database to get function names from

.PARAMETER Server
 The server where the database resides

#>
function Get-DbFunctions
{
    param(
        [Parameter(Mandatory=$true)][string]$Server,
        [Parameter(Mandatory=$true)][string]$Database
    )

    $query = @"
        SELECT
            o.name AS Name,
            s.name AS [Schema]
        FROM
            $Database.sys.objects AS o
            JOIN
                $Database.sys.schemas AS s
                ON
                    o.[schema_id] = s.[schema_id]
        WHERE
            [type] IN ('FN', 'IF', 'TF')
"@

    $result = Invoke-Sqlcmd -ServerInstance $Server -Query $query

    return $result
}

<#
.SYNOPSIS
 Get the definition of a database object

.DESCRIPTION
 Get the definition of a database object

.PARAMETER Database
 The database where the object resides

.PARAMETER Server
 The server where the database resides

.PARAMETER Schema
 The schema where the object resides

.PARAMETER Name
 The name of the object

#>
function Get-DbObjectDefinition
{
    param(
        [Parameter(Mandatory=$true)][string]$Server,
        [Parameter(Mandatory=$true)][string]$Database,
        [Parameter(Mandatory=$false)][string]$Schema,
        [Parameter(Mandatory=$true)][string]$Name
    )

    if($Schema) {
        $query = @"
            USE $Database;
            GO
            EXEC sp_helptext '$Schema.$Name'
"@
    }
    else
    {
        $query = @"
            USE $Database;
            GO
            EXEC sp_helptext '$Name'
"@
    }

    $result = Invoke-Sqlcmd -ServerInstance $Server -Query $query

    return $result.Text -join ''
}

<#
.SYNOPSIS
 Get the names, schemas, and types of all objects in sys.objects for a particular database

.DESCRIPTION
 Get the names, schemas, and types of all objects in sys.objects for a particular database

.PARAMETER Database
 The database to get objects from

.PARAMETER Server
 The server where the database resides

.PARAMETER Schema
 The schema where the objects reside

#>
function Get-DbObjects
{
    param(
        [Parameter(Mandatory=$true)][string]$Server,
        [Parameter(Mandatory=$true)][string]$Database,
        [Parameter(Mandatory=$false)][string]$Schema
    )

    $query = @"
        SELECT
            o.name AS Name,
            s.name AS [Schema],
            o.type_desc AS Type
        FROM
            $Database.sys.objects AS o
            JOIN
                $Database.sys.schemas AS s
                ON
                    o.[schema_id] = s.[schema_id]
"@
    
    if($Schema) {
        $query += "WHERE s.name = '$Schema'"
    }

    $result = Invoke-Sqlcmd -ServerInstance $Server -Query $query

    return $result
}

<#
.SYNOPSIS
 Get the name of all databases on a server

.DESCRIPTION
 Get the name of all databases on a server

.PARAMETER Server
 The server to return database names from

#>
function Get-Dbs
{
    param(
        [Parameter(Mandatory=$true)][string]$Server
    )
    
    $QUERY = "SELECT name FROM sys.databases WHERE owner_sid != 0x01"

    $result = Invoke-Sqlcmd -ServerInstance $Server -Query $QUERY

    return $result.name
}

<#
.SYNOPSIS
 Get the name of all schemas in a database

.DESCRIPTION
 Get the name of all schemas in a database

.PARAMETER Database
 The database to get schema names from

.PARAMETER Server
 The server where the database resides

#>
function Get-DbSchemas
{
    param(
        [Parameter(Mandatory=$true)][string]$Server,
        [Parameter(Mandatory=$true)][string]$Database
    )

    $query = "SELECT name FROM $Database.sys.schemas WHERE schema_id < 16384 AND name NOT LIKE '%\%' AND name NOT IN ('guest', 'INFORMATION_SCHEMA', 'sys')"

    $result = Invoke-Sqlcmd -ServerInstance $Server -Query $query

    return $result.name
}

<#
.SYNOPSIS
 Get the definition for all stored procedures in a database

.DESCRIPTION
 Get the definition for all stored procedures in a database

.PARAMETER Database
 The database to get stored procedure definitions from

.PARAMETER Server
 The server where the database resides

#>
function Get-DbStoredProcedureDefinitions
{
    param(
        [Parameter(Mandatory=$true)][string]$Database,
        [Parameter(Mandatory=$true)][string]$Server
    )

    $procedures = Get-DbStoredProcedures -Server $Server -Database $Database

    Add-DefinitionsToObject -Server $Server -Database $Database -Object $procedures

    return $procedures
}

<#
.SYNOPSIS
 Get the name of all stored procedures in a database

.DESCRIPTION
 Get the name of all stored procedures in a database

.PARAMETER Database
 The database to get stored procedure names from

.PARAMETER Server
 The server where the database resides

#>
function Get-DbStoredProcedures
{
    param(
        [Parameter(Mandatory=$true)][string]$Server,
        [Parameter(Mandatory=$true)][string]$Database
    )

    $query = @"
        SELECT
            p.name AS Name,
            s.name AS [Schema]
        FROM
            $Database.sys.procedures AS p
            JOIN
                $Database.sys.schemas AS s
                ON
                    p.[schema_id] = s.[schema_id]
"@

    $result = Invoke-Sqlcmd -ServerInstance $Server -Query $query

    return $result
}

<#
.SYNOPSIS
 Get the definition of all triggers in a database

.DESCRIPTION
 Get the definition of all triggers in a database

.PARAMETER Database
 The database to get trigger definitions from

.PARAMETER Server
 The server where the database resides

#>
function Get-DbTriggerDefinitions
{
    param(
        [Parameter(Mandatory=$true)][string]$Database,
        [Parameter(Mandatory=$true)][string]$Server
    )

    $triggers = Get-DbTriggers -Server $Server -Database $Database

    Add-DefinitionsToObject -Server $Server -Database $Database -Object $triggers

    return $triggers
}

<#
.SYNOPSIS
 Get the name of all triggers in a database

.DESCRIPTION
 Get the name of all triggers in a database

.PARAMETER Database
 The database to get trigger names from

.PARAMETER Server
 The server where the database resides

#>
function Get-DbTriggers
{
    param(
        [Parameter(Mandatory=$true)][string]$Server,
        [Parameter(Mandatory=$true)][string]$Database
    )

    $query = "SELECT name FROM $Database.sys.triggers"

    $result = Invoke-Sqlcmd -ServerInstance $Server -Query $query

    return $result.name
}

<#
.SYNOPSIS
 Get the definition of all views in a database

.DESCRIPTION
 Get the definition of all views in a database

.PARAMETER Database
 The database to get view definitions from

.PARAMETER Server
 The server where the database resides

#>
function Get-DbViewDefinitions
{
    param(
        [Parameter(Mandatory=$true)][string]$Database,
        [Parameter(Mandatory=$true)][string]$Server
    )

    $views = Get-DbStoredProcedures -Server $Server -Database $Database

    Add-DefinitionsToObject -Server $Server -Database $Database -Object $views

    return $views
}

<#￼
.SYNOPSIS
 Get the name of all views in a database

.DESCRIPTION
 Get the name of all views in a database

.PARAMETER Database
 The database to get view names from

.PARAMETER Server
 The server where the database resides

#>
function Get-DbViews
{
    param(
        [Parameter(Mandatory=$true)][string]$Server,
        [Parameter(Mandatory=$true)][string]$Database
    )

    $query = @"
        SELECT
            v.name AS Name,
            s.name AS [Schema]
        FROM
            $Database.sys.views AS v
            JOIN
                $Database.sys.schemas AS s
                ON
                    v.[schema_id] = s.[schema_id]
"@

    $result = Invoke-Sqlcmd -ServerInstance $Server -Query $query

    return $result
}