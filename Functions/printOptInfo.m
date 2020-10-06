function printOptInfo(dataStruct,b_bold)
try
    if nargin <2
        b_bold = false;
    end
    
    cost = dataStruct.cost.data;
    
    if ~isnan(cost)
        time = dataStruct.timeVector.data;
        
        metabolicEnergyWang = dataStruct.E.data(contains(string(dataStruct.E.info),'Wang'));
        metabolicEnergyUmb10  = dataStruct.E.data(contains(string(dataStruct.E.info),'Umberger (2010)'));
        meanVel = dataStruct.vMean.data;
        meanStepTime = dataStruct.tStepMean.data;
        meanStepLength = dataStruct.lStepMean.data;
        ASIStepLength = dataStruct.lStepASI.data;
        ASIStepTime = dataStruct.tStepASI.data;
        timeCost = dataStruct.timeCost.data;
        velCost = dataStruct.velCost.data;
        sumOfStopTorques = dataStruct.sumTstop.data;
        maxCMGTorque = dataStruct.maxCMGTorque.data;
        maxCMGdeltaH = dataStruct.maxCMGdeltaH.data;
        controlRMSE = dataStruct.controlRMSE.data;
        numberOfCollisions = dataStruct.numberOfCollisions.data;
        if b_bold
            fprintf(['-- <strong> t_sim: %2.2f</strong>, Cost: %2.2f, E_m: %.0f, <strong>avg v_step: %2.2f</strong>, ',...
                'sumStopT: %3.0f, timeCost: %2.2f, velCost: %2.2f, maxCMGdeltaH: %3.1f, controlRMSE: %3.1f, maxCMGTorque: %3.1f, #collisions: %d --\n'],...
                time(end), cost, metabolicEnergyUmb10,...
                meanVel,sumOfStopTorques, timeCost, velCost, maxCMGdeltaH, controlRMSE, maxCMGTorque, numberOfCollisions);
        else
            fprintf(['-- t_sim: %2.2f, Cost: %2.2f, E_m: %.0f, avg v_step: %2.2f, ',...
                'sumStopT: %1.0f, timeCost: %2.2f, velCost: %2.2f, maxCMGdeltaH: %3.1f, controlRMSE: %3.1f, maxCMGTorque: %3.1f, #collisions: %d --\n'],...
                time(end), cost, metabolicEnergyUmb10,...
                meanVel,sumOfStopTorques, timeCost, velCost, maxCMGdeltaH, controlRMSE, maxCMGTorque, numberOfCollisions);
        end
%         if b_bold
%             fprintf(['-- <strong> t_sim: %2.2f</strong>, Cost: %2.2f, E_m (Wang): %.0f, E_m(Umb10): %.0f, <strong>avg v_step: %2.2f</strong>, ',...
%                 'sumStopT: %3.0f, avg t_step: %1.2f, avg l_step: %1.2f, timeCost: %2.2f, velCost: %2.2f, maxCMGTorque: %3.1f --\n'],...
%                 time(end), cost, metabolicEnergyWang, metabolicEnergyUmb10,...
%                 meanVel,sumOfStopTorques, meanStepTime, meanStepLength, timeCost, velCost, maxCMGTorque);
%         else
%             fprintf(['-- t_sim: %2.2f, Cost: %2.2f, E_m (Wang): %.0f, E_m(Umb10): %.0f, avg v_step: %2.2f, ',...
%                 'sumStopT: %1.0f, avg t_step: %1.2f, avg l_step: %1.2f, timeCost: %2.2f, velCost: %2.2f, maxCMGTorque: %3.1f --\n'],...
%                 time(end), cost, metabolicEnergyWang, metabolicEnergyUmb10,...
%                 meanVel,sumOfStopTorques, meanStepTime, meanStepLength, timeCost, velCost, maxCMGTorque);
%         end
        
        
    end
catch ME
    warning(ME.message)
end
end
% if b_bold
%     fprintf(['-- <strong> t_sim: %2.2f</strong>, Cost: %2.2f, E_m (Wang): %.0f, E_m(Umb10): %.0f, <strong>avg v_step: %2.2f</strong>, ',...
%         'avg t_step: %1.2f, avg l_step: %1.2f, ASI l_step: %2.2f, ASI t_step: %2.2f, timeCost: %2.2f, velCost: %2.2f --\n'],...
%         time(end), cost, metabolicEnergyWang, metabolicEnergyUmb10,...
%         meanVel, meanStepTime, meanStepLength,round(ASIStepLength,2),round(ASIStepTime,2), timeCost, velCost);
% else
%     fprintf(['-- t_sim: %2.2f, Cost: %2.2f, E_m (Wang): %.0f, E_m(Umb10): %.0f, avg v_step: %2.2f, ',...
%         'avg t_step: %1.2f, avg l_step: %1.2f, ASI l_step: %2.2f, ASI t_step: %2.2f, timeCost: %2.2f, velCost: %2.2f --\n'],...
%         time(end), cost, metabolicEnergyWang, metabolicEnergyUmb10,...
%         meanVel, meanStepTime, meanStepLength,round(ASIStepLength,2),round(ASIStepTime,2), timeCost, velCost);
% end