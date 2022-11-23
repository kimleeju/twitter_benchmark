Memory="DRAM PMEM TDM_B TDM_NB"
TRACE="cluster043 cluster049 cluster050"
#twitter_DRAM.rslt

    
for trace in $TRACE; do
    OFILE=twitter_"$trace".rslt
    echo "MEM "$Memory > $OFILE
    echo "$trace" | tr "\n" " " >> $OFILE  
    for mem in $Memory;do
        if [[ $mem == "TDM_NB" ]] ; then
            cat twitter_"$mem"_"$trace".rslt | grep "Totals" | awk '{print $2}' >> $OFILE
        else
            cat twitter_"$mem"_"$trace".rslt | grep "Totals" | awk '{print $2}' | tr "\n" " ">> $OFILE
        fi
    done
done
