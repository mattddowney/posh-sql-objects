$installDir = ($env:PSModulePath).Split(';')[0]
Write-Host "Installing to $installDir"
Copy-Item posh-sql-objects $installDir -Recurse -Force
Write-Host "Done"