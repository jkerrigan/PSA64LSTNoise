#!/bin/bash

data='/users/jkerriga/scratch/Day'
dlist=' '
ct=0
for i in 2 4 8 16 32 64 128; do
    #if [[ $i -eq 150 ]];then
    #i=128
    #fi
    for j in $(seq 0 ${i} $((128-${i})));do
    #echo $data${i}
    echo $j
    cd ~/scratch/Day${i}/Day${i}_${j}/
    if [ -e pspec_*.npz ]; then
	ct=$(($ct+1))
	dlist=$dlist$data${i}/Day${i}_${j}/'pspec_*.npz '
    fi
    done
    cd ~/scratch/Day${i}/
    python ~/PSA64Noise/LSTStats.py $i $dlist
    dlist=' '
    ct=0
done
echo $dlist
echo $ct

npzlist=' '
for n in 2 4 8 16 32 64 128; do
    cd ~/scratch/Day${n}/
    echo $n
    if [ -e Day*.npz ]; then
    npzlist=$npzlist$data${n}/Day'*.npz '
    fi
done
echo 'THIS IS THE NPZ LIST',$npzlist
cd ~/PSA64Noise/
python ~/PSA64Noise/PlotbyLST.py $npzlist