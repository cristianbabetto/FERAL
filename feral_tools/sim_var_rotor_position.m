function [Res, Vec, Skew] = sim_var_rotor_position(MD, SD)
%% SIM_VAR_ROTOR_POSITION simulate the rotation of the rotor with

%% Save initial time
Res.StartTime = datestr(clock, 31);

%% Set default settings if not defined
default_data_settings
[MD, SD] = set_default_data_settings(MD, SD, DefaultSettings);

%% Set default plot settings if not defined
if SD.PlotResults == 1
  [MD, SD] = set_default_plot_settings(MD, SD);
end

% enable warning messages
warning(SD.Warning)

% print all the results in the command window
if isOctave
  more off % for Octave compatibility
end

% add underscore after FileResultsPrefix
if ~strcmp(SD.FileResultsPrefix, '') && ~strcmp(SD.FileResultsPrefix, '_')
  SD.FileResultsPrefix = [SD.FileResultsPrefix, '_'];
end

%% Define short variables
s = MD.Stator;
s.geo = s.Geometry;
s.w = s.Winding;
r = MD.Rotor;
r.geo = MD.Rotor.Geometry;
pp = MD.PolePairs;
ncs = s.w.ConductorsInSlot/s.w.ParallelPaths;
K = s.w.SlotMatrix;
Ipeak = SD.CurrentAmplitude;
alphaie = SD.CurrentAngle;
freq = MD.PolePairs * SD.MechSpeedRPM /60;
SymFactor = 2*pp/MD.SimPoles;
SimulatedSlots = s.geo.Slots / SymFactor;

if length(SD.RotorPositions) > 1
  RotorPositions_step = SD.RotorPositions(2) - SD.RotorPositions(1);
else
  RotorPositions_step = 0;
end

%% Create folders

% Temp files
if ~isfield(SD,'TempID')
  SD.TempFolder = [SD.TempFolderPath, '\', SD.TempFolderName];
else
  SD.TempFolder = [SD.TempFolderPath, '\', SD.TempFolderName, '_', num2str(SD.TempID)];
end

if ~exist(SD.TempFolder,'dir')
  mkdir(SD.TempFolder);
end

% Results folder
if ~exist(SD.ResultsFolder, 'dir')
  mkdir(SD.ResultsFolder);
end

%% Set some material properties if missing

% Set slot conductor mass density
s.Material.Slot = warning_missing_field(s.Material.Slot, 'MassDensity', 0);

% Set slot conductor electric conductivity
s.Material.Slot = warning_missing_field(s.Material.Slot, 'ElConductivity', 0);

% Set slot conductor specific cost
s.Material.Slot = warning_missing_field(s.Material.Slot, 'SpecificCost', 0);

% Set lamination mass density
s.Material.Lamination = warning_missing_field(s.Material.Lamination, 'MassDensity', 0);

% Set stator iron losses coefficients
s.Material.Lamination = warning_missing_field(s.Material.Lamination, 'HysteresisCoeff', 0);
s.Material.Lamination = warning_missing_field(s.Material.Lamination, 'AlphaCoeff', 0);
s.Material.Lamination = warning_missing_field(s.Material.Lamination, 'BetaCoeff', 0);
s.Material.Lamination = warning_missing_field(s.Material.Lamination, 'EddyCurrentCoeff', 0);

% Set rotor iron losses coefficients
r.Material.Lamination = warning_missing_field(r.Material.Lamination, 'HysteresisCoeff', 0);
r.Material.Lamination = warning_missing_field(r.Material.Lamination, 'AlphaCoeff', 0);
r.Material.Lamination = warning_missing_field(r.Material.Lamination, 'BetaCoeff', 0);
r.Material.Lamination = warning_missing_field(r.Material.Lamination, 'EddyCurrentCoeff', 0);

% Set lamination specific cost
s.Material.Lamination = warning_missing_field(s.Material.Lamination, 'SpecificCost', 0);

% Set magnet electric conductivity
s.Material.Magnet = warning_missing_field(s.Material.Lamination, 'ElConductivity', 0);

% define short variables
% stator and rotor lamination properties
StatorLamProp     = s.Material.Lamination;
RotorLamProp      = r.Material.Lamination;

%% Open FEMM instance
if SD.NewFemmInstance == 1
  openfemm(SD.MinimizeFemm); % open a FEMM instance
end

%% Add sliding bands to model
opendocument([SD.ModelPath, '\', SD.ModelName,'.fem']); % open the model
draw_gap_lines(MD, MD.AirgapMeshSize); % add the air-gap bands
mi_saveas([SD.TempFolder, '\', SD.ModelName, '_SB.fem']); % save the modified model
mi_close() % close the model

%% Start simulation loops
% Initialize skew index
sk = 1;
SimCounter = 1;
TotalSimulationTime = 0;
NumOfSimulations = length(SD.Skew_vec) * length(SD.RotorPositions);

for skew = SD.Skew_vec % for each skew angle
  
  thm = 1; % initialize rotor position index
  
  for thetam = SD.RotorPositions % for each rotor position
    
    opendocument([SD.TempFolder, '\', SD.ModelName, '_SB.fem']); % open fem model
    
    tic
    sim_pre_processing % solve the problem
    sim_post_processing % get the results
    SimulationTime = toc;
    
    mi_close(); % close pre-processing in femm
    
    TotalSimulationTime = TotalSimulationTime + SimulationTime;
    
    % Show progress state information
    if SD.DisplayProgress == 1 % basic
      clc
      disp(['Process state ', num2str(SimCounter/NumOfSimulations*100,2),' %'])
      disp(['Simulation ', num2str(SimCounter),' of ',num2str(NumOfSimulations)])
      disp(['Remaining time ', num2str((NumOfSimulations - SimCounter)*SimulationTime),' seconds, ', num2str((NumOfSimulations - SimCounter)*SimulationTime/60),' minutes, ',num2str((NumOfSimulations - SimCounter)*SimulationTime/60/60),' hours']);
    end
    
    % If there is only one skew angle
    % create two equal rows for a more general code
    if length(SD.Skew_vec) == 1
      sk = [1 2];
      sk_Bg = 1;
    else
      sk_Bg = sk;
    end
    
    %% Store the simulation results
    Skew.RotorPositions(thm) = thetam;
    Skew.Ia(thm) = ia;
    Skew.Ib(thm) = ib;
    Skew.Ic(thm) = ic;
    Skew.CurrentInSlot(thm,:) = CurrentInSlot;
    Skew.FluxA(sk,thm) = FluxABC(1);
    Skew.FluxB(sk,thm) = FluxABC(2);
    Skew.FluxC(sk,thm) = FluxABC(3);
    Skew.FluxD(sk,thm) = FluxD;
    Skew.FluxQ(sk,thm) = FluxQ;
    Skew.TorqueMXW(sk,thm) = TorqueMXW;
    Skew.TorqueDQ(sk,thm) = TorqueDQ;
    Skew.ForceX(sk,thm) = ForceX;
    Skew.ForceY(sk,thm) = ForceY;
    Skew.Energy(sk,thm) = Energy;
    Skew.Coenergy(sk,thm) = Coenergy;
    Skew.IntegralAJ(sk,thm) = AJint;
    Skew.MaxFluxDensityTeeth(sk,thm) = MaxFluxDensityTeeth;
    Skew.MaxFluxDensityYoke(sk,thm) = MaxFluxDensityYoke;
    Skew.AirgapFluxDensity(thm,:,sk_Bg) = AirgapFluxDensity;
    Skew.AirgapFluxDensityFund(sk, thm) = AirgapFluxDensityFund;
    
    %% Store the mesh element properties
    if SD.IronLossesFFT == 1
      
      if length(SD.Skew_vec) == 1 % only one skewing angle
        Skew.ElmAz_mat(thm,:) = ElmAz;
        Skew.ElmBx_mat(thm,:) = ElmBx;
        Skew.ElmBy_mat(thm,:) = ElmBy;
      else % more skewing angles
        Skew.ElmAz_mat(thm,:,sk) = ElmAz;
        Skew.ElmBx_mat(thm,:,sk) = ElmBx;
        Skew.ElmBy_mat(thm,:,sk) = ElmBy;
      end
      
    end % if SD.IronLossesFFT == 1
    
    % rotor position counter
    thm = thm + 1;
    
    % simulation counter
    SimCounter = SimCounter + 1;
    
  end % for thm = SD.RotorPositions
  
  % skewing counter
  sk = sk + 1;
  
end % for skew = SD.Skew

%% Close FEMM instance
if SD.CloseFemm
  closefemm;
end

%% Save time
% Save current time
Res.FinishTime = datestr(clock, 31);
% Save total simulation time
Res.TotalSimulationTime = TotalSimulationTime;

%% Compute the skewed arrays
Vec.RotorPositions         = Skew.RotorPositions;
Vec.Ia                     = Skew.Ia;
Vec.Ib                     = Skew.Ib;
Vec.Ic                     = Skew.Ic;
Vec.FluxA                  = mean(Skew.FluxA);
Vec.FluxB                  = mean(Skew.FluxB);
Vec.FluxC                  = mean(Skew.FluxC);
if length(RotorPositions_step) > 1
  Vec.EmfA                   = gradient(Vec.FluxA, RotorPositions_step*pi/180);
  Vec.EmfB                   = gradient(Vec.FluxB, RotorPositions_step*pi/180);
  Vec.EmfC                   = gradient(Vec.FluxC, RotorPositions_step*pi/180);
end
Vec.FluxD                  = mean(Skew.FluxD);
Vec.FluxQ                  = mean(Skew.FluxQ);
Vec.TorqueMXW              = mean(Skew.TorqueMXW);
Vec.TorqueDQ               = mean(Skew.TorqueDQ);
Vec.RippleSTD              = std(Vec.TorqueMXW)/mean(Vec.TorqueMXW)*100;
Vec.Ripple                 = (max(Vec.TorqueMXW) - min(Vec.TorqueMXW))/mean(TorqueMXW)*100;
Vec.ForceX                 = max(Skew.ForceX);
Vec.ForceY                 = max(Skew.ForceY);
Vec.Energy                 = mean(Skew.Energy);
Vec.Coenergy               = mean(Skew.Coenergy);
Vec.IntegralAJ             = mean(Skew.IntegralAJ);
Vec.MaxFluxDensityTeeth    = mean(Skew.MaxFluxDensityTeeth);
Vec.MaxFluxDensityYoke     = mean(Skew.MaxFluxDensityYoke);
Vec.AirgapFluxDensity      = Skew.AirgapFluxDensity;
Vec.AirgapFluxDensityFund  = abs(mean(Skew.AirgapFluxDensityFund));
Vec.AirgapFluxDensityAngle = AirgapFluxDensityAngleVec;

%% Compute average or max values
Res.ia                    = ia;
Res.ib                    = ib;
Res.ic                    = ic;
Res.Id                    = Id;
Res.Iq                    = Iq;
Res.CurrentAmplitude      = Ipeak;
Res.CurrentAngle          = alphaie;
Res.FluxA                 = Vec.FluxA(end);
Res.FluxB                 = Vec.FluxB(end);
Res.FluxC                 = Vec.FluxC(end);
Res.FluxD                 = mean(Vec.FluxD);
Res.FluxQ                 = mean(Vec.FluxQ);
Res.Flux                  = hypot(Res.FluxD, Res.FluxQ);
Res.TorqueMXW             = mean(Vec.TorqueMXW);
Res.TorqueDQ              = mean(Vec.TorqueDQ);
Res.ForceX                = max(Vec.ForceX);
Res.ForceY                = max(Vec.ForceY);
Res.Energy                = mean(Vec.Energy);
Res.Coenergy              = mean(Vec.Coenergy);
Res.IntegralAJ            = mean(Vec.IntegralAJ);
Res.MaxFluxDensityTeeth   = max(Vec.MaxFluxDensityTeeth);
Res.MaxFluxDensityYoke    = max(Vec.MaxFluxDensityYoke);
Res.AirgapFluxDensityFund = mean(Vec.AirgapFluxDensityFund);

%% Compute materials weights
% Lamination (teeth and yoke)
Res.Weight.Teeth  = s.geo.ToothWidth * s.geo.SlotHeight * s.geo.StackLength * SD.PackFactor * s.geo.Slots * StatorLamProp.MassDensity;
Res.YokeHeight    = StatorYokeHeight;
Res.Weight.Yoke   = pi * (s.geo.OuterDiameter - Res.YokeHeight) * Res.YokeHeight * s.geo.StackLength * SD.PackFactor * StatorLamProp.MassDensity;
% Conductors
Res.EndWindingLength  = MD.EndWindingLength;
Res.ConductorLength   = s.geo.StackLength + MD.EndWindingLength;
Res.ConductorVolume   = s.w.SlotFillFactor * SlotCrossSection * s.geo.Slots * Res.ConductorLength;
Res.Weight.Conductor  = Res.ConductorVolume * s.Material.Slot.MassDensity;

%% Compute stator material costs
Res.Cost.Conductor  = s.Material.Slot.MassDensity * s.Material.Slot.SpecificCost;
Res.Cost.Core       = s.Material.Lamination.MassDensity * s.Material.Lamination.SpecificCost;

%% Compute stator Joule Losses
calc_joule_losses

%% Compute iron losses

% maximum flux density in the stator teeth and yoke
Bmax_t            = Res.MaxFluxDensityTeeth;
Bmax_yk           = Res.MaxFluxDensityYoke;

% Define some short variables
% Iron losses equation: Pfe = Khy * f^alpha * B^beta + Kec * f^2 * B^2
% stator lamination iron losses coefficients
StatorKhy         = StatorLamProp.HysteresisCoeff;
StatorKec         = StatorLamProp.EddyCurrentCoeff;
StatorAlphaCoeff  = StatorLamProp.AlphaCoeff;
StatorBetaCoeff   = StatorLamProp.BetaCoeff;
% rotor lamination iron losses coefficients
RotorKhy          = RotorLamProp.HysteresisCoeff;
RotorKec          = RotorLamProp.EddyCurrentCoeff;
RotorAlphaCoeff   = RotorLamProp.AlphaCoeff;
RotorBetaCoeff    = RotorLamProp.BetaCoeff;

% Compute iron losses with the FFT method
if SD.IronLossesFFT == 1
  calc_fft_iron_losses
end

% Compute the iron losses with the simple method
calc_iron_losses

%% Magnet losses fft
if SD.MagnetLossesFFT == 1
  calc_magnetlosses_fft
else
  Res.Losses.Magnet = NaN;
end

%% Extend flux and torque waveforms from 60 el-deg to 360 el-deg
if SD.CompletePeriod
  Vec = complete_waveform_period(Vec);
  CompletePlotString = '_complete';
else
  CompletePlotString = '';
end

%% Save mesh nodes (heavy file)
if SD.SaveMeshNodes == 1
  Res.Mesh.NumNodes = NumNodes;
  Res.Mesh.XY = [Xmsh, Ymsh];
end

%% Compute and save additional results
Res.ModelData           = MD; % save model data
Res.SimData             = SD; % save simulation data
Res.SlotCrossSection    = SlotCrossSection; % Slot cross section
Res.ElFrequency         = freq; % Electrical frequency [Hz]
Res.ElSpeed             = 2*pi*Res.ElFrequency; % Electrical speed [rad/s el.]
Res.MechSpeed           = Res.ElSpeed/MD.PolePairs; % Mechanical speed [rad/s]
Res.MechSpeedRPM        = SD.MechSpeedRPM; % Mechanical speed RPM [rpm]
Res.ElSpeed             = 2*pi*freq; % Electrical speed [rad/s el.]
Res.FluxAngle           = angle(Res.FluxD + 1i*Res.FluxQ)*180/pi; % Flux angle [deg]
Res.FluxD1              = Res.FluxD + SD.EndWindingInductance * Res.Id; % d-axis flux [Vs]
Res.FluxQ1              = Res.FluxQ + SD.EndWindingInductance * Res.Iq; % q-axis flux [Vs]
Res.Flux1               = hypot(Res.FluxD1, Res.FluxQ1); % total flux with end-winding [Vs]
Res.FluxAngle1          = angle(Res.FluxD1 + 1i*Res.FluxQ1)*180/pi; % Flux angle [deg]
Res.Ud                  = Res.WindingResistance * Res.Id - Res.ElSpeed * Res.FluxQ1; % d-axis voltage [V]
Res.Uq                  = Res.WindingResistance * Res.Iq + Res.ElSpeed * Res.FluxD1; % q-axis voltage [V]
Res.Voltage             = hypot(Res.Ud, Res.Uq); % Voltage [V]
Res.AngleFluxCurrent    = Res.FluxAngle1 + 90 - Res.CurrentAngle; % Flux-Current angle displacement [deg]
Res.MechPower           = 1.5 * Res.ElSpeed * Res.Flux1 * Res.CurrentAmplitude * cosd(Res.AngleFluxCurrent); % Mechanical power [W]
Res.ReactPower          = 1.5 * Res.ElSpeed * Res.Flux1 * Res.CurrentAmplitude * sind(Res.AngleFluxCurrent); % Reactive power [Var]
Res.AddLossesCoeff      = SD.AddLossesCoeff; % Additional losses coefficient [-]
Res.TotalLosses         = (Res.Losses.Conductor + Res.Losses.Lamination.Total + Res.Losses.Magnet) * Res.AddLossesCoeff; % Total losses [W]
Res.InputPower          = Res.MechPower + Res.TotalLosses; % Input active power [W]
Res.Phi                 = atand(Res.ReactPower/Res.InputPower); % Angle Phi [deg]
Res.PowerFactor         = cosd(Res.Phi); % Power factor [-]
Res.Efficiency          = Res.MechPower / (Res.MechPower + Res.TotalLosses); % Efficiency [%]

%% Save results to file
if SD.SaveResults == 1
  
  % Set skew string
  if (length(SD.Skew_vec) == 1 && SD.Skew_vec(1) ~= 0)
    Res.SkewString = ['skew_', number2string(SD.Skew_vec, SD.DecimalSymbol, SD.FormatNumber),'_deg_'];
  elseif length(SD.Skew_vec) > 1
    Res.SkewString = ['skew_', number2string(SD.Skew_vec, SD.DecimalSymbol, SD.FormatNumber),'_deg_'];
  else
    Res.SkewString = '';
  end
  
  CurrentAmplitudeString = ['Ipk_', number2string(Ipeak, SD.DecimalSymbol, SD.FormatNumber),'_A'];
  CurrentAngleString = ['aie_', number2string(alphaie, SD.DecimalSymbol, SD.FormatNumber),'_deg'];
  Res.CurrentString = [CurrentAmplitudeString,'_',CurrentAngleString];
  Res.RotorPositionString = ['thme_', number2string(SD.RotorPositions*pp, SD.DecimalSymbol, SD.FormatNumber),'_deg'];
  Res.SpeedString = ['RPM_', number2string(SD.MechSpeedRPM, SD.DecimalSymbol, SD.FormatNumber),'_rpm'];
  Res.DateString = datestr(clock,30);
  
  % Set the file results name
  if ~isfield(SD,'FileResultsName')
    SD.FileResultsName = ['VRP_',Res.SkewString, Res.CurrentString, '_', Res.RotorPositionString, '_', Res.SpeedString, '_', Res.DateString,'.mat'];
    CompleteFileNameResults = [SD.ResultsFolder, '\', SD.FileResultsPrefix, SD.FileResultsName];
  else
    CompleteFileNameResults = SD.FileResultsName;
  end % if ~isfield(SD,'FileResultsName')
  
  
  % Clear the output structures if not required
  if nargout == 1
    Vec = [];
    Skew = [];
  elseif nargout == 2
    Skew = [];
  end
  
  % Save the results
  if isOctave
    % Matlab-Octave compatibility option
    % large file size are not well suported
    save(CompleteFileNameResults, 'Res')
    save(CompleteFileNameResults, 'Vec','-append')
    save(CompleteFileNameResults, 'Skew','-append')
  else
    save(CompleteFileNameResults, 'Res', 'Vec', 'Skew');
  end % if isOctave
  
end % if SD.SaveResults == 1

%% Delete auxiliary files
if SD.ClearAuxFiles == 1 && SD.IronLossesFFT == 1
  delete([SD.TempFolder,'/MeshNodes.txt']);
  delete([SD.TempFolder,'/ElementsValues.txt']);
  delete([SD.TempFolder,'/get_elements_values.lua']);
  delete([SD.TempFolder,'/get_mesh_nodes.lua']);
end

if SD.ClearTempFolder == 1
  delete([SD.TempFolder, '\', SD.ModelName, '_SB.fem']);
  delete([SD.TempFolder,'\temp.fem']);
  delete([SD.TempFolder,'\temp.ans']);
  if SD.IronLossesFFT == 1
    delete([SD.TempFolder,'\MeshNodes.txt']);
    delete([SD.TempFolder,'\ElementsValues.txt']);
    delete([SD.TempFolder,'\get_elements_values.lua']);
    delete([SD.TempFolder,'\get_mesh_nodes.lua']);
  end
  rmdir(SD.TempFolder)
end

% enable warning messages
warning('on')

%% Plot simulation results
if SD.PlotResults == 1 && length(SD.RotorPositions) > 1
     
  plot_sim_var_rotor_position_results(Res, Vec);
  
  % close all the figures
  if SD.CloseFigures == 1
    close all
  end % if SD.PlotResults == 1
  
end % function