%%
dx_comp = -1*[20 35 50 70 100 200]./(60*1000);
dx_ext  =    [20 35 50 70 100 200]./(60*1000);
c_swing_comp_tab  = fliplr([58000 124000 178000 251000 363000 635000]);
c_swing_ext_tab   = fliplr([33700 79000 117000 167000 244000 429000]);
c_swing_comp_poly = polyfit(1./abs(dx_comp),c_swing_comp_tab,1);
c_swing_ext_poly  = polyfit(1./abs(dx_ext),c_swing_ext_tab,1);
c_swing_between_poly = polyfit(1./[dx_comp(1) dx_ext(1)],[635000 429000],1);

c_stance_comp_tab  = fliplr([1340 2110 2600 3720 4910 7080]);
c_stance_ext_tab   = fliplr([6130 70000 74500 77500 81300 83200]);
c_stance_comp_poly = polyfit(1./abs(dx_comp),c_stance_comp_tab,1);
c_stance_ext_poly  = polyfit(1./abs(dx_ext),c_stance_ext_tab,1);

c_swing_comp_bet = c_swing_comp_tab(1)/(dx_comp(1));
c_swing_ext_bet  = c_swing_ext_tab(1)/abs(dx_ext(1));

%%
dx_comp = -1*[0 1 5 10 20 35 50 70 100 200 400]./(60*1000);
dx_ext  =    [0 1 5 10 20 35 50 70 100 200 400]./(60*1000);

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

if dx(i) < -threshold
    if dx(i) < -20/(60*1000)
        c_swing(i) = c_swing_comp(dx(i));
    else
        c_swing(i) = c_swing_comp_bet*dx(i);
    end
    c_stance(i) = c_stance_comp(dx(i));
elseif dx(i) > threshold
    
    if dx(i) > 20/(60*1000)
        c_swing(i) = c_swing_ext(dx(i));
    else
        c_swing(i) = c_swing_ext_bet*dx(i);
    end
    c_stance(i) = c_stance_ext(dx(i));
else
    c_swing(i) = 0;
    c_stance(i) = 0;
end

end
Fswing = c_swing.*dx;
Fstance = c_stance.*dx;
plot(dx,Fswing,dx,Fstance)
legend('$F_{swing}$','$F_{stance}$')

