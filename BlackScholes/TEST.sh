#!/bin/bash
echo "starting tests BlackScholes ..."
echo "test for 0 degraded elements ... "
mkdir results_BlackScholes_NEW/
RDIR="results_BlackScholes_NEW"
DIR="results_BlackScholes_NEW/OUTPUTS"
mkdir "$DIR"
for I in {1..50} 
do
./../BlackScholes/bin/x86_64/Release/BlackScholes -e -ndeg 0 -wic 256 -k 0 > out_0_256_${I}.txt
sudo mv out_0_256_${I}.txt "$DIR"
sleep 5s
done
sudo mv timing_0_256.csv "$RDIR"
echo "test 0 finished!"
sleep 2s
#for NUMFAULTS in {1..32}
for NUMFAULTS in 1 32
#1 2 3 4 5 6 7 8 9 10 16 32
do
#let WICC=256-NUMFAULTS*4
let WICC=128
echo "test for $NUMFAULTS degraded elements ... "
	for I in {1..50} 
	do
    		./../BlackScholes/bin/x86_64/Release/BlackScholes -e -ndeg $NUMFAULTS -wic $WICC -k 1 > out_${NUMFAULTS}_${WICC}_${I}.txt
    		sudo mv out_${NUMFAULTS}_${WICC}_${I}.txt "$DIR"
		sleep 2s
	done
    	sudo mv timing_${NUMFAULTS}_${WICC}.csv "$RDIR"
    	echo "test $NUMFAULTS finished!"
    	sleep 5s
done
