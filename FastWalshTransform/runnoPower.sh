#!/bin/bash
echo "starting tests FastWalshTransform ..."
echo "test for 0 degraded elements ... "
mkdir results_FastWalshTransform_NEW/
RDIR="results_FastWalshTransform_NEW"
DIR="results_FastWalshTransform_NEW/OUTPUTS"
mkdir "$DIR"
for I in {1..50} 
do
./../FastWalshTransform/bin/x86_64/Release/FastWalshTransform -e -ndeg 0 -wic 16384 -k 0 > out_0_256_${I}.txt
sudo mv out_0_256_${I}.txt "$DIR"
sleep 5s
done
sudo mv timing_0_256.csv "$RDIR"
echo "test 0 finished!"
sleep 2s

for NUMFAULTS in 1 2 3 4 5 6 7 8 10 12 14 16 20 24 28 32
do
echo "test for $NUMFAULTS degraded elements ... "
	for I in {1..50} 
	do
    		./../FastWalshTransform/bin/x86_64/Release/FastWalshTransform -e -ndeg $NUMFAULTS -wic 16384 -k 1 > out_${NUMFAULTS}_256_${I}.txt
    		sudo mv out_${NUMFAULTS}_256_${I}.txt "$DIR"
		sleep 2s
	done
    	sudo mv timing_${NUMFAULTS}_256.csv "$RDIR"
    	echo "test $NUMFAULTS finished!"
    	sleep 5s
done
