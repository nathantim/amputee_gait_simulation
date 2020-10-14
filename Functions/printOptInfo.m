function printOptInfo(dataStruct,b_bold)
try
    if nargin <2
        b_bold = false;
    end
    
    cost = dataStruct.cost.data;
    
    if ~isnan(cost)
        time = dataStruct.timeVector.data;
        
%         metabolicEnergyWang = dataStruct.E.data(contains(string(dataStruct.E.info),'Wang'));
        metabolicEnergyUmb10  = dataStruct.E.data(contains(string(dataStruct.E.info),'Umberger (2010)'));
        CoTUmb10  = dataStruct.CoT.data(contains(string(dataStruct.CoT.info),'Umberger (2010)'));
        meanVel = dataStruct.vMean.data;
        stepLengthASIstruct = dataStruct.stepLengthASIstruct.data;
        stepTimeASIstruct = dataStruct.stepTimeASIstruct.data;
        timeCost = dataStruct.timeCost.data;
%         velCost = dataStruct.velCost.data;
        sumOfStopTorques = dataStruct.sumTstop.data;
        maxCMGTorque = dataStruct.maxCMGTorque.data;
        maxCMGdeltaH = dataStruct.maxCMGdeltaH.data;
%         controlRMSE = dataStruct.controlRMSE.data;
        numberOfCollisions = dataStruct.numberOfCollisions.data;
%         HATPos = dataStruct.HATPos.data;
        if b_bold
            fprintf(['-- <strong> t_sim: %2.2f</strong>, Cost: %2.2f, CoT: %.2f, E_m: %.0f, <strong>v_avg: %2.2f</strong>, ',...
                'sumStopT: %1.0f, stepLengthASI: %2.1f%%, stepTimeASI: %2.1f%%,',...
                ' #collisions: %d, maxCMGdeltaH: %3.1f, maxCMGTorque: %3.1f --\n'],...
                time(end), cost, CoTUmb10, metabolicEnergyUmb10,...
                meanVel,sumOfStopTorques, stepLengthASIstruct.ASImean, stepTimeASIstruct.ASImean, ...
                numberOfCollisions, maxCMGdeltaH, maxCMGTorque);
        else
            fprintf(['-- t_sim: %2.2f, Cost: %2.2f, CoT: %.2f, E_m: %.0f, v_avg: %2.2f, ',...
                'sumStopT: %1.0f, stepLengthASI: %2.1f%%, stepTimeASI: %2.1f%%,',...
                ' #collisions: %d, maxCMGdeltaH: %3.1f, maxCMGTorque: %3.1f --\n'],...
                time(end), cost, CoTUmb10, metabolicEnergyUmb10,...
                meanVel,sumOfStopTorques, stepLengthASIstruct.ASImean, stepTimeASIstruct.ASImean, ...
                numberOfCollisions, maxCMGdeltaH, maxCMGTorque);
               
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