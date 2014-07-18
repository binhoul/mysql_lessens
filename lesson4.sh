#/bin/bash

##########
HOST=10.192.0.7
USER=root
PASS='fengmao'
INTERVAL=3
EXEC=/usr/bin/mysql
COUNTS=0

cal_pcthit()
{
    key_reads=`$EXEC -h$HOST -u$USER -p$PASS -e "show global status like \"key_reads\"\G" \
               |grep Value |awk '{print $2}'`
    key_read_requests=`$EXEC -h$HOST -u$USER -p$PASS -e "show global status like \"key_read_requests\"\G" \
                       |grep Value |awk '{print $2}'`
    pcthit=`echo "scale=4;$key_reads/$key_read_requests*100" |bc`
    echo -e "\033[3;9H$pcthit"

}

#while true
#do
SECS=`expr $COUNTS * $INTERVAL`
echo $SECS
clear
echo -e "\033[2;1HRunning for $SECS seconds"
cal_pcthit
COUNTS=`expr $COUNTS + 1`
sleep $INTERVAL
#done
