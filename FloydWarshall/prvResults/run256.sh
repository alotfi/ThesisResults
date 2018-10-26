!/bin/bash
echo "starting tests FloydWarshall ..."
mkdir results_FloydWarshall
for NUMFAULTS in {11..30}
do
echo "test for $NUMFAULTS degraded elements ... "
mkdir results_FloydWarshall/$NUMFAULTS
DIR="results_FloydWarshall/$NUMFAULTS/wic16_default"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../FloydWarshall/bin/x86_64/Release/FloydWarshall -e -ndeg $NUMFAULTS -wic 16 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
for COUNTER in {6..10}
do
    ./../FloydWarshall/bin/x86_64/Release/FloydWarshall -e -ndeg $NUMFAULTS -wic 16 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
DIR="results_FloydWarshall/$NUMFAULTS/wic256"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../FloydWarshall/bin/x86_64/Release/FloydWarshall -e  -ndeg $NUMFAULTS -wic 64 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
for COUNTER in {6..10}
do
    ./../FloydWarshall/bin/x86_64/Release/FloydWarshall -e  -ndeg $NUMFAULTS -wic 64 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
done
