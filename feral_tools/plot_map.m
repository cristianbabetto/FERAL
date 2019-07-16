function [h, C] = plot_map(Map, PlotProp)

%% define some short variables
MTPA = Map.MTPA;
FW = Map.FW;
MTPV = Map.MTPV;

if nargin < 2
  PlotProp = struct;
end

PlotProp = set_default_plot_settings(PlotProp);

hold on; grid on; box on;

%% current limit
h.Ilim = plot(Map.CurrentLimit*cosd(Map.CurrentAngleRange), Map.CurrentLimit*sind(Map.CurrentAngleRange), ...
    PlotProp.LineStyle.Ilim, ...
    'Color', PlotProp.Color.Ilim,  ...
    'linewidth', PlotProp.LineWidth.Ilim);

%% iso-torque curves
[C.torque, h.torque] = contour(Map.Id, Map.Iq, Map.TorqueDQ); 
clabel(C.torque);

%% iso-flux curves
[C.flux, h.flux] = contour(Map.Id, Map.Iq, Map.Flux); 
clabel(C.flux);

%% MTPA locus
h.Mtpa = plot(MTPA.Id, MTPA.Iq, ...
    PlotProp.LineStyle.MTPA, ...
    'Color', PlotProp.Color.MTPA,  ...
    'linewidth', PlotProp.LineWidth.MTPA); 

%% FW loci
for kkk = 1:length(FW)
  h.fw(kkk) = plot(FW(kkk).Id, FW(kkk).Iq, ...
    PlotProp.LineStyle.FW, ...
    'Color', PlotProp.Color.FW,  ...
    'linewidth', PlotProp.LineWidth.FW, ...
    'HandleVisibility','off');
end

%% MTPV loci
for kkk = 1:length(MTPV)
  h.Mtpv(kkk) = plot(MTPV(kkk).Id, MTPV(kkk).Iq, ...
    PlotProp.LineStyle.MTPV, ...
    'Color', PlotProp.Color.MTPV, ...
    'linewidth', PlotProp.LineWidth.MTPV, ...
    'HandleVisibility','off'); % MTPV locus
end

%% XY-label
h.LabelX = xlabel('d-axis current (A) peak');
h.LabelY = ylabel('q-axis current (A) peak');

%% Legend

% labels
h.Legend = legend([h.Ilim, h.torque, h.flux, h.Mtpa, h.fw(1), h.Mtpv(1)], ...
  PlotProp.Legend.Ilim, ...
  PlotProp.Legend.IsoTorque, ...
  PlotProp.Legend.IsoFlux, ...
  PlotProp.Legend.MTPA, ...
  PlotProp.Legend.FW, ...
  PlotProp.Legend.MTPV);

% set(h.Legend, 'location', 'Northeastoutside');

%% Axis limits
xlim([min(min(Map.Id)) max(max(Map.Id))])
ylim([min(min(Map.Iq)) max(max(Map.Iq))])

axis equal

set_plot_properties

end % function