%% Script to compute the iron losses by means of the simplified method

% INPUT
% the iron losses are computed only in the stator (teeth and yoke)
%
% the equation is: Khy * f1^alpha * Bmax^2 + Kec * f1^2 * Bmax^2
%
% Khy, alpha, beta are the hysteresis iron losses coefficients
% Kec is the eddy-current iron losses coefficient
% f1 is the fundamental frequency [Hz]
% Bmax is the maximum value of the flux density [T]

% Compute iron losses in the teeth
Res.Losses.Lamination.Stator.Teeth.Hysteresis   = StatorKhy * freq^StatorAlphaCoeff * Bmax_t^StatorBetaCoeff * Res.Weight.Teeth * SD.LossesTeethFactor;
Res.Losses.Lamination.Stator.Teeth.EddyCurrent  = StatorKec * (Bmax_t * freq)^2 * Res.Weight.Teeth * SD.LossesTeethFactor;
Res.Losses.Lamination.Stator.Teeth.Total        = Res.Losses.Lamination.Stator.Teeth.Hysteresis + Res.Losses.Lamination.Stator.Teeth.EddyCurrent;

% Compute iron losses in the yoke
Res.Losses.Lamination.Stator.Yoke.Hysteresis  = StatorKhy * freq^StatorAlphaCoeff * Bmax_yk^StatorBetaCoeff * Res.Weight.Yoke * SD.LossesYokeFactor;
Res.Losses.Lamination.Stator.Yoke.EddyCurrent = StatorKec * (Bmax_yk * freq)^2 * Res.Weight.Yoke * SD.LossesYokeFactor;
Res.Losses.Lamination.Stator.Yoke.Total       = Res.Losses.Lamination.Stator.Yoke.Hysteresis + Res.Losses.Lamination.Stator.Yoke.EddyCurrent;

% Total stator hysteresis losses [W]
Res.Losses.Lamination.Stator.Hysteresis = Res.Losses.Lamination.Stator.Teeth.Hysteresis + Res.Losses.Lamination.Stator.Yoke.Hysteresis;
% Total stator eddy-current losses [W]
Res.Losses.Lamination.Stator.EddyCurrent = Res.Losses.Lamination.Stator.Teeth.EddyCurrent + Res.Losses.Lamination.Stator.Yoke.EddyCurrent;

% Total stator lamination losses [W]
Res.Losses.Lamination.Total = Res.Losses.Lamination.Stator.Hysteresis + Res.Losses.Lamination.Stator.EddyCurrent;
