x1_1 = rand(3,1);
x1_2 = rand(3,1);
x2_1 = rand(3,1);
x2_2 = rand(3,1);

e1 = (x1_2- x1_1);
e2 = (x2_2- x2_1);

n = cross(e1,e2);

t1 = dot((x2_1-x1_1),cross(e2,n))/(dot(e1,cross(e2,n)));
t2 = dot((x1_1-x2_1),cross(e1,n))/(dot(e2,cross(e1,n)));

if t1 < 0
    c1 = x1_1;
elseif t1 > 1
    c1 = x1_2;
else
    c1 = x1_1 + t1*e1;
end
if t2 < 0
    c2 = x2_1;
elseif t2 > 1
    c2 = x2_2;
else
    c2 = x2_1 + t2*e2;
end

if norm(c1-c2) < 0.02
   disp('Collision') 
end
%%
figure();
plot3([x1_1(1),x1_2(1)],[x1_1(2),x1_2(2)],[x1_1(3),x1_2(3)],'DisplayName','line 1');
hold on;
plot3([x2_1(1),x2_2(1)],[x2_1(2),x2_2(2)],[x2_1(3),x2_2(3)],'DisplayName','line 2');
cplot1 = plot3(c1(1),c1(2),c1(3),'*','MarkerSize',15,'DisplayName','closest point on line 1');
% set(get(get(cplot1,'Annotation'),'LegendInformation'),...
%     'IconDisplayStyle','off');
cplot2 = plot3(c2(1),c2(2),c2(3),'*','MarkerSize',15,'DisplayName','closest point on line 2');
% set(get(get(cplot2,'Annotation'),'LegendInformation'),...
%     'IconDisplayStyle','off')
% plot3([x1_1(1),x1_1(1)+n(1)],[x1_1(2),x1_1(2)+n(2)],[x1_1(3),x1_1(3)+n(3)]);

% plot3([c1(1),c1(1)+n(1)],[c1(2),c1(2)+n(2)],[c1(3),c1(3)+n(3)]);
% plot3([c2(1),c2(1)+n(1)],[c2(2),c2(2)+n(2)],[c2(3),c2(3)+n(3)]);

plot3([x1_1(1),x2_1(1)],[x1_1(2),x2_1(2)],[x1_1(3),x2_1(3)],':','DisplayName','$x_{2,1}-x_{1,1}$');

fact = 1;

n1 = 2*fact*cross(e1,n);
n2 = 4*fact*cross(e2,n);

plot3([x2_1(1)-n1(1),x2_1(1)+n1(1)],[x2_1(2)-n1(2),x2_1(2)+n1(2)],[x2_1(3)-n1(3),x2_1(3)+n1(3)],'-.','DisplayName','$e_1 \times n$');
plot3([x1_1(1)-n2(1),x1_1(1)+n2(1)],[x1_1(2)-n2(2),x1_1(2)+n2(2)],[x1_1(3)-n2(3),x1_1(3)+n2(3)],'--','DisplayName','$e_2 \times n$');
plot3([x1_1(1)-fact*n(1),x1_1(1)+fact*n(1)],[x1_1(2)-fact*n(2),x1_1(2)+fact*n(2)],[x1_1(3)-fact*n(3),x1_1(3)+fact*n(3)],':','DisplayName','$n_1$');
plot3([x2_1(1)-fact*n(1),x2_1(1)+fact*n(1)],[x2_1(2)-fact*n(2),x2_1(2)+fact*n(2)],[x2_1(3)-fact*n(3),x2_1(3)+fact*n(3)],':','DisplayName','$n_2$');
legend
axis equal
% point = c1;
% normal = n;
% 
% %# a plane is a*x+b*y+c*z+d=0
% %# [a,b,c] is the normal. Thus, we have to calculate
% %# d and we're set
% d = -dot(point,normal); %'# dot product for less typing
% 
% %# create x,y
% [xx,yy]=ndgrid(-0.5:0.25:0.5,-0.5:0.25:0.5);
% 
% %# calculate corresponding z
% z = (-normal(1)*xx - normal(2)*yy - d)/normal(3);
% 
% %# plot the surface
% % figure
% surf(xx,yy,z)

% point = x1_1';
% normal = e1';
% t=(0:10:360)';
% circle0=[cosd(t) sind(t) zeros(length(t),1)];
% r=0.5*vrrotvec2mat(vrrotvec([0 0 1],normal));
% circle=circle0*r'+repmat(point,length(circle0),1);
% patch(circle(:,1),circle(:,2),circle(:,3),.5,'FaceAlpha',0.2);
% % axis square; grid on;
% %add line
% % line=[point;point+normr(normal)]
% % hold on;plot3(line(:,1),line(:,2),line(:,3),':','LineWidth',1)
% point = x2_1';
% normal = e2';
% t=(0:10:360)';
% circle0=[cosd(t) sind(t) zeros(length(t),1)];
% r=0.5*vrrotvec2mat(vrrotvec([0 0 1],normal));
% circle=circle0*r'+repmat(point,length(circle0),1);
% patch(circle(:,1),circle(:,2),circle(:,3),.5,'FaceAlpha',0.2,'FaceColor','g');