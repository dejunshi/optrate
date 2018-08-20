#!/bin/bash

dirpath=$(cd `dirname $0`;pwd)

#linux基础环境调优
$dirpath/bassi_optimization/bin/batch_basis.sh

#nginx安装配置
$dirpath/nginx_install/bin/batch_nginx.sh

#keepalived安装配置
$dirpath/keepalived_install/bin/batch_keepalived.sh
