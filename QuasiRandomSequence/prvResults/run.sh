#!/bin/bash
echo "starting tests QuasiRandomSequence ..."
mkdir results_QuasiRandomSequence
for NUMFAULTS in {1..30}
do
echo "test for $NUMFAULTS degraded elements ... "
mkdir results_QuasiRandomSequence/$NUMFAULTS
DIR="results_QuasiRandomSequence/$NUMFAULTS/wic64"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../QuasiRandomSequence/bin/x86_64/Release/QuasiRandomSequence -e -ndeg $NUMFAULTS -wic 256 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
for COUNTER in {6..10}
do
    ./../QuasiRandomSequence/bin/x86_64/Release/QuasiRandomSequence -e -ndeg $NUMFAULTS -wic 256 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
DIR="results_QuasiRandomSequence/$NUMFAULTS/wic128"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../QuasiRandomSequence/bin/x86_64/Release/QuasiRandomSequence -e -ndeg $NUMFAULTS -wic 512 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
for COUNTER in {6..10}
do
    ./../QuasiRandomSequence/bin/x86_64/Release/QuasiRandomSequence -e -ndeg $NUMFAULTS -wic 512 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
DIR="results_QuasiRandomSequence/$NUMFAULTS/wic130"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../QuasiRandomSequence/bin/x86_64/Release/QuasiRandomSequence -e -ndeg $NUMFAULTS -wic 520 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
for COUNTER in {6..10}
do
    ./../QuasiRandomSequence/bin/x86_64/Release/QuasiRandomSequence -e -ndeg $NUMFAULTS -wic 520 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done

DIR="results_QuasiRandomSequence/$NUMFAULTS/wic192"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../QuasiRandomSequence/bin/x86_64/Release/QuasiRandomSequence -e -ndeg $NUMFAULTS -wic 768 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
for COUNTER in {6..10}
do
    ./../QuasiRandomSequence/bin/x86_64/Release/QuasiRandomSequence -e -ndeg $NUMFAULTS -wic 768 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
DIR="results_QuasiRandomSequence/$NUMFAULTS/wic256"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../QuasiRandomSequence/bin/x86_64/Release/QuasiRandomSequence -e -ndeg $NUMFAULTS -wic 1024 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
for COUNTER in {6..10}
do
    ./../QuasiRandomSequence/bin/x86_64/Release/QuasiRandomSequence -e -ndeg $NUMFAULTS -wic 1024 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
done
