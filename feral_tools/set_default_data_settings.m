function [MD, SD] = set_default_data_settings(MD, SD, DefaultSettings)
%%SET_DEFAULT_SETTINGS load and set the default model and simulation
%   data settings in the missing fields

%% Set default model and simulation data settings
for jj = 1:size(DefaultSettings, 1)
  
  FieldName = DefaultSettings{jj,1};
  FieldContent = DefaultSettings{jj,2};
 
  if ischar(FieldContent) % for string input
    FieldContent = ['''', FieldContent, ''''];
  end
  
  if iscell(FieldContent) % for cell input
    FieldContent = '{}';
  end
  
  if isnumeric(FieldContent) && isvector(FieldContent) && length(FieldContent)>1 % fot array input
    FieldContentString = mat2str(FieldContent);
  else
    FieldContentString = num2str(FieldContent);
  end
  
  if ~isfield(MD, FieldName)
    eval(['MD.', FieldName, ' = ', FieldContentString, ';']);
  end
  
  % the simulation data loads the model data setting
  if ~isfield(SD, FieldName)
    eval(['SD.', FieldName, ' = MD.', FieldName, ';']);
  end
  
end % for jj = 1:size(DefaultSettings, 1)

end % function


