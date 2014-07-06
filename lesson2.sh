#!/usr/bin/bash

usage()
{
cat <<EOF
Usage: $0 -i <innodb_buffer_pool_size> -p <port> 
EOF
}

parse_opts()
{
while getopts 'i:p:' OPTION;do
    case $OPTION in
        i)
        innodb_buffer_pool_size=$OPTION
        ;;
        p)
        port=$OPTION
        ;;
        ?)
        usage
        ;;
    esac
done
}

#e.g. set 192.168.0.1 ==> 192168000001
fillzero()
{
for i in `echo $1 | awk -F '.' -v OFS=" " '{print $1,$2,$3,$4}'`;do
    printf "%03d" $i
    done
echo -n $port
}

set_serverid()
{
ip=`ifconfig | grep -A1 wlan0 |grep "inet addr" |cut -d: -f2|cut -d" " -f1`
std_ip=`fillzero $ip`

}


############start executing#########################
groupadd dba
useradd -m -g dba -s bash mysql

innodb_buffer_pool_size=0  #defaults
port=0  #defaults
binfile=/depots/mysql/mysql-5.5.37-bin.rpm
dstdir=/app/db/mysql
serverid=set_serverid

#install
rpm -ivh $binfile
cp -a /depots/mysql/my.cnf $dstdir
chown -R mysql.dba $dstdir

#modify the my.cnf file
parse_opts
[`cat $dstdir/my.cnf |grep ^innodb_buffer_pool_size |wc -l` != 0] && \
sed -i '/^innodb_buffer_pool_size/innodb_buffer_pool_size=$innodb_buffer_pool_size/' ${dstdir}/my.cnf || \
echo "innodb_buffer_pool_size=$innodb_buffer_pool_size" >> $dstdir/my.cnf
sed -i '/^port/port=$port/' ${dstdir}/my.cnf
sed -i '/^server_id/server_id=$serverid/' ${dstdir}/my.cnf

#startup
sudo -u mysql -H $dstdir/bin/mysqld_safe --defaults_file=$dstdir/my.cnf &

