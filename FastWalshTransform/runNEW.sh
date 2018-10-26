#!/bin/bash
echo "starting tests FastWalshTransform ..."
echo "test for 0 degraded elements ... "
mkdir results_FastWalshTransform_NEW/
RDIR="results_FastWalshTransform_NEW"
DIR="results_FastWalshTransform_NEW/OUTPUTS"
mkdir "$DIR"
for I in {1..15} 
do
/opt/AMDAPPSDK-2.9-1/samples/opencl/cl/wattsup/wattsup.py -p /dev/ttyUSB0 -t 5 -i 1 -y > FastWalsh_0_${I}.csv & 
sleep 1s
./../FastWalshTransform/bin/x86_64/Release/FastWalshTransform -e -ndeg 0 -wic 16384 -k 0 > out_0_256_${I}.txt
sleep 3s
killall wattsup.py
sleep 1s
sudo mv FastWalsh_0_${I}.csv "$RDIR"	
sudo mv out_0_256_${I}.txt "$DIR"
done
sudo mv timing_0_256.csv "$RDIR"
echo "test 0 finished!"

for NUMFAULTS in 1 2 8 16 24 32
do
echo "test for $NUMFAULTS degraded elements ... "
	for I in {1..15} 
	do
		/opt/AMDAPPSDK-2.9-1/samples/opencl/cl/wattsup/wattsup.py -p /dev/ttyUSB0 -t 5 -i 1 -y > FastWalsh_${NUMFAULTS}_${I}.csv & 
		sleep 1s

    		./../FastWalshTransform/bin/x86_64/Release/FastWalshTransform -e -ndeg $NUMFAULTS -wic 16384 -k 1 > out_${NUMFAULTS}_256_${I}.txt
		sleep 3s
		killall wattsup.py
		sleep 1s
		sudo mv FastWalsh_${NUMFAULTS}_${I}.csv "$RDIR"	
    		sudo mv out_${NUMFAULTS}_256_${I}.txt "$DIR
"
	done
    	sudo mv timing_${NUMFAULTS}_256.csv "$RDIR"
    	echo "test $NUMFAULTS finished!"
done
