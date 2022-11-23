if [[ $# -lt 1 ]]; then
	echo "Usage: ./.sh num"
	exit
fi
threads=4
clients=50
MEM="DRAM PMEM TDM-B TDM-NB"
#MEM="DRAM PMEM TDM"
#MEM="TDM_B TDM_NB"
#TRACE="cluster012 cluster031 cluster038 cluster050"
TRACE="cluster049 cluster050"
TRACE="cluster043 cluster033 cluster023"
#MEM="PMEM"
num=$1

for trace in $TRACE; do
    for mem in $MEM; do
        if [[ $mem == "TDM-NB" ]]; then
            port=5000
            DIR=/home/ljkim/temp/test/PA_Redis
        elif [[ $mem == "PMEM" ]]; then
            port=4000
            DIR=/home/ljkim/temp/test/pmem-redis
        elif [[ $mem == "DRAM" ]]; then
            port=3000
            DIR=/home/ljkim/temp/test/org_redis
        elif [[ $mem == "TDM-B" ]]; then
            port=6000
            DIR=/home/ljkim/temp/test/PA_Redis_lock
        else
            port=6378
        fi

        RDIR=/home/ljkim/temp/test/memtier_benchmark_twitter/expr/result

        if [[ ! -d $RDIR ]]; then
            mkdir $RDIR
        fi

        n=1

        while [[ $n -le $num ]]; do
            sudo $DIR/src/redis-server $DIR/redis.conf &
            sleep 3
            echo "$port"
            echo "$threads"
            echo "$clients"
            ./memtier_benchmark -p $port -t $threads -c $clients --trace=$trace > $RDIR/twitter_"$mem"_"$trace".rslt
            
#sleep 10
            #./memtier_benchmark/memtier_benchmark -p 6379 -n 100000 --ratio=100:0 -d 256
# grep "Totals" $RDIR/*.rslt | grep "$mem" | grep "_"$ops"_" | grep "$vsize"
        #| grep "$ops" | grep "$vsize" 
            #grep "Totals" $RDIR/*.rslt | grep $mem | grep "$ops" | grep "$vsize" 

            pid=$(ps -ef | grep "redis" | grep $port | awk '{print $2}')
            kill -9 $pid

#            pkill redis 
            sleep 3
            sudo rm /mnt/pmem1/*
            n=$((n+1))
        done

    done

done
