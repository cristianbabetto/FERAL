function add_materials2model(varargin)
%ADD_MATERIALS2MODEL add the material properties to .fem model
%   the input can be material functions or structures with a field
%   called 'Material'.

indx = {};
ii = 1;
MaterialNameList = {};

for mtrl = 1 : length(varargin) % for each input
  
  if isfield(varargin{mtrl},'Material') % load all the fields inside Material
    MaterialFieldNames = fieldnames(varargin{mtrl}.Material);
    NumOfMaterialFields = numel(MaterialFieldNames);
    
    for ff = 1:NumOfMaterialFields
      FieldName = MaterialFieldNames{ff};
      NameOfMaterial = eval(['varargin{mtrl}.Material.',FieldName,'.Name']);
      indx = strfind(MaterialNameList,NameOfMaterial);
      indx = cell2mat(indx);
      
      if isempty(indx) % add the material to cell if it is not defined
        MaterialNameList{ii} = NameOfMaterial;
        MaterialPropertiesList(ii).Material = eval(['varargin{mtrl}.Material.',FieldName]);
        ii = ii + 1;
      end % if isempty(indx)
      
    end % for ff = 1:NumOfMaterialFields
    
  else
    NameOfMaterial = varargin{mtrl}.Name;
    indx = strfind(MaterialNameList,NameOfMaterial);
    indx = cell2mat(indx);
    if isempty(indx) % add the material to cell if it is not defined
      MaterialNameList{ii} = NameOfMaterial;
      MaterialPropertiesList(ii).Material = varargin{mtrl};
      ii = ii + 1;
    end % if isempty(indx)
    
  end % if isfield(varargin{mtrl},'Material')
  
end % for mt = 1 : length(varargin)


for mtrl = 1:length(MaterialPropertiesList)
  
  material = MaterialPropertiesList(mtrl).Material;
  
  if ~isfield(material,'RelativePermeability')
    material.RelativePermeability = [1 1];
  end
  
  if ~isfield(material,'CoercitiveField')
    material.CoercitiveField = 0;
  end
  
  if ~isfield(material,'AppliedCurrentDensity')
    material.AppliedCurrentDensity = 0;
  end
  
  if ~isfield(material,'ElConductivity')
    material.ElConductivity = 0;
  end
  
  if ~isfield(material,'LaminationThickness')
    material.LaminationThickness = 0;
  end
  
  if ~isfield(material,'HysteresisLagAngle')
    material.HysteresisLagAngle = 0;
  end
  
  if ~isfield(material,'LaminationFill')
    material.LaminationFill = 0;
  end
  
  if ~isfield(material,'LaminationType')
    material.LaminationType = 0;
  end
  
  % delete existing material to avoid duplicates
  mi_deletematerial(material.Name);
  % create new material 
  mi_addmaterial(material.Name, ...
    material.RelativePermeability(1), ...
    material.RelativePermeability(2), ...
    material.CoercitiveField, ...
    material.AppliedCurrentDensity, ...
    material.ElConductivity, ...
    material.LaminationThickness, ...
    material.HysteresisLagAngle, ...
    material.LaminationFill, ...
    material.LaminationType);
  
  if isfield(material,'BHpoints')
    for kk = 1:size(material.BHpoints,1)
      mi_addbhpoint(material.Name, material.BHpoints(kk,1), material.BHpoints(kk,2));
    end
  end
  
end % for mtrl = unique_index

end % function