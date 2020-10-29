# Neuromuscular-Transfemoral-Prosthesis-Model


This repository contains neuromuscular models of an amputee walking on a transfemoral prosthesis, containing the Otto Bock 3R60 knee prosthesis. 
The model is based on the work of:

-Song, S., & Geyer, H. (2015). A neural circuitry that emphasizes spinal feedback generates diverse behaviours of human locomotion. The Journal of physiology, 593(16), 3493-3511.
-Thatte, Nitish, and Hartmut Geyer. "Toward balance recovery with leg prostheses using neuromuscular model control." IEEE Transactions on Biomedical Engineering 63.5 (2016): 904-913.

The repository contains a 2D and 3D model of a healthy person and of a trans-femoral amputee.

To run one the models:

1. Run the setup_paths.m script.
2. Go to the folder for the model you wish to run.
3. Open the model
3. Load one of the optimizedGains.mat files in the Results folder
4. Select 'normal' or 'rapid-accelerator' mode in Simulink
5. Run evaluateCost.m
6. If 'normal' simulation mode is selected, the simulation is visualized. If 'rapid-accelerator' mode is selected, the simulation can be animated using animPost3D.
7. Simulation data can be plotted using the plotData() function.


Example of running animPost3D: 
animPost3D(animData3D,'intact',false,'speed',1,'followModel',true,'createVideo',true);
This will animate the model and keep the model in the middle of the figure. Also, a .avi video will be created. See the animPost3D function for all the specifics.

Example of running plotData: 
plotData(angularData,musculoData,GRFData,jointTorquesData,GaitPhaseData,stepTimes,'prosthetic3D',true,true,true);
This will show the kinematics, muscle activation, GRF, joint torques for the simulation. It will show the average data with standard deviation. As a reference winter data will be plotted for the sagittal data. This figure will be saved. See the plotData function for specifics.

This model is available for Academic or Non-Profit Organization Noncommercial research use only.

Compiler used: MEX configured to use 'Microsoft Visual C++ 2015 (C)' for C language compilation.
Model is numerically sensitive. Gains were obtained while sampling the data at 30 Hz. Changing this will change the evaluations. On flat terrain this does not differ too much, however, on rougher terrain it might result in an unsuccesful gait
