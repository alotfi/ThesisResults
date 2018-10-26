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
sleep 5s
for I in {1..50} 
do
./../BlackScholes/bin/x86_64/Release/BlackScholes -e -ndeg 0 -wic 128 -k 0 > out_0_128_${I}.txt
sudo mv out_0_128_${I}.txt "$DIR"
sleep 5s
done
sudo mv timing_0_128.csv "$RDIR"
echo "test 0 finished!"
sleep 5s

for NUMFAULTS in {1..8}
do
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
for NUMFAULTS in 10 12 14 16 20
do
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

for NUMFAULTS in 24 28 32
do
let WICC=64
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


