$ip = "192.168.1.135"
if(Test-NetConnection -Port 22 -InformationLevel Quiet $ip)#checando se o servidor esta local
{
   $online = $true
}
else
{
    $ip = "179.214.73.101"
    if(Test-NetConnection -Port 22 -InformationLevel Quiet $ip)#cehgcando se o servidor esta online
    {
        $online = $true
    }
    else
    {
        $online = $false
    }
}

if($online)#atualizando arquivos apenas se o servidor SSH estiver online
{
    scp -i ~\`.ssh\id_rsa bitcraze@${ip}:/home/bitcraze/git/magic_juggle/dados/ultimos_parametros.csv ./dados
}