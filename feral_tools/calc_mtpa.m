function [MTPA, BASE] = calc_mtpa(Map, CurrentAmplitudeRange, CurrentAngleRange, Voltage)
%CALC_MTPA computes the maximum torque per ampere point for each current in Ilim_vec

%% Set default options if not defined
% interpolation method 
% default is linear
if ~isfield(Map, 'InterpMethod')
  Map.InterpMethod = 'linear';
end

% winding resistance 
% default is 0
if ~isfield(Map, 'WindingResistance')
  Map.WindingResistance = 0;
end

% end-winding inductance 
% default is 0
if ~isfield(Map, 'EndWindingInductance')
  Map.EndWindingInductance = 0;
end

%% Define some short variables 
method = Map.InterpMethod; % interpolation method
Rw = Map.WindingResistance; % winding resistance [ohm]
Lew = Map.EndWindingInductance; % end-winding inductance [H]
p = Map.PolePairs; 
Ilim_vec = CurrentAmplitudeRange;

%% Find the MTPA for each current amplitude
for ii = 1 : length(Ilim_vec)
  
  Ilim = Ilim_vec(ii);
  % compute the dq current components 
  Id = Ilim * cosd(CurrentAngleRange);
  Iq = Ilim * sind(CurrentAngleRange);
  % compute the dq-flux and the torque
  fluxD = interp2(Map.Id, Map.Iq, Map.FluxD, Id, Iq, method) + Lew * Id;
  fluxQ = interp2(Map.Id, Map.Iq, Map.FluxQ, Id, Iq, method) + Lew * Iq;
  TorqueDQ = 3/2 * p * (fluxD .* Iq - fluxQ .* Id); 

  [TorqueMax, IdxMax] = max(TorqueDQ); % find the maximum torque
  % save the MTPA values
  MTPA.Id(ii) = Id(IdxMax);
  MTPA.Iq(ii) = Iq(IdxMax);
  MTPA.CurrentAmplitude(ii) = hypot(MTPA.Id(ii), MTPA.Iq(ii));
  MTPA.CurrentAngle(ii) = atan2d(MTPA.Iq(ii), MTPA.Id(ii));
  
  MTPA.FluxD(ii) = fluxD(IdxMax);
  MTPA.FluxQ(ii) = fluxQ(IdxMax);

  MTPA.Flux(ii) = hypot(MTPA.FluxD(ii), MTPA.FluxQ(ii));
  MTPA.Torque(ii) = TorqueMax;

  if ii == length(Ilim_vec) % save the base values
    BASE.Id = MTPA.Id(ii);
    BASE.Iq = MTPA.Iq(ii);
    BASE.CurrentAmplitude = MTPA.CurrentAmplitude(ii);
    BASE.CurrentAngle = MTPA.CurrentAngle(ii);
    BASE.FluxD = MTPA.FluxD(ii);
    BASE.FluxQ = MTPA.FluxQ(ii);
    BASE.Flux = MTPA.Flux(ii);
    BASE.Torque = MTPA.Torque(ii);
    [BASE.ElSpeed, BASE.MechSpeed, BASE.MechSpeedRPM, BASE.ElFrequency] = calc_speed(Voltage, BASE.FluxD, BASE.FluxQ, BASE.Id, BASE.Iq, Rw, p);
    BASE.Power = BASE.Torque * BASE.MechSpeed;
    [BASE.Ud, BASE.Uq, BASE.U] = calc_voltage(BASE.Id, BASE.Iq, BASE.FluxD, BASE.FluxQ, Rw, BASE.ElSpeed);
  end % if ii == length(Ilim_vec)
  
end % for ii = 1 : length(Ilim_vec)

end % function