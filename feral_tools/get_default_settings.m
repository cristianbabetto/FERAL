function [MD, SD] = get_default_settings()
%GET_SIMULATIONA_DATA Generate the complete simulation data structure on
%   command window.

%% Initilize the structures MD and SD
MD = struct;
SD = MD;

%% Load the default simulation settings
default_data_settings
[MD, SD] = set_default_data_settings(MD, SD, DefaultSettings);


%% Load the default plot settings
[MD, SD] = set_default_plot_settings(MD, SD);


end % function
