function h = plot_torque_spectrum(v, PlotProp)
%PLOT_FLUX_LINKAGE_HARMONICS plot the flux linkage harmonics of the structure v

if nargin < 2 
  PlotProp = struct;
end

PlotProp = set_default_plot_settings(PlotProp);

hold on
box on
grid on

% check for skewing
if size(v.TorqueMXW, 1) == 1 % no skewing
  
  [Th, phih, hh] = calc_fft(v.TorqueMXW);
  bar(hh, Th, 'FaceColor', PlotProp.Color.BarPlot);
  ylim(get_axis_lim([Th], 0.2))
  
else % skewing --> comparison between skew and no-skew
  
  % [-alphask(n) ...  -alphask(1) 0 alphask(1) ...  -alphask(n)]
  % the un-skewed solution must be in the middle
  idx_nosk = (size(v.TorqueMXW, 1) - 1)/2 + 1;
  
  % fft flux unskewed
  [Th, phih, hh] = calc_fft(v.TorqueMXW(idx_nosk, :));
  % fft skewed
  Torq_skew = mean(v.TorqueMXW);
  [Th_sk, phih, hh] = calc_fft(v.TorqueMXW);
 
  % plot skew and unskewd side by side
  T_fft = [Th; Th_sk];
  hb = bar(hh, T_fft);
  hbc = get(hb, 'Children');
  set(hbc{1}, 'FaceColor', PlotProp.Color.BarPlot)  
  set(hbc{2}, 'FaceColor', PlotProp.Color.BarPlotSkew)  
  ylim(get_axis_lim([Th, Th_sk], 0.2))

end

title('Maxwell strees tensor torque spectrum')
xlim([-1 max(hh)+1])

%% XY-label
h.LabelX = xlabel('Harmonic order');
h.LabelY = ylabel('Torque [Nm]');

set_plot_properties

end % function