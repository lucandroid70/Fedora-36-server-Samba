#!/bin/sh

sudo -s

####### remove firewall-cmd 

sudo systemctl stop firewalld

sudo systemctl disable firewalld

sudo dnf autoremove firewall* -y

###### end remove 

sudo dnf update -y
sudo setenforce 0
sudo dnf install bash-completion -y
sudo dnf install perl perl-Net-SSLeay openssl perl-Encode-Detect wget -y
sudo dnf install samba samba-common samba-client -y


sudo mv /etc/samba/smb.conf /etc/samba/_smb.conf


cat >> /etc/samba/smb.conf << EOF
[global]
workgroup = WORKGROUP
server string = Samba Server %v
netbios name = smbshared 
security = user
map to guest = bad user
dns proxy = no
# Private shared directory
[Secure]
path = /opt/secure
valid users = @smbshared_gr
guest ok = no
writable = yes
browsable = yes
# Anonymous shared 


[Anonymous]
workgroup = WORKGROUP
server string = Samba Server %v
netbios name = smbshared 
path = /srv/01/shared
browsable =yes
writable = yes
guest ok = yes
read only = no
valid users = @nobody
EOF

sudo useradd luke
sudo groupadd smbshared_gr
sudo usermod -a -G smbshared_gr luke

sudo mkdir -p /srv/01/shared
sudo chmod -R 0777 /srv/01/shared
sudo chown -R nobody:nobody /srv/01/shared
sudo chcon -t samba_share_t -R /srv/01/shared
sudo setfacl -R -m "u:nobody:rwx" /srv/01/shared

sudo mkdir /opt/secure
sudo chmod -R 0777 /opt/secure
sudo chown -R luke:smbshared_gr /opt/secure
sudo chcon -t samba_share_t /opt/secure
sudo setfacl -R -m "g:smbshared_gr:rwx" /opt/secure

#firewall-cmd --permanent --zone=public --add-service=samba
#sudo firewall-cmd --permanent --zone=FedoraServer --add-service=samba 
#sudo firewall-cmd --reload

sudo systemctl enable smb.service
sudo systemctl enable nmb.service
sudo systemctl restart smb.service 
sudo systemctl restart nmb.service

# insert password for user 'luke'
sudo smbpasswd -a luke






sudo wget https://github.com/rpmsphere/noarch/raw/master/r/rpmsphere-release-36-1.noarch.rpm
sudo rpm -Uvh rpmsphere-release*rpm
sudo rpm -Uvh rpmsphere-release*rpm
sudo dnf install gufw -y

sudo systemctl enable ufw.service 
sudo systemctl start ufw.service 



sudo ufw allow from 192.168.1.1/24
sudo ufw reload
sudo ufw status numbered




#sudo ufw status numbered
#sudo ufw delete 2




# smb://192.168.1.48/anonymous/
# smb://testnet23.local/anonymous/






# By Luca Lucandroid70
#Based for Fedora-Xfce-Live-x86_64-36-1.5.iso
