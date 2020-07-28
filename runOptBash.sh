#!/bin/sh

#PBS -N umb10_energy
#PBS -l nodes=1:ppn=1
#PBS -q guest
#PBS -m ae
#PBS -o out.$PBS_JOBID
#PBS -e err.$PBS_JOBID

# Start job
module load matlab/2019b
cd $PBS_O_WORKDIR
matlab -nosplash -nodisplay -nojvm < runOptFromScript.m
