function T_sp = Torque_Specification()
	% This function calculates the torque needed for the motor to produce,
	% in order to be able to drive a specific vehicle under all conditions. 
    % You need to modify properly the function below the current, named
	% Calculate_Torque() which you can find at the end of the page.

	%% Input - Problem Data Initialization
	Veh_Parameters.RR_Coefficient     = 0.012;
	Veh_Parameters.Drag_Coefficient   = 0.3; 
	Veh_Parameters.Cross_Section_Area = 0.3; %m^2
	Veh_Parameters.Wheel_Diameter     = 0.5; %m
	Veh_Parameters.Mass               = 200; %Kg Driver included
	Veh_Parameters.Inertia_Mass       = 0.1*Veh_Parameters.Mass; %approximation Inertia Mass 10% of Vehicle Mass

	Driver_Parameters.Speed             = 35; %Km/h
	Driver_Parameters.Accel_Time        = 30; %sec
	Driver_Parameters.Uphill_Speed      = 25; %Km/h
	Driver_Parameters.Uphill_Accel_Time = 50; %sec

	Environment_Parameters.AirDensity      =1.225; %Kg/m^3
	Environment_Parameters.G_Acceleration  =9.806; %m/s^2
	Environment_Parameters.Max_Inclination =0.1; %percentage

	Safety_Coefficient = 1.05;


	%% Calculate torque needed under different driving conditions
	T1 = Calculate_Torque(Veh_Parameters, Driver_Parameters, Environment_Parameters, 'const_speed'); % flat surface with constant speed
	T2 = Calculate_Torque(Veh_Parameters, Driver_Parameters, Environment_Parameters, 'acceleration'); % flat surface start
	T3 = Calculate_Torque(Veh_Parameters, Driver_Parameters, Environment_Parameters, 'upward_slope_no_accel'); % upward slope constant speed
	T4 = Calculate_Torque(Veh_Parameters, Driver_Parameters, Environment_Parameters, 'upward_slope_accel'); % upward slope start

	%% Output - Sizing the motor according to the most difficult conditions calculated above. 
	T_sp = round( Safety_Coefficient*max([T1,T2,T3,T4]), 0 ); % max torque + 5% safety margin

	%%
	function T = Calculate_Torque(Veh_Parameters, Driver_Parameters, Environment_Parameters, movement_type)

		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		% Below this point you need to complete the script, calculating slope,         %%       
        % acceleration and initial vehicle speed for the 4 possible driving conditions %%  
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

		% Constant speed, flat surface scenario
		if strcmpi(movement_type, 'const_speed')  % if movement_type == 'const_speed'   
			Theta = 0;
			% initial speed
			u0 = Driver_Parameters.Speed/3.6; % m/s - units must be in SI units
			% mean accel
			a = 0;  
		end
						
		% flat surface start scenario
		if strcmpi(movement_type, 'acceleration')   
			% ...
			%Theta = ...
			%u0 = ... 
			%a = ...
		end
		
		% upward slope constant speed scenario
		if strcmpi(movement_type, 'upward_slope_no_accel') 
			% ...
			%Theta = ...
			%u0 = ... 
			%a = ...
		end
		
		% upward slope start scenario
		if strcmpi(movement_type, 'upward_slope_accel') 
			% ...
			%Theta = ...
			%u0 = ... 
			%a = ...    
		end

		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		% Stop here.                                                                   %%  
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

		% Set easier symbols to calculate forces in vehicle
		M = Veh_Parameters.Mass;
		mi = Veh_Parameters.RR_Coefficient;
		Cd = Veh_Parameters.Drag_Coefficient;
		A = Veh_Parameters.Cross_Section_Area;
		R = Veh_Parameters.Wheel_Diameter/2;
		I_M = Veh_Parameters.Inertia_Mass;
		M = Veh_Parameters.Mass;
		p = Environment_Parameters.AirDensity;
		g = Environment_Parameters.G_Acceleration;
			   

		%% Forces Calculation
		D=0.5*Cd*p*A*u0^2; %Drag

		RR=M*g*cosd(Theta)*mi; %Rolling Resistance

		XG=M*g*sind(Theta);%Gravity Force x axis

		T_F=(M + I_M)*a;  %Total Force

		%% Motor Torque Calculation
		T = (T_F+D+RR+XG)*R;

	end

end
