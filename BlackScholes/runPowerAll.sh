#!/bin/bash
echo "starting tests BlackScholes ..."
echo "test for 0 degraded elements ... "
mkdir results_BlackScholes_NEW/
RDIR="results_BlackScholes_NEW"
DIR="results_BlackScholes_NEW/OUTPUTS"
mkdir "$DIR"
for I in {1..20} 
do
ssh atieh@132.239.95.199 'cd wattsup; /home/atieh/anaconda3/bin/python wattsup.py -p /dev/ttyUSB0 -t 1 -i 1 -y > BlackScholes_0_128_${I}.csv' & 
sleep 10s
./../BlackScholes/bin/x86_64/Release/BlackScholes -e -ndeg 0 -wic 128 -k 0 > out_0_128_${I}.txt
sudo mv out_0_128_${I}.txt "$DIR"
sleep 5s
killall ssh
done
sudo mv timing_0_128.csv "$RDIR"
echo "test 0 finished!"
sleep 1s

for NUMFAULTS in {1..8}
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
    		sudo mv out_${NUMFAULTS}_${WICC}_${I}.txt "$DIR"
		sleep 5s
		killall ssh
	done
    	sudo mv timing_${NUMFAULTS}_${WICC}.csv "$RDIR"
    	echo "test $NUMFAULTS finished!"
    	sleep 1s
done
for NUMFAULTS in 10 12 14 16 20
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
    		sudo mv out_${NUMFAULTS}_${WICC}_${I}.txt "$DIR"
		sleep 5s
		killall ssh
	done
    	sudo mv timing_${NUMFAULTS}_${WICC}.csv "$RDIR"
    	echo "test $NUMFAULTS finished!"
    	sleep 1s
done

for NUMFAULTS in 24 28 32
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
	done
    	sudo mv timing_${NUMFAULTS}_${WICC}.csv "$RDIR"
    	echo "test $NUMFAULTS finished!"
    	sleep 1s
done
