function legState = detectGaitPhase_leg(legState,GRF,GRF_other,SAGGpos,norm_foot_shank)

allow_stance_transition         = GRF > 0;
allow_stance_transition_other   = GRF_other > 0;
allow_swing_transition          = GRF <= 0;
allow_late_stance_transition    = SAGGpos < 0;
allow_lift_off_transition       = SAGGpos < norm_foot_shank;
allow_landing_transition        = SAGGpos > 0;

if(legState == -1) 
    % 		-- In case of unknown or init state
    if allow_stance_transition
        if allow_late_stance_transition
            leg.state = "LateStance"
        else
            leg.state = "EarlyStance"
        end
    else
        if allow_landing_transition
            leg.state = "Landing"
        else
            leg.state = "Swing"
        end
    end
        
    else if(leg.state == "EarlyStance") && allow_late_stance_transition 
            leg.state = "LateStance"
        else if(leg.state == "LateStance") && allow_liftoff_transition 
                leg.state = "Liftoff"
            else if(leg.state == "Liftoff") && allow_swing_transition 
                    leg.state = "Swing"
                else if(leg.state == "Swing") && allow_landing_transition 
                        leg.state = "Landing"
                    else if(leg.state == "Landing") && allow_stance_transition 
                            leg.state = "EarlyStance"
                        end