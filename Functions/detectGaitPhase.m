function [leftLegState, rightLegState] = detectGaitPhase(leftLegState_old, rightLegState_old,L_GRF,R_GRF,L_SAGGpos,R_SAGGpos,L_norm_foot_shank,R_norm_foot_shank)

leftLegState    = detectGaitPhase_leg(leftLegState_old, L_GRF,R_GRF,L_SAGGpos,R_SAGGpos,L_norm_foot_shank);
rightLegState   = detectGaitPhase_leg(rightLegState_old,R_GRF,L_GRF,R_SAGGpos,L_SAGGpos,R_norm_foot_shank);