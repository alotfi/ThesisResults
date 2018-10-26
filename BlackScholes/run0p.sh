#!/bin/bash
echo "starting tests BlackScholes ..."
echo "test for 0 degraded elements ... "
mkdir results_BlackScholes_NEW/
RDIR="results_BlackScholes_NEW"
DIR="results_BlackScholes_NEW/OUTPUTS"
mkdir "$DIR"
for I in 1
do
echo $I
a='cd wattsup; /home/atieh/anaconda3/bin/python wattsup.py -p /dev/ttyUSB0 -t 10 -i 1 -y > BlackScholes_'
f='0'
u='_'
p=$I
d='.csv'
c="$a$f$u$p$d"
echo "before ssh"
current_date_time="`date +%Y%m%d%H%M%S`";
echo $current_date_time
#ssh atieh@132.239.95.199 'cd wattsup; /home/atieh/anaconda3/bin/python wattsup.py -p /dev/ttyUSB0 -t 5 -i 1 -y > BlackScholes_0_128_${I}.csv' & 
/opt/AMDAPPSDK-2.9-1/samples/opencl/cl/wattsup/wattsup.py -p /dev/ttyUSB0 -t 5 -i 1 -y > BlackScholes_0_128_${I}.csv & 
sleep 1s
echo "just before gpu call"
current_date_time="`date +%Y%m%d%H%M%S`";
echo $current_date_time
./../BlackScholes/bin/x86_64/Release/BlackScholes -e -ndeg 0 -wic 128 -k 0 > out_0_128_${I}.txt
sudo mv out_0_128_${I}.txt "$DIR"
sudo mv BlackScholes_0_128_${I}.csv "$RDIR"	
echo "after gpu call:"
current_date_time="`date +%Y%m%d%H%M%S`";
echo $current_date_time
sleep 3s
killall wattsup.py
sleep 1s
#killall ssh
#pkill ssh
#echo "killed ssh ..."
#current_date_time="`date +%Y%m%d%H%M%S`";
#echo $current_date_time
done
sudo mv timing_0_128.csv "$RDIR"
echo "test 0 finished!"

