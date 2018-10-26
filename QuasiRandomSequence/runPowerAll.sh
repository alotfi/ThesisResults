#!/bin/bash
echo "starting tests QuasiRandomSequence ..."
echo "test for 0 degraded elements ... "
mkdir results_QuasiRandomSequence_NEW/
RDIR="results_QuasiRandomSequence_NEW"
DIR="results_QuasiRandomSequence_NEW/OUTPUTS"
mkdir "$DIR"
for I in {1..20} 
do
ssh atieh@132.239.95.199 'cd wattsup; /home/atieh/anaconda3/bin/python wattsup.py -p /dev/ttyUSB0 -t 1 -i 1 -y > Quasi_0_256_${I}.csv' & 
sleep 10s
./../QuasiRandomSequence/bin/x86_64/Release/QuasiRandomSequence -e -ndeg 0 -wic 128 -k 0 > out_0_128_${I}.txt
sudo mv out_0_128_${I}.txt "$DIR"
sleep 5s
killall ssh
done
sudo mv timing_0_128.csv "$RDIR"
echo "test 0 finished!"
sleep 1s

for NUMFAULTS in 1 2 3 4 5 6 7 8 10 12 14 16 20 24 28 32
do
let WICC=128
echo "test for $NUMFAULTS degraded elements ... "
	for I in {1..20} 
	do
                a='cd wattsup; /home/atieh/anaconda3/bin/python wattsup.py -p /dev/ttyUSB0 -t 1 -i 1 -y > Quasi_'
                f=${NUMFAULTS}
                u='_'
                p=$I
                d='.csv'
                c="$a$f$u$p$d"
                ssh atieh@132.239.95.199 $c &
                sleep 10s

    		./../QuasiRandomSequence/bin/x86_64/Release/QuasiRandomSequence -e -ndeg $NUMFAULTS -wic $WICC -k 1 > out_${NUMFAULTS}_${WICC}_${I}.txt
    		sudo mv out_${NUMFAULTS}_${WICC}_${I}.txt "$DIR"
		sleep 5s
		killall ssh
	done
    	sudo mv timing_${NUMFAULTS}_${WICC}.csv "$RDIR"
    	echo "test $NUMFAULTS finished!"
    	sleep 1s
done
