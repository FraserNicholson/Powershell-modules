$conn = New-Object System.Data.SqlClient.SQLConnection 
$conn.ConnectionString = "Server=dealtrack-us-live.database.windows.net;Initial Catalog=master;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30"

$conn.AccessToken = $(az account get-access-token --resource https://database.windows.net --query accessToken -o tsv)

$conn.Open()

$sqlcmd = $conn.CreateCommand()
<# or #>
$sqlcmd = New-Object System.Data.SqlClient.SqlCommand
$sqlcmd.Connection = $conn
$query = “SELECT 
[DimensionCollectionItemId], 
[DimensionCollectionAttributeId], 
[DimensionCollectionAttributeValueId], 
COUNT(Id) 
FROM DimensionCollectionItemValues 
GROUP BY DimensionCollectionItemId, DimensionCollectionAttributeId, DimensionCollectionAttributeValueId 
HAVING COUNT(Id) > 1”
$sqlcmd.CommandText = $query

$adp = New-Object System.Data.SqlClient.SqlDataAdapter $sqlcmd

$data = New-Object System.Data.DataSet
$adp.Fill($data) | Out-Null

$data.Tables