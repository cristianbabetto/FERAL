function plot_ipeak_vs_speed(Map, PlotProp)

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
  
  plot(FW(kkk).MechSpeedRPM(1)*[0,1], FW(kkk).CurrentAmplitude(1)*[1,1], ...
    PlotProp.LineStyle.IpeakMTPA, ...
    'Color',  PlotProp.Color.IpeakMTPA, ...
    'linewidth', PlotProp.LineWidth.IpeakMTPA, ...
    'HandleVisibility', LegendVisibility); % constant torque region
  
  plot(FW(kkk).MechSpeedRPM, FW(kkk).CurrentAmplitude, ...
    PlotProp.LineStyle.IpeakFW, ...
    'Color',  PlotProp.Color.IpeakFW, ...
    'linewidth', PlotProp.LineWidth.IpeakFW, ...
    'HandleVisibility', LegendVisibility); % FW region
  
  plot(MTPV(kkk).MechSpeedRPM, MTPV(kkk).CurrentAmplitude, ...
    PlotProp.LineStyle.IpeakMTPV, ...
    'Color',  PlotProp.Color.IpeakMTPV, ...
    'linewidth', PlotProp.LineWidth.IpeakMTPV, ...
    'HandleVisibility', LegendVisibility); % MTPV region    
  
end

ylim(get_axis_lim([0 FW(end).CurrentAmplitude], 0.2))

%% Legend
h.Legend = legend(PlotProp.Legend.IpeakMTPA, PlotProp.Legend.IpeakFW, PlotProp.Legend.IpeakMTPV);

%% XY-label
h.LabelX = xlabel('Mechanical speed [rpm]');
h.LabelY = ylabel('Current [A]');

set_plot_properties

end % function