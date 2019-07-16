function material = mtrl_Ferrite(Temperature)
%MTRL_Ferrite defines the properties of the 'Ferrite' material

FunctionName = mfilename;
MaterialName = FunctionName(6:end);

% set default temperature is not defined
if nargin < 1
  Temperature = 20;
end

material.Name = [MaterialName,'@',num2str(Temperature),'C'];
material.TemperatureRef = 20; % [C]
material.RelativePermeability = [1.05 1.05];
material.RemanenceRef = 0.425; % [T]
material.RemanenceTemperatureCoeff = 0.11; % [%T/C]  

% compute the permanent magnet remanence at 'Temperature' Celsius
material.Remanence = material.RemanenceRef - (material.RemanenceTemperatureCoeff*material.RemanenceRef)*100 * (Temperature-material.TemperatureRef);
material.CoercitiveField = material.Remanence / (4e-7*pi * material.RelativePermeability(1));

material.ElConductivity= 3.22;
material.MassDensity = 7500; 

end % function