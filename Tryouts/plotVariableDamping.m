clearvars; 
% close all; 
clc;
%%
dx_comp_e = -1*[20 35 50 70 100 200]./(60*1000);
dx_ext_e  =    [20 35 50 70 100 200]./(60*1000);
dx_comp = -1*[5 10 20 35 50 70 100 200 300 ]./(60*1000);
dx_ext  =    [5 10 20 35 50 70 100 200 300 ]./(60*1000);
c_swing_comp_tab  = ([58000 124000 178000 251000 363000 635000]);
c_swing_ext_tab   = fliplr([33700 79000 117000 167000 244000 429000]);
c_swing_comp_poly = polyfit(1./abs(dx_comp_e),fliplr(c_swing_comp_tab),1);
c_swing_ext_poly  = polyfit(1./abs(dx_ext_e),c_swing_ext_tab,1);
% c_swing_between_poly = polyfit(1./[dx_comp(1) dx_ext(1)],[635000 429000],1);

c_stance_comp_tab  = ([1340 2110 2600 3720 4910 7080]);
c_stance_ext_tab   = fliplr([61300 70000 74500 77500 81300 83200]);
c_stance_comp_poly = polyfit(1./abs(dx_comp_e),fliplr(c_stance_comp_tab),1);
c_stance_ext_poly  = polyfit(1./abs(dx_ext_e),c_stance_ext_tab,1);

c_swing_comp_bet = c_swing_comp_tab(1)/(dx_comp(1));
c_swing_ext_bet  = c_swing_ext_tab(1)/abs(dx_ext(1));



%%
% dx_comp = (-200:1:-1)./(60*1000);%-1*[20 35 50 70 100 200]./(60*1000);
% dx_ext  =  (1:1:200)./(60*1000);%  [20 35 50 70 100 200]./(60*1000);
% dx_comp = -1*[0 1 5 10 20 35 50 70 100 200 400]./(60*1000);
% dx_ext  =    [0 1 5 10 20 35 50 70 100 200 400]./(60*1000);

dx_e = [fliplr(dx_comp_e) dx_ext_e];
dx = [fliplr(dx_comp) 0 dx_ext];
threshold = 0;%1e-3;
c_swing_comp     = @(dx)(c_swing_comp_poly(1)*(1./abs(dx))+c_swing_comp_poly(2));      % Ns/m
c_swing_ext      = @(dx)(c_swing_ext_poly(1)*(1./abs(dx))+c_swing_ext_poly(2));      % Ns/m


c_swing          = [c_swing_comp(dx_comp), c_swing_ext(dx_ext)];

% k_bumper        = 130000;                                 % N/m
c_stance_comp   = @(dx)(c_stance_comp_poly(1)*(1./abs(dx)) + c_stance_comp_poly(2));    % Ns/m
c_stance_ext    = @(dx)(c_stance_ext_poly(1)*(1./abs(dx)) + c_stance_ext_poly(2));       % Ns/m
c_stance        = [c_stance_comp(dx_comp), c_stance_ext(dx_ext)];
% 
% c_swing_comp     = @(dx)(213.5932*(1./abs(dx))-4927.5);      % Ns/m
% c_swing_ext      = @(dx)(146.3288*(1./abs(dx))-8808.5);      % Ns/m
% 
% 
% c_swing          = [c_swing_comp(dx_comp), c_swing_ext(dx_ext)];
% 
% % k_bumper        = 130000;                                 % N/m
% c_stance_comp   = @(dx)(2.1443*(1./abs(dx)) + 885.0653);    % Ns/m
% c_stance_ext    = @(dx)(7.0819*(1./abs(dx)) + 65579);       % Ns/m
% c_stance        = [c_stance_comp(dx_comp), c_stance_ext(dx_ext)];

% plot(dx_comp,c_swing_comp(dx_comp).*-dx_comp,dx_ext,c_swing_ext(dx_ext).*-dx_ext,dx_comp,c_stance_comp(dx_comp).*-dx_comp,dx_ext,c_stance_ext(dx_ext).*-dx_ext)
% legend('$c_{swing_{comp}}$','$c_{swing_{ext}}$','$c_{stance_{comp}}$','$c_{stance_{ext}}$')

%%
for i = 1:length(dx)
    val2set = 0;
    in_dx_e = find(dx_e == dx(i));
    if ~isempty(in_dx_e)
        val2set = 1;       
    end
    bool_vect_e(i) = val2set;
        
if dx(i) < -threshold
%     if dx(i) < -19.999/(60*1000)
        c_swing(i) = c_swing_comp(dx(i));
%     else
%         c_swing(i) = c_swing_comp_bet*dx(i);
%     end
    c_stance(i) = c_stance_comp(dx(i));
elseif dx(i) > threshold
    
%     if dx(i) > 20/(60*1000)
        c_swing(i) = c_swing_ext(dx(i));
%     else
%         c_swing(i) = c_swing_ext_bet*dx(i);
%     end
    c_stance(i) = c_stance_ext(dx(i));
else
    c_swing(i) = 0;
    c_stance(i) = 0;
end

end
figure();
Fswing = c_swing.*dx;
Fstance = c_stance.*dx;

lineP = plot(dx,Fswing,dx,Fstance,'--');
colororder = get(gca,'ColorOrder');
hold on;
axis([dx(1) dx(end) (min([Fswing Fstance])-20) (max([Fswing Fstance])+20)])

plot(dx_e,Fswing(bool_vect_e~=0),'o','MarkerSize',12,'color',colororder(1,:))
hold on;
plot(dx_e,Fstance((bool_vect_e~=0)),'*','MarkerSize',12,'color',colororder(2,:))

set(lineP, 'LineWidth', 4);
xlabel('m/s','FontSize',26)
ylabel('N','FontSize',26)
legend('Polynomial of $F_{sw}$','Polynomial of  $F_{st}$','Measured  $F_{sw}$','Measured  $F_{st}$','Location','northwest','FontSize',26)
title('Hydraulic damping forces','FontSize',26)

figure;
subplot(2,1,1)

plot(dx,c_swing)
title('Swing element')
xlabel('$\dot{x}$');
ylabel('$c(\dot{x})$ in N$\cdot$m$^{-1}\cdot$s');
hold on;
plot(dx_e,c_swing(bool_vect_e~=0),'o','MarkerSize',12,'color',colororder(1,:))
legend('Polynomial of $c(\dot{x})$','Measured  $c(\dot{x})$','Location','northwest','FontSize',26)

subplot(2,1,2)
plot(dx,c_stance,'Color',colororder(2,:))
xlabel('$\dot{x}$');
ylabel('$c(\dot{x})$ in N$\cdot$m$^{-1}\cdot$s');
title('Stance element');
hold on;
plot(dx_e,c_stance((bool_vect_e~=0)),'*','MarkerSize',12,'color',colororder(2,:))
legend('Polynomial of  $c(\dot{x})$','Measured  $c(\dot{x})$','Location','northwest','FontSize',26)

% subplot(3,1,2)
% plot(dx_comp_e,c_swing_comp_tab.*dx_comp_e,dx_ext_e,c_swing_ext_tab.*dx_ext_e)
% xlabel('$\dot{x}$');
% ylabel('$F$');
% title('Swing element')
% legend('Compression', 'Extension');
% subplot(3,1,3)
% plot(dx_comp_e,c_swing_comp_tab.*dx_comp_e.*dx_comp_e,dx_ext_e,c_swing_ext_tab.*dx_ext_e.*dx_ext_e)
% 
% figure;
% subplot(2,1,1)
% plot(dx_comp_e,c_stance_comp_tab,dx_ext_e,c_stance_ext_tab)
% title('Stance element')
% subplot(2,1,2)
% % plot(dx_comp,c_stance_comp_tab.*dx_comp,dx_ext,c_stance_ext_tab.*dx_ext)
% plot([-fliplr(dx_comp_e),dx_ext_e],[fliplr(c_stance_comp_tab),c_stance_ext_tab])
