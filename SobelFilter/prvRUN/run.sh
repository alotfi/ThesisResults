#!/bin/bash
echo "starting tests SobelFilter ..."
mkdir results_SobelFilter/
for NUMFAULTS in {1..30}
do
echo "test for $NUMFAULTS degraded elements ... "
mkdir results_SobelFilter/$NUMFAULTS
DIR="results_SobelFilter/$NUMFAULTS/wic256"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../SobelFilter/bin/x86_64/Release/SobelFilter -e -ndeg $NUMFAULTS -wic 256 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
for COUNTER in {6..10}
do
    ./../SobelFilter/bin/x86_64/Release/SobelFilter -e -ndeg $NUMFAULTS -wic 256 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
DIR="results_SobelFilter/$NUMFAULTS/wic128"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../SobelFilter/bin/x86_64/Release/SobelFilter -e -ndeg $NUMFAULTS -wic 128 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
for COUNTER in {6..10}
do
    ./../SobelFilter/bin/x86_64/Release/SobelFilter -e -ndeg $NUMFAULTS -wic 128 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
done
