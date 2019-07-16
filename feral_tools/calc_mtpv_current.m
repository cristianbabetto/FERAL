function [Id_mtpv, Iq_mtpv, Imtpv] = calc_mtpv_current(fluxD, fluxQ, FluxPM, Id, Iq)
%%CALC_MTPV_CURRENT compute the maximum torque per voltage current

flux = hypot(fluxD, fluxQ);
Ld  = (fluxD - FluxPM)/Id; % d-axis  apparent inductance
Lq  = (fluxQ)/Iq; % q-axis apparent inductance
csi = Lq/Ld; % saliency ratio

a     = 2*(1-csi)*flux/csi;
sint  = (-FluxPM+sqrt(FluxPM^2+2*a^2))/(2*a);
cost  = sqrt(1-sint^2);
Id_mtpv  = (flux*sint-FluxPM)/Ld; % d-axis MTPV current
Iq_mtpv  = flux*cost/(csi*Ld); % q-axis MTPV current
Imtpv   = hypot(Id_mtpv, Iq_mtpv); % MTPV current

end % function