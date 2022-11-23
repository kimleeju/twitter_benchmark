
Memory="DRAM PMEM TDM_L TDM"
TRACE="cluster023 cluster043 cluster033 cluster032 cluster050"
#twitter_DRAM.rslt

    
OFILE=twitter.rslt
echo "MEM "$Memory > $OFILE
for trace in $TRACE; do

    echo "$trace" | tr "\n" " " >> $OFILE  
    for mem in $Memory;do
        if [[ $mem == "TDM" ]] ; then
            cat twitter_"$mem"_"$trace".rslt | grep "Totals" | awk '{print $2}' >> $OFILE
        else
            cat twitter_"$mem"_"$trace".rslt | grep "Totals" | awk '{print $2}' | tr "\n" " ">> $OFILE
        fi
    done
done
