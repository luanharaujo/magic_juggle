scp -i ~\`.ssh\id_rsa bitcraze@192.168.1.135:/home/bitcraze/git/magic_juggle/dados/$(ssh  -i ~\`.ssh\id_rsa bitcraze@192.168.1.135 ('ls -t /home/bitcraze/git/magic_juggle/dados | head -1')) './dados'
scp -i ~\`.ssh\id_rsa bitcraze@192.168.1.135:/home/bitcraze/git/magic_juggle/dados/nome.txt ./dados
#Test-NetConnection -Port 22 -InformationLevel Quiet 192.168.1.135