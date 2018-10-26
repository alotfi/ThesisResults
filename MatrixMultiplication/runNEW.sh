#!/bin/bash
echo "starting tests MatrixMultiplication ..."
echo "test for 0 degraded elements ... "
mkdir results_MatrixMultiplication_NEW/
RDIR="results_MatrixMultiplication_NEW"
DIR="results_MatrixMultiplication_NEW/OUTPUTS"
mkdir "$DIR"
for I in {1..15} 
do
/opt/AMDAPPSDK-2.9-1/samples/opencl/cl/wattsup/wattsup.py -p /dev/ttyUSB0 -t 5 -i 1 -y > Matrix_0_${I}.csv & 
sleep 1s
./../MatrixMultiplication/bin/x86_64/Release/MatrixMultiplication -e -ndeg 0 -wic 8 -k 0 > out_0_64_${I}.txt
sleep 3s
killall wattsup.py
sleep 1s
sudo mv Matrix_0_${I}.csv "$RDIR"	
sudo mv out_0_64_${I}.txt "$DIR"

done
sudo mv timing_0_64.csv "$RDIR"
echo "test 0 finished!"

for NUMFAULTS in 1 2 8
do
let WICC=8
echo "test for $NUMFAULTS degraded elements ... "
	for I in {1..15} 
	do
		/opt/AMDAPPSDK-2.9-1/samples/opencl/cl/wattsup/wattsup.py -p /dev/ttyUSB0 -t 5 -i 1 -y > Matrix_${NUMFAULTS}_${I}.csv & 
		sleep 1s

    		./../MatrixMultiplication/bin/x86_64/Release/MatrixMultiplication -e -ndeg $NUMFAULTS -wic $WICC -k 1 > out_${NUMFAULTS}_${WICC}_${I}.txt
		sleep 3s
		killall wattsup.py
		sleep 1s
		sudo mv Matrix_${NUMFAULTS}_${I}.csv "$RDIR"

    		sudo mv out_${NUMFAULTS}_${WICC}_${I}.txt "$DIR"

	done
    	sudo mv timing_${NUMFAULTS}_64.csv "$RDIR"
    	echo "test $NUMFAULTS finished!"
done
for NUMFAULTS in 16 24 32
do
let WICC=8
echo "test for $NUMFAULTS degraded elements ... "
	for I in {1..15} 
	do
		/opt/AMDAPPSDK-2.9-1/samples/opencl/cl/wattsup/wattsup.py -p /dev/ttyUSB0 -t 5 -i 1 -y > Matrix_${NUMFAULTS}_${I}.csv & 
		sleep 1s

    		./../MatrixMultiplication/bin/x86_64/Release/MatrixMultiplication -e -ndeg $NUMFAULTS -wic $WICC -k 1 > out_${NUMFAULTS}_${WICC}_${I}.txt
    		sleep 3s
		killall wattsup.py
		sleep 1s
		sudo mv Matrix_${NUMFAULTS}_${I}.csv "$RDIR"

		sudo mv out_${NUMFAULTS}_${WICC}_${I}.txt "$DIR"
	done
    	sudo mv timing_${NUMFAULTS}_64.csv "$RDIR"
    	echo "test $NUMFAULTS finished!"
done

