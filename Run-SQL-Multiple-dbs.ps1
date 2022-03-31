$Inst = "dealtrack-us-live.database.windows.net"

$filepath = "./sql.sql"


# $databases grabs list of databases. Adjust the where condition to filter.

$databases = invoke-sqlcmd -ServerInstance $Inst -Database "master" -Query "select name from sys.databases"

$outfile = $filepath + ".log"

Clear-Content -Path $outfile

foreach ($database in $databases)
{
    Add-Content -Path $outfile -Value "================================================================================"
    Add-Content -Path $outfile -Value $database.Name

    #Execute scripts
    Invoke-Sqlcmd -ServerInstance ${Inst} -Database $database.name -InputFIle $filepath -OutputAs DataRows | Format-Table | Out-File -FilePath $outfile -Append
}