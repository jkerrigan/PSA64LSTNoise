#!/bin/bash

data='/users/jkerriga/data/jkerriga/LST/Day'
dlist=' '
for i in 2 4 8 16 32 64 128; do
    echo $data${i}'/*.npz'
    dlist=$dlist$data${i}'/*.npz '
done
echo $dlist
python PlotbyLST.py $dlist