#!/bin/bash
echo "starting tests SimpleConvolution..."
mkdir results_SimpleConvolution/
mkdir results_SimpleConvolution/1F_SC
DIR="results_SimpleConvolution/1F_SC/wic54"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 1 -wic 56 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
for COUNTER in {6..10}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 1 -wic 56 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
DIR="results_SimpleConvolution/1F_SC/wic117"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 1 -wic 111 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
sleep 10s
for COUNTER in {6..10}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 1 -wic 111 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
DIR="results_SimpleConvolution/1F_SC/wic189"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 1 -wic 168 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
sleep 10s
for COUNTER in {6..10}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 1 -wic 168 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
DIR="results_SimpleConvolution/1F_SC/wic239"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 1 -wic 225 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
sleep 10s
for COUNTER in {6..10}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 1 -wic 225 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
mkdir results_SimpleConvolution/2F_SC
DIR="results_SimpleConvolution/2F_SC/wic54"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 2 -wic 56 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
for COUNTER in {6..10}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 2 -wic 56 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
DIR="results_SimpleConvolution/2F_SC/wic117"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 2 -wic 111 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
sleep 10s
for COUNTER in {6..10}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 2 -wic 111 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
DIR="results_SimpleConvolution/2F_SC/wic189"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 2 -wic 168 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
sleep 10s
for COUNTER in {6..10}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 2 -wic 168 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
DIR="results_SimpleConvolution/2F_SC/wic239"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 2 -wic 225 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
sleep 10s
for COUNTER in {6..10}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 2 -wic 225 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
mkdir results_SimpleConvolution/3F_SC
DIR="results_SimpleConvolution/3F_SC/wic54"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 3 -wic 56 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
for COUNTER in {6..10}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 3 -wic 56 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
DIR="results_SimpleConvolution/3F_SC/wic117"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 3 -wic 111 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
sleep 10s
for COUNTER in {6..10}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 3 -wic 111 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
DIR="results_SimpleConvolution/3F_SC/wic189"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 3 -wic 168 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
sleep 10s
for COUNTER in {6..10}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 3 -wic 168 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
DIR="results_SimpleConvolution/3F_SC/wic239"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 3 -wic 225 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
sleep 10s
for COUNTER in {6..10}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 3 -wic 225 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
mkdir results_SimpleConvolution/4F_SC
DIR="results_SimpleConvolution/4F_SC/wic54"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 4 -wic 56 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
for COUNTER in {6..10}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 4 -wic 56 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
DIR="results_SimpleConvolution/4F_SC/wic117"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 4 -wic 111 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
sleep 10s
for COUNTER in {6..10}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 4 -wic 111 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
DIR="results_SimpleConvolution/4F_SC/wic189"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 4 -wic 168 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
sleep 10s
for COUNTER in {6..10}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 4 -wic 168 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
DIR="results_SimpleConvolution/4F_SC/wic239"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 4 -wic 225 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
sleep 10s
for COUNTER in {6..10}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 4 -wic 225 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
mkdir results_SimpleConvolution/5F_SC
DIR="results_SimpleConvolution/5F_SC/wic54"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 5 -wic 56 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
for COUNTER in {6..10}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 5 -wic 56 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
DIR="results_SimpleConvolution/5F_SC/wic117"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 5 -wic 111 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
sleep 10s
for COUNTER in {6..10}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 5 -wic 111 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
DIR="results_SimpleConvolution/5F_SC/wic189"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 5 -wic 168 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
sleep 10s
for COUNTER in {6..10}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 5 -wic 168 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
DIR="results_SimpleConvolution/5F_SC/wic239"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 5 -wic 225 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
sleep 10s
for COUNTER in {6..10}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 5 -wic 225 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
mkdir results_SimpleConvolution/6F_SC
DIR="results_SimpleConvolution/6F_SC/wic54"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 6 -wic 56 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
for COUNTER in {6..10}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 6 -wic 56 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
DIR="results_SimpleConvolution/6F_SC/wic117"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 6 -wic 111 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
sleep 10s
for COUNTER in {6..10}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 6 -wic 111 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
DIR="results_SimpleConvolution/6F_SC/wic189"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 6 -wic 168 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
sleep 10s
for COUNTER in {6..10}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 6 -wic 168 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
DIR="results_SimpleConvolution/6F_SC/wic239"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 6 -wic 225 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
sleep 10s
for COUNTER in {6..10}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 6 -wic 225 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
mkdir results_SimpleConvolution/7F_SC
DIR="results_SimpleConvolution/7F_SC/wic54"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 7 -wic 56 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
for COUNTER in {6..10}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 7 -wic 56 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
DIR="results_SimpleConvolution/7F_SC/wic117"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 7 -wic 111 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
sleep 10s
for COUNTER in {6..10}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 7 -wic 111 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
DIR="results_SimpleConvolution/7F_SC/wic189"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 7 -wic 168 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
sleep 10s
for COUNTER in {6..10}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 7 -wic 168 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
DIR="results_SimpleConvolution/7F_SC/wic239"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 7 -wic 225 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
sleep 10s
for COUNTER in {6..10}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 7 -wic 225 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
mkdir results_SimpleConvolution/8F_SC
DIR="results_SimpleConvolution/8F_SC/wic54"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 8 -wic 56 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
for COUNTER in {6..10}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 8 -wic 56 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
DIR="results_SimpleConvolution/8F_SC/wic117"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 8 -wic 111 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
sleep 10s
for COUNTER in {6..10}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 8 -wic 111 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
DIR="results_SimpleConvolution/8F_SC/wic189"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 8 -wic 168 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
sleep 10s
for COUNTER in {6..10}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 8 -wic 168 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
DIR="results_SimpleConvolution/8F_SC/wic239"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 8 -wic 225 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
sleep 10s
for COUNTER in {6..10}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 8 -wic 225 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
mkdir results_SimpleConvolution/9F_SC
DIR="results_SimpleConvolution/9F_SC/wic54"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 9 -wic 56 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
for COUNTER in {6..10}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 9 -wic 56 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
DIR="results_SimpleConvolution/9F_SC/wic117"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 9 -wic 111 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
sleep 10s
for COUNTER in {6..10}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 9 -wic 111 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
DIR="results_SimpleConvolution/9F_SC/wic189"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 9 -wic 168 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
sleep 10s
for COUNTER in {6..10}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 9 -wic 168 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
DIR="results_SimpleConvolution/9F_SC/wic239"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 9 -wic 225 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
sleep 10s
for COUNTER in {6..10}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 9 -wic 225 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
mkdir results_SimpleConvolution/10F_SC
DIR="results_SimpleConvolution/10F_SC/wic54"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 10 -wic 56 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
for COUNTER in {6..10}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 10 -wic 56 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
DIR="results_SimpleConvolution/10F_SC/wic117"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 10 -wic 111 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
sleep 10s
for COUNTER in {6..10}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 10 -wic 111 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
DIR="results_SimpleConvolution/10F_SC/wic189"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 10 -wic 168 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
sleep 10s
for COUNTER in {6..10}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 10 -wic 168 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
DIR="results_SimpleConvolution/10F_SC/wic239"
mkdir "$DIR"
for COUNTER in {1..5}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 10 -wic 225 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done
sleep 10s
for COUNTER in {6..10}
do
    ./../SimpleConvolution/bin/x86_64/Release/SimpleConvolution -e -ndeg 10 -wic 225 -k 1>out$COUNTER.txt
    sudo mv out$COUNTER.txt "$DIR"
    echo "test $COUNTER finished!"
    sleep 10s
done

