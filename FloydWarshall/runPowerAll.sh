#!/bin/bash
echo "starting tests FloydWarshall ..."
echo "test for 0 degraded elements ... "
mkdir results_FloydWarshall_NEW/
RDIR="results_FloydWarshall_NEW"
DIR="results_FloydWarshall_NEW/OUTPUTS"
mkdir "$DIR"
for I in {1..20} 
#for I in {1..10} 
do
ssh atieh@132.239.95.199 'cd wattsup; /home/atieh/anaconda3/bin/python wattsup.py -p /dev/ttyUSB0 -t 1 -i 1 -y > Floyd_0_256_${I}.csv' & 
sleep 10s
./../FloydWarshall/bin/x86_64/Release/FloydWarshall -e -ndeg 0 -wic 512 -k 0 > out_0_256_${I}.txt
sudo mv out_0_256_${I}.txt "$DIR"
sleep 5s
killall ssh
done
sudo mv timing_0_256.csv "$RDIR"
echo "test 0 finished!"
sleep 2s

for NUMFAULTS in 1 2 3 4 5 6 7 8 10 12 14 16 20 24 28 32
#for NUMFAULTS in {31..32}
do
echo "test for $NUMFAULTS degraded elements ... "
	for I in {1..20} 
	#for I in {1..10} 
	do
                a='cd wattsup; /home/atieh/anaconda3/bin/python wattsup.py -p /dev/ttyUSB0 -t 1 -i 1 -y > Floyd_'
                f=${NUMFAULTS}
                u='_'
                p=$I
                d='.csv'
                c="$a$f$u$p$d"
                ssh atieh@132.239.95.199 $c &
                sleep 10s
    		./../FloydWarshall/bin/x86_64/Release/FloydWarshall -e -ndeg $NUMFAULTS -wic 512 -k 1 > out_${NUMFAULTS}_256_${I}.txt
    		sudo mv out_${NUMFAULTS}_256_${I}.txt "$DIR"
		sleep 5s
		killall ssh
	done
    	sudo mv timing_${NUMFAULTS}_256.csv "$RDIR"
    	echo "test $NUMFAULTS finished!"
    	sleep 5s
done
