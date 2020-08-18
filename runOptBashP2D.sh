#!/bin/sh

#PBS -N Prosthetic2DTry
#PBS -l nodes=1:ppn=16
#PBS -q guest
#PBS -m ae
#PBS -o "Logfiles/Prosthetic2D/out.$PBS_JOBNAME.$PBS_JOBID"
#PBS -e "Logfiles/Prosthetic2D/err.$PBS_JOBNAME.$PBS_JOBID"

# Start job
module load devtoolset/6
module load matlab/2019b

cd $PBS_O_WORKDIR

echo "Model to run: Prosthetic 2D."

export OMP_NUM_THREADS=16

#matlab -batch "modelname = 'Prosthetic3R60_2D'; disp(modelname);"
matlab -batch "modelname = 'Prosthetic3R60_2D'; runOptFromScript"