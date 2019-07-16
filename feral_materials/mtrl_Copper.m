function material = mtrl_Copper(Temperature)
%MTRL_COPPER defines the properties of the 'copper' material

FunctionName = mfilename;
MaterialName = FunctionName(6:end);

% set default temperature is not defined
if nargin < 1
  Temperature = 20; % [degree Celsius]
end

material.Name = [MaterialName,'@',num2str(Temperature),'C'];
material.MassDensity = 8900; % mass density of the slot material (kg/m3)
material.TemperatureRef = 20; % [degree Celsius]
material.TemperatureCoeff = 4e-3; % [1/degree Celsius]
material.ElConductivityRef = 59;  % electric conductivity (MS/m) @ TemperatureRef
material.ElResistivity = calc_resistivity_at_temperature( 1/material.ElConductivityRef, ...
                                                          material.TemperatureCoeff, ...
                                                          material.TemperatureRef, ...
                                                          Temperature); % electric conductivity (MS/m) @ T
material.ElConductivity = 1/material.ElResistivity;

% other properties 
material.PoissonRatio = 0.34; % [-]
material.YoungModulus = 110; % [GPa]

end