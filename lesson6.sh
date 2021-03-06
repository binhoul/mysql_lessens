#!/bin/bash

#author: silence.li
#

usage()
{
cat <<EOF
Usage: $0 -o
-o[options]:
-f <>    :error logfile
-l <>    :log level,one of Note,Warning,Error
-i <>    :reflesh intervals
EOF
}

parse_opts()
{
    [ $# -le 0 ] && usage && exit 1
    while getopts 'f:l:i:' opts;do
        case $opts in
            f) errorlog=$OPTARG
                ;;
            l) loglevel=$OPTARG
                ;;
            i) interval=$OPTARG
                ;;
            *) usage
                ;;
        esac
    done
}



###############################
errorlog="/var/log/mysql/error.log"
loglevel="Note"
interval=10
parse_opts $@
while :
do
cat $errorlog |awk -v loglev=$loglevel 'BEGIN{
    print "+-------|------|-------------------------------------------------+\n";
    printf("%8s|counts|detailed info about                              |\n",loglev);
    print "+-------|------|-------------------------------------------------+\n";
    }
    $3~loglev{num="";for(n=4;n<=NF;n++){num=num" "$n};{a[num]++}}
    END{
        for(i in a){printf("%8s|%6d|%50s|\n",loglev,a[i],i)}
    }'
sleep $interval
done
