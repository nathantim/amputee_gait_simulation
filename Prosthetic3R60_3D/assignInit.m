% ASSIGNINIT        Script that assigns initial condition values from the initial condition vectors
%%
setInitVar;

vxInit              = initConditionsSagittal(1); 
LphiHip0            = initConditionsSagittal(2);
LphiKnee0           = initConditionsSagittal(3); 
LphiAnkle0          = initConditionsSagittal(4); %
RphiHip0            = initConditionsSagittal(5);

LTargetAngleInit    = initConditionsSagittal(6);
LPreStimHFLinit     = initConditionsSagittal(7);
LPreStimGLUinit     = initConditionsSagittal(8);
LPreStimHAMinit     = initConditionsSagittal(9);
LPreStimRFinit      = initConditionsSagittal(10);
LPreStimVASinit     = initConditionsSagittal(11);
LPreStimBFSHinit    = initConditionsSagittal(12);
LPreStimGASinit     = initConditionsSagittal(13);
LPreStimSOLinit     = initConditionsSagittal(14);
LPreStimTAinit      = initConditionsSagittal(15);

RTargetAngleInit    = initConditionsSagittal(16);
RPreStimHFLinit     = initConditionsSagittal(17);
RPreStimGLUinit     = initConditionsSagittal(18);
RPreStimHAMinit     = initConditionsSagittal(19);
RPreStimRFinit      = initConditionsSagittal(20);

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