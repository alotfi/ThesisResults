#!/bin/bash
echo "starting tests SobelFilter ..."
echo "test for 0 degraded elements ... "
mkdir results_SobelFilter_NEW/
RDIR="results_SobelFilter_NEW"
DIR="results_SobelFilter_NEW/OUTPUTS"
mkdir "$DIR"
for I in {1..20} 
do
a='cd wattsup; /home/atieh/anaconda3/bin/python wattsup.py -p /dev/ttyUSB0 -t 1 -i 1 -y > Sobel_'
f='0'
u='_'
p=$I
d='.csv'
c="$a$f$u$p$d"
ssh atieh@132.239.95.199 $c &
#ssh atieh@132.239.95.199 'cd wattsup; /home/atieh/anaconda3/bin/python wattsup.py -p /dev/ttyUSB0 -t 1 -i 1 -y > Sobel_0_256_${I}.csv' & 
sleep 10s
./../SobelFilter/bin/x86_64/Release/SobelFilter -e -ndeg 0 -wic 256 -k 0 > out_0_256_${I}.txt
sudo mv out_0_256_${I}.txt "$DIR"
sleep 5s
killall ssh
sleep 5s
done
sudo mv timing_0_256.csv "$RDIR"
echo "test 0 finished!"

sleep 1s
for NUMFAULTS in 1 2
do
let WICC=256-NUMFAULTS*4
echo "test for $NUMFAULTS degraded elements ... "
        for I in {1..20}
        do
                a='cd wattsup; /home/atieh/anaconda3/bin/python wattsup.py -p /dev/ttyUSB0 -t 1 -i 1 -y > Sobel_'
                f=${NUMFAULTS}
                u='_'
                p=$I
                d='.csv'
                c="$a$f$u$p$d"
                ssh atieh@132.239.95.199 $c &
                sleep 10s
                ./../SobelFilter/bin/x86_64/Release/SobelFilter -e -ndeg $NUMFAULTS -wic $WICC -k 1 > out_${NUMFAULTS}_${WICC}_${I}.txt
                sudo mv out_${NUMFAULTS}_${WICC}_${I}.txt "$DIR"
                sleep 5s
		killall ssh
		sleep 5s
        done
        sudo mv timing_${NUMFAULTS}_${WICC}.csv "$RDIR"
        echo "test $NUMFAULTS finished!"
done

for NUMFAULTS in 8
do
let WICC=128
echo "test for $NUMFAULTS degraded elements ... "
	for I in {1..20} 
	do
	        a='cd wattsup; /home/atieh/anaconda3/bin/python wattsup.py -p /dev/ttyUSB0 -t 1 -i 1 -y > Sobel_'
                f=${NUMFAULTS}
                u='_'
                p=$I
                d='.csv'
                c="$a$f$u$p$d"
                ssh atieh@132.239.95.199 $c &
                sleep 10s

    		./../SobelFilter/bin/x86_64/Release/SobelFilter -e -ndeg $NUMFAULTS -wic $WICC -k 1 > out_${NUMFAULTS}_${WICC}_${I}.txt
    		sudo mv out_${NUMFAULTS}_${WICC}_${I}.txt "$DIR"
		sleep 5s
		killall ssh
		sleep 5s
	done
    	sudo mv timing_${NUMFAULTS}_${WICC}.csv "$RDIR"
    	echo "test $NUMFAULTS finished!"
done
for NUMFAULTS in 16
do
let WICC=128
echo "test for $NUMFAULTS degraded elements ... "
	for I in {1..20} 
	do
        	a='cd wattsup; /home/atieh/anaconda3/bin/python wattsup.py -p /dev/ttyUSB0 -t 1 -i 1 -y > Sobel_'
                f=${NUMFAULTS}
                u='_'
                p=$I
                d='.csv'
                c="$a$f$u$p$d"
                ssh atieh@132.239.95.199 $c &
                sleep 10s

    		./../SobelFilter/bin/x86_64/Release/SobelFilter -e -ndeg $NUMFAULTS -wic $WICC -k 1 > out_${NUMFAULTS}_${WICC}_${I}.txt
    		sudo mv out_${NUMFAULTS}_${WICC}_${I}.txt "$DIR"
		sleep 5s
		killall ssh
		sleep 5s
	done
    	sudo mv timing_${NUMFAULTS}_${WICC}.csv "$RDIR"
    	echo "test $NUMFAULTS finished!"
done
for NUMFAULTS in 24 32
do
let WICC=64
echo "test for $NUMFAULTS degraded elements ... "
	for I in {1..20} 
	do
	        a='cd wattsup; /home/atieh/anaconda3/bin/python wattsup.py -p /dev/ttyUSB0 -t 1 -i 1 -y > Sobel_'
                f=${NUMFAULTS}
                u='_'
                p=$I
                d='.csv'
                c="$a$f$u$p$d"
                ssh atieh@132.239.95.199 $c &
                sleep 10s
    		./../SobelFilter/bin/x86_64/Release/SobelFilter -e -ndeg $NUMFAULTS -wic $WICC -k 1 > out_${NUMFAULTS}_${WICC}_${I}.txt
    		sudo mv out_${NUMFAULTS}_${WICC}_${I}.txt "$DIR"
		sleep 5s
		killall ssh
		sleep 5s
	done
    	sudo mv timing_${NUMFAULTS}_${WICC}.csv "$RDIR"
    	echo "test $NUMFAULTS finished!"
done
