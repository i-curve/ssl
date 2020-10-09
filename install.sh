#!/bin/bash
#author: curve
#名称:ssl证书申请
#System:Ubuntu 18.04+
yellow(){
    echo -e "\033[33m\033[01m$1\033[0m"
}
green(){
    echo -e "\033[32m\033[01m$1\033[0m"
}
red(){
    echo -e "\033[31m\033[01m$1\033[0m"
}
function check(){
if cat /etc/issue | grep -Eqi "debian|ubuntu";then
	systemPackage="apt-get"
elif cat /etc/issue | grep -Eqi "centos|red hat|redhat";then
	systemPackage="yum"
else
	red "系统不匹配";
	exit 1;
fi
}
check
check_name(){
    real_addr=`ping ${name} -c 1 | sed '1{s/[^(]*(//;s/).*//;q}'`
    local_addr=`curl getip.tk`
    if [ $real_addr == $local_addr ];then
	green "=========================================="
	green "       域名解析正常，开始安装"
	green "=========================================="
    else
        red "域名解析不正确"
        exit 1
    fi
}
install(){
    clear
    yellow "进入安装程序..."
    green "请输入绑定到本机的域名"
    read name
    green "请输入网站根目录的位置"
    read  position
    green "请输入证书生成位置，默认执行命令的位置"
    read  out
    if [[ -z "$out" ]];then
        out=./out
    fi

    check_name
$systemPackage -y update
mkdir -p ~/.acme.sh
if curl -o ~/.acme.sh/acme.sh https://raw.githubusercontent.com/acmesh-official/acme.sh/master/acme.sh;then
    if bash ~/.acme.sh/acme.sh  --issue  -d $name  --webroot $position;then
        bash ~/.acme.sh/acme.sh  --installcert  -d  $name   \
        --key-file   $out/private.key \
        --fullchain-file $out/fullchain.cer
        green "证书申请成功，请进入目录 $out 查看"
    else
        red "网站根目录解析不正确"
    fi
else
    red "下载出错"
    exit 1
fi
}

start(){
		clear
		green "==========================="
		green "==========================="
		green " Author:curve"
		green " Target:ssl证书安装"
		green " 系统：centos7+/debian9+/ubuntu16.04+"
		green "==========================="
		echo 
		green " ====================="
		yellow " 1. 一键安装"
		green " ====================="
		yellow " 0. 退出"
		echo
		read -p "请输入数字：" num
		case "$num" in
			1)
				install
				;;
			0)
				exit 0
				;;
			*)
				clear
				red "请输入正确数字"
				sleep 1
				start
				;;
		esac
}
start