#!/bin/bash
echo "starting tests SobelFilter ..."
echo "test for 0 degraded elements ... "
#mkdir results_SobelFilter_NEW/
RDIR="results_SobelFilter_NEW"
DIR="results_SobelFilter_NEW/OUTPUTS"
#mkdir "$DIR"
for I in {1..50} 
do
./../SobelFilter/bin/x86_64/Release/SobelFilter -e -ndeg 1 -wic 252 -k 1 > out_1_252_${I}.txt
sudo mv out_1_252_${I}.txt "$DIR"
sleep 5s
./../SobelFilter/bin/x86_64/Release/SobelFilter -e -ndeg 0 -wic 256 -k 0 > out_0_256_${I}.txt
sudo mv out_0_256_${I}.txt "$DIR"
sleep 5s
done
sudo mv timing_0_256.csv "$RDIR"
sudo mv timing_1_252.csv "$RDIR"
echo "test 0 finished!"
sleep 5s
#for I in {1..50} 
#do
#./../SobelFilter/bin/x86_64/Release/SobelFilter -e -ndeg 0 -wic 252 -k 0 > out_0_252_${I}.txt
#sudo mv out_0_252_${I}.txt "$DIR"
#sleep 5s
#done
#sudo mv timing_0_252.csv "$RDIR"
#echo "test 0 finished!"
#sleep 5s

#for NUMFAULTS in {1..32..7}
#for NUMFAULTS in 1 2 3 4 5 6 7 8 9 10 16 32

