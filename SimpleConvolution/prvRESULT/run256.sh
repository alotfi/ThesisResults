#!/bin/bash
echo "starting tests SimpleConvolution..."
mkdir results_SimpleConvolution/
for NUMFAULTS in {1..30}
do
echo "test for $NUMFAULTS degraded elements ... "
mkdir results_SimpleConvolution/$NUMFAULTS
DIR="results_SimpleConvolution/$NUMFAULTS/wic256"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg $NUMFAULTS -wic 256 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
sleep 10s
for COUNTER in {6..10}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg $NUMFAULTS -wic 256 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
done
