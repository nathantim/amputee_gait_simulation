#!/bin/sh

#PBS -N Prosthetic3DTry
#PBS -l nodes=1:ppn=16
#PBS -q guest
#PBS -m ae
#PBS -o "Logfiles/Prosthetic3D/out.$PBS_JOBNAME.$PBS_JOBID"
#PBS -e "Logfiles/Prosthetic3D/err.$PBS_JOBNAME.$PBS_JOBID"
	
# Start job
module load devtoolset/6
module load matlab/2019b

cd $PBS_O_WORKDIR

echo "Model to run: Prosthetic 3D."

export OMP_NUM_THREADS=16

#matlab -batch "modelname = 'Prosthetic3R60_3D'; disp(modelname);"
matlab -batch "modelname = 'Prosthetic3R60_3D'; runOptFromScript"
