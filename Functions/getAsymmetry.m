function ASI = getAsymmetry(side1, side2)
% ASI: Absolute Asymmetry Index

ASI = (side1 - side2)/( 1/2 * (side1 + side2) ) * 100; 