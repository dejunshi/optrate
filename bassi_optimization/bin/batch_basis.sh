#!/bin/bash

#Batch operation script
#Basic environment tuning for Linux
#author by djshi2
#ip.list file need have ip user and password hostname

! which expect > /dev/null 2>&1 && echo "Please install expect first!" && exit 1

dirpath=$(cd `dirname $0`;pwd)
dir=`dirname $dirpath`

ip_path="$dir/conf/ip.list"
cmd_path="$dir/etc/basic_cmd"
custom_path="$dir/conf/custom.cfg"
ntpdate_ip=`cat $custom_path | grep -oP "(?<=ntpdate_ip=)[^ ]+"`

cat $ip_path | while read ip user password hostname
do
  /usr/bin/expect << EOF
  set timeout 5
  spawn scp $cmd_path $user@$ip:/tmp/
  expect {
          "yes/no" {send "yes\r";exp_continue}
          "assword" {send "$password\r"}
          timeout {puts "error: timeout on $ip";exit 1}
          }
  expect {
          "assword" {puts "error: password is wrong on $ip";exit 1}
          "%" {puts "copy is running on $ip"}
          }
  set timeout 3000
  expect {
          "100%" {puts "copy file successfully on $ip"}
          timeout {puts "error: copy file failed on $ip";exit 1}
          }
  spawn ssh $user@$ip "bash /tmp/basic_cmd $ip $hostname $ntpdate_ip;rm -rf /tmp/basic_cmd"
  expect {
          "yes/no" {send "yes\r";exp_continue}
          "assword" {send "$password\r"}
          }
  expect eof
EOF
done
