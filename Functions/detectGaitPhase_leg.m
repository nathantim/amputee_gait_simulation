function legState = detectGaitPhase_leg(legState,GRF,GRF_other,SAGGpos,SAGGpos_other,norm_foot_shank)
%%
EarlyStance = 0; LateStance = 1; Liftoff = 2; Swing = 3; Landing = 4;

%%
allow_stance_transition         = GRF > 0;
allow_stance_transition_other   = GRF_other > 0;
allow_swing_transition          = GRF <= 0;
allow_late_stance_transition    = SAGGpos < 0;
allow_liftoff_transition       = (SAGGpos < norm_foot_shank && allow_stance_transition_other && SAGGpos < SAGGpos_other);
allow_landing_transition        = SAGGpos > 0;

if (legState ~= EarlyStance && legState ~= LateStance && legState ~= Liftoff && legState ~= Swing && legState ~= Landing )
    % 		-- In case of unknown or init state
    if allow_stance_transition
        if allow_late_stance_transition
            legState = LateStance;
        else
            legState = EarlyStance;
        end
    else
        if allow_landing_transition
            legState = Landing;
        else
            legState = Swing;
        end
    end
    
elseif(legState == EarlyStance) && allow_late_stance_transition
    legState = LateStance;
elseif(legState == LateStance) && allow_liftoff_transition
    legState = Liftoff;
elseif(legState == Liftoff) && allow_swing_transition
    legState = Swing;
elseif(legState == Swing) && allow_landing_transition
    legState = Landing;
elseif(legState == Landing) && allow_stance_transition
    legState = EarlyStance;
end