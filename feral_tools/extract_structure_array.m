%% Script to extract the content of a structure array
% The input is a structure array called 'ExtractStruct'
% The output are all the 'ExtractStruct' fields

% get all the structure field names
StructFieldNames = fieldnames(ExtractStruct);
% get the number of fields
NumOfStructFields = numel(StructFieldNames);
    
for fld = 1:NumOfStructFields % for each field

  FieldContent = eval(['ExtractStruct.', StructFieldNames{fld}]);
  eval([StructFieldNames{fld}, '= FieldContent;'])

end % for fld = 1:NumOfStructFields

clear ExtractStruct StructFieldNames NumOfStructFields FieldContent fld