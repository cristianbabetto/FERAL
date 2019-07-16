function plot_airgapfluxdensity_spectrum(Vec, p, thm_idx, PlotProp)
%PLOT_AIRGAPFLUXDENSITY_HARMONICS plot the harmonics of the structure v

if nargin < 2 
  PlotProp = struct;
end

PlotProp = set_default_plot_settings(PlotProp);

% select the rotor position
Bg = Vec.AirgapFluxDensity(thm_idx, :);
thetam = Vec.RotorPositions(thm_idx);

hold on
box on
grid on

% compute the fundamental
[Bh, phih, h] = calc_fft(Bg);
Bg1 = Bh(p+1);
phi1 = phih(p+1);

bar(h, Bh, 'FaceColor', PlotProp.Color.BarPlot);

title(['Air-gap flux density spectrum, \theta_m = ', num2str(thetam), ' deg'])

xlim([-1 max(h)+1])

%% XY-label
xlabel('Harmonic order')
ylabel('Flux density [T]')

set_plot_properties

end % function
