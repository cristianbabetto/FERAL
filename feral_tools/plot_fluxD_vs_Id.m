function plot_fluxD_vs_Id(Map, PlotProp)

if nargin < 2
  PlotProp = struct;
end

PlotProp = set_default_plot_settings(PlotProp);

hold on; grid on; box on;

idx_Iq0 = find(Map.Iq(:,1) == 0);

Id = Map.Id(1,:);
h.flxD = plot(Id, Map.FluxD', PlotProp.LineStyle.FluxD, 'color', PlotProp.Color.FluxD, 'linewidth', PlotProp.LineWidth.FluxD, 'HandleVisibility', 'off');
h.flxD0 = plot(Id, Map.FluxD(idx_Iq0,:), PlotProp.LineStyle.FluxD0, 'color', PlotProp.Color.FluxD0, 'linewidth', PlotProp.LineWidth.FluxD0);


Id_min = min(Id);
Id_max = max(Id);
xlim([Id_min Id_max])
flux_min = min(min(Map.FluxD));
flux_max = max(max(Map.FluxD));
ylim(get_axis_lim([flux_min flux_max], 0.2))

%% Legend
h.Legend = legend(PlotProp.Legend.FluxD0);

%% XY-label
h.LabelX = xlabel('d-axis current [A] peak');
h.LabelY = ylabel('d-axis flux linkage [Vs] peak');

set_plot_properties

end % function