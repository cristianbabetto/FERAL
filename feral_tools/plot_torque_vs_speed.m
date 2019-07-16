function plot_torque_vs_speed(Map, PlotProp)

%% define some short variables
FW = Map.FW;
MTPV = Map.MTPV;

if nargin < 2
  PlotProp = struct;
end

PlotProp = set_default_plot_settings(PlotProp);

hold on;
grid on;
box on;

for kkk = 1:length(FW)
  
  if kkk == 1
    LegendVisibility = 'on';
  else
    LegendVisibility = 'off';
  end
  
  plot(FW(kkk).MechSpeedRPM(1)*[0,1], FW(kkk).Torque(1)*[1,1], ...
    PlotProp.LineStyle.TorqueMTPA, ...
    'Color',  PlotProp.Color.TorqueMTPA, ...
    'linewidth', PlotProp.LineWidth.TorqueMTPA, ...
    'HandleVisibility', LegendVisibility); % constant torque region
  
  plot(FW(kkk).MechSpeedRPM, FW(kkk).Torque, ...
    PlotProp.LineStyle.TorqueFW, ...
    'Color',  PlotProp.Color.TorqueFW, ...
    'linewidth', PlotProp.LineWidth.TorqueFW, ...
    'HandleVisibility', LegendVisibility); % FW region
  
  plot(MTPV(kkk).MechSpeedRPM, MTPV(kkk).Torque, ...
    PlotProp.LineStyle.TorqueMTPV, ...
    'Color',  PlotProp.Color.TorqueMTPV, ...
    'linewidth', PlotProp.LineWidth.TorqueMTPV, ...
    'HandleVisibility', LegendVisibility); % MTPV region
  
end

ylim(get_axis_lim([0 FW(end).Torque], 0.2))

%% Legend
h.Legend = legend(PlotProp.Legend.TorqueMTPA, PlotProp.Legend.TorqueFW, PlotProp.Legend.TorqueMTPV);

%% XY-label
h.LabelX = xlabel('Mechanical speed [rpm]');
h.LabelY = ylabel('Torque [Nm]');

set_plot_properties

end % function