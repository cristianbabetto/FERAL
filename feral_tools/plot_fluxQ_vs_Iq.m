function plot_fluxQ_vs_Iq(Map, PlotProp)

if nargin < 2
  PlotProp = struct;
end

PlotProp = set_default_plot_settings(PlotProp);

hold on; grid on; box on;

idx_Id0 = find(Map.Id(1,:) == 0);

Iq = Map.Iq(:,1);
h.flxQ = plot(Iq, Map.FluxQ, PlotProp.LineStyle.FluxQ, 'color', PlotProp.Color.FluxQ, 'linewidth', PlotProp.LineWidth.FluxQ, 'HandleVisibility', 'off');
h.flxQ0 = plot(Iq, Map.FluxQ(:,idx_Id0), PlotProp.LineStyle.FluxQ0, 'color', PlotProp.Color.FluxQ0, 'linewidth', PlotProp.LineWidth.FluxQ0);

xlabel('q-axis current [A] peak')
ylabel('q-axis flux linkage [Vs] peak')
Iq_min = min(Iq);
Iq_max = max(Iq);
xlim([Iq_min Iq_max])
flux_min = min(min(Map.FluxQ));
flux_max = max(max(Map.FluxQ));
ylim(get_axis_lim([flux_min flux_max], 0.2))

%% Legend
h.Legend = legend(PlotProp.Legend.FluxQ0);

%% XY-label
h.LabelX = xlabel('q-axis current [A] peak');
h.LabelY = ylabel('q-axis flux linkage [Vs] peak');

set_plot_properties

end % function
