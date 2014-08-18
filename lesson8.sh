#!/bin/bash
#author binhoul

function usage()
{
    cat <<EOF
    Usage: $0 ip:port nip:nport var
    ip:port     : instance_1's ipaddress and port
    nip:nport   : instance_2's ipaddress and port
    var         : the parameter to be compared between the two instance
EOF
exit 1
}

function parse_options()
{
    if [ $# -ge 2 ]
        then
        instance1=$1
        host1=`echo $instance1 |cut -d ':' -f1`
        port1=`echo $instance1 |cut -d ':' -f2`
        instance2=$2
        host2=`echo $instance2 |cut -d ':' -f1`
        port2=`echo $instance2 |cut -d ':' -f2`
        [ $3 ] && var_to_compare=$3
    elif [ $# -lt 2 ]
        then
        usage
    fi
}

function mysql_parameters()
{
    logfile1="/tmp/${instance1}.data"
    logfile2="/tmp/${instance2}.data"
    if [ $var_to_compare ]
        then
        mysql -h $host1 -P $port1 -uroot -pfengmao -e "show variables like '$var_to_compare';" > $logfile1
        mysql -h $host2 -P $port2 -uroot -pfengmao -e "show variables like '$var_to_compare';" > $logfile2
    else
        mysql -h $host1 -P $port1 -uroot -pfengmao -e "show variables;" > $logfile1
        mysql -h $host2 -P $port2 -uroot -pfengmao -e "show variables;" > $logfile2
    fi
}


#function to compare the two variables in the given mysql instances
function mysql_compare()
{
    awk -v instance1="$instance1" -v instance2="$instance2" 'NR==FNR{a[$1]=$2}NR>FNR{b[$1]=$2}
        END{
            printf("\n%-40s|%25s|%25s|\n","mysql parameters",instance1,instance2);
            printf("+---------------------------------------+-------------------------+-------------------------+\n");
            for(i in a)if(a[i]!=b[i])printf("%-40s|%25s|%25s|\n",i,a[i],b[i])}' $logfile1 $logfile2
}

#main
parse_options $@
mysql_parameters
mysql_compare 
