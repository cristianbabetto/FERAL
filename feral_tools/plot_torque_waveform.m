function plot_torque_waveform(v, TorqueType, PlotProp)

%PLOT_TORQUE_MXW plot the torque and add some labels

if nargin < 2 
  PlotProp = struct;
end

PlotProp = set_default_plot_settings(PlotProp);

hold on; box on; grid on;

if TorqueType == 1 % Torque MXW

h = plot(v.RotorPositions, v.TorqueMXW, ...
  PlotProp.LineStyle.TorqueMXW, ...
  'color', PlotProp.Color.TorqueMXW, ...
  'linewidth', PlotProp.LineWidth.TorqueMXW);

xlim([v.RotorPositions(1) v.RotorPositions(end)])
ylim(get_axis_lim([v.TorqueDQ v.TorqueMXW], 0.2))

elseif 



end

  
h = plot(v.RotorPositions, v.TorqueDQ, PlotProp.LineStyle.TorqueDQ, 'color', PlotProp.Color.TorqueDQ, 'linewidth', PlotProp.LineWidth.TorqueDQ);
.Legendtitle('Torque dq')
xlim([v.RotorPositions(1) v.RotorPositions(end)])
ylim(get_axis_lim([v.TorqueDQ v.TorqueMXW], 0.2))

%% XY-label
h.LabelX = xlabel('Rotor Position [deg]');
h.LabelY = ylabel('Torque [Nm]');

set_plot_properties


end % function