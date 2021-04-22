%% Here you enter the initial motor parameters

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% In this script you need to complete the geometrical parameters of the  %%
% initial motor. To complete you need to examine the physical meaning of %%
% the parameters. As parameters are modified some trade-offs appear. You %%
% need to compromise within the allowable range using your critical      %%
% thinking.                                                              %% 
% There is no correct answer. There is an acceptable range of answers.   %% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rso = ...              % Stator outer radius                                       complete according to your strategy
rsi = (...)*rso;       % Stator inner radius                                       0.35 - 0.65
dm  = (...)*rso;       % Magnet thickness                                          0.04 - 0.012
dc  = (...)*dm;        % Can thickness                                             0.5-1.5
ds  = (...)*dm;        % depth of slot opening                                     0.3-0.9
fm  = ...              % Pole fraction spanned by the magnet                       0.5-0.9
fp  = ...              % Pole fraction spanned by the iron                         0.3-0.9
ft  = ...              % Width of tooth as a fraction of pole pitch at stator ID   0.2-0.6
fb  = ...              % Back iron thickness as a fraction of tooth thickness      0.75-1.25

%%%%%%%%%%%%%%%%%%%%%%%%%
% Stop Here!!!         %%
%%%%%%%%%%%%%%%%%%%%%%%%%

go = 0.5; 	% stator to magnet mechanical clearance 
hh = 25; 	% length in the into-the-page direction 
Jpk = 10.0; 	% peak current density in the winding 
