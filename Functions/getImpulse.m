function [impulse_brake,impulse_prop] = getImpulse(time,startV,endV,forceData)

for ii = 1:length(startV)
    startIdx = startV(ii);
    endIdx = endV(ii);
    dF = ((forceData(startIdx:endIdx-1)+forceData(startIdx+1:endIdx))./2).*diff(time(startIdx:endIdx));
    impulse_brake(ii) =sum(dF(dF<0));
    impulse_prop(ii) =sum(dF(dF>0));
end