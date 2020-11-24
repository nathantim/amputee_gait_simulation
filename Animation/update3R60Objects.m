% -------------------
% Update Cone Objects
% -------------------

function update3R60Objects( prosthSphereObjects, prosthLinkObjects, u, x, t)

% extract cone objects
% thighConnectObj    = prosthSphereObjects(1);
joint1Obj          = prosthSphereObjects(1);
joint2Obj          = prosthSphereObjects(2);
joint3Obj          = prosthSphereObjects(3);
joint4Obj          = prosthSphereObjects(4);
joint5Obj          = prosthSphereObjects(5);
joint6Obj          = prosthSphereObjects(6);
joint7Obj          = prosthSphereObjects(7);
shankConnectObj    = prosthSphereObjects(8);

link1Obj  = prosthLinkObjects(1);
link3Obj  = prosthLinkObjects(2);
link4Obj  = prosthLinkObjects(3);
link17Obj = prosthLinkObjects(4);
link5Obj  = prosthLinkObjects(5);
link6Obj  = prosthLinkObjects(6);
link8Obj  = prosthLinkObjects(7);
link9Obj  = prosthLinkObjects(8);
link11Obj = prosthLinkObjects(9);
link13Obj = prosthLinkObjects(10);
link14Obj = prosthLinkObjects(11);
link16Obj = prosthLinkObjects(12);

thighConnectIdx = 35:37;
joint1Idx       = thighConnectIdx + 3;
joint2Idx       = joint1Idx + 3;
joint3Idx       = joint2Idx + 3;
joint4Idx       = joint3Idx + 3;
joint5Idx       = joint4Idx + 3;
joint6Idx       = joint5Idx + 3;
joint7Idx       = joint6Idx + 3;
shankConnectIdx = joint7Idx + 3;

%% Set spheres
set(joint1Obj,      'XData',  get(joint1Obj, 'XData')          +  u(joint1Idx(1)) - x(joint1Idx(1)), ...
                    'YData',  get(joint1Obj, 'YData')          +  u(joint1Idx(2)) - x(joint1Idx(2)), ...
                    'ZData',  get(joint1Obj, 'ZData')          +  u(joint1Idx(3)) - x(joint1Idx(3)));
set(joint2Obj,      'XData',  get(joint2Obj, 'XData')          +  u(joint2Idx(1)) - x(joint2Idx(1)), ...
                    'YData',  get(joint2Obj, 'YData')          +  u(joint2Idx(2)) - x(joint2Idx(2)), ...
                    'ZData',  get(joint2Obj, 'ZData')          +  u(joint2Idx(3)) - x(joint2Idx(3)));
set(joint3Obj,      'XData',  get(joint3Obj, 'XData')          +  u(joint3Idx(1)) - x(joint3Idx(1)), ...
                    'YData',  get(joint3Obj, 'YData')          +  u(joint3Idx(2)) - x(joint3Idx(2)), ...
                    'ZData',  get(joint3Obj, 'ZData')          +  u(joint3Idx(3)) - x(joint3Idx(3)));
set(joint4Obj,      'XData',  get(joint4Obj, 'XData')          +  u(joint4Idx(1)) - x(joint4Idx(1)), ...
                    'YData',  get(joint4Obj, 'YData')          +  u(joint4Idx(2)) - x(joint4Idx(2)), ...
                    'ZData',  get(joint4Obj, 'ZData')          +  u(joint4Idx(3)) - x(joint4Idx(3)));
set(joint5Obj,      'XData',  get(joint5Obj, 'XData')          +  u(joint5Idx(1)) - x(joint5Idx(1)), ...
                    'YData',  get(joint5Obj, 'YData')          +  u(joint5Idx(2)) - x(joint5Idx(2)), ...
                    'ZData',  get(joint5Obj, 'ZData')          +  u(joint5Idx(3)) - x(joint5Idx(3)));
set(joint6Obj,      'XData',  get(joint6Obj, 'XData')          +  u(joint6Idx(1)) - x(joint6Idx(1)), ...
                    'YData',  get(joint6Obj, 'YData')          +  u(joint6Idx(2)) - x(joint6Idx(2)), ...
                    'ZData',  get(joint6Obj, 'ZData')          +  u(joint6Idx(3)) - x(joint6Idx(3)));
set(joint7Obj,      'XData',  get(joint7Obj, 'XData')          +  u(joint7Idx(1)) - x(joint7Idx(1)), ...
                    'YData',  get(joint7Obj, 'YData')          +  u(joint7Idx(2)) - x(joint7Idx(2)), ...
                    'ZData',  get(joint7Obj, 'ZData')          +  u(joint7Idx(3)) - x(joint7Idx(3)));
set(shankConnectObj,'XData',  get(shankConnectObj, 'XData')    +  u(shankConnectIdx(1)) - x(shankConnectIdx(1)), ...
                    'YData',  get(shankConnectObj, 'YData')    +  u(shankConnectIdx(2)) - x(shankConnectIdx(2)), ...
                    'ZData',  get(shankConnectObj, 'ZData')    +  u(shankConnectIdx(3)) - x(shankConnectIdx(3)));
                
%% Set link
if t==0
    link1Length = norm(u(shankConnectIdx) - u(joint2Idx));
    set(link1Obj, 'ZData', get(link1Obj, 'ZData') * link1Length);
    
    link3Length =  norm(u(joint2Idx) - u(joint5Idx));
    set(link3Obj, 'ZData', get(link3Obj, 'ZData') * link3Length);
    
    link4Length = norm(u(joint2Idx) - u(joint6Idx));
    set(link4Obj, 'ZData', get(link4Obj, 'ZData') * link4Length);
    
    link5Length = norm(u(shankConnectIdx) - u(joint4Idx));
    set(link5Obj, 'ZData', get(link5Obj, 'ZData') * link5Length);
    
    link6Length = norm(u(joint2Idx) - u(joint1Idx));
    set(link6Obj, 'ZData', get(link6Obj, 'ZData') * link6Length);
    
    link8Length = norm(u(joint6Idx) - u(joint7Idx));
    set(link8Obj, 'ZData', get(link8Obj, 'ZData') * link8Length);
    
    link9Length = norm(u(joint5Idx) - u(joint4Idx));
    set(link9Obj, 'ZData', get(link9Obj, 'ZData') * link9Length);
    
    link11Length = norm(u(joint4Idx) - u(joint3Idx));
    set(link11Obj, 'ZData', get(link11Obj, 'ZData') * link11Length);
    
    link13Length = norm(u(joint3Idx) - u(joint1Idx));
    set(link13Obj, 'ZData', get(link13Obj, 'ZData') * link13Length);
    
    link14Length = norm(u(joint7Idx) - u(joint1Idx));
    set(link14Obj, 'ZData', get(link14Obj, 'ZData') * link14Length);
    
    link16Length = norm(u(joint1Idx) - u(thighConnectIdx));
    set(link16Obj, 'ZData', get(link16Obj, 'ZData') * link16Length);
    
    link17Length = norm(u(shankConnectIdx) - u(joint5Idx));
    set(link17Obj, 'ZData', get(link17Obj, 'ZData') * link17Length);
    
    % rotate and shift cones to their new angles and positions
    rotTransObj( link1Obj, u(joint2Idx),   u(shankConnectIdx),   zeros(1,3),   [0;0;link1Length]);
    rotTransObj( link3Obj, u(joint5Idx),   u(joint2Idx),         zeros(1,3),   [0;0;link3Length]);
    rotTransObj( link4Obj, u(joint6Idx),   u(joint2Idx),         zeros(1,3),   [0;0;link4Length]);
    rotTransObj( link17Obj, u(joint5Idx),   u(shankConnectIdx),  zeros(1,3),   [0;0;link17Length]);
    rotTransObj( link5Obj, u(joint4Idx),   u(shankConnectIdx),   zeros(1,3),   [0;0;link5Length]);
    rotTransObj( link6Obj, u(joint1Idx),   u(joint2Idx),         zeros(1,3),   [0;0;link6Length]);
    rotTransObj( link8Obj, u(joint7Idx),   u(joint6Idx),         zeros(1,3),   [0;0;link8Length]);
    rotTransObj( link9Obj, u(joint4Idx),   u(joint5Idx),         zeros(1,3),   [0;0;link9Length]);
    rotTransObj( link11Obj, u(joint3Idx),   u(joint4Idx),        zeros(1,3),   [0;0;link11Length]);
    rotTransObj( link13Obj, u(joint1Idx),   u(joint3Idx),        zeros(1,3),   [0;0;link13Length]);
    rotTransObj( link14Obj, u(joint1Idx),   u(joint7Idx),        zeros(1,3),   [0;0;link14Length]);
    rotTransObj( link16Obj, u(thighConnectIdx),  u(joint1Idx),   zeros(1,3),   [0;0;link16Length]);

    
else  
    
    % rotate and shift cones to their new angles and positions
    rotTransObj( link1Obj, u(joint2Idx),   u(shankConnectIdx),   x(joint2Idx),   x(shankConnectIdx));
    rotTransObj( link3Obj, u(joint5Idx),   u(joint2Idx),         x(joint5Idx),   x(joint2Idx));
    rotTransObj( link4Obj, u(joint6Idx),   u(joint2Idx),         x(joint6Idx),   x(joint2Idx));
    rotTransObj( link17Obj, u(joint5Idx),   u(shankConnectIdx),  x(joint5Idx),   x(shankConnectIdx));
    rotTransObj( link5Obj, u(joint4Idx),   u(shankConnectIdx),   x(joint4Idx),   x(shankConnectIdx));
    rotTransObj( link6Obj, u(joint1Idx),   u(joint2Idx),         x(joint1Idx),   x(joint2Idx));
    rotTransObj( link8Obj, u(joint7Idx),   u(joint6Idx),         x(joint7Idx),   x(joint6Idx));
    rotTransObj( link9Obj, u(joint4Idx),   u(joint5Idx),         x(joint4Idx),   x(joint5Idx));
    rotTransObj( link11Obj, u(joint3Idx),   u(joint4Idx),        x(joint3Idx),   x(joint4Idx));
    rotTransObj( link13Obj, u(joint1Idx),   u(joint3Idx),        x(joint1Idx),   x(joint3Idx));
    rotTransObj( link14Obj, u(joint1Idx),   u(joint7Idx),        x(joint1Idx),   x(joint7Idx));
    rotTransObj( link16Obj, u(thighConnectIdx),  u(joint1Idx),   x(thighConnectIdx),  x(joint1Idx));
    

    % Scale hydraulic elements
    scaleObj(link5Obj, u(joint4Idx),   u(shankConnectIdx),   x(joint4Idx),   x(shankConnectIdx))
    scaleObj(link8Obj, u(joint7Idx),   u(joint6Idx),         x(joint7Idx),   x(joint6Idx))    

end
