BodyMechParams
ControlParams
% prostheticParams

InitialGuess( 1) = LGainGAS;           
InitialGuess( 2) = LGainGLU;           
InitialGuess( 3) = LGainHAM;           
InitialGuess( 4) = LGainKneeOverExt;   
InitialGuess( 5) = LGainSOL;           
InitialGuess( 6) = LGainSOLTA;         
InitialGuess( 7) = LGainTA;            
InitialGuess( 8) = LGainVAS;           
InitialGuess( 9) = LKglu;              
InitialGuess(10) = LPosGainGG;         
InitialGuess(11) = LSpeedGainGG;       
InitialGuess(12) = LhipDGain;          
InitialGuess(13) = LhipPGain;          
InitialGuess(14) = LkneeExtendGain;    
InitialGuess(15) = LkneeFlexGain;      
InitialGuess(16) = LkneeHoldGain1;     
InitialGuess(17) = LkneeHoldGain2;     
InitialGuess(18) = LkneeStopGain;      
InitialGuess(19) = LlegAngleFilter;    
InitialGuess(20) = LlegLengthClr;              
InitialGuess(21) = RGainGLU;                  
InitialGuess(22) = RGainHAMCut;               
InitialGuess(23) = RKglu;              
InitialGuess(24) = RPosGainGG;         
InitialGuess(25) = RSpeedGainGG;       
InitialGuess(26) = RhipDGain;          
InitialGuess(27) = RhipPGain;          
InitialGuess(28) = RkneeExtendGain;    
InitialGuess(29) = RkneeFlexGain;      
InitialGuess(30) = RkneeHoldGain1;     
InitialGuess(31) = RkneeHoldGain2;     
InitialGuess(32) = RkneeStopGain;      
InitialGuess(33) = RlegAngleFilter;    
InitialGuess(34) = RlegLengthClr;      
InitialGuess(35) = simbiconGainD;     
InitialGuess(36) = simbiconGainV;     
InitialGuess(37) = simbiconLegAngle0;      
InitialGuess(38) = legAngleTgt;      

InitialGuess = InitialGuess';
save('InitialGuess.mat','InitialGuess')
