%%
dx_comp_e = -1*[20 35 50 70 100 200]./(60*1000);
dx_ext_e  =    [20 35 50 70 100 200]./(60*1000);
dx_comp = -1*[0.1 1 5 10 15 20 35 50 70 100 200 300 400]./(60*1000);
dx_ext  =    [0.1 1 5 10 15 20 35 50 70 100 200 300 400]./(60*1000);
c_swing_comp_tab  = fliplr([58000 124000 178000 251000 363000 635000]);
c_swing_ext_tab   = fliplr([33700 79000 117000 167000 244000 429000]);
c_swing_comp_poly = polyfit(1./abs(dx_comp_e),c_swing_comp_tab,1);
c_swing_ext_poly  = polyfit(1./abs(dx_ext_e),c_swing_ext_tab,1);
% c_swing_between_poly = polyfit(1./[dx_comp(1) dx_ext(1)],[635000 429000],1);

c_stance_comp_tab  = fliplr([1340 2110 2600 3720 4910 7080]);
c_stance_ext_tab   = fliplr([61300 70000 74500 77500 81300 83200]);
c_stance_comp_poly = polyfit(1./abs(dx_comp_e),c_stance_comp_tab,1);
c_stance_ext_poly  = polyfit(1./abs(dx_ext_e),c_stance_ext_tab,1);

c_swing_comp_bet = c_swing_comp_tab(1)/(dx_comp(1));
c_swing_ext_bet  = c_swing_ext_tab(1)/abs(dx_ext(1));

figure;
subplot(3,1,1)
plot(dx_comp_e,c_swing_comp_tab,dx_ext_e,c_swing_ext_tab)
xlabel('$\dot{x}$');
ylabel('$c(\dot{x})$');
subplot(3,1,2)
plot(dx_comp_e,c_swing_comp_tab.*dx_comp_e,dx_ext_e,c_swing_ext_tab.*dx_ext_e)
xlabel('$\dot{x}$');
ylabel('$F$');
legend('Compression', 'Extension');
subplot(3,1,3)
plot(dx_comp_e,c_swing_comp_tab.*dx_comp_e.*dx_comp_e,dx_ext_e,c_swing_ext_tab.*dx_ext_e.*dx_ext_e)

figure;
subplot(2,1,1)
plot(dx_comp_e,c_stance_comp_tab,dx_ext_e,c_stance_ext_tab)
subplot(2,1,2)
% plot(dx_comp,c_stance_comp_tab.*dx_comp,dx_ext,c_stance_ext_tab.*dx_ext)
plot([-fliplr(dx_comp_e),dx_ext_e],[fliplr(c_stance_comp_tab),c_stance_ext_tab])

%%
% dx_comp = (-200:1:-1)./(60*1000);%-1*[20 35 50 70 100 200]./(60*1000);
% dx_ext  =  (1:1:200)./(60*1000);%  [20 35 50 70 100 200]./(60*1000);
% dx_comp = -1*[0 1 5 10 20 35 50 70 100 200 400]./(60*1000);
% dx_ext  =    [0 1 5 10 20 35 50 70 100 200 400]./(60*1000);

dx_e = [fliplr(dx_comp_e) dx_ext_e];
dx = [fliplr(dx_comp) dx_ext];
threshold = 0;%1e-3;
c_swing_comp     = @(dx)(213.5932*(1./abs(dx))-4927.5);      % Ns/m
c_swing_ext      = @(dx)(146.3288*(1./abs(dx))-8808.5);      % Ns/m


c_swing          = [c_swing_comp(dx_comp), c_swing_ext(dx_ext)];

% k_bumper        = 130000;                                 % N/m
c_stance_comp   = @(dx)(2.1443*(1./abs(dx)) + 885.0653);    % Ns/m
c_stance_ext    = @(dx)(7.0819*(1./abs(dx)) + 65579);       % Ns/m
c_stance        = [c_stance_comp(dx_comp), c_stance_ext(dx_ext)];

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
hold on;
axis([dx(1) dx(end) (min([Fswing Fstance])-20) (max([Fswing Fstance])+20)])

plot(dx_e,Fswing(bool_vect_e~=0),'bo',dx_e,Fstance((bool_vect_e~=0)),'r*','MarkerSize',12)
set(lineP, 'LineWidth', 4);
xlabel('m/s','FontSize',26)
ylabel('N','FontSize',26)
legend('ploynomial of $F_{sw}$','polynomial of  $F_{st}$','Measured  $F_{sw}$','Measured  $F_{st}$','Location','northwest','FontSize',26)
title('Hydraulic damping forces','FontSize',26)

