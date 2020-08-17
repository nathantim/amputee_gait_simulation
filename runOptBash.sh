#!/bin/sh

#PBS -N rtw_build_test
#PBS -l nodes=1:ppn=4
#PBS -q guest
#PBS -m ae
#PBS -o out.$PBS_JOBID
#PBS -e err.$PBS_JOBID

# Start job
module load devtoolset/6
module load matlab/2019b

cd $PBS_O_WORKDIR
#matlab -nosplash -nodisplay -nojvm -r < runOptFromScript.m
matlab -batch "runOptFromScript"
