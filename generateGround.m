function [groundX, groundZ, groundTheta] = generateGround(type, param, seed)
groundX = zeros(1,200);
groundX(1:2:end) = 0:99;
groundX(2:2:end) = (1:100)-.03;
groundZ = zeros(1,200);

rng('default')
if nargin < 3
    rng('shuffle');
else
    rng(seed);
end
if nargin == 0
    type = 'flat';
end

switch lower(type)
    %no roughness
    case 'flat'

    %ramped roughness
    case 'ramp'
        %default slope of 2.5 mm per meter
        if nargin == 1
            rampSlope =  0.0025;
        else
            rampSlope = param;
        end

        for i = 21:2:length(groundX)
            groundZ(i) = groundZ(i-2) + groundX(i-19)*2*(rand - 0.5)*rampSlope;
            groundZ(i+1) = groundZ(i);
        end
        %groundZ(end) = [];

    %const roughness
    case {'constant', 'const'}
        %default step size of 3 cm
        if nargin == 1
            stepSize = 0.03;
        else
            stepSize = param;
        end

        for i = 21:2:length(groundX)
            groundZ(i) = groundZ(i-2) + 2*(rand - 0.5)*stepSize;
            groundZ(i+1) = groundZ(i);
        end
        %groundZ(end) = [];

        %scale so largest step is equalt to step size
        largestStep = max(abs(diff(groundZ)));
        groundZ = groundZ * stepSize/(largestStep+eps);
end

%calculate slope angle
groundTheta = [atan(diff(groundZ)./diff(groundX)), 0];

save('groundHeight.mat','groundX','groundZ','groundTheta');
