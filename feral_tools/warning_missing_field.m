function Struct = warning_missing_field(Struct, Field, Autoset, AdditionalMessage)
%WARNING_MESSAGE_FIELD check if a structure field exist
%   A warning message is diplayed if the field is missing
%   Struct = structure array
%   Field = structure field to check
%   Autoset = default value of the field
%   AdditionalMessage = cell composed by several additional strings

% No addtional warning message
if nargin < 4
  AdditionalMessage = {};
end

% Initialize warning string
WarningMessage = '';

if ~isfield(Struct, Field)
  MainWarningString = ['Field ', Field, ' is missing.'];
  MainWarningString = [MainWarningString, '\nAutomatically set to ', num2str(Autoset)];
  WarningMessage = [MainWarningString];
  % append additional warning messages
  for msg = 1:length(AdditionalMessage)
    WarningMessage = [WarningMessage, '\n', AdditionalMessage{msg}];
  end
  
  eval(['Struct.', Field, ' = ', num2str(Autoset), ';']);
  warning(sprintf(WarningMessage));
  
end



end % function