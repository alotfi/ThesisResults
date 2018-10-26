#!/bin/bash
echo "starting tests SobelFilter ..."
echo "test for 0 degraded elements ... "
mkdir results_SobelFilter_NEW/
RDIR="results_SobelFilter_NEW"
DIR="results_SobelFilter_NEW/OUTPUTS"
mkdir "$DIR"
for I in {1..15} 
do
/opt/AMDAPPSDK-2.9-1/samples/opencl/cl/wattsup/wattsup.py -p /dev/ttyUSB0 -t 5 -i 1 -y > Sobel_0_${I}.csv & 
sleep 1s
./../SobelFilter/bin/x86_64/Release/SobelFilter -e -ndeg 0 -wic 256 -k 0 > out_0_256_${I}.txt
sleep 3s
killall wattsup.py
sleep 1s
sudo mv Sobel_0_${I}.csv "$RDIR"	
sudo mv out_0_256_${I}.txt "$DIR"
done
sudo mv timing_0_256.csv "$RDIR"
echo "test 0 finished!"

for NUMFAULTS in 1 2
do
let WICC=256-NUMFAULTS*4
echo "test for $NUMFAULTS degraded elements ... "
        for I in {1..15}
        do
		/opt/AMDAPPSDK-2.9-1/samples/opencl/cl/wattsup/wattsup.py -p /dev/ttyUSB0 -t 5 -i 1 -y > Sobel_${NUMFAULTS}_${I}.csv & 
		sleep 1s
                ./../SobelFilter/bin/x86_64/Release/SobelFilter -e -ndeg $NUMFAULTS -wic $WICC -k 1 > out_${NUMFAULTS}_${WICC}_${I}.txt
		sleep 3s
		killall wattsup.py
		sleep 1s
		sudo mv Sobel_${NUMFAULTS}_${I}.csv "$RDIR"
                sudo mv out_${NUMFAULTS}_${WICC}_${I}.txt "$DIR"
        done
        sudo mv timing_${NUMFAULTS}_${WICC}.csv "$RDIR"
        echo "test $NUMFAULTS finished!"
done

for NUMFAULTS in 8
do
let WICC=128
echo "test for $NUMFAULTS degraded elements ... "
	for I in {1..15} 
	do
		/opt/AMDAPPSDK-2.9-1/samples/opencl/cl/wattsup/wattsup.py -p /dev/ttyUSB0 -t 5 -i 1 -y > Sobel_${NUMFAULTS}_${I}.csv & 
		sleep 1s
    		./../SobelFilter/bin/x86_64/Release/SobelFilter -e -ndeg $NUMFAULTS -wic $WICC -k 1 > out_${NUMFAULTS}_${WICC}_${I}.txt
		sleep 3s
		killall wattsup.py
		sleep 1s
		sudo mv Sobel_${NUMFAULTS}_${I}.csv "$RDIR"
    		sudo mv out_${NUMFAULTS}_${WICC}_${I}.txt "$DIR"
	done
    	sudo mv timing_${NUMFAULTS}_${WICC}.csv "$RDIR"
    	echo "test $NUMFAULTS finished!"
done
for NUMFAULTS in 16
do
let WICC=128
echo "test for $NUMFAULTS degraded elements ... "
	for I in {1..15} 
	do
		/opt/AMDAPPSDK-2.9-1/samples/opencl/cl/wattsup/wattsup.py -p /dev/ttyUSB0 -t 5 -i 1 -y > Sobel_${NUMFAULTS}_${I}.csv & 
		sleep 1s
    		./../SobelFilter/bin/x86_64/Release/SobelFilter -e -ndeg $NUMFAULTS -wic $WICC -k 1 > out_${NUMFAULTS}_${WICC}_${I}.txt
    		sleep 3s
		killall wattsup.py
		sleep 1s
		sudo mv Sobel_${NUMFAULTS}_${I}.csv "$RDIR"
		sudo mv out_${NUMFAULTS}_${WICC}_${I}.txt "$DIR"
	done
    	sudo mv timing_${NUMFAULTS}_${WICC}.csv "$RDIR"
    	echo "test $NUMFAULTS finished!"
done
for NUMFAULTS in 24 32
do
let WICC=64
echo "test for $NUMFAULTS degraded elements ... "
	for I in {1..15} 
	do
		/opt/AMDAPPSDK-2.9-1/samples/opencl/cl/wattsup/wattsup.py -p /dev/ttyUSB0 -t 5 -i 1 -y > Sobel_${NUMFAULTS}_${I}.csv & 
		sleep 1s
    		./../SobelFilter/bin/x86_64/Release/SobelFilter -e -ndeg $NUMFAULTS -wic $WICC -k 1 > out_${NUMFAULTS}_${WICC}_${I}.txt
		sleep 3s
		killall wattsup.py
		sleep 1s
		sudo mv Sobel_${NUMFAULTS}_${I}.csv "$RDIR"
    		sudo mv out_${NUMFAULTS}_${WICC}_${I}.txt "$DIR"
	done
    	sudo mv timing_${NUMFAULTS}_${WICC}.csv "$RDIR"
    	echo "test $NUMFAULTS finished!"
done
