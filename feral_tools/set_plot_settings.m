function PlotProp = set_plot_settings(PlotProp)
%SET_PLOTPROP set default plot properties if not defined

if ~isfield(PlotProp, 'NumPlots')
  PlotProp.NumPlots = 1;
end

if ~isfield(PlotProp, 'Linestyle')
  PlotProp.Linestyle = {'-r', '-g', '-b'};
end

if ~isfield(PlotProp, 'Linewidths')
  PlotProp.Linewidth = {'-r', '-g', '-b'};
end



end % function