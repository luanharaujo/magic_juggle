#!/bin/zsh
ip="192.168.68.135"

if nc -z ${ip} 22 2>/dev/null; then
   online=true
else
    ip="177.235.240.242"
    if nc -z ${ip} 22 2>/dev/null; then
        online=true
    else
        online=false
    fi
fi

if $online; then #atualizando arquivos apenas se o servidor SSH estiver online
    name=$(ssh -i ~/.ssh/id_rsa bitcraze@${ip} 'ls -t /home/bitcraze/git/magic_juggle/dados | head -1')
    scp -i ~/.ssh/id_rsa bitcraze@${ip}:/home/bitcraze/git/magic_juggle/dados/${name} ./dados
    scp -i ~/.ssh/id_rsa bitcraze@${ip}:/home/bitcraze/git/magic_juggle/dados/nome.txt ./dados
fi
