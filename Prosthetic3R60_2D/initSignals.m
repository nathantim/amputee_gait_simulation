LTargetAnglesigIn = Simulink.Signal;
LTargetAnglesigIn.StorageClass = 'ExportedGlobal';
LTargetAnglesigIn.InitialValue = 'LTargetAngleInit';
LTargetAnglesigOut = copy(LTargetAnglesigIn);

LStimHFLsigIn = Simulink.Signal;
LStimHFLsigIn.StorageClass = 'ExportedGlobal';
LStimHFLsigIn.InitialValue = 'LPreStimHFLinit';
LStimHFLsigOut = copy(LStimHFLsigIn);

LStimGLUsigIn = Simulink.Signal;
LStimGLUsigIn.StorageClass = 'ExportedGlobal';
LStimGLUsigIn.InitialValue = 'LPreStimGLUinit';
LStimGLUsigOut = copy(LStimGLUsigIn);

LStimHAMsigIn = Simulink.Signal;
LStimHAMsigIn.StorageClass = 'ExportedGlobal';
LStimHAMsigIn.InitialValue = 'LPreStimHAMinit';
LStimHAMsigOut = copy(LStimHAMsigIn);

LStimRFsigIn = Simulink.Signal;
LStimRFsigIn.StorageClass = 'ExportedGlobal';
LStimRFsigIn.InitialValue = 'LPreStimRFinit';
LStimRFsigOut = copy(LStimRFsigIn);

LStimVASsigIn = Simulink.Signal;
LStimVASsigIn.StorageClass = 'ExportedGlobal';
LStimVASsigIn.InitialValue = 'LPreStimVASinit';
LStimVASsigOut = copy(LStimVASsigIn);

LStimBFSHsigIn = Simulink.Signal;
LStimBFSHsigIn.StorageClass = 'ExportedGlobal';
LStimBFSHsigIn.InitialValue = 'LPreStimBFSHinit';
LStimBFSHsigOut = copy(LStimBFSHsigIn);

LStimGASsigIn = Simulink.Signal;
LStimGASsigIn.StorageClass = 'ExportedGlobal';
LStimGASsigIn.InitialValue = 'LPreStimGASinit';
LStimGASsigOut = copy(LStimGASsigIn);

LStimSOLsigIn = Simulink.Signal;
LStimSOLsigIn.StorageClass = 'ExportedGlobal';
LStimSOLsigIn.InitialValue = 'LPreStimSOLinit';
LStimSOLsigOut = copy(LStimSOLsigIn);

LStimTAsigIn = Simulink.Signal;
LStimTAsigIn.StorageClass = 'ExportedGlobal';
LStimTAsigIn.InitialValue = 'LPreStimTAinit';
LStimTAsigOut = copy(LStimTAsigIn);

%%
RTargetAnglesigIn = Simulink.Signal;
RTargetAnglesigIn.StorageClass = 'ExportedGlobal';
RTargetAnglesigIn.InitialValue = 'RTargetAngleInit';
RTargetAnglesigOut = copy(RTargetAnglesigIn);

RStimHFLsigIn = Simulink.Signal;
RStimHFLsigIn.StorageClass = 'ExportedGlobal';
RStimHFLsigIn.InitialValue = 'RPreStimHFLinit';
RStimHFLsigOut = copy(RStimHFLsigIn);

RStimGLUsigIn = Simulink.Signal;
RStimGLUsigIn.StorageClass = 'ExportedGlobal';
RStimGLUsigIn.InitialValue = 'RPreStimGLUinit';
RStimGLUsigOut = copy(RStimGLUsigIn);

RStimHAMsigIn = Simulink.Signal;
RStimHAMsigIn.StorageClass = 'ExportedGlobal';
RStimHAMsigIn.InitialValue = 'RPreStimHAMinit';
RStimHAMsigOut = copy(RStimHAMsigIn);

RStimRFsigIn = Simulink.Signal;
RStimRFsigIn.StorageClass = 'ExportedGlobal';
RStimRFsigIn.InitialValue = 'RPreStimRFinit';
RStimRFsigOut = copy(RStimRFsigIn);