#!/bin/bash
echo "starting tests FastWalshTransform ..."
mkdir results_FastWalshTransform
for NUMFAULTS in {1..20}
do
echo "test for $NUMFAULTS degraded elements ... "
mkdir results_FastWalshTransform/$NUMFAULTS
DIR="results_FastWalshTransform/$NUMFAULTS/wic128"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../FastWalshTransform/bin/x86_64/Release/FastWalshTransform -e -ndeg $NUMFAULTS -wic 256 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
for COUNTER in {6..10}
do
    ./../FastWalshTransform/bin/x86_64/Release/FastWalshTransform -e -ndeg $NUMFAULTS -wic 256 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
DIR="results_FastWalshTransform/$NUMFAULTS/wic256"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../FastWalshTransform/bin/x86_64/Release/FastWalshTransform -e -ndeg $NUMFAULTS -wic 512 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
for COUNTER in {6..10}
do
    ./../FastWalshTransform/bin/x86_64/Release/FastWalshTransform -e -ndeg $NUMFAULTS -wic 512 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
done
