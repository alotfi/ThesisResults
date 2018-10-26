#!/bin/bash
echo "starting tests FastWalshTransform ..."
mkdir results_FastWalshTransform
DIR="results_FastWalshTransform/wic32"
mkdir "$DIR"
for COUNTER in {1..15}
do
    ./../FastWalshTransform/bin/x86_64/Release/FastWalshTransform -e -wic 32 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
for COUNTER in {16..30}
do
    ./../FastWalshTransform/bin/x86_64/Release/FastWalshTransform -e -wic 32 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
DIR="results_FastWalshTransform/wic64"
mkdir "$DIR"
for COUNTER in {1..15}
do
    ./../FastWalshTransform/bin/x86_64/Release/FastWalshTransform -e -wic 64 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
for COUNTER in {16..30}
do
    ./../FastWalshTransform/bin/x86_64/Release/FastWalshTransform -e -wic 64 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
DIR="results_FastWalshTransform/wic128"
mkdir "$DIR"
for COUNTER in {1..15}
do
    ./../FastWalshTransform/bin/x86_64/Release/FastWalshTransform -e -wic 128 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
for COUNTER in {16..30}
do
    ./../FastWalshTransform/bin/x86_64/Release/FastWalshTransform -e -wic 128 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done

