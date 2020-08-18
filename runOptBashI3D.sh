#!/bin/sh

#PBS -N Intact3DTry
#PBS -l nodes=1:ppn=16
#PBS -q guest
#PBS -m ae
#PBS -o "Logfiles/Intact3D/out.$PBS_JOBNAME.$PBS_JOBID"
#PBS -e "Logfiles/Intact3D/err.$PBS_JOBNAME.$PBS_JOBID"

# Start job
module load devtoolset/6
module load matlab/2019b

cd $PBS_O_WORKDIR

echo "Model to run: Intact 3D."

export OMP_NUM_THREADS=16

#matlab -batch "modelname = 'IntactModel3D'; disp(modelname);"
matlab -batch "modelname = 'IntactModel3D'; runOptFromScript"