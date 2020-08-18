#!/bin/sh

#PBS -N Intact2DTry
#PBS -l nodes=1:ppn=8
#PBS -q guest
#PBS -m ae
#PBS -o "Logfiles/Intact2D/out.$PBS_JOBNAME.$PBS_JOBID"
#PBS -e "Logfiles/Intact2D/err.$PBS_JOBNAME.$PBS_JOBID"

# Start job
module load devtoolset/6
module load matlab/2019b

cd $PBS_O_WORKDIR

echo "Model to run: Intact 2D."

export OMP_NUM_THREADS=8

#matlab -batch "modelname = 'IntactModel'; disp(modelname);"
matlab -batch "modelname = 'IntactModel'; runOptFromScript"