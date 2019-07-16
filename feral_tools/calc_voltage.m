function [Ud, Uq, U] = calc_voltage(Id, Iq, FluxD, FluxQ, Rw, w)
%CALC_VOLTAGE compute the voltage in the dq reference frame

% d-axis voltage
Ud = Rw * Id - w * FluxQ;
% q-axis voltage
Uq = Rw * Iq + w * FluxD;
% voltage amplitude
U = hypot(Ud, Uq);

end % function