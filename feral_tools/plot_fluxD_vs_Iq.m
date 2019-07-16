function plot_fluxD_vs_Iq(Map, PlotProp)

if nargin < 2
  PlotProp = struct;
end

PlotProp = set_default_plot_settings(PlotProp);

hold on; grid on; box on;

idx_Id0 = find(Map.Id(1,:) == 0);

Iq = Map.Iq(:,1);
h.flxD = plot(Iq, Map.FluxD, PlotProp.LineStyle.FluxD, 'color', PlotProp.Color.FluxD, 'linewidth', PlotProp.LineWidth.FluxD, 'HandleVisibility','off');
h.flxD0 = plot(Iq, Map.FluxD(:,idx_Id0), PlotProp.LineStyle.FluxD0, 'color', PlotProp.Color.FluxD0, 'linewidth', PlotProp.LineWidth.FluxD0);

Iq_min = min(Iq);
Iq_max = max(Iq);
xlim([Iq_min Iq_max])
flux_min = min(min(Map.FluxD));
flux_max = max(max(Map.FluxD));
ylim(get_axis_lim([flux_min flux_max], 0.2))


%% Legend
h.Legend = legend(PlotProp.Legend.FluxQ0);

%% XY-label
h.LabelX = xlabel('q-axis current [A] peak');
h.LabelY = ylabel('d-axis flux linkage [Vs] peak');

set_plot_properties

end % function