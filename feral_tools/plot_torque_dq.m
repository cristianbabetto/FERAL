function [h] = plot_torque_dq(v, PlotProp)
%PLOT_TORQUE_MXW plot the torque and add some labels

if nargin < 2 
  PlotProp = struct;
end

PlotProp = set_default_plot_settings(PlotProp);

box on
h.Tdq = plot(v.RotorPositions, v.TorqueDQ, PlotProp.LineStyle.TorqueDQ, 'color', PlotProp.Color.TorqueDQ, 'linewidth', PlotProp.LineWidth.TorqueDQ);
title('Torque DQ')
xlim([v.RotorPositions(1) v.RotorPositions(end)])
ylim(get_axis_lim([v.TorqueDQ v.TorqueMXW], 0.2))

%% XY-label
h.LabelX = xlabel('Rotor Position [deg]');
h.LabelY = ylabel('Torque [Nm]');

set_plot_properties

end % function