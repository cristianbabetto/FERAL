function [h] = plot_torque_mxw(v, PlotProp)
%PLOT_TORQUE_MXW plot the torque and add some labels

if nargin < 2 
  PlotProp = struct;
end

PlotProp = set_default_plot_settings(PlotProp);

box on
h.Tmxw = plot(v.RotorPositions, v.TorqueMXW, PlotProp.LineStyle.TorqueMXW, 'color', PlotProp.Color.TorqueMXW, 'linewidth', PlotProp.LineWidth.TorqueMXW);

xlim([v.RotorPositions(1) v.RotorPositions(end)])
ylim(get_axis_lim([v.TorqueDQ v.TorqueMXW], 0.2))

title('Maxwell Strees Tensor Torque')

%% XY-label
h.LabelX = xlabel('Rotor Position [deg]');
h.LabelY = ylabel('Torque [Nm]');

set_plot_properties

end % function