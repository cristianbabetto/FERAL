function [Map, Skew] = sim_mapping(MD, SD)
%% SIM_MAPPING simulate the model in the Id-Iq plane

%% Save initial time
Res.StartTime = datestr(clock, 31);

%% Set default settings if not defined
% load default settings
default_data_settings

% set default settings
[MD, SD] = set_default_data_settings(MD, SD, DefaultSettings);


% Display progress or not 
% (default is 1)
% it shows the progress state in the command window
if ~isfield(SD,'DisplayProgress')
  DisplayProgress = 1;
else
  DisplayProgress = SD.DisplayProgress;
end

SaveResults = SD.SaveResults; % save SaveResults setting
SD.SaveResults = 0; % disable saving for 'sim_var_rotor_position'

% Disable plot results for sim_var_rotor_position
PlotResults = SD.PlotResults; % save SaveResults setting
SD.PlotResults = 0; % disable saving for 'sim_var_rotor_position'

% Disable warning messages for sim_var_rotor_position
Warning = SD.Warning; % save SaveResults setting
SD.Warning = 'off'; % disable saving for 'sim_var_rotor_position'


% Total number of simulations
NumOfSimulations = length(SD.Id_vec) * length(SD.Iq_vec);
SimCounter = 1;
TotalSimulationTime = 0;

dd = 1; % d-axis current counter
qq = length(SD.Iq_vec); % q-axis current counter

for Id = SD.Id_vec
 
  for Iq = SD.Iq_vec
    
    SD.CurrentAmplitude = hypot(Id,Iq);
    SD.CurrentAngle = atan2d(Iq,Id);

    tic
    [res, ~, skew] = sim_var_rotor_position(MD, SD);
    SimulationTime = toc;
    TotalSimulationTime = TotalSimulationTime + SimulationTime;

    if DisplayProgress == 1
      more off % for Octave compatibility
      clc
      disp(['Process state ', num2str(SimCounter/NumOfSimulations*100,2),' %'])
      disp(['Simulation ', num2str(SimCounter),' of ',num2str(NumOfSimulations)])
      disp(['Remaining time ', num2str((NumOfSimulations - SimCounter)*SimulationTime),' seconds, ', num2str((NumOfSimulations - SimCounter)*SimulationTime/60),' minutes, ',num2str((NumOfSimulations - SimCounter)*SimulationTime/60/60),' hours']);
    end
    
    % save 'sim_var_rotor_position' results
    % Skewed map
    Map.Id(qq,dd) = Id;
    Map.Iq(qq,dd) = Iq;
    Map.CurrentAmplitude(qq,dd) = res.CurrentAmplitude;
    Map.CurrentAngle(qq,dd) = res.CurrentAngle;
    Map.FluxD(qq,dd) = res.FluxD;
    Map.FluxQ(qq,dd) = res.FluxQ;
    Map.Flux(qq,dd) = hypot(res.FluxD, res.FluxQ);
    Map.TorqueMXW(qq,dd) = res.TorqueMXW;
    Map.TorqueDQ(qq,dd) = res.TorqueDQ;
    Map.ForceX(qq,dd) = res.ForceX;
    Map.ForceY(qq,dd) = res.ForceY;
    Map.Energy(qq,dd) = res.Energy;
    Map.Coenergy(qq,dd) = res.Coenergy;
    Map.IntegralAJ(qq,dd) = res.IntegralAJ;
    Map.MaxFluxDensityTeeth(qq,dd) = res.MaxFluxDensityTeeth;
    Map.MaxFluxDensityYoke(qq,dd) = res.MaxFluxDensityYoke;
    
    % All the maps
    Skew.FluxD(qq,dd,:) = skew.FluxD;
    Skew.FluxQ(qq,dd,:) = skew.FluxQ;
    Skew.Flux(qq,dd,:) = hypot(skew.FluxD, skew.FluxQ);
    Skew.TorqueMXW(qq,dd,:) = skew.TorqueMXW;
    Skew.TorqueDQ(qq,dd,:) = skew.TorqueDQ;
    Skew.ForceX(qq,dd,:) = skew.ForceX;
    Skew.ForceY(qq,dd,:) = skew.ForceY;
    Skew.Energy(qq,dd,:) = skew.Energy;
    Skew.Coenergy(qq,dd,:) = skew.Coenergy;
    Skew.IntegralAJ(qq,dd,:) = skew.IntegralAJ;
    Skew.MaxFluxDensityTeeth(qq,dd,:) = skew.MaxFluxDensityTeeth;
    Skew.MaxFluxDensityYoke(qq,dd,:) = skew.MaxFluxDensityYoke;    
    
    
    SimCounter = SimCounter + 1;

    % clear ans file for the next simulation
    delete([res.SimData.TempFolder,'\', res.SimData.TempFileName, '.ans']); 

    qq = qq - 1;
    
  end % for qq = Iq_vec
  
  qq = length(SD.Iq_vec);
  dd = dd + 1;
  
end % for dd = Id_vec

Map.Id_vec = Map.Id(1,:);
Map.Iq_vec = Map.Iq(:,1);
Map.ModelData = MD;
Map.SimData = SD;
Map.TotalSimulationTime = TotalSimulationTime;
Map.SlotCrossSection = res.SlotCrossSection;
Map.PolePairs = MD.PolePairs;
SD.SaveResults = SaveResults; % restore SD.SaveResults;
SD.PlotResults = PlotResults; % restore SD.PlotResults
SD.Warning = Warning; % restore SD.Warning

%% Save results to file
if SD.SaveResults == 1
  
  % Set skew string
  if isfield(SD, 'Skew_vec') && (length(SD.Skew_vec) == 1 && SD.Skew_vec(1) ~= 0)
    Map.SkewString = ['_skew_', number2string(SD.Skew_vec, SD.DecimalSymbol, SD.FormatNumber),'_deg'];
  elseif isfield(SD, 'Skew_vec') && length(SD.Skew_vec) > 1
    Map.SkewString = ['_skew_', number2string(SD.Skew_vec, SD.DecimalSymbol, SD.FormatNumber),'_deg'];
  else
    Map.SkewString = '';
  end
  
  Map.CurrentDString = ['Id_', number2string(SD.Id_vec, SD.DecimalSymbol, SD.FormatNumber),'_A'];
  Map.CurrentQString = ['Iq_', number2string(SD.Iq_vec, SD.DecimalSymbol, SD.FormatNumber),'_A'];
  Map.CurrentString = [Map.CurrentDString, '_', Map.CurrentQString];
  
  if length(SD.RotorPositions) > 1
    Map.RotorPositionString = ['_thme_', number2string(SD.RotorPositions*MD.PolePairs, SD.DecimalSymbol, SD.FormatNumber),'_deg'];
  else
    Map.RotorPositionString = '';
  end
  
  Map.DateString = datestr(clock,30);
    
  % set the file results name
  % (default is MD.FileResultsName)
  if ~isfield(SD,'FileResultsName')
    SD.FileResultsName = ['map', Map.SkewString, '_', Map.CurrentString, Map.RotorPositionString, '_', Map.DateString, '.mat'];
  end % if ~isfield(SimInput,'FileResultsName')
  
  CompleteFileNameResults = [SD.ResultsFolder, '\', SD.FileResultsName];
  SD.CompleteFileNameResults = CompleteFileNameResults;
  
  % Clear the output structures if not required
  if nargout == 1
    Skew = [];
  end
  
  % Save the results
  if isOctave
    % Matlab-Octave compatibility option
    % large file size are not well suported
    save(CompleteFileNameResults, 'Map')
    save(CompleteFileNameResults, 'Skew','-append')
  else
    save(CompleteFileNameResults, 'Map', 'Skew');
  end % if isOctave
  
  
  
end % if SimInput.SaveResults == 1

if SD.PlotResults
  
  plot_sim_mapping_results(Map);
  
end % if SD.PlotResults

end % function