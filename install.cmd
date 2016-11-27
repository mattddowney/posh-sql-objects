SET module_folder=%HOMEDRIVE%\%HOMEPATH%\Documents\WindowsPowerShell\Modules\posh-sql-objects
mkdir %module_folder%
robocopy posh-sql-objects %module_folder% /MIR /IS