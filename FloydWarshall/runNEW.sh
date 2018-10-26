#!/bin/bash
echo "starting tests FloydWarshall ..."
echo "test for 0 degraded elements ... "
mkdir results_FloydWarshall_NEW/
RDIR="results_FloydWarshall_NEW"
DIR="results_FloydWarshall_NEW/OUTPUTS"
mkdir "$DIR"
for I in {1..15} 
do
/opt/AMDAPPSDK-2.9-1/samples/opencl/cl/wattsup/wattsup.py -p /dev/ttyUSB0 -t 5 -i 1 -y > Floyd_0_${I}.csv & 
sleep 1s
./../FloydWarshall/bin/x86_64/Release/FloydWarshall -e -ndeg 0 -wic 512 -k 0 > out_0_256_${I}.txt
sleep 3s
killall wattsup.py
sleep 1s
sudo mv Floyd_0_${I}.csv "$RDIR"	
sudo mv out_0_256_${I}.txt "$DIR"
done
sudo mv timing_0_256.csv "$RDIR"
echo "test 0 finished!"

for NUMFAULTS in 1 2 8 16 24 32
do
echo "test for $NUMFAULTS degraded elements ... "
	for I in {1..15} 
	do
		/opt/AMDAPPSDK-2.9-1/samples/opencl/cl/wattsup/wattsup.py -p /dev/ttyUSB0 -t 5 -i 1 -y > Floyd_${NUMFAULTS}_${I}.csv & 
		sleep 1s
    		./../FloydWarshall/bin/x86_64/Release/FloydWarshall -e -ndeg $NUMFAULTS -wic 512 -k 1 > out_${NUMFAULTS}_256_${I}.txt
		sleep 3s
		killall wattsup.py
		sleep 1s
		sudo mv Floyd_${NUMFAULTS}_${I}.csv "$RDIR"
    		sudo mv out_${NUMFAULTS}_256_${I}.txt "$DIR"
	done
    	sudo mv timing_${NUMFAULTS}_256.csv "$RDIR"
    	echo "test $NUMFAULTS finished!"
done
