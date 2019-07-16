function plot_fluxQ_vs_Id(Map, PlotProp)

if nargin < 2
  PlotProp = struct;
end

PlotProp = set_default_plot_settings(PlotProp);

hold on; grid on; box on;

idx_Iq0 = find(Map.Iq(:,1) == 0);

Id = Map.Id(1,:);
h.flxQ = plot(Id, Map.FluxQ', PlotProp.LineStyle.FluxQ, 'color', PlotProp.Color.FluxQ, 'linewidth', PlotProp.LineWidth.FluxQ, 'HandleVisibility','off');
h.flxQ0 = plot(Id, Map.FluxQ(idx_Iq0,:), PlotProp.LineStyle.FluxQ0, 'color', PlotProp.Color.FluxQ0, 'linewidth', PlotProp.LineWidth.FluxQ0);

Id_min = min(Id);
Id_max = max(Id);
xlim([Id_min Id_max])
flux_min = min(min(Map.FluxQ));
flux_max = max(max(Map.FluxQ));
ylim(get_axis_lim([flux_min flux_max], 0.2))

%% Legend
h.Legend = legend(PlotProp.Legend.FluxD0);

%% XY-label
h.LabelX = xlabel('d-axis current [A] peak');
h.LabelY = ylabel('q-axis flux linkage [Vs] peak');

set_plot_properties

end % function