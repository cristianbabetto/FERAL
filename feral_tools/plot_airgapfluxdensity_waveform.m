function [h] = plot_airgapfluxdensity_waveform(v, p, thm_idx, PlotProp)
%PLOT_AIRGAPFLUXDENSITY_WAVEFORM plot the normal flux density within the air-gap

if nargin < 4
  PlotProp = struct;
end

PlotProp = set_default_plot_settings(PlotProp);

if size(v.AirgapFluxDensity, 3) > 1 % skew
  idx_noskew = (size(v.AirgapFluxDensity,3)-1)/2+1;
else
  idx_noskew = 1;
end

% select the rotor position
Bg = v.AirgapFluxDensity(thm_idx, :, idx_noskew);
thetam = v.RotorPositions(thm_idx);

% compute the fundamental
[Bh, phih] = calc_fft(Bg);
Bg1 = Bh(p+1);
phi1 = phih(p+1);

% plot
box on
hold on
grid on
h.Bg = plot(v.AirgapFluxDensityAngle, Bg, PlotProp.LineStyle.FluxDensity, 'color', PlotProp.Color.FluxDensity, 'linewidth', PlotProp.LineWidth.FluxDensity);
h.Bg1 = plot(v.AirgapFluxDensityAngle, Bg1*cos((v.AirgapFluxDensityAngle*pi/180)*p + phi1), PlotProp.LineStyle.FluxDensityFund, 'color', PlotProp.Color.FluxDensityFund, 'linewidth', PlotProp.LineWidth.FluxDensityFund);
title(['Air-gap flux density waveform, \theta_m = ', num2str(thetam), ' deg'])
xlim([min(v.AirgapFluxDensityAngle) max(v.AirgapFluxDensityAngle)])
ylim(get_axis_lim(Bg, 0.2))

%% Legend
h.Legend = legend(PlotProp.Legend.FluxDensity, PlotProp.Legend.FluxDensityFund);

%% XY-label
h.LabelX = xlabel('Rotor coordinate [deg]');
h.LabelY = ylabel('Flux density [T]');
set(gca, 'xtick', [0:30:360])

set_plot_properties

end % function