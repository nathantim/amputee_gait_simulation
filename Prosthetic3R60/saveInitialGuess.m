BodyMechParams
ControlParams

InitialGuess( 1) = GainGAS;
InitialGuess( 2) = GainGLU;           
InitialGuess( 3) = GainHAM;           
InitialGuess( 4) = GainKneeOverExt;   
InitialGuess( 5) = GainSOL;           
InitialGuess( 6) = GainSOLTA;         
InitialGuess( 7) = GainTA;            
InitialGuess( 8) = GainVAS;           
InitialGuess( 9) = Kglu;              
InitialGuess(10) = PosGainGG;         
InitialGuess(11) = SpeedGainGG;       
InitialGuess(12) = hipDGain;          
InitialGuess(13) = hipPGain;          
InitialGuess(14) = kneeExtendGain;    
InitialGuess(15) = kneeFlexGain;      
InitialGuess(16) = kneeHoldGain1;     
InitialGuess(17) = kneeHoldGain2;     
InitialGuess(18) = kneeStopGain;      
InitialGuess(19) = legAngleFilter;    
InitialGuess(20) = legLengthClr;      
InitialGuess(21) = simbiconGainD;     
InitialGuess(22) = simbiconGainV;     
InitialGuess(23) = simbiconLegAngle0;

InitialGuess = InitialGuess';
save('InitialGuess.mat','InitialGuess')
