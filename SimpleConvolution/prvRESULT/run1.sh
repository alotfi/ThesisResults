#!/bin/bash
echo "starting tests SimpleConvolution ..."
DIR="results_SimpleConvolution/wic256"
mkdir "$DIR"
for COUNTER in {1..15}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -wic 240  1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
for COUNTER in {16..30}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -wic 240 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done

