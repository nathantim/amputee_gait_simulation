# Neuromuscular-Transfemoral-Prosthesis-Model


This repository contains neuromuscular models of an amputee walking on a transfemoral prosthesis. 
These models were used to obtain the results presented in: 

Thatte, Nitish, and Hartmut Geyer. "Toward balance recovery with leg prostheses using neuromuscular model control." IEEE Transactions on Biomedical Engineering 63.5 (2016): 904-913.

To run one the models:

1. Add the root folder and the Animation and Prosthesis folders to your Matlab Path.
2. Go to the folder for the model you wish to run.
3. Load one of the optimizedGains.mat files in the Results folder
4. Run assignGains.m
5. Run the model
6. Animate the result by calling animPost(animData). The animPost function has several options, check them out by opening animPost.m in the Animations folder.

This model is available for Academic or Non-Profit Organization Noncommercial research use only.
