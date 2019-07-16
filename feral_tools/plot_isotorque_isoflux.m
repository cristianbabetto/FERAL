function [h, C] = plot_isotorque_isoflux(Map, PlotProp)

if nargin < 2
  PlotProp = struct;
end

PlotProp = set_default_plot_settings(PlotProp);

hold on; grid on; box on;

%% Iso-torque
[C.torque, h.torque] = contour(Map.Id, Map.Iq, Map.TorqueDQ, 'linewidth', PlotProp.LineWidth.IsoTorque); % iso-torque curves
clabel(C.torque);
[C.flux, h.flux] = contour(Map.Id, Map.Iq, Map.Flux, 'k', 'linewidth', PlotProp.LineWidth.IsoTorque); % iso-flux curves
clabel(C.flux);
xlim([min(min(Map.Id)) max(max(Map.Id))])
ylim([min(min(Map.Iq)) max(max(Map.Iq))])

axis equal

%% Legend
h.Legend = legend(PlotProp.Legend.IsoTorque, PlotProp.Legend.IsoFlux);
set(h.Legend, 'location', 'northwest');

%% XY-label
h.LabelX = xlabel('d-axis current (A) peak');
h.LabelY = ylabel('q-axis current (A) peak');

set_plot_properties

end % function