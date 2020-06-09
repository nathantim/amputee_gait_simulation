function makeFigureEmpty(figureHandle)
delete(findall(figureHandle,'type','Line'));
delete(findall(figureHandle,'type','Legend'));
delete(findall(figureHandle,'type','Stair'));
delete(findall(figureHandle,'type','Patch'));