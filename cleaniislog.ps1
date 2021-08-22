#atualizado 27/07/2021
#funcao: compactar e limpar logs com mais de 7 dias do diretorio padrao   

Import-Module -Name WebAdministration

#captura diretorio padrão de log
$mypath = (Get-ItemProperty -Path 'IIS:\Sites\*' -Name logfile | Select-Object -Unique ).directory 

$data = get-date -UFormat %d-%m-%y
$nDays		= 7
Write-Output $data


#capturando lista de diretorios
Get-ChildItem -name $mypath > c:\lista_dir.txt

#verifica e compacta os logs do IIS
foreach($line in [System.IO.File]::ReadLines("c:\lista_dir.txt"))
{
   cd $mypath\$line
   pwd
   mkdir $data
   #Get-ChildItem *.log | where {($_.Length -ge 100kb)} | Move-Item -destination ".\$data"
   Get-ChildItem *.log |   Where {$_.LastWriteTime -le (Get-Date).AddDays(-$nDays) } | Move-Item -destination ".\$data"
   Add-Type -A 'System.IO.Compression.FileSystem';
   [IO.Compression.ZipFile]::CreateFromDirectory("$mypath\$line\$data","$mypath\$line\$data.zip" )
   Remove-Item -Recurse $data
                
}

