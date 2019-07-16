function build_dxf2fem_model(DXFfilenames, MD, OpenFEMM, ExistingFile, ClearDXFGroups, SaveModel)
%BUILD_DXF2FEM_MODEL builds a fem model starting from different dxf files
%   and set the FEMM problem properties.
%   DXFfilenames is a cell containin
%% Open new FEMM instance by default
if OpenFEMM == 1
  openfemm;
end

%% Open a new FEMM document by default
if ischar(ExistingFile)
  opendocument([ExistingFile, '.fem']);
elseif ExistingFile == 1
  newdocument(0)
end

%% Check if DXFfilenames is a cell
if ~iscell(DXFfilenames)
  DXFfilenames = {DXFfilenames}; % convert to cell
end

%% Open all the dxf files
for dxf_idx = 1:length(DXFfilenames)
  
  mi_readdxf([DXFfilenames{dxf_idx}, '.dxf']);
  
end % for dxf_idx = 1:length(DXFfilenames)

%% Clear DXF groups
if ClearDXFGroups == 1
  % stator
  mi_selectcircle(0, 0, MD.Stator.Geometry.OuterDiameter*10, 4);
  mi_setgroup(0);
  mi_clearselected();
  % rotor
  mi_selectcircle(0, 0, MD.Stator.Geometry.InnerDiameter/2 - MD.Airgap/2, 4);
  mi_setgroup(MD.Rotor.Group);
  mi_clearselected();
end

%% Load default model data setting if not declared
default_data_settings
SD = MD;
[MD] = set_default_data_settings(MD, SD, DefaultSettings);

%% Set femm problem properties
set_femm_problem_definition(MD);

%% Zoom the model
mi_zoomnatural;

%% Save FEMM model
if SaveModel == 1
  mi_saveas([MD.ModelPath, '\', MD.ModelName, '.fem']);
end
end % function