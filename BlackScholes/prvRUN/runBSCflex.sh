#!/bin/bash
echo "starting tests BlackScholes..."
mkdir results_BlackScholes/
for NUMFAULTS in {1..30}
do
echo "test for $NUMFAULTS degraded elements ... "
mkdir results_BlackScholes/$NUMFAULTS
DIR="results_BlackScholes/$NUMFAULTS/wic54"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../BlackScholes/bin/x86_64/Release/BlackScholes -e -ndeg $NUMFAULTS -wic 59 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
for COUNTER in {6..10}
do
    ./../BlackScholes/bin/x86_64/Release/BlackScholes -e -ndeg $NUMFAULTS -wic 59 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
DIR="results_BlackScholes/$NUMFAULTS/wic117"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../BlackScholes/bin/x86_64/Release/BlackScholes -e -ndeg $NUMFAULTS -wic 119 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
sleep 10s
for COUNTER in {6..10}
do
    ./../BlackScholes/bin/x86_64/Release/BlackScholes -e -ndeg $NUMFAULTS -wic 119 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
DIR="results_BlackScholes/$NUMFAULTS/wic189"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../BlackScholes/bin/x86_64/Release/BlackScholes -e -ndeg $NUMFAULTS -wic 174 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
sleep 10s
for COUNTER in {6..10}
do
    ./../BlackScholes/bin/x86_64/Release/BlackScholes -e -ndeg $NUMFAULTS -wic 174 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
DIR="results_BlackScholes/$NUMFAULTS/wic239"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../BlackScholes/bin/x86_64/Release/BlackScholes -e -ndeg $NUMFAULTS -wic 200 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
sleep 10s
for COUNTER in {6..10}
do
    ./../BlackScholes/bin/x86_64/Release/BlackScholes -e -ndeg $NUMFAULTS -wic 200 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
done

