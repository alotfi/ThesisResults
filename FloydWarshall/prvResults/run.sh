!/bin/bash
echo "starting tests FloydWarshall ..."
mkdir results_FloydWarshall
for NUMFAULTS in {11..30}
do
echo "test for $NUMFAULTS degraded elements ... "
mkdir results_FloydWarshall/$NUMFAULTS
DIR="results_FloydWarshall/$NUMFAULTS/wic16"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../FloydWarshall/bin/x86_64/Release/FloydWarshall -e -ndeg $NUMFAULTS -wic 32 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 5s
done
for COUNTER in {6..10}
do
    ./../FloydWarshall/bin/x86_64/Release/FloydWarshall -e -ndeg $NUMFAULTS -wic 32 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 5s
done
DIR="results_FloydWarshall/$NUMFAULTS/wic64"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../FloydWarshall/bin/x86_64/Release/FloydWarshall -e  -ndeg $NUMFAULTS -wic 64 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 5s
done
for COUNTER in {6..10}
do
    ./../FloydWarshall/bin/x86_64/Release/FloydWarshall -e  -ndeg $NUMFAULTS -wic 64 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 5s
done
DIR="results_FloydWarshall/$NUMFAULTS/wic100"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../FloydWarshall/bin/x86_64/Release/FloydWarshall -e  -ndeg $NUMFAULTS -wic 80 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 5s
done
for COUNTER in {6..10}
do
    ./../FloydWarshall/bin/x86_64/Release/FloydWarshall -e  -ndeg $NUMFAULTS -wic 80 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 5s
done
DIR="results_FloydWarshall/$NUMFAULTS/wic196"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../FloydWarshall/bin/x86_64/Release/FloydWarshall -e  -ndeg $NUMFAULTS -wic 106 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 5s
done
for COUNTER in {6..10}
do
    ./../FloydWarshall/bin/x86_64/Release/FloydWarshall -e  -ndeg $NUMFAULTS -wic 106 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 5s
done
DIR="results_FloydWarshall/$NUMFAULTS/wic128"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../FloydWarshall/bin/x86_64/Release/FloydWarshall -e  -ndeg $NUMFAULTS -wic 256 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 5s
done
for COUNTER in {6..10}
do
    ./../FloydWarshall/bin/x86_64/Release/FloydWarshall -e  -ndeg $NUMFAULTS -wic 256 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 5s
done
done
