#! /bin/bash
#SBATCH -t 4:00:00 
#SBATCH --array=0-112:16
######SBATCH -n 40
#SBATCH --ntasks=2
#SBATCH --mem=6G                                                            
#SBATCH -J NoisePipe
#SBATCH -o NoisePipe_%a.out
#SBATCH -e NoisePipe_%a.out
####
#### For use with SLURM, LST bins according to day, by cutting up
#### all observation days into LST chunks e.g. if you have 100 days of
#### data, you can LST bin by 25 days, so you have 4 sets of LST'ed data


source activate PAPER
N=16
#####SLURM_ARRAY_TASK_ID=0
start=$SECONDS
CALFILE=psa6240_v003
LSTS=`python -c "import numpy as n; hr = 1.0; print ' '.join(['%f_%f' % (d,d+hr/4.) for d in n.arange(0,24.0*hr,hr/4.)])"`       
#LSTS='0.000000_0.250000 0.250000_0.500000'
MY_LSTS=`~/capo/scripts/pull_args.py $LSTS`
echo $MY_LSTS
trap "exit" INT
chk='True'
#if [ chk == 'True' ];then
### Set end  # of days to bin
i=$N
minDay=$(( 242+${SLURM_ARRAY_TASK_ID} ))
scripts=~/capo/mjk/scripts
#LSTDir=/users/jkerriga/data/jkerriga/LST
#cd $LSTDir
ct=0
#while [ ${i} -le $((${nDays})) ]; do
    LSTDir=/users/jkerriga/scratch/Day$N
    cd $LSTDir
    #mkdir Day$i
    echo 'Day2:' $i
    #cd $LSTDir/Day$i
    mkdir Day${N}_${SLURM_ARRAY_TASK_ID}
    cd Day${N}_${SLURM_ARRAY_TASK_ID}
    #### Find how to separate by geometric days #####
    even=" /users/jkerriga/data/jkerriga/"
    odd=" /users/jkerriga/data/jkerriga/"
    lsteven=''
    lstodd=''
    echo $minDay,$(( $minDay + $i -1 ))
    #echo $(( $minDay + $i ))
    ### Build lists for even odd data locations for lst binning
    for j in $(seq $minDay $(( $minDay + $i -1 ))); do
	if [ ! -f ~/data/jkerriga/zen.2456${j}.*.uvcRREcACOcPBRA ]; then
	    echo "No data for Day ${j}"
	else
	    ct=$(( $ct + 1 )) 
	    echo ${j}
	    if [ $(($j%2)) -ne 0 ]; then
		lstodd=$lstodd$odd'zen.*'${j}'.*.*A'
	    else
		lsteven=$lsteven$even'zen.*'${j}'.*.*A'
	    fi
	fi
    done
    echo $ct,' Number of valid days found.'
    #echo $lstodd
    #echo $lsteven
    ### Begin to lst bin ###    
    #echo $MY_LSTS
    for LST in $MY_LSTS; do
	echo Working on $LST
	#echo /usr/global/paper/capo/scripts/lstbin_v02.py -a cross -C ${CALFILE} -s Sun --lst_res=42.95 --lst_rng=$LST --tfile=600 --altmax=0 --stats=all --median --nsig=3 $lsteven
	$scripts/lstbin_v02.py -a cross -C ${CALFILE} -s Sun --lst_res=42.95 --lst_rng=$LST --tfile=600 --altmax=0 --stats=all --median --nsig=3 $lsteven
        $scripts/lstbin_v02.py -a cross -C ${CALFILE} -s Sun --lst_res=42.95 --lst_rng=$LST --tfile=600 --altmax=0 --stats=all --median --nsig=3 $lstodd
    done;
    
    ## Apply giannia bandpass filter...check scripts name arguments etc
    ~/capo/scripts/apply_bandpass_psa64.py -C psa6240_v003 *.uv
    
    evenodd='even odd'
    ## Pull and separate the files
    for n in $evenodd; do
	mkdir $n
	mkdir $n/sep{-1,0,1},1
	for m in {-1,0,1}; do
	    bls=$(python /users/jkerriga/capo/mjk/scripts/getbls.py -C psa6240_v003 --sep=${m},1 "/users/jkerriga/data/jkerriga/zen.2456307.61226.uvcRREcACOcPBRA")
	    if [ ${n} == 'even' ]; then
		
		/users/jkerriga/capo/scripts/pull_antpols.py -a ${bls} lst.*[02468].*.*.uvG
            else
     		/users/jkerriga/capo/scripts/pull_antpols.py -a ${bls} lst.*[13579].*.*.uvG
            fi
	    cp -r *A /users/jkerriga/scratch/Day${N}/Day${N}_${SLURM_ARRAY_TASK_ID}/${n}/sep${m},1/
	    rm -r *A
	    #if [ $N == 2 ] && [ $n == 'even' ]; then
	#	rm -r /users/jkerriga/scratch/Day${N}/Day${N}_${SLURM_ARRAY_TASK_ID}/${n}/sep${m},1/lst.*.6[45]*.17387.uvGA
	    #fi
	done
    done
    
    ## FRINGE RATE FILTER ##
    ## Move to Day N directory ##
    cd ~/scratch/Day${N}/Day${N}_${SLURM_ARRAY_TASK_ID}
    cp ~/PSA64Noise/batch_frf_filter.sh ~/scratch/Day${N}/Day${N}_${SLURM_ARRAY_TASK_ID}/
    sh batch_frf_filter.sh 
#fi
    cd ~/scratch/Day${N}/Day${N}_${SLURM_ARRAY_TASK_ID}
    cp ~/PSA64Noise/mk_psa64_pspec.sh ~/scratch/Day${N}/Day${N}_${SLURM_ARRAY_TASK_ID}/
    cp ~/PSA64Noise/pspec_psa64.cfg ~/scratch/Day${N}/Day${N}_${SLURM_ARRAY_TASK_ID}/
    cp ~/PSA64Noise/findLSTrng.py ~/scratch/Day${N}/Day${N}_${SLURM_ARRAY_TASK_ID}/
    rm -r ~/scratch/Day${N}/Day${N}_${SLURM_ARRAY_TASK_ID}/PSPEC
    ./mk_psa64_pspec.sh pspec_psa64.cfg
    rm -r ~/scratch/Day${N}/Day${N}_${SLURM_ARRAY_TASK_ID}/lst*.uv*
    rm -r ~/scratch/Day${N}/Day${N}_${SLURM_ARRAY_TASK_ID}/even/sep{-1,0,1},1/lst*.uvGA
    rm -r ~/scratch/Day${N}/Day${N}_${SLURM_ARRAY_TASK_ID}/odd/sep{-1,0,1},1/lst*.uvGA
    #i=$(( ${i} + ${SLURM_ARRAY_TASK_ID} ))
    #minDay=$(( ${minDay} + ${SLURM_ARRAY_TASK_ID} ))
done   


    ## Go to next geometric day in the series ##
#    i=$((${i}*2))

#done

#duration=$(( SECONDS - start ))
#echo duration