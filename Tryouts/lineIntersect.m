%%
% https://en.wikipedia.org/wiki/Skew_lines#Distance
% r1 = [0;0;0];
% e1 = [1;1;1];

r1 = 2*rand(3,1)-0.5; %[-0.5;-0.5;0];
e1 = 2*rand(3,1)-0.5; %[1;1;0];


% r2 = [1;0;0];
% e2 = [-1;1;1];

r2 = 2*rand(3,1)-0.5; %[1;1;1];
e2 = 2*rand(3,1)-0.5; %[3;-1;2];
% e1 = e1./norm(e1);
% e2 = e2./norm(e2);

n = cross(e1,e2);

d = dot(n,(r1-r2))/norm(n);

c1 = r1 + dot((r2-r1),cross(e2,n))/(dot(e1,cross(e2,n))) *e1
c2 = r2 + dot((r1-r2),cross(e1,n))/(dot(e2,cross(e1,n))) *e2
% figure(); plot3([0,-2],[3,-1],[0,2]); hold on; plot3([-1,1],[4,1],[0,1]);



if min(( c1 - r1 )./e1 > 1)
    c1 = r1 + e1;
elseif min(( c1 - r1 )./e1 < 0)
    c1 = r1;
end
if min(( c2 - r2 )./e2 > 1)
    c2 = r2 + e2;
elseif min(( c2 - r2 )./e2 < 0)
    c2 = r2;
end

d2 = norm(c1-c2)
figure(); plot3([r1(1),r1(1)+e1(1)],[r1(2), r1(2)+e1(2)],[r1(3),r1(3)+e1(3)]); hold on; 
 plot3([r2(1),r2(1)+e2(1)],[r2(2), r2(2)+e2(2)],[r2(3),r2(3)+e2(3)]);
plot3(c1(1),c1(2),c1(3),'*')
plot3(c2(1),c2(2),c2(3),'o')
xlabel('x');
ylabel('y');

if norm(c2-c1) < 1E-4
    fprintf('Intersection at (%1.2f, %1.2f, %1.2f)\n', c1);
else
    fprintf('No intersection, distance: %1.2f\n',norm(c2-c1));
end