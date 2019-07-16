function material = mtrl_N35SH(Temperature)
%MTRL_N35SH defines the properties of the 'N35SH' material

FunctionName = mfilename;
MaterialName = FunctionName(6:end);

% set default temperature is not defined
if nargin < 1
  Temperature = 20; % [degree Celsius]
end

material.Name = [MaterialName,'@',num2str(Temperature),'C'];
material.TemperatureRef = 20; % [degree Celsius]
material.RelativePermeability = [1.1 1.1];
material.RemanenceRef = 1.215; % [T]
material.RemanenceTemperatureCoeff = 0.11; % [%Br/(degree Celsius)]  
material.Temperature = Temperature; % [degree Celsius]


% compute the permanent magnet remanence at 'Temperature'
material.Remanence = calc_remanence_at_temperature( material.RemanenceRef, ...
                                                    material.RemanenceTemperatureCoeff, ...
                                                    material.TemperatureRef, ...
                                                    material.Temperature); % [T]

material.CoercitiveField = material.Remanence / (4e-7*pi * material.RelativePermeability(1)); % [A/m]

material.ElResistivity= 150e-8; % [ohm * m]
material.ElConductivity = 1/150e-8; % [S / m]
material.MassDensity = 7500; % [kg/m3]

% other properties
material.CurieTemperature = 310; % [degree Celsius]
material.YoungModulus = 160e3; % [N/mm2]
material.SpecificHeat = 0.12; % [kcal/(kg degree Celsius)]

end % function
