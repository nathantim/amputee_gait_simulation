% ASSIGNINIT        Script that assigns the initial values from the initial conditions vector 
%%
setInitVar;

vxInit              = initConditionsSagittal(1); 
LphiHip0            = initConditionsSagittal(2);
LphiKnee0           = initConditionsSagittal(3); 
LphiAnkle0          = initConditionsSagittal(4); %
RphiHip0            = initConditionsSagittal(5);
RphiKnee0           = initConditionsSagittal(6); 
RphiAnkle0          = initConditionsSagittal(7); %

LTargetAngleInit    = initConditionsSagittal(8);
LPreStimHFLinit     = initConditionsSagittal(9);
LPreStimGLUinit     = initConditionsSagittal(10);
LPreStimHAMinit     = initConditionsSagittal(11);
LPreStimRFinit      = initConditionsSagittal(12);
LPreStimVASinit     = initConditionsSagittal(13);
LPreStimBFSHinit    = initConditionsSagittal(14);
LPreStimGASinit     = initConditionsSagittal(15);
LPreStimSOLinit     = initConditionsSagittal(16);
LPreStimTAinit      = initConditionsSagittal(17);

RTargetAngleInit    = initConditionsSagittal(18);
RPreStimHFLinit     = initConditionsSagittal(19);
RPreStimGLUinit     = initConditionsSagittal(20);
RPreStimHAMinit     = initConditionsSagittal(21);
RPreStimRFinit      = initConditionsSagittal(22);
RPreStimVASinit     = initConditionsSagittal(23);
RPreStimBFSHinit    = initConditionsSagittal(24);
RPreStimGASinit     = initConditionsSagittal(25);
RPreStimSOLinit     = initConditionsSagittal(26);
RPreStimTAinit      = initConditionsSagittal(27);

vyInit              = initConditionsCoronal(1);
rollInit            = initConditionsCoronal(2);
LphiHipR0           = initConditionsCoronal(3);
RphiHipR0           = initConditionsCoronal(4);
LTargetAngleRInit   = initConditionsCoronal(5);
LPreStimHABinit     = initConditionsCoronal(6);
LPreStimHADinit     = initConditionsCoronal(7);
RTargetAngleRInit   = initConditionsCoronal(8);
RPreStimHABinit     = initConditionsCoronal(9);
RPreStimHADinit     = initConditionsCoronal(10);