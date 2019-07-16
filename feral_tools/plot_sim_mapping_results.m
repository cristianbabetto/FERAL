function plot_sim_mapping_results(Map)

SD = Map.SimData;

%% Create figures folder if does not exist
if SD.SaveFigures == 1
  % create the figures folder
  if ~exist([SD.FiguresFolder, '/'], 'dir')
    mkdir(SD.FiguresFolder)
  end
end

%% Remove underscore from FileResultsPrefix (not necessary) 
UnderscoreIdx = strfind(SD.FileResultsPrefix, '_');
FigurePrefix = SD.FileResultsPrefix;
FigurePrefix(UnderscoreIdx) = ' '; % replace underscore with space

if isfield(Map, 'MTPA') && isfield(Map, 'FW')
  
  %% Plot MTPA, FW, MTPV
  figure('Name', [FigurePrefix, ' Map'], 'NumberTitle','off')
  plot_map(Map, SD);
  save_pdf([SD.FiguresFolder, '\', SD.FileResultsPrefix, 'Map', '_', Map.DateString], SD.SaveFigures, SD.FigureWidth, SD.FigureHeight);

  %% Plot torque vs speed
  figure('Name', [FigurePrefix, ' Torque vs Speed'], 'NumberTitle','off')
  plot_torque_vs_speed(Map, SD)
  save_pdf([SD.FiguresFolder, '\', SD.FileResultsPrefix, 'Torque_vs_Speed', '_', Map.DateString], SD.SaveFigures, SD.FigureWidth, SD.FigureHeight);

  %% Plot power vs speed
  figure('Name', [FigurePrefix, ' Power vs Speed'], 'NumberTitle','off')
  plot_power_vs_speed(Map, SD)
  save_pdf([SD.FiguresFolder, '\', SD.FileResultsPrefix, 'Power_vs_Speed', '_', Map.DateString], SD.SaveFigures, SD.FigureWidth, SD.FigureHeight);
  
  %% Plot ipeak vs speed
  figure('Name', [FigurePrefix, ' Current vs Speed'], 'NumberTitle','off')
  plot_ipeak_vs_speed(Map, SD)
  save_pdf([SD.FiguresFolder, '\', SD.FileResultsPrefix, 'Ipeak_vs_Speed', '_', Map.DateString], SD.SaveFigures, SD.FigureWidth, SD.FigureHeight);
    
  
end

%% Plot iso-torque and iso-flux
figure('Name', [FigurePrefix, ' Iso-Torque and Iso-Flux'], 'NumberTitle','off')
plot_isotorque_isoflux(Map, SD);
save_pdf([SD.FiguresFolder, '\', SD.FileResultsPrefix, 'Iso_torque_Iso_flux', '_', Map.DateString], SD.SaveFigures, SD.FigureWidth, SD.FigureHeight);

%% Plot FluxD vs Id
figure('Name', [FigurePrefix, ' FluxD vs Id'], 'NumberTitle','off')
plot_fluxD_vs_Id(Map, SD)
save_pdf([SD.FiguresFolder, '\', SD.FileResultsPrefix, 'FluxD_vs_Id', '_', Map.DateString], SD.SaveFigures, SD.FigureWidth, SD.FigureHeight);

%% Plot FluxQ vs Iq
figure('Name', [FigurePrefix, ' FluxQ vs Iq'], 'NumberTitle','off')
plot_fluxQ_vs_Iq(Map, SD)
save_pdf([SD.FiguresFolder, '\', SD.FileResultsPrefix, 'FluxQ_vs_Iq', '_', Map.DateString], SD.SaveFigures, SD.FigureWidth, SD.FigureHeight);

%% Plot FluxD vs Iq
figure('Name', [FigurePrefix, ' FluxD vs Iq'], 'NumberTitle','off')
plot_fluxD_vs_Iq(Map, SD)
save_pdf([SD.FiguresFolder, '\', SD.FileResultsPrefix, 'FluxD_vs_Iq', '_', Map.DateString], SD.SaveFigures, SD.FigureWidth, SD.FigureHeight);

%% Plot FluxQ vs Id
figure('Name', [FigurePrefix, ' FluxQ vs Id'], 'NumberTitle','off')
plot_fluxQ_vs_Id(Map, SD)
save_pdf([SD.FiguresFolder, '\', SD.FileResultsPrefix, 'FluxQ_vs_Id', '_', Map.DateString], SD.SaveFigures, SD.FigureWidth, SD.FigureHeight);

end % function