function h = plot_flux_linkage_waveform(v, FluxType, PlotProp)
%PLOT_FLUX_WAVEFORMS plot the flux linkage waveforms of the structure v

if nargin < 3
  PlotProp = struct;
end

PlotProp = set_default_plot_settings(PlotProp);

hold on
box on
grid on

if FluxType == 1 % ABC flux linkages
  
  flx = [v.FluxA, v.FluxB, v.FluxC];
  h.flxa = plot(v.RotorPositions, v.FluxA, PlotProp.LineStyle.PhaseA, 'color', PlotProp.Color.PhaseA, 'linewidth', PlotProp.LineWidth.PhaseA);
  h.flxb = plot(v.RotorPositions, v.FluxB, PlotProp.LineStyle.PhaseB, 'color', PlotProp.Color.PhaseB, 'linewidth', PlotProp.LineWidth.PhaseB);
  h.flxc = plot(v.RotorPositions, v.FluxC, PlotProp.LineStyle.PhaseC, 'color', PlotProp.Color.PhaseC, 'linewidth', PlotProp.LineWidth.PhaseC);
  h.Legend = legend(PlotProp.Legend.PhaseA, PlotProp.Legend.PhaseB, PlotProp.Legend.PhaseC, 'Orientation', 'horizontal', 'Location', 'NorthOutside');
  
elseif FluxType == 2 % DQ flux linkages
  
  flx = [v.FluxD, v.FluxQ];
  h.flxa = plot(v.RotorPositions, v.FluxD, PlotProp.LineStyle.AxisD, 'color', PlotProp.Color.AxisD, 'linewidth', PlotProp.LineWidth.AxisD);
  h.flxb = plot(v.RotorPositions, v.FluxQ, PlotProp.LineStyle.AxisQ, 'color', PlotProp.Color.AxisQ, 'linewidth', PlotProp.LineWidth.AxisQ);
  h.Legend = legend(PlotProp.Legend.AxisD, PlotProp.Legend.AxisQ, 'Orientation', 'horizontal', 'Location', 'NorthOutside');
  
end

%% XY-lim
xlim([min(v.RotorPositions) max(v.RotorPositions)])
ylim(get_axis_lim(flx, 0.2))

%% XY-label
h.LabelX = xlabel('Rotor position [deg]');
h.LabelY = ylabel('Flux linkage [Vs]');

set_plot_properties

end % function