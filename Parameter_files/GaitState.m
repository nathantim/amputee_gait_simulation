classdef GaitState < Simulink.IntEnumType
  enumeration
    EarlyStance(0)
    LateStance(1)
    LiftOff(2)
    SwingState(3)
    Landing(4)
  end
end 