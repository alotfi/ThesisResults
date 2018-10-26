#!/bin/bash
echo "starting tests SobelFilter ..."
echo "test for 0 degraded elements ... "
mkdir results_SobelFilter_NEW/
RDIR="results_SobelFilter_NEW"
DIR="results_SobelFilter_NEW/OUTPUTS"
mkdir "$DIR"
for I in {1..50} 
do
./../SobelFilter/bin/x86_64/Release/SobelFilter -e -ndeg 0 -wic 256 -k 0 > out_0_256_${I}.txt
sudo mv out_0_256_${I}.txt "$DIR"
sleep 5s
done
sudo mv timing_0_256.csv "$RDIR"
echo "test 0 finished!"
sleep 5s
for I in {1..50} 
do
./../SobelFilter/bin/x86_64/Release/SobelFilter -e -ndeg 0 -wic 252 -k 0 > out_0_252_${I}.txt
sudo mv out_0_252_${I}.txt "$DIR"
sleep 5s
done
sudo mv timing_0_252.csv "$RDIR"
echo "test 0 finished!"
sleep 5s

#for NUMFAULTS in {1..32..7}
#for NUMFAULTS in 1 2 3 4 5 6 7 8 9 10 16 32
for NUMFAULTS in {1..4}
do
let WICC=256-NUMFAULTS*4
echo "test for $NUMFAULTS degraded elements ... "
	for I in {1..50} 
	do
    		./../SobelFilter/bin/x86_64/Release/SobelFilter -e -ndeg $NUMFAULTS -wic $WICC -k 1 > out_${NUMFAULTS}_${WICC}_${I}.txt
    		sudo mv out_${NUMFAULTS}_${WICC}_${I}.txt "$DIR"
		sleep 5s
	done
    	sudo mv timing_${NUMFAULTS}_${WICC}.csv "$RDIR"
    	echo "test $NUMFAULTS finished!"
    	sleep 5s
done
for NUMFAULTS in {5..8}
do
let WICC=128
echo "test for $NUMFAULTS degraded elements ... "
	for I in {1..50} 
	do
    		./../SobelFilter/bin/x86_64/Release/SobelFilter -e -ndeg $NUMFAULTS -wic $WICC -k 1 > out_${NUMFAULTS}_${WICC}_${I}.txt
    		sudo mv out_${NUMFAULTS}_${WICC}_${I}.txt "$DIR"
		sleep 5s
	done
    	sudo mv timing_${NUMFAULTS}_${WICC}.csv "$RDIR"
    	echo "test $NUMFAULTS finished!"
    	sleep 5s
done
for NUMFAULTS in {10..16..2}
do
let WICC=128
echo "test for $NUMFAULTS degraded elements ... "
	for I in {1..50} 
	do
    		./../SobelFilter/bin/x86_64/Release/SobelFilter -e -ndeg $NUMFAULTS -wic $WICC -k 1 > out_${NUMFAULTS}_${WICC}_${I}.txt
    		sudo mv out_${NUMFAULTS}_${WICC}_${I}.txt "$DIR"
		sleep 5s
	done
    	sudo mv timing_${NUMFAULTS}_${WICC}.csv "$RDIR"
    	echo "test $NUMFAULTS finished!"
    	sleep 5s
done
for NUMFAULTS in {24..32..4}
do
let WICC=64
echo "test for $NUMFAULTS degraded elements ... "
	for I in {1..50} 
	do
    		./../SobelFilter/bin/x86_64/Release/SobelFilter -e -ndeg $NUMFAULTS -wic $WICC -k 1 > out_${NUMFAULTS}_${WICC}_${I}.txt
    		sudo mv out_${NUMFAULTS}_${WICC}_${I}.txt "$DIR"
		sleep 5s
	done
    	sudo mv timing_${NUMFAULTS}_${WICC}.csv "$RDIR"
    	echo "test $NUMFAULTS finished!"
    	sleep 5s
done

for NUMFAULTS in 20
do
let WICC=128
echo "test for $NUMFAULTS degraded elements ... "
	for I in {1..50} 
	do
    		./../SobelFilter/bin/x86_64/Release/SobelFilter -e -ndeg $NUMFAULTS -wic $WICC -k 1 > out_${NUMFAULTS}_${WICC}_${I}.txt
    		sudo mv out_${NUMFAULTS}_${WICC}_${I}.txt "$DIR"
		sleep 5s
	done
    	sudo mv timing_${NUMFAULTS}_${WICC}.csv "$RDIR"
    	echo "test $NUMFAULTS finished!"
    	sleep 5s
done
