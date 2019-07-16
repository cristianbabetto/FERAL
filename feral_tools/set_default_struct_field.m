function Struct = set_default_struct_field(Struct, FieldName, FieldContent)
%% SET_DEFAULT_STRUCT_FIELD set the default value of a non existinf structure field
%   Struct is the structure array
%   FieldName is the name of the structure field
%   FieldContent is the content of the field, it must be a single value

if ~isfield(Struct, FieldName)
  eval(['Struct.', FieldName, ' = ', num2str(FieldContent), ';']);
end

end % function