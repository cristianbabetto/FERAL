Res.CurrentDensityRMS   = Ipeak * ncs / sqrt(2) / (SlotCrossSection * 1e6 * s.w.SlotFillFactor);
if SD.WindingResistance % set user resistance value
  Res.WindingResistance = SD.WindingResistance;
else  
  Res.WindingResistance = 1/s.Material.Slot.ElConductivity * Res.ConductorLength * (ncs*s.geo.Slots/3) / (SlotCrossSection * 1e6 * s.w.SlotFillFactor/ncs);
end
Res.Losses.Conductor    = 3/2 * Res.WindingResistance * Ipeak^2;