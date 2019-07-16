function h = plot_flux_linkage_spectrum(v, PlotProp)
%PLOT_FLUX_LINKAGE_HARMONICS plot the flux linkage harmonics of the structure v

if nargin < 2 
  PlotProp = struct;
end

PlotProp = set_default_plot_settings(PlotProp);

hold on
box on
grid on

% check for skewing
if size(v.FluxA, 1) == 1 % no skewing
  
  [flxh, phih, hh] = calc_fft(v.FluxA);
  bar(hh, flxh, 'FaceColor', PlotProp.Color.BarPlot);
  ylim(get_axis_lim([flxh], 0.2))

  
else % skewing --> comparison between skew and no-skew
  
  % [-alphask(n) ...  -alphask(1) 0 alphask(1) ...  -alphask(n)]
  % the un-skewed solution must be in the middle
  idx_nosk = (size(v.FluxA, 1) - 1)/2 + 1;
  
  % fft flux unskewed
  [flxh, phih, hh] = calc_fft(v.FluxA(idx_nosk, :));
  % fft skewed
  flx_skew = mean(v.FluxA);
  [flxh_sk, phih, hh] = calc_fft(v.FluxA);
 
  % plot skew and unskewd side by side
  flx_fft = [flxh; flxh_sk];
  hb = bar(hh, flx_fft);
  hbc = get(hb, 'Children');
  set(hbc{1}, 'FaceColor', PlotProp.Color.BarPlot)   % Red bars for first column
  set(hbc{2}, 'FaceColor', PlotProp.Color.BarPlotSkew)   % Green bars for first column 
  ylim(get_axis_lim([flxh, flxh_sk], 0.2))

end

title('Flux linkage spectrum')


%% XY-label
h.LabelX = xlabel('Harmonic order');
h.LabelY = ylabel('Flux linkage [Vs]');

xlim([0 max(hh)+1])

set_plot_properties

end % function