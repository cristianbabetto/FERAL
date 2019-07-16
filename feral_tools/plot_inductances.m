function plot_inductances(Map)

subplot(121)
box on
hold on

Id = Map.Id(1,:);
Iq = Map.Iq(:,1);

idx_Id0 = find(Id==0);
idx_Iq0 = find(Iq==0);

% compute the PM flux
FluxPM = interp2(Id, Iq, Map.FluxD, 0, 0);

Ld_app = (Map.FluxD - FluxPM) ./ Map.Id;
Ld_diff = gradient(Map.FluxD', Id);

Ld_app(:, idx_Id0) = NaN;
Ld_diff(:, idx_Id0) = NaN;

plot(Id, Ld_app, 'k', 'linewidth', 1.5);












end % function