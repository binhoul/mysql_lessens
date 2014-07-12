#/bin/bash

usage()
{
cat <<EOF
    usage: $0 <command>   --options=<> ...
    command must be one of the following:
    vmstat          :Report virtual memory statistics
    iostat          :Report (CPU) statistics and I/O statistics
    mpstat          :provides statistics per CPU
    ===========================================================
    options:
    --interval=<>     :give the interval in seconds
    --counts=<>       :collect the data for the given <count> times
    --output=<>       :give the output file path
EOF
}

parse_options()
{
[ $# -le 0 ] && echo "no options to parse, use defaults 
the default interval is $def_interval sec, the default counts is $def_counts."
while [ $# -gt 0 ]
    do
    case $1 in
        --interval=*)
        def_interval=`echo $1 |sed -n "s/^--interval=//p"`
        ;;
        --counts=*)
        def_counts=`echo $1 |sed -n "s/^--counts=//p"`
        ;;
        --output=*)
        def_output=`echo $1 |sed -n "s/^--output=//p"`
        ;;
        --help|*)
        usage
        exit 1
        ;;
    esac
    shift
done

}

parse_command()
{
[ $# -le 0 ] && usage && exit
[ $1 == vmstat -o $1 == iostat -o $1 == mpstat ] || ( usage && exit 1 )
def_command=$1
shift
parse_options $@
}




##############################################################
#default settings
def_command=
def_interval=3
def_counts=5

parse_command $@
if [ ${#def_output} == 0 ]
then
def_output="./`date +%Y-%m-%d-%H:%M`/${def_command}.log"
def_output="${def_output}/`date +%Y-%m-%d-%H:%M`/${def_command}.log"

[ -d ${def_output%/*} ] || mkdir -p ${def_output%/*}
echo "the output is writen into $def_output ..."
$def_command $def_interval $def_counts >> $def_output



