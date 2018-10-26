#!/bin/bash
echo "starting tests MatrixMultiplication ..."
echo "test for 0 degraded elements ... "
mkdir results_MatrixMultiplication_NEW/
RDIR="results_MatrixMultiplication_NEW"
DIR="results_MatrixMultiplication_NEW/OUTPUTS"
mkdir "$DIR"
#for I in {1..20} 
#do
#./../MatrixMultiplication/bin/x86_64/Release/MatrixMultiplication -e -ndeg 0 -wic 16 -k 0 > out_0_256_${I}.txt
#sudo mv out_0_256_${I}.txt "$DIR"
#sleep 5s
#done
#sudo mv timing_0_256.csv "$RDIR"
#echo "test 0 finished!"
#sleep 5s
for I in {1..20} 
do
a='cd wattsup; /home/atieh/anaconda3/bin/python wattsup.py -p /dev/ttyUSB0 -t 1 -i 1 -y > Matrix_'
f='0'
u='_'
p=$I
d='.csv'
c="$a$f$u$p$d"
ssh atieh@132.239.95.199 $c &

#ssh atieh@132.239.95.199 'cd wattsup; /home/atieh/anaconda3/bin/python wattsup.py -p /dev/ttyUSB0 -t 1 -i 1 -y > Matrix_0_256_${I}.csv' & 
sleep 10s
./../MatrixMultiplication/bin/x86_64/Release/MatrixMultiplication -e -ndeg 0 -wic 8 -k 0 > out_0_64_${I}.txt
sudo mv out_0_64_${I}.txt "$DIR"
sleep 5s
killall ssh
sleep 5s
done
sudo mv timing_0_64.csv "$RDIR"
echo "test 0 finished!"

#for NUMFAULTS in {1..32..7}
#for NUMFAULTS in 1 2 3 4 5 6 7 8 9 10 16 32
for NUMFAULTS in 1 2 8
do
let WICC=8
echo "test for $NUMFAULTS degraded elements ... "
	for I in {1..20} 
	do
                a='cd wattsup; /home/atieh/anaconda3/bin/python wattsup.py -p /dev/ttyUSB0 -t 1 -i 1 -y > Matrix_'
                f=${NUMFAULTS}
                u='_'
                p=$I
                d='.csv'
                c="$a$f$u$p$d"
                ssh atieh@132.239.95.199 $c &
                sleep 10s

    		./../MatrixMultiplication/bin/x86_64/Release/MatrixMultiplication -e -ndeg $NUMFAULTS -wic $WICC -k 1 > out_${NUMFAULTS}_${WICC}_${I}.txt
    		sudo mv out_${NUMFAULTS}_${WICC}_${I}.txt "$DIR"
		sleep 5s
		killall ssh
		sleep 5s
	done
    	sudo mv timing_${NUMFAULTS}_64.csv "$RDIR"
    	echo "test $NUMFAULTS finished!"
done
for NUMFAULTS in 16 24 32
do
let WICC=8
echo "test for $NUMFAULTS degraded elements ... "
	for I in {1..20} 
	do
                a='cd wattsup; /home/atieh/anaconda3/bin/python wattsup.py -p /dev/ttyUSB0 -t 1 -i 1 -y > Matrix_'
                f=${NUMFAULTS}
                u='_'
                p=$I
                d='.csv'
                c="$a$f$u$p$d"
                ssh atieh@132.239.95.199 $c &
                sleep 10s

    		./../MatrixMultiplication/bin/x86_64/Release/MatrixMultiplication -e -ndeg $NUMFAULTS -wic $WICC -k 1 > out_${NUMFAULTS}_${WICC}_${I}.txt
    		sudo mv out_${NUMFAULTS}_${WICC}_${I}.txt "$DIR"
		sleep 5s
		killall ssh
		sleep 5s
	done
    	sudo mv timing_${NUMFAULTS}_64.csv "$RDIR"
    	echo "test $NUMFAULTS finished!"
done

