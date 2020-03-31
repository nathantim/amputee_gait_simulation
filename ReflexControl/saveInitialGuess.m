BodyMechParams
ControlParams
prostheticParams

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
InitialGuess(21) = RGainGAS;           
InitialGuess(22) = RGainGLU;           
InitialGuess(23) = RGainHAM;           
InitialGuess(24) = RGainHAMCut;        
InitialGuess(25) = RGainKneeOverExt;   
InitialGuess(26) = RGainSOL;           
InitialGuess(27) = RGainSOLTA;         
InitialGuess(28) = RGainTA;            
InitialGuess(29) = RGainVAS;           
InitialGuess(30) = RKglu;              
InitialGuess(31) = RPosGainGG;         
InitialGuess(32) = RSpeedGainGG;       
InitialGuess(33) = RhipDGain;          
InitialGuess(34) = RhipPGain;          
InitialGuess(35) = RkneeExtendGain;    
InitialGuess(36) = RkneeFlexGain;      
InitialGuess(37) = RkneeHoldGain1;     
InitialGuess(38) = RkneeHoldGain2;     
InitialGuess(39) = RkneeStopGain;      
InitialGuess(40) = RlegAngleFilter;    
InitialGuess(41) = RlegLengthClr;      
InitialGuess(42) = simbiconGainD;     
InitialGuess(43) = simbiconGainV;     
InitialGuess(44) = simbiconLegAngle0; 
InitialGuess(45) = anklePgain;         
InitialGuess(46) = ankleDgain;         
InitialGuess(47) = ankleFilterPID;     
InitialGuess(48) = ankleFilterSEA;     
InitialGuess(49) = kneePgain;          
InitialGuess(50) = kneeDgain;          
InitialGuess(51) = kneeFilterPID;      
InitialGuess(52) = kneeFilterSEA;      
InitialGuess(53) = legAngleTgt;      

InitialGuess = InitialGuess';
save('InitialGuess.mat','InitialGuess')
