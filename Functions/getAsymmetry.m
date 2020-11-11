function ASI = getAsymmetry(side1, side2)
% ASI: Absolute Asymmetry Index
if size(side1,1) ~= size(side2,1)
    side2 = side2';
end
ASI = (side1 - side2)./( 1/2 .* (side1 + side2) ) .* 100; 