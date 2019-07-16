function MTPA = sim_find_mtpa(MD, SD)
%SIM_FIND_MTPA find the maximum torque per ampere current angle for
%   a given current amplitude

kk = 0;
for CurrentAngle = SD.CurrentAngleRange % evaluate the torque for each current angle
  
  kk = kk + 1;
  
  SD.SaveResults = 0;
  SD.PlotResults = 0;
  SD.SaveFigures = 0;
  SD.MechSpeedRPM = 2000;
  SD.DisplayProgress = 0;
  SD.SaveFigures = 0;
  SD.CurrentAngle = CurrentAngle;
  SD.Warning = 'off';
    
  [Res] = sim_var_rotor_position(MD, SD);
  Torque(kk) = Res.TorqueDQ;
  
  % if the new torque is lower than the previous one
  if (kk > 1 && Torque(kk) < Torque(kk-1)) 
    MTPA.Torque = Torque(kk-1);
    MTPA.CurrentAmplitude = SD.CurrentAmplitude;
    MTPA.CurrentAngle = CurrentAngle;
    return % the MTPA is found, stop the loop
  elseif kk == length(SD.CurrentAngleRange) % MTPA not found
    MTPA.Torque = Torque(kk);
    MTPA.CurrentAmplitude = SD.CurrentAmplitude;
    MTPA.CurrentAngle = CurrentAngle;    
  end % if kk > 1 && Torque(kk) < Torque(kk-1)
  
end % for SD.CurrentAngleVec


end % function

