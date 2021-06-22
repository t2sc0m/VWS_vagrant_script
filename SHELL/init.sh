#!/bin/bash
set -euo pipefail

HOST=$(hostname)
WORK="/vagrant/WORK/"
CONF="/vagrant/CONF/"
SSH="${CONF}ssh/"
NGINX="/etc/nginx/conf.d/default.conf"
MDB="/etc/my.cnf.d/server.cnf"
NFS="/etc/exports"

echo "hosts에 각 서버를 등록합니다."
{
	echo "172.18.1.91 cent1" 
	echo "172.18.1.92 cent2" 
	echo "172.18.1.93 cent3" 
}>> /etc/hosts

echo "fstab에 nfs정보를 등록합니다."
echo "172.18.1.93:/nfs     /mnt    nfs     noauto   1 1" >> /etc/fstab

echo "root유저의 환경설정을 합니다."
{
	echo "HISTTIMEFORMAT='## %Y-%m-%d %T ## '"
        echo "alias ls='ls --color=tty'"
        echo "alias vi='vim'"
} >> /root/.bashrc

echo "ssh 설정을 등록합니다."
sudo cp -rfp ${SSH} /root/.ssh
sudo chown root:root /root/.ssh -R
sudo chmod 600 /root/.ssh/id_rsa
sudo chmod 644 /root/.ssh/authorized_keys

echo "서버 접속 메세지를 설정합니다."
{
	echo
	echo "---------------------------------------------------------------------"
	echo "이 서버는 학습용 가상회사인 Virtual Web Service Company의 서버입니다."
	echo
	echo "실습의 용이성을 위해 selinux와 iptables를 off 했습니다."
	echo
	echo "접속 후 sudo su - 커맨드를 실행하여 root 유저로 실습을 진행해 주세요."
	echo "---------------------------------------------------------------------"
	echo
} >> /etc/motd

echo "selinux를 무효화합니다."
sed -i s/^SELINUX=.*$/SELINUX=disabled/ /etc/selinux/config

case ${HOST} in
	cent1)
		echo "NGINX 설정을 복사합니다."
                [ -e ${CONF}default.conf ] && sudo cp -fvp ${CONF}default.conf ${NGINX} 
		echo "임시 웹소스를 복사합니다."
		[ -e ${WORK}web_src.tgz ] && sudo tar xzf ${WORK}web_src.tgz -C /usr/share/nginx/html/ 
                echo "NGINX를 restart합니다."
                sudo systemctl restart nginx
                echo "NGINX를 시작 프로그램에 등록합니다."
                sudo systemctl enable nginx
                echo "NGINX 실행상태 확인"
                sudo systemctl status nginx
		;;
	cent2)
                echo "MariaDB를 stop합니다."
                sudo systemctl stop mariadb
                echo "MariaDB를 시작합니다."
                sudo systemctl start mariadb
                echo "MariaDB를 시작 프로그램에 등록합니다."
                sudo systemctl enable mariadb
                echo "MariaDB 실행상태 확인"
                sudo systemctl status mariadb 
                echo "DB 임시 데이터를 준비합니다."
		sudo git clone https://github.com/t2sc0m/test_db.git ${WORK}test_db
		cd ${WORK}test_db
		sudo mysql -uroot < employees.sql 
		;;
	cent3)
		echo "NFS 설정을 복사합니다."
                [ -e ${CONF}exports ] && sudo cp -fvp ${CONF}exports ${NFS} 
                echo "NFS를 restart합니다."
                sudo systemctl restart nfs-server
                echo "NFS를 시작 프로그램에 등록합니다."
                sudo systemctl enable nfs-server
                echo "NFS 실행상태 확인"
                sudo systemctl status nfs-server 
		;;
	*)
		echo "처리항목에 없는 서버입니다. 호스트를 확인해주세요."
esac

echo "서버를 재시작합니다."
init 6
