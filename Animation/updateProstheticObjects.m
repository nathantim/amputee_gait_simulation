% -------------------------
% Update Prosthetic Objects
% -------------------------

function updateProstheticObjects(prosthSphereObjects, prosthLinkObjects, u, x, t, rCMG)
if ~isempty(rCMG)
    CMG_obj  = prosthSphereObjects(end-3);
    CMGlink_obj = prosthLinkObjects(end-3);
else
    CMG_obj = [];
end
update3R60Objects( prosthSphereObjects, prosthLinkObjects, u, x, t);
    
P_ShankCone  = prosthLinkObjects(end-2);
P_BallCone = prosthLinkObjects(end-1);
P_HeelCone = prosthLinkObjects(end);

P_AJ_Obj   = prosthSphereObjects(end-2);
P_BallObj = prosthSphereObjects(end-1);
P_HeelObj = prosthSphereObjects(end);
    
shankConnectIdx = 59:61;
ankleIdx = 25:27;
ballIdx = ankleIdx + 3;
heelIdx = ballIdx + 3;
CMGIdx = shankConnectIdx + 3;

%%
set(P_AJ_Obj,  'XData',  get(P_AJ_Obj, 'XData')  +  u(ankleIdx(1)) - x(ankleIdx(1)), ...
    'YData',  get(P_AJ_Obj, 'YData')  +  u(ankleIdx(2)) - x(ankleIdx(2)), ...
    'ZData',  get(P_AJ_Obj, 'ZData')  +  u(ankleIdx(3)) - x(ankleIdx(3)));
set(P_BallObj, 'XData',  get(P_BallObj, 'XData') +  u(ballIdx(1)) - x(ballIdx(1)), ...
    'YData',  get(P_BallObj, 'YData') +  u(ballIdx(2)) - x(ballIdx(2)), ...
    'ZData',  get(P_BallObj, 'ZData') +  u(ballIdx(3)) - x(ballIdx(3)));
set(P_HeelObj, 'XData',  get(P_HeelObj, 'XData') +  u(heelIdx(1)) - x(heelIdx(1)), ...
    'YData',  get(P_HeelObj, 'YData') +  u(heelIdx(2)) - x(heelIdx(2)), ...
    'ZData',  get(P_HeelObj, 'ZData') +  u(heelIdx(3)) - x(heelIdx(3)));

if ~isempty(CMG_obj)
    set(CMG_obj, 'XData',  get(CMG_obj, 'XData') +  u(CMGIdx(1)) - x(CMGIdx(1)), ...
        'YData',  get(CMG_obj, 'YData')          +  u(CMGIdx(2)) - x(CMGIdx(2)), ...
        'ZData',  get(CMG_obj, 'ZData')          +  u(CMGIdx(3)) - x(CMGIdx(3)))
end

%%

if t ==0
    if ~isempty(rCMG)
        P_CMGlinkLength = norm(u(CMGIdx) - u(shankConnectIdx)) - rCMG ;
        set(CMGlink_obj, 'ZData', get(CMGlink_obj, 'ZData') * P_CMGlinkLength);
        rotTransObj( CMGlink_obj, u(shankConnectIdx), u(CMGIdx),      zeros(1,3),   [0;0;P_CMGlinkLength]);
        
        P_ShankLength = norm(u(CMGIdx) - u(ankleIdx)) - rCMG ;
        set(P_ShankCone, 'ZData', get(P_ShankCone, 'ZData') * P_ShankLength);
        rotTransObj( P_ShankCone, u(ankleIdx),   u(CMGIdx),   zeros(1,3),   [0;0;P_ShankLength]);
    else
        P_ShankLength = norm(u(shankConnectIdx) - u(ankleIdx));
        set(P_ShankCone, 'ZData', get(P_ShankCone, 'ZData') * P_ShankLength);
        rotTransObj( P_ShankCone, u(ankleIdx),   u(shankConnectIdx),   zeros(1,3),   [0;0;P_ShankLength]);
    end
    
            % set right shank length
%         R_KneeProsthLength = sqrt( (u(22)-u(35))^2 + (u(23)-u(36))^2 + (u(24)-u(37))^2 );
%         set(R_KneeProsthObj, 'ZData', get(R_KneeProsthObj, 'ZData') * R_KneeProsthLength);
%         x(24) = R_KneeProsthLength;
%         
%         if CMGFlag
%             CMGlinkLength = sqrt( (u(38)-u(35))^2 + (u(39)-u(36))^2 + (u(40)-u(37))^2 ) - rCMG;
%             set(CMGlinkObj, 'ZData', get(CMGlinkObj, 'ZData') * CMGlinkLength);
%             x(37) = 0*CMGlinkLength;
%             % set right shank length
%             R_ShankLength = sqrt( (u(38)-u(25))^2 + (u(39)-u(26))^2 + (u(40)-u(27))^2 ) - rCMG;
%             set(R_ShankObj, 'ZData', get(R_ShankObj, 'ZData') * R_ShankLength);
%             x(40) = R_ShankLength;
%         else
%             % set right shank lengths
%             R_ShankLength = sqrt( (u(35)-u(25))^2 + (u(36)-u(26))^2 + (u(37)-u(27))^2 );
%             set(R_ShankObj, 'ZData', get(R_ShankObj, 'ZData') * R_ShankLength);
%             x(37) = R_ShankLength;
%         end     

    P_BallLength =  norm(u(ankleIdx) - u(ballIdx));
    set(P_BallCone, 'ZData', get(P_BallCone, 'ZData') * P_BallLength);
    
    P_HeelLength = norm(u(ankleIdx) - u(heelIdx));
    set(P_HeelCone, 'ZData', get(P_HeelCone, 'ZData') * P_HeelLength);
 
    
    rotTransObj( P_BallCone, u(ballIdx),   u(ankleIdx),         zeros(1,3),   [0;0;P_BallLength]);
    rotTransObj( P_HeelCone, u(heelIdx),   u(ankleIdx),         zeros(1,3),   [0;0;P_HeelLength]);
    
else     
    if ~isempty(rCMG)
        rotTransObj( P_ShankCone, u(ankleIdx),   u(CMGIdx),   x(ankleIdx),   x(CMGIdx));
        rotTransObj( CMGlink_obj, u(shankConnectIdx), u(CMGIdx),  x(shankConnectIdx), x(CMGIdx));
    else
        rotTransObj( P_ShankCone, u(ankleIdx),   u(shankConnectIdx),   x(ankleIdx),   x(shankConnectIdx));
    end
    rotTransObj( P_BallCone, u(ballIdx),   u(ankleIdx),         x(ballIdx),   x(ankleIdx));
    rotTransObj( P_HeelCone, u(heelIdx),   u(ankleIdx),         x(heelIdx),   x(ankleIdx));
    
end
end
