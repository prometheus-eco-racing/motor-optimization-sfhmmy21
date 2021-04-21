clear all;
close all;
addpath('c:\\femm42\\mfiles');  %path is where femm files exist
savepath;
openfemm(2)

%% Input
tqdes = Torque_Specification();   %Calculates Desired Max Torque
Initial_Motor_Parameters;         %Initial Geometry Guess
Optimization_Parameters; 

%% Initialize bestMass and stall
bestMass = 0;		% Place holder for optimal cost
stall = 0;		% Number of iterations since the last forward progress

%% Optimization
for k = 1:nmax
    fprintf('Iteration %i; d = %f; stall = %i\n',k,d,stall);
    
    bOK = 0;
    while (bOK == 0) % randomly try picking a new geometry and retry until all constraints are met
        
        % If first time through the loop, evaluate the initial condition
        % Otherwise, randomly pick a nearby geometry
        if (k == 1)
            dd = 0;
        else
            dd = d;
        end
        
        % Randomly pick a new candidate geometry
        newrso = rso* (1 + dd*myrand);
        newrsi = rsi* (1 + dd*myrand);
        newdm  = dm * (1 + dd*myrand);
        newds  = ds * (1 + dd*myrand);
        newdc  = dc * (1 + dd*myrand);
        newfm  = fm * (1 + dd*myrand);
        newfp  = fp * (1 + dd*myrand);
        newft  = ft * (1 + dd*myrand);
        newfb  = fb * (1 + dd*myrand);
        newhh  = hh;
        newrro = (newrso + go + newdm + newdc);                             
        bOK=1;
        
                
        % Constaints Check
        % If your constraint isn't met, just say the geometry isn't OK and try a new one on next iteration...

        if (newdm < 0) bOK=0; end                                   %dimension
        if (newdc < 0) bOK=0; end                                   %dimension
        if (newds < 0) bOK=0; end                                   %dimension
        if ((newfm > 1) || (newfm < 0)) bOK=0; end                  %fraction
        if ((newfp > 1) || (newfp < rsi*ft/rso)) bOK=0; end         %so that shoe is wider than tooth
        if (newrro > 200) bOK = 0; end                              %Outer Radius is smaller than rim radius 
        CoilLength=newrso-newrsi-newds-2*pi*newfb*newft*newrsi/12;
        if (CoilLength < 0) bOK=0; end                              %dimension

    end
    
    % Build and analyze candidate geometry
    BuildMotor(newrso, newrsi, newdm, newdc, newds, newfm, newfp, newft, newfb, go, hh, Jpk);
    mi_saveas('femm_files/temp.fem');
    mi_probdef(0,'millimeters','planar',1e-008,hh,25,0) %some solver parameters to speed up solutions proccess
    mi_smartmesh(0);                                    %some solver parameters to speed up solutions proccess
    mi_analyze(1);                                      %solve problem
    mi_loadsolution;                                    %load solution
    
    % Compute torque for a fixed length to figure out how long the machine
    % needs to be to get the desired torque;
    mo_groupselectblock(1);
    tq = mo_blockintegral(22);
    newhh = hh*tqdes/abs(tq); %Calculate length so that motor can produce desired torque
 	newhh = max([newhh,30]);  %min length constaint 
    mo_clearblock;
    
    %Calculate Masses
    Copper_Mass=Calculate_Copper_Mass(newhh);
    Iron_Mass =Calculate_Iron_Mass(newrsi, newrso, go, newdm, newdc, newhh);
    Magnet_Mass=Calculate_Magnet_Mass(newrso, go, newdm, newhh);
    
    %Total Mass, Cost Function
    this_Mass = round(Magnet_Mass+Iron_Mass+Copper_Mass, 2);
    
    
    % See if this candidate is better than the previous optimum.
    % If so, this candidate is the new optimum
    stall = stall + 1;
    if (((this_Mass < bestMass) || (k==1)))
        stall = 0;
        bestMass = this_Mass;
        hh  = newhh;
        rso = newrso;
        rsi = newrsi;
        dm  = newdm;
        ds  = newds;
        dc  = newdc;
        fm  = newfm;
        fp  = newfp;
        ft  = newft;
        fb  = newfb;
        fprintf('bestMass = %f; rro = %f; rso = %f; hh = %f\n', bestMass, newrro, rso, hh);
    end
    
    % save the calculated cost function (mass)
    progress(k) = this_Mass;
    best(k) = bestMass;

    
    % Run through the 'stall logic' to see if the step size should be reduced.
    if (stall > nstall)
        d = d/2;
        stall = 0;
        if (d < dmin)
            break;
        end
    end
    
    % clean up before next iteration
    mo_close
    mi_close
    
end

% round results
rso = round(rso,3);
rsi = round(rsi,3);
dm  = round(dm, 3);
dc  = round(dc, 3);
ds  = round(ds, 3);
fm  = round(fm, 4);
fp  = round(fp, 4);
ft  = round(ft, 4);
fb  = round(fb, 4);
go  = round(go, 3);
hh  = round(hh, 3);
Jpk = round(Jpk,3);

%% Finished! Report the results
fprintf('Optimal Mass = %f\n',bestMass);
fprintf('rso = %f\n', rso);
fprintf('rsi = %f\n', rsi);
fprintf('dm  = %f\n', dm);
fprintf('dc  = %f\n', dc);
fprintf('ds  = %f\n', ds);
fprintf('fm  = %f\n', fm);
fprintf('fp  = %f\n', fp);
fprintf('ft  = %f\n', ft);
fprintf('fb  = %f\n', fb);
fprintf('go  = %f\n', go);
fprintf('hh  = %f\n', hh);
fprintf('Jpk = %f\n', Jpk);

plot(progress,"linewidth", 2);
hold on;
plot(best,"linewidth", 2);
title('Progress of Random Optimization');
xlabel('Iterations') ;
ylabel('Calculated Mass') ;
xlim([0 k]);
hold off;
closefemm
