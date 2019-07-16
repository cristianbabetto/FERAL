function get_model_data(Filename, StructName)
%GET_MODEL_DATA create a general file .m useful for all simulations
%   Filename is the name of the file .m
%   StructName (optional) is the name of the model data structure, default is 'md'

% set default script filename if not defined
% default is 'MODEL_DATA'
if ~exist('Filename', 'var') || strcmp(Filename, '')
  Filename = 'MODEL_DATA';
end

% set default structure name if not defined
% default is 'MD'
if ~exist('StructName', 'var') || strcmp(Filename, '')
  StructName = 'MD';
end

% create and write the model data file
fid = fopen([Filename,'.m'],'wt');
fprintf(fid, ['%%%% General data \n']);
fprintf(fid, ['', StructName, '.ModelName = '' ''; %% .fem model name \n']);
fprintf(fid, ['', StructName, '.MaterialsFolder = ''feral_materials/''; \n']);
fprintf(fid, ['', StructName, '.ToolsFolder = ''feral_tools/''; \n']);
fprintf(fid, ['addpath(', StructName, '.ToolsFolder,', StructName, '.MaterialsFolder); \n']);
fprintf(fid, ['', StructName, '.ScaleFactor = 1e-3; \n']);
fprintf(fid, ['', StructName, '.StackLength = 40*', StructName, '.ScaleFactor; \n']);
fprintf(fid, ['', StructName, '.PackFactor = 0.96; \n']);
fprintf(fid, ['', StructName, '.PolePairs = 4; \n']);
fprintf(fid, ['', StructName, '.Airgap = 0.5e-3; \n']);
fprintf(fid, ['', StructName, '.SimPoles = 8; \n']);
fprintf(fid, ['\n']);
fprintf(fid, ['%%%% Stator general data \n']);
fprintf(fid, ['Stator.Group = 1000; \n']);
fprintf(fid, ['Stator.Geometry.Airgap = ', StructName, '.Airgap; \n']);
fprintf(fid, ['Stator.Geometry.PolePairs = ', StructName, '.PolePairs; \n']);
fprintf(fid, ['Stator.Geometry.StackLength = ', StructName, '.StackLength; \n']);
fprintf(fid, ['Stator.Geometry.Slots = 24;  \n']);
fprintf(fid, ['Stator.Geometry.OuterDiameter = 120*', StructName, '.ScaleFactor; \n']);
fprintf(fid, ['Stator.Geometry.InnerDiameter = 70*', StructName, '.ScaleFactor; \n']);   
fprintf(fid, ['Stator.Geometry.ToothWidth = 4.77*', StructName, '.ScaleFactor; \n']);
fprintf(fid, ['Stator.Geometry.SlotHeight = 15*', StructName, '.ScaleFactor; \n']);     
fprintf(fid, ['%% Stator.Geometry.SlotOpeningWidth = 2.5*', StructName, '.ScaleFactor; \n']);  
fprintf(fid, ['%% Stator.Geometry.SlotOpeningHeight = 0.8*', StructName, '.ScaleFactor; \n']);    
fprintf(fid, ['%% Stator.Geometry.WedgeHeight = 1.5*', StructName, '.ScaleFactor; \n']);  
fprintf(fid, ['%%%% Stator materials \n']);
fprintf(fid, ['Stator.Material.Slot = mtrl_Copper; \n']);
fprintf(fid, ['Stator.Material.Lamination = mtrl_M530_50A; \n']);
fprintf(fid, ['%% Stator.Material.SlotOpening = mtrl_Air; \n']);
fprintf(fid, ['%%%% Stator mesh sizes \n']);
fprintf(fid, ['%% Stator.Mesh.Lamination = 1*', StructName, '.ScaleFactor; \n']);
fprintf(fid, ['%% Stator.Mesh.Slot = 1*', StructName, '.ScaleFactor; \n']);
fprintf(fid, ['%% Stator.Mesh.SlotOpening = 1*', StructName, '.ScaleFactor \n']);
fprintf(fid, ['%%%% Stator winding properties \n']);
fprintf(fid, ['Stator.Winding.SlotFillFactor = 0.4;  \n']); 
fprintf(fid, ['Stator.Winding.ConductorsInSlot = 25; \n']);       
fprintf(fid, ['Stator.Winding.ParallelPaths = 1; \n']);
fprintf(fid, ['Stator.Winding.SlotMatrix = []; \n']);
fprintf(fid, ['\n']);
fprintf(fid, ['%%%% Rotor general data \n']);
fprintf(fid, ['Rotor.Group = 10; \n']);
fprintf(fid, ['Rotor.Alignment = -7.5;  \n']);
fprintf(fid, ['Rotor.Geometry.Airgap = ', StructName, '.Airgap; \n']);
fprintf(fid, ['Rotor.Geometry.PolePairs = ', StructName, '.PolePairs; \n']);
fprintf(fid, ['Rotor.Geometry.StackLength = ', StructName, '.StackLength; \n']);
fprintf(fid, ['Rotor.Geometry.OuterDiameter = 69*', StructName, '.ScaleFactor; \n']);
fprintf(fid, ['Rotor.Geometry.InnerDiameter = 40*', StructName, '.ScaleFactor; \n']);
fprintf(fid, ['%%%% Rotor magnet dimensions \n']);
fprintf(fid, ['%% Rotor.Geometry.Magnet.Thickness = 2*', StructName, '.ScaleFactor; \n']);
fprintf(fid, ['%% Rotor.Geometry.Magnet.Width = 5*', StructName, '.ScaleFactor; \n']);
fprintf(fid, ['Rotor.Geometry.Magnet.Groups = []; %% (for fft losses) \n']);
fprintf(fid, ['%%%% Rotor materials \n']);
fprintf(fid, ['Rotor.Material.Lamination = mtrl_M530_50A; \n']);
fprintf(fid, ['Rotor.Material.Magnet = mtrl_N35SH; \n']);
fprintf(fid, ['%% Rotor.Material.Shaft = mtrl_Air; \n']);
fprintf(fid, ['%% Rotor.Material.Barrier = mtrl_Air; \n']);
fprintf(fid, ['%%%% Rotor mesh sizes \n']);
fprintf(fid, ['%% Rotor.Mesh.Lamination = 1*', StructName, '.ScaleFactor; \n']);
fprintf(fid, ['%% Rotor.Mesh.Magnet = 1*', StructName, '.ScaleFactor; \n']);
fprintf(fid, ['%% Rotor.Mesh.Shaft = 1*', StructName, '.ScaleFactor; \n']);
fprintf(fid, ['%% Rotor.Mesh.Barrier = 1*', StructName, '.ScaleFactor; \n']);
fprintf(fid, ['\n']);
fprintf(fid, ['', StructName, '.Stator = Stator; \n']);
fprintf(fid, ['', StructName, '.Rotor = Rotor; \n']);
fprintf(fid, ['', StructName, '.MotionGroups = [', StructName, '.Rotor.Group,Rotor.Magnet.Groups]; \n']);;
fprintf(fid, '\n');
fprintf(fid, '%%%% Set general simulation data \n');
fprintf(fid, ['%% ', StructName, '.FiguresFolder = ''figures''; \n']);
fprintf(fid, ['%% ', StructName, '.ResultsFolder = ''results''; \n']);
fprintf(fid, ['%% ', StructName, '.ModelPath = ''''; \n']);
fprintf(fid, ['%% ', StructName, '.ModelUnit = ''meters''; \n']);
fprintf(fid, ['%% ', StructName, '.ModelType = ''planar''; \n']);
fprintf(fid, ['%% ', StructName, '.ModelPrecision = 1e-8; \n']);
fprintf(fid, ['%% ', StructName, '.MeshMinAngle = 30; \n']);
fprintf(fid, ['%% ', StructName, '.ACSolver = ''Succ. Approx''; \n']);
fprintf(fid, ['%% ', StructName, '.FemmVisibility = 0; %% set the FEMM visibility \n']);
fprintf(fid, ['%% ', StructName, '.NewFemmInstance = 0; %% open a new FEMM instance \n']);
fprintf(fid, ['%% ', StructName, '.MechSpeedRPM = 1000; %% declare mechanical speed [rpm] \n']);
fprintf(fid, ['%% ', StructName, '.Skew_vec = [0]; %% declare skewing angle array \n']);
fprintf(fid, ['%% ', StructName, '.RotorPositions = [0]; %% declare rotor position array \n']);
fprintf(fid, ['%% ', StructName, '.AirgapMeshSize = 0.25e-3; %% declare air-gap mesh size [m] \n']);
fprintf(fid, ['%% ', StructName, '.EndWindingLength = 0; %% declare end-winding length [m] \n']);
fprintf(fid, ['%% ', StructName, '.EndWindingInductance = 0; %% declare end-winding inductance [H] \n']);
fprintf(fid, ['%% ', StructName, '.AirgapFluxDensityContourPoints = 720; %% number of samples of airgap flux density \n']);
fprintf(fid, ['%% ', StructName, '.AirgapFluxDensityAngle = 360/2/PolePairs; %% angle of airgap flux density \n']);
fprintf(fid, ['%% ', StructName, '.IronLossesFFT = 0; %% abilitate iron losses fft computation \n']);
fprintf(fid, ['%% ', StructName, '.MirrorHalfPeriod = 0; %% mirror an electric period \n']);
fprintf(fid, ['%% ', StructName, '.SaveMeshNodes = 0; %% save the mesh nodes coordinates \n']);
fprintf(fid, ['%% ', StructName, '.SaveMeshElementsValues = 0; %% save mesh elements properties \n']);
fprintf(fid, ['%% ', StructName, '.AddLossesCoeff = 0; %% increase the total losses \n']);
fprintf(fid, ['%% ', StructName, '.PackFactor = 1; %% packaging factor \n']);
fprintf(fid, ['%% ', StructName, '.DisplayProgress = 1; %% display the simulation progress percentage \n']);
fprintf(fid, ['%% ', StructName, '.SaveResults = 1; %% save the simulation results \n']);
fprintf(fid, ['%% ', StructName, '.FileResultsPrefix = ''something''; %% add a prefix to results file name \n']);
fclose(fid);

end % function