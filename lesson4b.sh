#/bin/bash

##########
HOST=10.192.0.7
USER=root
PASS='fengmao'
INTERVAL=3
EXEC=/usr/bin/mysql
COUNTS=0

cal_key_pcthit()
{
    key_reads=`$EXEC -h$HOST -u$USER -p$PASS -e "show global status like \"key_reads\"\G" \
               |grep Value |awk '{print $2}'`
    key_read_requests=`$EXEC -h$HOST -u$USER -p$PASS -e "show global status like \"key_read_requests\"\G" \
                       |grep Value |awk '{print $2}'`
    pcthit=`echo "scale=4;(1 - $key_reads/$key_read_requests)*100" |bc`
    echo -e "\033[3;1HQcache_Hits: $pcthit%\r\c"

}
cal_innodb_pcthit()
{
    innodb_buffer_pool_read_requests=`$EXEC -h$HOST -u$USER -p$PASS -e "show global status like \"Innodb_buffer_pool_read_requests\"\G" \
                              |grep Value |awk '{print $2}'`
    innodb_buffer_pool_reads=`$EXEC -h$HOST -u$USER -p$PASS -e "show global status like \"Innodb_buffer_pool_reads\"\G" \
                              |grep Value |awk '{print $2}'`
    innodb_pcthit=`echo "scale=4;(1 - $innodb_buffer_pool_reads/$innodb_buffer_pool_read_requests)*100" |bc`
    echo -e "\033[5;1HInnodb Hits: $innodb_pcthit%\r\c"

}
clear
while true
do
SECS=`expr $COUNTS '*' $INTERVAL`
echo -e "\033[2;1HRunning for $SECS seconds:"
cal_innodb_pcthit
COUNTS=`expr $COUNTS + 1`
sleep $INTERVAL
done
