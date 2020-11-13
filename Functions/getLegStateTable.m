function legStateTable = getLegStateTable(GaitInfo,saveInfo)
% GETLEGSTATETABLE              Function that gets the table with stance time, swing time, double stance time and 
%                               asymmetry values
% INPUTS:
%   - GaitInfo                  Structure containing information on where a stride begins and ends, whether to show average
%                               for stride, or just all the data.
%   - saveInfo                  Structure with info on how and if to save the figure
%
% OUTPUTS:
%   -
%%
legStateTable = [];
if ~isempty(GaitInfo.gaitstate)
    rowNames = {'Stance','Double Stance (leg to other leg)','Swing'};
    if contains(saveInfo.info,'prosthetic') || contains(saveInfo.info,'amputee')
        varNames = {'Left (%)','Right (%)', 'ASI_% (%)', 'Left (s)','Right (s)', 'ASI_s (%)'};
        vars = {GaitInfo.gaitstate.left.stanceMeanstdtxt_perc, GaitInfo.gaitstate.right.stanceMeanstdtxt_perc, GaitInfo.gaitstate.stanceASItxt_perc, ...
                GaitInfo.gaitstate.left.stanceMeanstdtxt, GaitInfo.gaitstate.right.stanceMeanstdtxt, GaitInfo.gaitstate.stanceASItxt; ...
                GaitInfo.gaitstate.left.doubleStanceMeanstdtxt_perc, GaitInfo.gaitstate.right.doubleStanceMeanstdtxt_perc, GaitInfo.gaitstate.doubleStanceASItxt_perc, ...
                GaitInfo.gaitstate.left.doubleStanceMeanstdtxt, GaitInfo.gaitstate.right.doubleStanceMeanstdtxt, GaitInfo.gaitstate.doubleStanceASItxt; ...
                GaitInfo.gaitstate.left.swingMeanstdtxt_perc, GaitInfo.gaitstate.right.swingMeanstdtxt_perc, GaitInfo.gaitstate.swingASItxt_perc, ...
                GaitInfo.gaitstate.left.swingMeanstdtxt, GaitInfo.gaitstate.right.swingMeanstdtxt, GaitInfo.gaitstate.swingASItxt};
        legStateTable = (table(vars(:,1),vars(:,2),vars(:,3),vars(:,4),vars(:,5),vars(:,6),'VariableNames',varNames,'RowNames',rowNames));
    else
        varNames = {'Total (%)', 'ASI_% (%)', 'Total (s)', 'ASI_s (%)'};
        vars = {GaitInfo.gaitstate.stanceMeanstdtxt_perc, GaitInfo.gaitstate.stanceASItxt_perc, ...
                GaitInfo.gaitstate.stanceMeanstdtxt, GaitInfo.gaitstate.stanceASItxt;...
                GaitInfo.gaitstate.doubleStanceMeanstdtxt_perc, GaitInfo.gaitstate.doubleStanceASItxt_perc, ...
                GaitInfo.gaitstate.doubleStanceMeanstdtxt, GaitInfo.gaitstate.doubleStanceASItxt;
                GaitInfo.gaitstate.swingMeanstdtxt_perc, GaitInfo.gaitstate.swingASItxt_perc, ...
                GaitInfo.gaitstate.swingMeanstdtxt, GaitInfo.gaitstate.swingASItxt};
        legStateTable = (table(vars(:,1),vars(:,2),vars(:,3),vars(:,4),'VariableNames',varNames,'RowNames',rowNames));
    end
end