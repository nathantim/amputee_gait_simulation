# Neuromuscular-Transfemoral-Prosthesis-Model

The repository contains a 3D neuromuscular model of
1. a healthy person 
2. a trans-femoral amputee wearing the Otto Bock 3R60 knee prosthesis
3. a trans-femoral amputee wearing the Otto Bock 3R60 knee prosthesis with CMG embedded in the prosthetic shank

The model is based on the work of:
- Song, S., & Geyer, H. (2015). A neural circuitry that emphasizes spinal feedback generates diverse behaviours of human locomotion. The Journal of physiology, 593(16), 3493-3511.
- Thatte, Nitish, and Hartmut Geyer. "Toward balance recovery with leg prostheses using neuromuscular model control." IEEE Transactions on Biomedical Engineering 63.5 (2016): 904-913.

## Demo
You can run `DEMO.m`. This demo script allows you to plot and/or animate results. The results can be obtained through simulation, or by just loading the data included in the repository.
Note: the simulation will take some time (30-60 min). Also the model is numerically sensitive, especially the trip prevention simulation. This means that when simulating the model on your computer it can obtain a different, maybe even unsuccessful, result.

## Running a model

1. Run the `setup_paths.m` script.
2. Go to the folder for the model you wish to run.
3. Open the model
4. Load one of the optimizedGains.mat files in the Results folder
5. Select 'normal' or 'rapid-accelerator' mode in Simulink
6. Run `evaluateCost.m`
7. If 'normal' simulation mode is selected, the simulation is visualized. If 'rapid-accelerator' mode is selected, the simulation can be animated using `animPost3D()`.
8. Simulation data can be plotted using the `plotData()` function.


## Optimizing the model

1. Run the `setup_paths.m` script.
2. Go to the folder for the model you wish to optimize.
3. Open `optimize.m`
4. Select the disired initial gains 
5. Check if the settings are as you wish in `setInnerOptSettings`
6. Select which data you want to have plotted during optimization in `plotProgressOptimization`
7. Run `optimize.m`

## Animating the data
* `animPost3D` function. See the `animPost3D` function for all the options and specifics.
* Example of running animPost3D: 
  * `animPost3D(simout(1).animData3D,'intact',false)`
    * Shows an animation of the simulated amputee model
  * `animPost3D(simout(1).animData3D,'intact',false,'speed',1,'obstacle',true,'view','side','CMG',true,'showFigure',true,'createVideo',true,'info','prosthetic1.2ms','saveLocation','Videos');`
    * Shows an animation of the simulated amputee model walking with CMG and tripping over obstacle. A mp4 file is created and saved. The filename contains prosthetic1.2ms and it is saved in a subfolder called Videos located in the current directory	

## Plotting the data:
* `plotData` function. Check the function for all the options and specifics
* GaitPhaseData and stepTimes are required. Other data sets are optional for plotting
* Example of running plotData: 
  * `plotData(simout(1).GaitPhaseData,simout(1).stepTimes,simout, 'angularData',simout(1).angularData, 'musculoData',simout(1).musculoData, 'GRFData',simout(1).GRFData, 'jointTorquesData',simout(1).jointTorquesData, 'CMGData',simout(1).CMGData,'prosthetic3D_1.2ms_yaw',[7 10],0,1,1,0);`
    * Shows the data between 7 and 10 seconds
  * `plotData(simout(1).GaitPhaseData,simout(1).stepTimes,simout, 'angularData',simout(1).angularData, 'musculoData',simout(1).musculoData, 'GRFData',simout(1).GRFData, 'jointTorquesData',simout(1).jointTorquesData, 'CMGData',simout(1).CMGData,'prosthetic3D_1.2ms_yaw',[],1,1,1);`
    * Shows and saves the data. Presented as average data and standard deviation per stride. Saved filename contains prosthetic3D_1.2ms_yaw


## Notes:
* Compilers used: 
  * MEX configured to use 'Microsoft Visual C++ 2015 (C)' for C language compilation.
  * CompilerConfiguration with properties:
    * Name: 'Microsoft Visual C++ 2015 (C)'
    * Manufacturer: 'Microsoft'
    * Language: 'C'
    * Version: '14.0'
  * MEX configured to use 'Microsoft Visual C++ 2017' for C++ language compilation.
  * CompilerConfiguration with properties: 
    * Name: 'Microsoft Visual C++ 2017'
    * Manufacturer: 'Microsoft'
    * Language: 'C++'
    * Version: '15.0'
* Model is numerically sensitive. 
  * Gains were obtained while sampling the data at 30 Hz. Changing this will change the evaluations. 
  * On flat terrain this does not differ too much, however, on rougher terrain it might result in an unsuccesful gait.
  * Adding integrator blocks will also affect the outcome, since the solver variable step takes different amount of steps.
	

This model is available for Academic or Non-Profit Organization Noncommercial research use only.
