#!/bin/bash
echo "starting tests BlackScholes ..."
mkdir results_BlackScholes
DIR="results_BlackScholes/wic64"
mkdir "$DIR"
for COUNTER in {1..15}
do
    ./../BlackScholes/bin/x86_64/Release/BlackScholes -e -wic 59 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
for COUNTER in {16..30}
do
    ./../BlackScholes/bin/x86_64/Release/BlackScholes -e -wic 59 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
DIR="results_BlackScholes/wic128"
mkdir "$DIR"
for COUNTER in {1..15}
do
    ./../BlackScholes/bin/x86_64/Release/BlackScholes -e -wic 119 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
for COUNTER in {16..30}
do
    ./../BlackScholes/bin/x86_64/Release/BlackScholes -e -wic 119 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
DIR="results_BlackScholes/wic192"
mkdir "$DIR"
for COUNTER in {1..15}
do
    ./../BlackScholes/bin/x86_64/Release/BlackScholes -e -wic 179 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
for COUNTER in {16..30}
do
    ./../BlackScholes/bin/x86_64/Release/BlackScholes -e -wic 179 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
DIR="results_BlackScholes/wic256"
mkdir "$DIR"
for COUNTER in {1..15}
do
    ./../BlackScholes/bin/x86_64/Release/BlackScholes -e -wic 240 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
for COUNTER in {16..30}
do
    ./../BlackScholes/bin/x86_64/Release/BlackScholes -e -wic 240 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done

