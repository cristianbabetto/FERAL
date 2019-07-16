function get_plot_var_rotor_position(ScriptPath)
%GET_PROCESS_VAR_ROTOR_POSITION creates a template of a script to process the
%   results of a var_rotor_position procedure

feral_tools_PATH = mfilename('fullpath');
% remove filename from PATH
idx_filename = findstr('get_process_var_rotor_position', feral_tools_PATH);
feral_tools_PATH(idx_filename:end) = [];


if nargin < 1
  ScriptPath = pwd;
end

idx_file = '';
jj = 0;
while exist([ScriptPath, '\plot_var_rotor_position', num2str(idx_file), '.m'], 'file')
  idx_file = jj + 1;
end 
copyfile([feral_tools_PATH, 'plot_var_rotor_position.m'], ScriptPath)

end % function