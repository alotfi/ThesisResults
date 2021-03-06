#!/bin/bash
echo "starting tests BlackScholes ..."
echo "test for 0 degraded elements ... "
mkdir results_BlackScholes_NEW/
RDIR="results_BlackScholes_NEW"
DIR="results_BlackScholes_NEW/OUTPUTS"
mkdir "$DIR"
for I in {1..15} 
do
/opt/AMDAPPSDK-2.9-1/samples/opencl/cl/wattsup/wattsup.py -p /dev/ttyUSB0 -t 5 -i 1 -y > BlackScholes_0_${I}.csv & 
sleep 1s
./../BlackScholes/bin/x86_64/Release/BlackScholes -e -ndeg 0 -wic 128 -k 0 > out_0_128_${I}.txt
sleep 3s
killall wattsup.py
sleep 1s
sudo mv BlackScholes_0_${I}.csv "$RDIR"	
sudo mv out_0_128_${I}.txt "$DIR"
done
sudo mv timing_0_128.csv "$RDIR"
echo "test 0 finished!"


for NUMFAULTS in 1 2 8
do
let WICC=128
echo "test for $NUMFAULTS degraded elements ... "
	for I in {1..15} 
	do
		/opt/AMDAPPSDK-2.9-1/samples/opencl/cl/wattsup/wattsup.py -p /dev/ttyUSB0 -t 5 -i 1 -y > BlackScholes_${NUMFAULTS}_${I}.csv & 
		sleep 1s
    		./../BlackScholes/bin/x86_64/Release/BlackScholes -e -ndeg $NUMFAULTS -wic $WICC -k 1 > out_${NUMFAULTS}_${WICC}_${I}.txt
		sleep 3s
		killall wattsup.py
		sleep 1s
		sudo mv BlackScholes_${NUMFAULTS}_${I}.csv "$RDIR"
    		sudo mv out_${NUMFAULTS}_${WICC}_${I}.txt "$DIR"
	done
    	sudo mv timing_${NUMFAULTS}_${WICC}.csv "$RDIR"
    	echo "test $NUMFAULTS finished!"
    	sleep 1s
done
for NUMFAULTS in 16
do
let WICC=128
echo "test for $NUMFAULTS degraded elements ... "
	for I in {1..15} 
	do
       		/opt/AMDAPPSDK-2.9-1/samples/opencl/cl/wattsup/wattsup.py -p /dev/ttyUSB0 -t 5 -i 1 -y > BlackScholes_${NUMFAULTS}_${I}.csv & 
		sleep 1s
    		./../BlackScholes/bin/x86_64/Release/BlackScholes -e -ndeg $NUMFAULTS -wic $WICC -k 1 > out_${NUMFAULTS}_${WICC}_${I}.txt
		sleep 3s
		killall wattsup.py
		sleep 1s
		sudo mv BlackScholes_${NUMFAULTS}_${I}.csv "$RDIR"	
    		sudo mv out_${NUMFAULTS}_${WICC}_${I}.txt "$DIR"
	done
    	sudo mv timing_${NUMFAULTS}_${WICC}.csv "$RDIR"
    	echo "test $NUMFAULTS finished!"
    	sleep 1s
done

for NUMFAULTS in 24 32
do
let WICC=64
echo "test for $NUMFAULTS degraded elements ... "
	for I in {1..15} 
	do
       		/opt/AMDAPPSDK-2.9-1/samples/opencl/cl/wattsup/wattsup.py -p /dev/ttyUSB0 -t 5 -i 1 -y > BlackScholes_${NUMFAULTS}_${I}.csv & 
		sleep 1s
    		./../BlackScholes/bin/x86_64/Release/BlackScholes -e -ndeg $NUMFAULTS -wic $WICC -k 1 > out_${NUMFAULTS}_${WICC}_${I}.txt
		sleep 3s
		killall wattsup.py
		sleep 1s
		sudo mv BlackScholes_${NUMFAULTS}_${I}.csv "$RDIR"	
    		sudo mv out_${NUMFAULTS}_${WICC}_${I}.txt "$DIR"
	done
    	sudo mv timing_${NUMFAULTS}_${WICC}.csv "$RDIR"
    	echo "test $NUMFAULTS finished!"
    	sleep 1s
done
