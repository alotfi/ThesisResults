#!/bin/bash
echo "starting tests FastWalshTransform ..."
echo "test for 0 degraded elements ... "
mkdir results_FastWalshTransform_NEW/
RDIR="results_FastWalshTransform_NEW"
DIR="results_FastWalshTransform_NEW/OUTPUTS"
mkdir "$DIR"
for I in {1..20} 
do
a='cd wattsup; /home/atieh/anaconda3/bin/python wattsup.py -p /dev/ttyUSB0 -t 1 -i 1 -y > FastW_'
f='0'
u='_'
p=$I
d='.csv'
c="$a$f$u$p$d"
ssh atieh@132.239.95.199 $c &
#ssh atieh@132.239.95.199 'cd wattsup; /home/atieh/anaconda3/bin/python wattsup.py -p /dev/ttyUSB0 -t 1 -i 1 -y > FastW_0_256_${I}.csv' & 
sleep 10s
./../FastWalshTransform/bin/x86_64/Release/FastWalshTransform -e -ndeg 0 -wic 16384 -k 0 > out_0_256_${I}.txt
sudo mv out_0_256_${I}.txt "$DIR"
sleep 5s
killall ssh
sleep 5s
done
sudo mv timing_0_256.csv "$RDIR"
echo "test 0 finished!"

for NUMFAULTS in 1 2 8 16 24 32
do
echo "test for $NUMFAULTS degraded elements ... "
	for I in {1..20} 
	do
     		a='cd wattsup; /home/atieh/anaconda3/bin/python wattsup.py -p /dev/ttyUSB0 -t 1 -i 1 -y > FastW_'
                f=${NUMFAULTS}
                u='_'
                p=$I
                d='.csv'
                c="$a$f$u$p$d"
                ssh atieh@132.239.95.199 $c &
                sleep 10s
    		./../FastWalshTransform/bin/x86_64/Release/FastWalshTransform -e -ndeg $NUMFAULTS -wic 16384 -k 1 > out_${NUMFAULTS}_256_${I}.txt
    		sudo mv out_${NUMFAULTS}_256_${I}.txt "$DIR"
		sleep 5s
		killall ssh
		sleep 5s
	done
    	sudo mv timing_${NUMFAULTS}_256.csv "$RDIR"
    	echo "test $NUMFAULTS finished!"
done
