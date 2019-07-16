function [w, wm, RPM, freq] = calc_speed(U, fluxD, fluxQ, Id, Iq, Rw, p)
%CALC_SPEED compute the speed taking into account the resistive voltage drop

flux = hypot(fluxD,fluxQ);
a = flux.^2;
b = 2*Rw*(fluxD.*Iq - fluxQ.*Id);
c = (Rw*hypot(Id,Iq)).^2 - U^2;

w = (-b + sqrt(b.^2 - 4*a.*c))./(2*a); 
freq = w/2/pi;
wm = w/p;
RPM = 60*wm/(2*pi);

end % function