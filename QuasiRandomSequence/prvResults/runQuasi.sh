#!/bin/bash
echo "starting tests QuasiRandomSequence ..."
mkdir results_QuasiRandomSequence
DIR="results_QuasiRandomSequence/wic64"
mkdir "$DIR"
for COUNTER in {1..10}
do
    ./../QuasiRandomSequence/bin/x86_64/Release/QuasiRandomSequence -e -wic 238 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
for COUNTER in {11..20}
do
    ./../QuasiRandomSequence/bin/x86_64/Release/QuasiRandomSequence -e -wic 238 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
DIR="results_QuasiRandomSequence/wic128"
mkdir "$DIR"
for COUNTER in {1..10}
do
    ./../QuasiRandomSequence/bin/x86_64/Release/QuasiRandomSequence -e -wic 478 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
for COUNTER in {11..20}
do
    ./../QuasiRandomSequence/bin/x86_64/Release/QuasiRandomSequence -e -wic 478 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
DIR="results_QuasiRandomSequence/wic192"
mkdir "$DIR"
for COUNTER in {1..10}
do
    ./../QuasiRandomSequence/bin/x86_64/Release/QuasiRandomSequence -e -wic 718 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
for COUNTER in {11..20}
do
    ./../QuasiRandomSequence/bin/x86_64/Release/QuasiRandomSequence -e -wic 718 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
DIR="results_QuasiRandomSequence/wic256"
mkdir "$DIR"
for COUNTER in {1..10}
do
    ./../QuasiRandomSequence/bin/x86_64/Release/QuasiRandomSequence -e -wic 960 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
for COUNTER in {11..20}
do
    ./../QuasiRandomSequence/bin/x86_64/Release/QuasiRandomSequence -e -wic 960 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done

