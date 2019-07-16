function material = mtrl_M530_50A(Frequency)
%MTRL_M530_50A defines the properties of the lamination 'M530_50A'

FunctionName = mfilename;
MaterialName = FunctionName(6:end);

% set default frequency is not defined
if nargin < 1
  Frequency = 50;
end

material.Name = [MaterialName,'@',num2str(Frequency),'Hz'];

% iron losses equation:
% losses = Khy * f^alpha * B^beta + Kec * (f*B)^2
% Khy = hysteresis coefficient
% alpha, beta = frequency and flux density coefficients
% Kec = eddy-current coefficient

% chose the proper lamination data
FrequencyData = [50, 100, 200, 400]; % frequency data array (lamination data sheet)

% default BH curve
Default_BHpoints = [
  0         0
  0.1      56.1
  0.2      74.1
  0.3      85.8
  0.4      95.6
  0.5      105
  0.6      114
  0.7      123
  0.8      133
  0.9      145
  1.0      158
  1.1      174
  1.2      200
  1.3      243
  1.4      333
  1.5      573
  1.6      1345
  1.7      3367
  1.8     6964
  4		1.75e6
  ];



if Frequency < FrequencyData(2) %  0 < f < 100
  
  material.LossesFreqRef = FrequencyData(1); % [Hz]
  material.HysteresisCoeff = 0.07832; % [-]
  material.EddyCurrentCoeff = 0.0003246 ; % [-]
  material.AlphaCoeff = 0.7212; % [-]
  material.BetaCoeff = 1.735; % [-]
  
  material.BHpoints = Default_BHpoints;
  
elseif Frequency >= FrequencyData(2) && Frequency < FrequencyData(3) %  100 <= f < 200
  
  material.LossesFreqRef = FrequencyData(2); % [Hz]
  material.HysteresisCoeff = 0.2145; % [-]
  material.EddyCurrentCoeff = 3.622e-4; % [-]
  material.AlphaCoeff = 1.45e-7; % [-]
  material.BetaCoeff = 0.01342; % [-]
  %material.BHpoints = ; no data available!
  
elseif Frequency >= FrequencyData(3) %  f >= 200

  material.LossesFreqRef = FrequencyData(3); % [Hz]
  material.HysteresisCoeff = 0.0415; % [-]
  material.EddyCurrentCoeff = 2.8e-4; % [-]
  material.AlphaCoeff = 4.81e-6; % [-]
  material.BetaCoeff = 0.01535; % [-]
  %material.BHpoints = ; no data available!
  
end

% load default BH curve is no other curves are defined
if ~isfield(material, 'BHpoints')
  material.BHpoints = Default_BHpoints;
end

material.ElResistivity= 36; % [uOhm*cm]
material.MassDensity = 7700; % mass density of the lamination


end