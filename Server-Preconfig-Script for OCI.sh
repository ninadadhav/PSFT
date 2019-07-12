#!/bin/bash
#created by kartikey.rajput@oracle.com
#creted Group
echo "<--------------------creted Group----------------------->"
sudo su -
groupadd oinstall
groupadd psoft

#create user IDs
echo "<--------------------create user IDs----------------------->"
sudo useradd -c "PeopleSoft DEV user" -g psoft -G oinstall -d /home/psoft -s /bin/bash psoft
echo -e "Orapsft@123" | passwd psoft
sudo useradd -c "ORACLE user" -g oinstall -d /home/oracle -s /bin/bash oracle
echo -e "Orapsft@123" | passwd oracle

#create baseline directory structure
echo "<--------------------create baseline directory structure----------------------->"
cd /
ls 

#configure server
echo "<--------------------configure server----------------------->"
sudo su -
#given versions are old, below commands will pich the latest versions 
yum install binutils.x86_64 -y
yum install compat-libcap1.x86_64 -y
yum install compat-libstdc++.i686 -y
yum install compat-libstdc++.x86_64 -y
yum install gcc.x86_64 -y
yum install gcc-c++.x86_64 -y 
yum install glibc.i686 -y
yum install glibc.x86_64 -y 
yum install glibc-devel.i686 -y 
yum install glibc-devel.x86_64 -y 
yum install ksh -y
yum install libaio.i686 -y 
yum install libaio.x86_64 -y 
yum install libaio-devel.i686 -y 
yum install libaio-devel.x86_64 -y 
yum install libgcc.i686 -y
yum install libgcc.x86_64 -y 
yum install libstdc++.i686 -y
yum install libstdc++.x86_64 -y 
yum install libstdc++.i686 -y 
yum install libstdc++-devel.x86_64 -y 
yum install libXi.i686 -y
yum install libXi.x86_64 -y 
yum install libXtst.i686 -y
yum install libXtst.x86_64 -y 
yum install make.x86_64 -y
yum install sysstat.x86_64 -y
yum -y install xterm* xorg* xclock xauth -y

yum -y install oracle-rdbms-server-11gR2-preinstall
yum  -y install oracle-rdbms-server-12cR1-preinstall

#<---------------------------------------doubt----------------------->
#only when nfs scp will be done
cd /mnt/nfs/jdk8
yum -y install jdk-8u201-linux-x64.rpm

#enabling X11 by appending data into sshd_config file
echo "<--------------------Enable X11 forwarding for GUI interfaces----------------------->"
sudo su -
sudo echo 'X11Forwarding yes' >>  /etc/ssh/sshd_config
sudo echo 'X11DisplayOffset 10' >>  /etc/ssh/sshd_config
sudo echo 'X11UseLocalhost no' >>  /etc/ssh/sshd_config

#Update limits.conf with the root user
echo "<--------------------limit.conf file modification----------------------->"
sudo su -
sudo echo 'psoft     hard   nofile   131072' >> /etc/security/limits.conf
sudo echo 'psoft     soft   nofile   131072' >> /etc/security/limits.conf
sudo echo 'psoft     hard   nproc   131072' >> /etc/security/limits.conf
sudo echo 'psoft     soft   nproc   131072' >> /etc/security/limits.conf
sudo echo 'psoft     hard   core   unlimited' >> /etc/security/limits.conf
sudo echo 'psoft     soft   core   unlimited' >> /etc/security/limits.conf
sudo echo 'psoft     hard   memlock   500000' >> /etc/security/limits.conf
sudo echo 'psoft     soft   memlock   500000' >> /etc/security/limits.conf
sudo echo 'oracle   hard   nofile   131072' >> /etc/security/limits.conf
sudo echo 'oracle   soft   nofile   131072' >> /etc/security/limits.conf
sudo echo 'oracle   hard   nproc   131072' >> /etc/security/limits.conf
sudo echo 'oracle   soft   nproc   131072' >> /etc/security/limits.conf
sudo echo 'oracle   hard   core   unlimited' >> /etc/security/limits.conf
sudo echo 'oracle   soft   core   unlimited' >> /etc/security/limits.conf
sudo echo 'oracle   hard   memlock   500000' >> /etc/security/limits.conf
sudo echo 'oracle   soft   memlock   500000' >> /etc/security/limits.conf

#Update sysctl.conf with the root user
echo "<--------------------sysctl.conf file modification----------------------->"
sudo su -
sudo echo 'vm.max_map_count=262144' >> /etc/sysctl.conf
sudo echo 'kernel.msgmnb = 65538' >> /etc/sysctl.conf
sudo echo 'kernel.msgmni = 1024' >> /etc/sysctl.conf
sudo echo 'kernel.msgmax = 65536' >> /etc/sysctl.conf
sudo echo 'kernel.shmmax = 68719476736' >> /etc/sysctl.conf
sudo echo 'kernel.shmall = 4294967296' >> /etc/sysctl.conf
sudo echo 'kernel.core_uses_pid = 1' >> /etc/sysctl.conf
sudo echo 'net.ipv4.tcp_keepalive_time = 90' >> /etc/sysctl.conf
sudo echo 'net.ipv4.tcp_timestamps = 1' >> /etc/sysctl.conf
sudo echo 'net.ipv4.tcp_window_scaling = 1' >> /etc/sysctl.conf
sudo echo 'net.ipv4.ip_local_port_range = 10000 65500' >> /etc/sysctl.conf

#setting environment variable from psoft on all servers
echo "<--------------------Setting up environment variable----------------------->"
sudo su – psoft
cd /home/psoft
echo "<--------------------setting environment variable for Psoft userid----------------------->"
echo '# Environment Variables for PeopleSoft
PS_DB=ORA;export PS_DB
COBDIR=/opt/microfocus/cobol;export COBDIR
ORACLE_HOME=/u01/app/oracle/product/12.2.0.1/client;export ORACLE_HOME
#tuxdir used to be set auto prior to 8.50, now it must be set manually
TUXDIR=/u01/app/psoft/tux12/tuxedo12.2.2.0.0;export TUXDIR
PATH=$PATH:$TUXDIR/bin:$COBDIR/bin:$ORACLE_HOME/bin;export PATH
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$TUXDIR/lib:$COBDIR/lib:$ORACLE_HOME/lib; export LD_LIBRARY_PATH

. /u01/app/psoft/tux12/tuxedo12.2.2.0.0/tux.env

PS_HOME=/u01/app/psoft/tools85702; export PS_HOME
PS_APP_HOME=/u01/app/psoft/fs92dmo; export PS_APP_HOME
PS_CFG_HOME=/u01/app/psoft/psconfig; export PS_CFG_HOME


<-----------------------------------------------DOUBT-------------------------------------------->
cd /u01/app/psoft/tools85702
. ./psconfig.sh

LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PS_HOME/bin; export LD_LIBRARY_PATH
' >> /home/psoft/.bash_profile


#setting environment variable from oracle on all servers

sudo su – oracle
cd /home/oracle
echo "<--------------------setting environment variable for Oracle userid----------------------->"
echo '# Environment Variables for PeopleSoft
ORACLE_HOME=/u01/app/oracle/product/12.2.0.1/client;export ORACLE_HOME
PATH=$PATH:$ORACLE_HOME/bin;export PATH
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ORACLE_HOME/lib; export LD_LIBRARY_PATH
' >> /home/oracle/.bash_profile

#setting environment variable from root on all servers
sudo su – 
cd /root
echo "<--------------------setting environment variable for Root userid----------------------->"
echo '# Environment Variables for PeopleSoft
COBDIR=/opt/microfocus/cobol;export COBDIR
PATH=$PATH:$COBDIR/bin;export PATH
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$COBDIR/lib; export LD_LIBRARY_PATH
' >> /root/.bash_profile

#granting CD access
echo "<--------------------Granting CD access----------------------->"
sudo su – 
cd /mnt
chmod -R 777 nfs

#Steps below will create the directory structure for the oracle client software installation
echo "<--------------------Setup Installation directories for Oracle----------------------->"
sudo su – 
mkdir -p /u01/app
chown -R oracle:oinstall /u01/app
cd /u01
ls -la

#Steps below will create the directory structure for peoplesoft software installation
echo "<--------------------Setup Installation directories for Psoft----------------------->"
mkdir -p /u01/app/psoft
chown -R psoft:psoft /u01/app/psoft
cd /u01/app
ls -la

#Create psft_customizations.yaml file
echo "<--------------------Creation of psft_customizations.yaml----------------------->"
sudo su – 
mkdir -p /u01/app/psoft/dpk/puppet/production/data
FILE="/u01/app/psoft/dpk/puppet/production/data/psft_customizations.yaml"
/bin/cat <<EOM >$FILE
peoplesoft_base:  /u01/app/psoft
pt_location:      "%{hiera('peoplesoft_base')}"
ps_home_location: "%{hiera('peoplesoft_base')}/tools85702"

ps_home:
  db_type:    "%{hiera('db_platform')}"
  unicode_db: "%{hiera('unicode_db')}"
  location: "%{hiera('ps_home_location')}"

ps_apphome_location: "%{hiera('pt_location')}/fs92dmo"
ps_app_home:
  db_type: "%{hiera('db_platform')}"
  include_ml_files: true
  location: "%{hiera('ps_apphome_location')}"
EOM

chown -R psoft:psoft /u01/app/psoft