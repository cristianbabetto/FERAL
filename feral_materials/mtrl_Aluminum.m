function material = mtrl_Aluminium(Temperature)
%MTRL_ALUMINIUM defines the properties of the 'aluminium' material

FunctionName = mfilename;
MaterialName = FunctionName(6:end);

% set default temperature is not defined
if nargin < 1
  Temperature = 20;
end

material.Name = [MaterialName,'@',num2str(Temperature),'C'];
material.MassDensity = 2700; % mass density of the slot material (kg/m3)
% thermal equation: ElResistivity = 1/ElConductivityRef*(1 + TemperatureCoeff*(T-TemperatureRef))
material.TemperatureRef = 20; 
material.TemperatureCoeff = 4e-3;
material.ElConductivityRef = 37.7;  % electric conductivity (MS/m) @ TemperatureRef
material.ElResistivity = 1/material.ElConductivityRef * (1 + material.TemperatureCoeff * (Temperature - material.TemperatureRef ));            % electric conductivity (MS/m) @ 120C
material.ElConductivity = 1/material.ElResistivity;

% other properties 
material.PoissonRatio = 0.3; % [-]
material.YoungModulus = 70; % [GPa]


end