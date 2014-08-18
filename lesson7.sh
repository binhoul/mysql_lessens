#!/bin/bash
#!/bin/bash


#######################################
#backup rules for one day
# 000 --> no backup
# 100 --> physical full
# 010 --> physical increment
# 001 --> logical 
#as above but should not be used in reality
# 110 --> physical full + physical increment
# 101 --> physical full + logical
# 011 --> physical increment + logical
# 111 --> physical full + increment + logical
#
#give a array of seven items 
#monday --> 100   #physical full
#thusday --> 010  #physical incr
#....             #as above
#sunday --> 001   #logical
#######################################
backup_rules=('x' '100' '010' '010' '010' '010' '010' '001') #'x' no meaning ,just 

host='127.0.0.1'
user='backup'
password='backup'
port='3306'
rhost='remote-ip-address'
ruser='dbback'
backtype=''
physical_todir='/datacenter/db/mysql/physical'
logical_todir='/datacenter/db/mysql/logical'
#record the backup files on local machine
backup_records='/data/mysql/backup_records.log'


usage()
{
    cat <<EOF
        usage: $0 --options
        options:
        --help      show help info
        --backtype      one of full, incremental, logical
        --host      database host
        --user      database user
        --password  database password
        --port      database port
        --rhost     data center host
        --ruser     data center ssh user ;non-root
        EOF
        exit 1
}

parse_options()
{
    [ $# -le 0 ] && echo "no parameters given, exit" && usage
        while [ $# -gt 0 ]
            do
            case $1 in
                --backtype=*)
                    backtype=`echo $1 |sed -n "s/^--backtype=//p"`
                    ;;
                --host=*)
                    host=`echo $1 |sed -n "s/^--host=//p"`
                    ;;
                --user=*)
                    user=`echo $1 |sed -n "s/^--user=//p"`
                    ;;
                --password=*)
                    password=`echo $1 |sed -n "s/^--password=//p"`
                    ;;
                --port=*)
                    port=`echo $1 |sed -n "s/^--port=//p"`
                    ;;
                --rhost=*)
                    rhost=`echo $1 |sed -n "s/^--rhost=//p"`
                    ;;
                --ruser=*)
                    ruser=`echo $1 |sed -n "s/^--ruser=//p"`
                    if [ $ruser == 'root' ];then echo "use non-root user" && exit 1;fi
                    ;;
                --help|*)
                    usage
                    ;;
           esac
           shift
       done

}

function physical_full_backup()
{
       #to be continued
}

function physical_incr_backup()
{
      #to be continued 
}

function logical_backup()
{
      backfile=$logical_todir/`hostname`/`date +%Y-%m-%d-%H-%M.sql`
            ssh $ruser@$rhost "if [ ! -d `dirname $backfile` ];then mkdir -p `dirname $backfile`;fi"
              mysqldump -h $host -u $user -p $password -A |pv -q -L 10 | ssh $ruser@$rhost "cat - > $backfile"
}


function main()
{
    parse_options $@
    while :
        do
        week=`date +%w`
        case ${backup_rules[$week]} in
            '000')
                 continue
                 ;;
            '100')
                 physical_full_backup
                 ;;
            '010')
                 pyhysical_incr_backup
                 ;;
            '001')
                 logical_backup
                 ;;
        esac
        sleep 86400
    done

}



#######################
#main....
main $@


