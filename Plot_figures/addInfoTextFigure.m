function addInfoTextFigure(infoText,letterText,parentAxis,ylabelPos)

infotxt = text(0,0,['\underline{',infoText,'}'],'interpreter','latex','FontSize',26,'Rotation',90);
set(infotxt,'Parent',parentAxis)
set(infotxt,'HorizontalAlignment','center','VerticalAlignment','bottom');
set(infotxt,'Units','Normalized');
set(infotxt,'Position',[ylabelPos*2.3,0.5, 0]);

lettertxt = text(0,0,['(',letterText,')'],'FontSize',20);
set(lettertxt,'Parent',parentAxis)
set(lettertxt,'HorizontalAlignment','center','VerticalAlignment','bottom');
set(lettertxt,'Units','Normalized');
set(lettertxt,'Position',[ylabelPos*3.8, 0.4, 0]);