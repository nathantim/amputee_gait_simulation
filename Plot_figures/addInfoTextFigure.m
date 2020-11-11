function addInfoTextFigure(infoText,infoFontSize,letterText,letterFontSize,parentAxis,ylabelPos,positionLabel,labelAlignment)
if nargin < 7
    positionLabel = [ylabelPos, 0.4, 0];
end
if nargin < 8
   labelAlignment =  'right';
end
% infotxt = text(0,0,['\underline{',infoText,'}'],'interpreter','latex','FontSize',infoFontSize,'Rotation',90);
% set(infotxt,'Parent',parentAxis)
% set(infotxt,'HorizontalAlignment','center','VerticalAlignment','bottom');
% set(infotxt,'Units','Normalized');
% set(infotxt,'Position',[ylabelPos*2.2,0.5, 0]);

lettertxt = text(0,0,letterText,'FontSize',letterFontSize,'clipping', 'off');
set(lettertxt,'Parent',parentAxis)
set(lettertxt,'HorizontalAlignment',labelAlignment,'VerticalAlignment','bottom');
set(lettertxt,'Units','Normalized');
% set(lettertxt,'Position',[ylabelPos*3.8, 0.4, 0]);
set(lettertxt,'Position',positionLabel);