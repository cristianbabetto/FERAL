function [FW, MTPV] = calc_fw_mtpv(Map, CurrentAmplitudeRange)
%CALC_FW_MTPV computes the flux-weakening and maximum torque per voltage locus

%% Set default fields if not defined
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
Ulim = Map.VoltageLimit; % voltage limit [V] (peak)
p = Map.PolePairs; % pole pairs
InterpMethod = Map.InterpMethod; % interpolation method 
Rw = Map.WindingResistance; % winding resistance [ohm]
Lew = Map.EndWindingInductance; % end-winding inductance [H]
RPM_max = Map.MaxMechSpeedRPM; % maximum mechanical speed [rpm]
Ilim_vec = CurrentAmplitudeRange; % current limit range [A] (peak)

% Compute PM flux linkage
FluxPM = interp2(Map.Id, Map.Iq, Map.FluxD, 0, 0, InterpMethod);


for kk = 1:length(Ilim_vec) % for each current amplitude
  
  jj = 1; % FW array index
  ii = 1; % MTPV array index
  
  % kk-th current limit
  Ilim = Ilim_vec(kk);
  alphaie_vec = Map.CurrentAngleRange; % current angle range [deg]
  alphaie_step = alphaie_vec(2)- alphaie_vec(1); % step of the current angle [deg]
  
  % Compute the base point
  [~, BASE] = calc_mtpa(Map, Ilim, alphaie_vec, Ulim);
  
  % initilize the FW structure fields
  % the first value is the BASE point
  FW(kk).Id(jj) = BASE.Id;
  FW(kk).Iq(jj) = BASE.Iq;
  FW(kk).CurrentAmplitude(jj) = BASE.CurrentAmplitude;
  FW(kk).CurrentAngle(jj) = BASE.CurrentAngle;
  FW(kk).FluxD(jj) = BASE.FluxD;
  FW(kk).FluxQ(jj) = BASE.FluxQ;
  FW(kk).Flux(jj) = hypot(FW(kk).FluxD(jj), FW(kk).FluxQ(jj));
  FW(kk).Torque(jj) = BASE.Torque;
  FW(kk).ElFrequency(jj) = BASE.ElFrequency;
  FW(kk).ElSpeed(jj) = BASE.ElSpeed;
  FW(kk).MechSpeed(jj) = BASE.MechSpeed(jj);
  FW(kk).MechSpeedRPM(jj) = BASE.MechSpeedRPM(jj);
  FW(kk).Power(jj) = FW(kk).Torque(jj)*FW(kk).MechSpeed(jj);
  
  CurrentAngle = BASE.CurrentAngle;

  % flag to check MTPV
  ExistMTPV = 0;
  
  RPM = 0;
  
  while (CurrentAngle <= alphaie_vec(end) && RPM < RPM_max)
    jj      = jj + 1;
    Id      = Ilim * cosd(CurrentAngle);
    Iq      = Ilim * sind(CurrentAngle);
    fluxD   = interp2(Map.Id_vec, Map.Iq_vec, Map.FluxD, Id, Iq, InterpMethod);
    fluxQ   = interp2(Map.Id_vec, Map.Iq_vec, Map.FluxQ, Id, Iq, InterpMethod);
    flux    = hypot(fluxD,fluxQ);
    torque  = interp2(Map.Id_vec, Map.Iq_vec, Map.TorqueDQ, Id, Iq, InterpMethod);
    [w, wm, RPM, freq] = calc_speed(Ulim, fluxD, fluxQ, Id, Iq, Rw, p);
    
    % Estimate the operating point along the MTPV locus
    [Id_mtpv, Iq_mtpv, Imtpv] = calc_mtpv_current(fluxD, fluxQ, FluxPM, Id, Iq);
    
    if Imtpv >= Ilim % the MTPV current is outside the current limit
      FW(kk).Id(jj) = Id;
      FW(kk).Iq(jj) = Iq;
      FW(kk).CurrentAmplitude(jj) = hypot(Id, Iq);
      FW(kk).CurrentAngle(jj) = CurrentAngle;
      FW(kk).FluxD(jj) = fluxD;
      FW(kk).FluxQ(jj) = fluxQ;
      FW(kk).Flux(jj) = flux;
      FW(kk).Torque(jj) = torque;
      FW(kk).ElFrequency(jj) = freq;
      FW(kk).ElSpeed(jj) = w;
      FW(kk).MechSpeed(jj) = wm;
      FW(kk).MechSpeedRPM(jj) = RPM;
      FW(kk).Power(jj) = torque*wm;
      
    else % the MTPV current is lower than the current limit
      ExistMTPV = 1;
      if ii == 1
        % initilize the MTPV structure arrays
        % the first values are the last of FW
        MTPV(kk).Id(ii) = FW(kk).Id(end);
        MTPV(kk).Iq(ii) = FW(kk).Iq(end);
        MTPV(kk).CurrentAmplitude(ii) = FW(kk).CurrentAmplitude(end);
        MTPV(kk).CurrentAngle(ii) = FW(kk).CurrentAngle(end);
        MTPV(kk).FluxD(ii) = FW(kk).FluxD(end);
        MTPV(kk).FluxQ(ii) = FW(kk).FluxQ(end);
        MTPV(kk).Flux(ii) = FW(kk).Flux(end);
        MTPV(kk).Torque(ii) = FW(kk).Torque(end);
        MTPV(kk).ElFrequency(ii) = FW(kk).ElFrequency(end);
        MTPV(kk).ElSpeed(ii) = FW(kk).ElSpeed(end);
        MTPV(kk).MechSpeed(ii) = FW(kk).MechSpeed(end);
        MTPV(kk).MechSpeedRPM(ii) = FW(kk).MechSpeedRPM(end);
        MTPV(kk).Power(ii) = FW(kk).Power(end);
        alphaie_step = alphaie_step/10;
      end % if ii == 1
      
      ii = ii + 1;
      
      Ilim = Imtpv;
      fluxD = interp2(Map.Id_vec, Map.Iq_vec, Map.FluxD, Id_mtpv, Iq_mtpv, InterpMethod);
      fluxQ = interp2(Map.Id_vec, Map.Iq_vec, Map.FluxQ, Id_mtpv, Iq_mtpv, InterpMethod);
      flux = hypot(fluxD, fluxQ);
      torque = interp2(Map.Id_vec, Map.Iq_vec, Map.TorqueDQ, Id_mtpv, Iq_mtpv, InterpMethod);
      [w, wm, RPM, freq] = calc_speed(Ulim, fluxD, fluxQ, Id_mtpv, Iq_mtpv, Rw, p);
      MTPV(kk).Id(ii) = Id_mtpv;
      MTPV(kk).Iq(ii) = Iq_mtpv;
      MTPV(kk).CurrentAmplitude(ii) = Imtpv;
      MTPV(kk).CurrentAngle(ii) = angle(Id_mtpv + 1i*Iq_mtpv);
      MTPV(kk).FluxD(ii) = fluxD;
      MTPV(kk).FluxQ(ii) = fluxQ;
      MTPV(kk).Flux(ii) = flux;
      MTPV(kk).Torque(ii) = torque;
      MTPV(kk).ElFrequency(ii) = freq;
      MTPV(kk).ElSpeed(ii) = w;
      MTPV(kk).MechSpeed(ii) = wm;
      MTPV(kk).MechSpeedRPM(ii) = RPM;
      MTPV(kk).Power(ii) = torque * wm;
    end % if Imtpv >= Ilim
    %  increase current angle
    CurrentAngle = CurrentAngle + alphaie_step;
  end % loop WHILE
  
  % for more general case
  if ExistMTPV == 0
    MTPV(kk).Id = FW(kk).Id(end);
    MTPV(kk).Id = FW(kk).Id(end);
    MTPV(kk).Iq = FW(kk).Iq(end);
    MTPV(kk).CurrentAmplitude = FW(kk).CurrentAmplitude(end);
    MTPV(kk).CurrentAngle = FW(kk).CurrentAngle(end);
    MTPV(kk).FluxD = FW(kk).FluxD(end);
    MTPV(kk).FluxQ = FW(kk).FluxQ(end);
    MTPV(kk).Flux = FW(kk).Flux(end);
    MTPV(kk).Torque = FW(kk).Torque(end);
    MTPV(kk).ElSpeed = FW(kk).ElSpeed(end);
    MTPV(kk).MechSpeed = FW(kk).MechSpeed(end);
    MTPV(kk).MechSpeedRPM = FW(kk).MechSpeedRPM(end);
    MTPV(kk).Power = FW(kk).Power(end);
  end
  
  ExistMTPV = 0;
  
end % for kk = 1 : CurrentLimVec

end % function