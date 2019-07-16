% computation of the slot cross section
mo_groupselectblock(s.Group + 1); % 1st slot selection
SlotCrossSection = mo_blockintegral(5); % [m^2], slot area
mo_clearblock();

%% Computation of Az for each simulated slot
Az(SimulatedSlots, 1) = 0;
for q = 1:SimulatedSlots
  mo_groupselectblock(s.Group + q);
  Az(q,1) = mo_blockintegral(1)/SlotCrossSection;
  mo_clearblock();
end

%% Computation of the flux linkages (abc) and (dq)
% flux abc
FluxABC = SymFactor * ncs*K(1:SimulatedSlots,:)'*real(Az);
% flux dq
[FluxD, FluxQ] = calc_abc2dq(FluxABC(1), FluxABC(2), FluxABC(3), thetame);

%% Computation of the torque, radial force, energy, coenergy, AJint
% computation of the dq-torque
TorqueDQ = 3/2 * pp * (FluxD*Iq - FluxQ*Id);
% Maxwell stress tensor torque and forces
TorqueMXW = mo_gapintegral('GapSlidingBand', 0);
Force = mo_gapintegral('GapSlidingBand', 1);
ForceX = Force(1);
ForceY = Force(2);
% energy in the sliding band
GapEnergy = mo_gapintegral('GapSlidingBand', 2);
  
% computation of energy, coenergy and integral of AJ
mo_groupselectblock();
Energy = SymFactor * mo_blockintegral(2);
Coenergy = SymFactor *  mo_blockintegral(17);
AJint = SymFactor * mo_blockintegral(0);
mo_clearblock();
% add airgap energy
Energy = Energy + GapEnergy;
Coenergy = Coenergy + GapEnergy;
AJint = AJint + 2*GapEnergy;


%% Computation of the maximum flux density in the stator teeth

MaxFluxDensityTeeth = 0;
SlotDiameter = (s.geo.InnerDiameter + s.geo.SlotHeight);
for tt = 0 : 360/SymFactor
  xx = SlotDiameter/2 * cos(tt*pi/180);
  yy = SlotDiameter/2 * sin(tt*pi/180);
  try
    out_values = mo_getpointvalues(xx,yy);
  catch
    out_values = zeros(1,14);
  end
  ToothFluxDensity = hypot(out_values(2), out_values(3));
  if ToothFluxDensity > MaxFluxDensityTeeth
    MaxFluxDensityTeeth = ToothFluxDensity;
  end
end
MaxFluxDensityTeeth = MaxFluxDensityTeeth;


%% Computation of the maximum flux density in the stator yoke

MaxFluxDensityYoke = 0;
StatorYokeHeight = (s.geo.OuterDiameter - (s.geo.InnerDiameter + 2*s.geo.SlotHeight))/2;
StatorYokeDiameter = (s.geo.OuterDiameter - StatorYokeHeight);
for tt = 0 : 360/SymFactor
  xx = StatorYokeDiameter/2 * cos(tt*pi/180);
  yy = StatorYokeDiameter/2 * sin(tt*pi/180);
  try
    out_values = mo_getpointvalues(xx,yy);
  catch
    out_values = zeros(1,14);
  end
  YokeFluxDensity = hypot(out_values(2), out_values(3));
  if YokeFluxDensity > MaxFluxDensityYoke
    MaxFluxDensityYoke = YokeFluxDensity;
  end
end
MaxFluxDensityYoke = MaxFluxDensityYoke;

%% Get air-gap flux density
AirgapFluxDensityAngleVec = linspace(0, 360, SD.AirgapFluxDensityContourPoints);
for jj = 1 : length(AirgapFluxDensityAngleVec)
  brbt = mo_getgapb('GapSlidingBand', AirgapFluxDensityAngleVec(jj));
  AirgapFluxDensity(jj) = brbt(1);
end
% compute the fft of the flux density waveform (remove last element)
[Bh, phih] = calc_fft(AirgapFluxDensity, 1);
% get the main harmonic (p-th)
AirgapFluxDensityFund = Bh(1+MD.PolePairs)*exp(1i*phih(1+MD.PolePairs));

%% Get mesh properties for FFT iron losses
if SD.IronLossesFFT == 1
  if thm == 1
    [Xmsh, Ymsh, NumNodes] = get_mesh_nodes(TempFolder);
  end
  [Elements, ElmNodes, ElmBarycenter, ElmArea, ElmGroup, ElmAz, ElmBx, ElmBy] = get_elements_values(TempFolder);
end

%% Exit from post processing procedure
mo_close();