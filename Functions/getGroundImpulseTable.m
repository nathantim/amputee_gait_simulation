function groundImpulseTable = getGroundImpulseTable(GRFData,GaitInfo,saveInfo)
% x: Anterior +, Posterior -
LGRFx = GRFData.signals.values(:,1);
RGRFx = GRFData.signals.values(:,4);
% z: Up +, down -
LGRFz = GRFData.signals.values(:,3);
RGRFz = GRFData.signals.values(:,6);

[LGRimpxBrake,LGRimpxProp]  = getImpulse(GRFData.time,GaitInfo.start.leftV,GaitInfo.end.leftV,LGRFx);
[~,LGRimpzProp]             = getImpulse(GRFData.time,GaitInfo.start.leftV,GaitInfo.end.leftV,LGRFz);

[RGRimpxBrake,RGRimpxProp]  = getImpulse(GRFData.time,GaitInfo.start.rightV,GaitInfo.end.rightV,RGRFx);
[~,RGRimpzProp]             = getImpulse(GRFData.time,GaitInfo.start.rightV,GaitInfo.end.rightV,RGRFz);

[impxBrakestruct]   = getFilterdMean_and_ASI(LGRimpxBrake,RGRimpxBrake);
[impxPropstruct]    = getFilterdMean_and_ASI(LGRimpxProp,RGRimpxProp);
[impzPropstruct]    = getFilterdMean_and_ASI(LGRimpzProp,RGRimpzProp);

rowNames = {'Ant-post','Vert'};
if contains(saveInfo.info,'prosthetic') || contains(saveInfo.info,'amputee')
    
    varNames = {'L braking impulse (Ns/kg)','R braking impulse (Ns/kg)', 'Braking ASI (%)', 'L prop impulse (Ns/kg)','R prop impulse (Ns/kg)', 'Prop ASI (%)'};%,'L mean propel impulse (N%/kg)','R mean propel impulse (N%/kg)'};
    vars = {impxBrakestruct.leftTxt, impxBrakestruct.rightTxt, impxBrakestruct.ASItxt, impxPropstruct.leftTxt, impxPropstruct.rightTxt, impxPropstruct.ASItxt; ...
        '-', '-', '-', impzPropstruct.leftTxt, impzPropstruct.rightTxt, impzPropstruct.ASItxt};
    groundImpulseTable = (table(vars(:,1),vars(:,2),vars(:,3),vars(:,4),vars(:,5),vars(:,6),'VariableNames',varNames,'RowNames',rowNames));
else
    varNames = {'Total braking impulse (Ns/kg)', 'Braking ASI (%)', 'Total prop impulse (Ns/kg)', 'Prop ASI (%)'};%,'L mean propel impulse (N%/kg)','R mean propel impulse (N%/kg)'};
    vars = {impxBrakestruct.totalTxt, impxBrakestruct.ASItxt, impxPropstruct.totalTxt, impxPropstruct.ASItxt; ...
        '-', '-', impzPropstruct.totalTxt, impzPropstruct.ASItxt};
    groundImpulseTable = (table(vars(:,1),vars(:,2),vars(:,3),vars(:,4),'VariableNames',varNames,'RowNames',rowNames));
    
end
