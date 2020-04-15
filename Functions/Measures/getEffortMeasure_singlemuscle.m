function getEffortMeasure_singlemuscle()

fa = 40*lambda * sin(pi/2*muscle_excitation) + 133*(1-lambda)*(1-cos(pi/2*muscle_excitation));
fm = 74*lambda * sin(pi/2*muscle_activation) + 111*(1-lambda)*(1-cos(pi/2*muscle_activation));