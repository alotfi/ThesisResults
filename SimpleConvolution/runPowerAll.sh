#!/bin/bash
echo "starting tests SimpleConvolution ..."
echo "test for 0 degraded elements ... "
mkdir results_SimpleConvolution_NEW/
RDIR="results_SimpleConvolution_NEW"
DIR="results_SimpleConvolution_NEW/OUTPUTS"
mkdir "$DIR"
for I in {1..20} 
do
ssh atieh@132.239.95.199 'cd wattsup; /home/atieh/anaconda3/bin/python wattsup.py -p /dev/ttyUSB0 -t 1 -i 1 -y > Conv_0_256_${I}.csv' & 
sleep 10s
./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 0 -wic 128 -k 0 > out_0_128_${I}.txt
sudo mv out_0_128_${I}.txt "$DIR"
sleep 5s
killall ssh
done
sudo mv timing_0_128.csv "$RDIR"
echo "test 0-128 finished!"
sleep 5s

for NUMFAULTS in {1..8}
do
let WICC=128
echo "test for $NUMFAULTS degraded elements ... "
	for I in {1..20} 
	do
                a='cd wattsup; /home/atieh/anaconda3/bin/python wattsup.py -p /dev/ttyUSB0 -t 1 -i 1 -y > Conv_'
                f=${NUMFAULTS}
                u='_'
                p=$I
                d='.csv'
                c="$a$f$u$p$d"
                ssh atieh@132.239.95.199 $c &
                sleep 10s
    		./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg $NUMFAULTS -wic $WICC -k 1 > out_${NUMFAULTS}_${WICC}_${I}.txt
    		sudo mv out_${NUMFAULTS}_${WICC}_${I}.txt "$DIR"
		sleep 5s
		killall ssh
	done
    	sudo mv timing_${NUMFAULTS}_${WICC}.csv "$RDIR"
    	echo "test $NUMFAULTS finished!"
    	sleep 5s
done
for NUMFAULTS in {10..16..2}
do
let WICC=128
echo "test for $NUMFAULTS degraded elements ... "
	for I in {1..20} 
	do
	        a='cd wattsup; /home/atieh/anaconda3/bin/python wattsup.py -p /dev/ttyUSB0 -t 1 -i 1 -y > Conv_'
                f=${NUMFAULTS}
                u='_'
                p=$I
                d='.csv'
                c="$a$f$u$p$d"
                ssh atieh@132.239.95.199 $c &
                sleep 10s

    		./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg $NUMFAULTS -wic $WICC -k 1 > out_${NUMFAULTS}_${WICC}_${I}.txt
    		sudo mv out_${NUMFAULTS}_${WICC}_${I}.txt "$DIR"
		sleep 5s
		killall ssh
	done
    	sudo mv timing_${NUMFAULTS}_${WICC}.csv "$RDIR"
    	echo "test $NUMFAULTS finished!"
    	sleep 5s
done
for NUMFAULTS in 20 24 28 32
do
let WICC=128
echo "test for $NUMFAULTS degraded elements ... "
	for I in {1..20} 
	do
	        a='cd wattsup; /home/atieh/anaconda3/bin/python wattsup.py -p /dev/ttyUSB0 -t 1 -i 1 -y > Conv_'
                f=${NUMFAULTS}
                u='_'
                p=$I
                d='.csv'
                c="$a$f$u$p$d"
                ssh atieh@132.239.95.199 $c &
                sleep 10s
    		./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg $NUMFAULTS -wic $WICC -k 1 > out_${NUMFAULTS}_${WICC}_${I}.txt
    		sudo mv out_${NUMFAULTS}_${WICC}_${I}.txt "$DIR"
		sleep 5s
		killall ssh
	done
    	sudo mv timing_${NUMFAULTS}_${WICC}.csv "$RDIR"
    	echo "test $NUMFAULTS finished!"
    	sleep 5s
done
