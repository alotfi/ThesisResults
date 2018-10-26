#!/bin/bash
echo "starting tests MatrixMultiplication ..."
echo "test for 0 degraded elements ... "
mkdir results_MatrixMultiplication_NEW/
RDIR="results_MatrixMultiplication_NEW"
DIR="results_MatrixMultiplication_NEW/OUTPUTS"
mkdir "$DIR"
#for I in {1..30} 
#do
#./../MatrixMultiplication/bin/x86_64/Release/MatrixMultiplication -e -ndeg 0 -wic 16 -k 0 > out_0_256_${I}.txt
#sudo mv out_0_256_${I}.txt "$DIR"
#sleep 5s
#done
#sudo mv timing_0_256.csv "$RDIR"
#echo "test 0 finished!"
#sleep 5s
for I in {1..30} 
do
./../MatrixMultiplication/bin/x86_64/Release/MatrixMultiplication -e -ndeg 0 -wic 8 -k 0 > out_0_64_${I}.txt
sudo mv out_0_64_${I}.txt "$DIR"
sleep 5s
done
sudo mv timing_0_64.csv "$RDIR"
echo "test 0 finished!"
sleep 5s

#for NUMFAULTS in {1..32..7}
#for NUMFAULTS in 1 2 3 4 5 6 7 8 9 10 16 32
for NUMFAULTS in {1..8}
do
let WICC=8
echo "test for $NUMFAULTS degraded elements ... "
	for I in {1..30} 
	do
    		./../MatrixMultiplication/bin/x86_64/Release/MatrixMultiplication -e -ndeg $NUMFAULTS -wic $WICC -k 1 > out_${NUMFAULTS}_${WICC}_${I}.txt
    		sudo mv out_${NUMFAULTS}_${WICC}_${I}.txt "$DIR"
		sleep 5s
	done
    	sudo mv timing_${NUMFAULTS}_64.csv "$RDIR"
    	echo "test $NUMFAULTS finished!"
    	sleep 5s
done
for NUMFAULTS in 10 12 14 16 20 24 28 32
do
let WICC=8
echo "test for $NUMFAULTS degraded elements ... "
	for I in {1..30} 
	do
    		./../MatrixMultiplication/bin/x86_64/Release/MatrixMultiplication -e -ndeg $NUMFAULTS -wic $WICC -k 1 > out_${NUMFAULTS}_${WICC}_${I}.txt
    		sudo mv out_${NUMFAULTS}_${WICC}_${I}.txt "$DIR"
		sleep 5s
	done
    	sudo mv timing_${NUMFAULTS}_64.csv "$RDIR"
    	echo "test $NUMFAULTS finished!"
    	sleep 5s
done

