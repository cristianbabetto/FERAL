function plot_power_vs_speed(Map, PlotProp)

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
  
  plot(FW(kkk).MechSpeedRPM(1)*[0,1], FW(kkk).Power(1)*[0,1], ...
    PlotProp.LineStyle.TorqueMTPA, ...
    'Color',  PlotProp.Color.PowerMTPA, ...
    'linewidth', PlotProp.LineWidth.PowerMTPA, ...
    'HandleVisibility', LegendVisibility); % constant torque region
  
  plot(FW(kkk).MechSpeedRPM, FW(kkk).Power, ...
    PlotProp.LineStyle.PowerFW, ...
    'Color',  PlotProp.Color.PowerFW, ...
    'linewidth', PlotProp.LineWidth.PowerFW, ...
    'HandleVisibility', LegendVisibility); % FW region
  
  plot(MTPV(kkk).MechSpeedRPM, MTPV(kkk).Power, ...
    PlotProp.LineStyle.PowerMTPV, ...
    'Color',  PlotProp.Color.PowerMTPV, ...
    'linewidth', PlotProp.LineWidth.PowerMTPV, ...
    'HandleVisibility', LegendVisibility); % MTPV region  
  
end

ylim(get_axis_lim([0 FW(end).Power], 0.2))

%% Legend
h.Legend = legend(PlotProp.Legend.PowerMTPA, PlotProp.Legend.PowerFW, PlotProp.Legend.PowerMTPV);

%% XY-label
h.LabelX = xlabel('Mechanical speed [rpm]');
h.LabelY = ylabel('Power [W]');

set_plot_properties

end % function