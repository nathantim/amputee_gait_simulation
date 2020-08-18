#!/bin/sh

#simToRun="I2D"
#simToRun="I3D"
#simToRun="P2D"
simToRun="P3D"


#matlab -nosplash -nodisplay -nojvm -r < runOptFromScript.m
#matlab -batch "modelname = 'Prosthetic3R60_2D'; disp(modelname);"

if [ "$simToRun" = "I2D" ]; then
    echo "Model to run: Intact 2D."
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
	
	matlab -batch "modelname = 'IntactModel'; runOptFromScript"
	
elif [ "$simToRun" = "I3D" ]; then
	echo "Model to run: Intact 3D."
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
	
	matlab -batch "modelname = 'IntactModel3D'; runOptFromScript"
	
elif [ "$simToRun" = "P2D" ]; then
    echo "Model to run: Prosthetic 2D."
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
	
	matlab -batch "modelname = 'Prosthetic3R60_2D'; runOptFromScript"
	
elif [ "$simToRun" = "P3D" ]; then
	echo "Model to run: Prosthetic 3D."
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
	
	matlab -batch "modelname = 'Prosthetic3R60_3D'; runOptFromScript"
else
	echo "Unkown Simulation to run"
	
	#PBS -N Prosthetic3DTry
#PBS -l nodes=1:ppn=16

#PBS -q guest
#PBS -m ae
#PBS -o "Logfiles/out.$PBS_JOBNAME.$PBS_JOBID"
#PBS -e "Logfiles/err.$PBS_JOBNAME.$PBS_JOBID"

# Start job
module load devtoolset/6
module load matlab/2019b

cd $PBS_O_WORKDIR

#matlab -nosplash -nodisplay -nojvm -r < runOptFromScript.m
#matlab -batch "modelname = 'Prosthetic3R60_2D'; disp(modelname);"

#matlab -batch "modelname = 'IntactModel'; runOptFromScript"
#matlab -batch "modelname = 'IntactModel3D'; runOptFromScript"
#matlab -batch "modelname = 'Prosthetic3R60_2D'; runOptFromScript"
fi
