#!/bin/bash

echo 
echo What is the name of your session?
read session_name
echo 
export bastion=<bastion-id>
export ssh_public_key=<path-to-public-key>
export ssh_private_key=<path-to-private-key>
export target_private_ip=<local-target-ip>
export session_ttl=10800 # Maximum amount of time of the session
export local_port=<local-port> # Local port to connect. It should be any highPorts from 1024 to 65535
export target_port=3389
export user_name=<user-name> # User to log in the target Instance

export session_id=$(oci bastion session create-port-forwarding --display-name $session_name --bastion-id $bastion --ssh-public-key-file $ssh_public_key --target-private-ip $target_private_ip --target-port $target_port --session-ttl $session_ttl --query 'data.id' --raw-output)

sleep 15s

export command_session=$(oci bastion session get --session-id $session_id --query 'data."ssh-metadata".command' --raw-output)

echo $command_session > $session_name

sed -i -e 's+<privateKey>+'"$ssh_private_key"'+g' $session_name

sed -i -e 's/<localPort>/'"$local_port"'/g' $session_name

echo -----------------------------------------------------
echo 
echo SESSION COMMAND
echo 
cat $session_name
echo 
echo ------------------------------------------------------
echo 
echo  SESSION CONNECTION
echo 
echo  Acessar pelo Conexao de Area de Trabalho Remoto com o endereço 127.0.0.1:$local_port
echo 
