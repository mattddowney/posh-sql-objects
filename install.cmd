SET module_folder=%PSModulePath%\posh-sql-objects
mkdir %module_folder%
robocopy posh-sql-objects %module_folder% /MIR /IS