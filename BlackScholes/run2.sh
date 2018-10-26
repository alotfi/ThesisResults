#!/bin/bash
echo "starting tests BlackScholes ..."
echo "test for 0 degraded elements ... "
mkdir results_BlackScholes_NEW/
RDIR="results_BlackScholes_NEW"
DIR="results_BlackScholes_NEW/OUTPUTS"
mkdir "$DIR"
for NUMFAULTS in 16 
do
let WICC=128
echo "test for $NUMFAULTS degraded elements ... "
	for I in {1..20} 
	do
         	a='cd wattsup; /home/atieh/anaconda3/bin/python wattsup.py -p /dev/ttyUSB0 -t 1 -i 1 -y > BlackScholes_'
                f=${NUMFAULTS}
                u='_'
                p=$I
                d='.csv'
                c="$a$f$u$p$d"
                ssh atieh@132.239.95.199 $c &
                sleep 10s
	    		./../BlackScholes/bin/x86_64/Release/BlackScholes -e -ndeg $NUMFAULTS -wic $WICC -k 1 > out_${NUMFAULTS}_${WICC}_${I}.txt
		current_date_time="`date +%Y%m%d%H%M%S`";
		echo $current_date_time
    		sudo mv out_${NUMFAULTS}_${WICC}_${I}.txt "$DIR"
		sleep 20s
		killall ssh
		sleep 5s
	done
    	sudo mv timing_${NUMFAULTS}_${WICC}.csv "$RDIR"
    	echo "test $NUMFAULTS finished!"
done

for NUMFAULTS in 24 32
do
let WICC=64
echo "test for $NUMFAULTS degraded elements ... "
	for I in {1..20} 
	do
         	a='cd wattsup; /home/atieh/anaconda3/bin/python wattsup.py -p /dev/ttyUSB0 -t 1 -i 1 -y > BlackScholes_'
                f=${NUMFAULTS}
                u='_'
                p=$I
                d='.csv'
                c="$a$f$u$p$d"
                ssh atieh@132.239.95.199 $c &
                sleep 10s
    		./../BlackScholes/bin/x86_64/Release/BlackScholes -e -ndeg $NUMFAULTS -wic $WICC -k 1 > out_${NUMFAULTS}_${WICC}_${I}.txt
    		sudo mv out_${NUMFAULTS}_${WICC}_${I}.txt "$DIR"
		sleep 5s
		killall ssh
		sleep 5s
	done
    	sudo mv timing_${NUMFAULTS}_${WICC}.csv "$RDIR"
    	echo "test $NUMFAULTS finished!"
done
