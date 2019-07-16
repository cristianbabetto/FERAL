%% Script to compute the iron losses by means of the FFT method

% INPUT
% the iron losses are computed for each element of 
% the stator (teeth and yoke) and rotor
% 
% the computation starts from the behavior of the flux density (Bx, By)
% versus the rotor position for each mesh element
% 
% then, the FFT of each waveform is computed
%
% the iron losses 

% the equation is: sum (Khy * fh^alpha * Bh^2 + Kec * fh^2 * Bh^2)
%
% Khy, alpha, beta are the hysteresis iron losses coefficients
% Kec is the eddy-current iron losses coefficient
% fh is the h-th harmonic of the fundamental frequency [Hz]
% Bh is the amplitude of the h-th harmonic of the flux density [T]

for sk = 1 : length(SD.Skew_vec)
  
  
  %% Stator iron losses (teeth and yoke)
  
  % Select the teeth elements
  TeethRadius = s.geo.InnerDiameter/2 + s.geo.SlotHeight;
  ElmBarycenterRadius = hypot(ElmBarycenter(:,1), ElmBarycenter(:,2));
  TeethIndex = find(ElmGroup == s.Group & ElmBarycenterRadius <= TeethRadius);
  % Select the stator yoke elements
  YokeIndex = find(ElmGroup == s.Group & ElmBarycenterRadius > TeethRadius);
  
  for ty = 1:2 % (teeth, yoke)
    
    if ty == 1
      StatorRegionIndex = TeethIndex;
    elseif ty == 2
      StatorRegionIndex = YokeIndex;
    end % if tt
    
    StatorRegionAz = Skew.ElmAz_mat(:, StatorRegionIndex, sk);
    StatorRegionBx = Skew.ElmBx_mat(:, StatorRegionIndex, sk);
    StatorRegionBy = Skew.ElmBy_mat(:, StatorRegionIndex, sk);
    StatorRegionVolume = ElmArea(StatorRegionIndex)*s.geo.StackLength;
    
    % usually is possible to mirror the flux density waveform
    %     Bx              -Bx
    % [0 --> T/2] ... [T/2 --> T]
    if SD.MirrorHalfPeriod == 1
      
      StatorRegionAz = [StatorRegionAz; -StatorRegionAz];
      StatorRegionBx = [StatorRegionBx; -StatorRegionBx];
      StatorRegionBy = [StatorRegionBy; -StatorRegionBy];
      
    end
    
    % save flux density values for each stator mesh element (heavy file)
    if SD.SaveMeshElementsValues == 1
      
      if ty == 1 % teeth
        
        Res.Mesh.Stator.NumElements = size(StatorRegionBx,2);
        Res.Mesh.Stator.Teeth.Az(:,:,sk) = StatorRegionAz;
        Res.Mesh.Stator.Teeth.FluxDensityX(:,:,sk) = StatorRegionBx;
        Res.Mesh.Stator.Teeth.FluxDensityY(:,:,sk) = StatorRegionBy;
        Res.Mesh.Stator.Teeth.ElmNodes = ElmNodes(StatorRegionIndex,:);
        Res.Mesh.Stator.Teeth.ElmBarycenter = ElmBarycenter(StatorRegionIndex,:);
        Res.Mesh.Stator.Teeth.ElmArea = ElmArea(StatorRegionIndex,:);
        Res.Mesh.Stator.Teeth.ElmGroup = ElmGroup(StatorRegionIndex,:);
        
        
      elseif ty == 2 % yoke
        
        Res.Mesh.Stator.Yoke.NumElements = size(StatorRegionBx,2);
        Res.Mesh.Stator.Yoke.Az(:,:,sk) = StatorRegionAz;
        Res.Mesh.Stator.Yoke.FluxDensityX(:,:,sk) = StatorRegionBx;
        Res.Mesh.Stator.Yoke.FluxDensityY(:,:,sk) = StatorRegionBy;
        Res.Mesh.Stator.Yoke.ElmNode = ElmNodes(StatorRegionIndex,:);
        Res.Mesh.Stator.Yoke.ElmBarycenter = ElmBarycenter(StatorRegionIndex,:);
        Res.Mesh.Stator.Yoke.ElmArea = ElmArea(StatorRegionIndex,:);
        Res.Mesh.Stator.Yoke.ElmGroup = ElmGroup(StatorRegionIndex,:);
        
      end % if tt
      
    end % if SD.SaveMeshElementsValues == 1
    
    % compute stator specific iron losses (hysteresis and eddy-current) for each element
    [StatorElmHarmPhy, StatorElmHarmPec] = calc_specific_iron_losses_fft(StatorRegionBx, StatorRegionBy,  freq, StatorKhy, StatorAlphaCoeff, StatorBetaCoeff, StatorKec);
    
    % compute the total stator iron losses
    if ty == 1 % teeth
      
      % stator teeth hysteresis iron losses [W]
      Res.FFTLosses.Lamination.Stator.Teeth.Hysteresis.Vec(sk) = SymFactor*sum(StatorElmHarmPhy*StatorRegionVolume)*StatorLamProp.MassDensity * SD.LossesTeethFactor; 
      
      % stator teeth eddy-current iron losses [W]
      Res.FFTLosses.Lamination.Stator.Teeth.EddyCurrent.Vec(sk) = SymFactor*sum(StatorElmHarmPec*StatorRegionVolume)*StatorLamProp.MassDensity * SD.LossesTeethFactor;
      
      % stator teeth total iron losses [W]
      Res.FFTLosses.Lamination.Stator.Teeth.Total.Vec(sk) = Res.FFTLosses.Lamination.Stator.Teeth.Hysteresis.Vec(sk) + Res.FFTLosses.Lamination.Stator.Teeth.EddyCurrent.Vec(sk);
      
    elseif ty == 2 % yoke
      
      % stator yoke hysteresis iron losses [W]
      Res.FFTLosses.Lamination.Stator.Yoke.Hysteresis.Vec(sk) = SymFactor*sum(StatorElmHarmPhy*StatorRegionVolume)*StatorLamProp.MassDensity * SD.LossesYokeFactor;
      
      % stator yoke eddy-current iron losses [W]
      Res.FFTLosses.Lamination.Stator.Yoke.EddyCurrent.Vec(sk) = SymFactor*sum(StatorElmHarmPec*StatorRegionVolume)*StatorLamProp.MassDensity * SD.LossesYokeFactor;
      
      % stator yoke total iron losses [W]
      Res.FFTLosses.Lamination.Stator.Yoke.Total.Vec(sk) = Res.FFTLosses.Lamination.Stator.Yoke.Hysteresis.Vec(sk) + Res.FFTLosses.Lamination.Stator.Yoke.EddyCurrent.Vec(sk); 
      
    end % if tt
    
  end % for tt = 1:2
  
  % stator hysteresis iron losses [W]
  Res.FFTLosses.Lamination.Stator.Hysteresis.Vec(sk) = Res.FFTLosses.Lamination.Stator.Teeth.Hysteresis.Vec(sk) + Res.FFTLosses.Lamination.Stator.Yoke.Hysteresis.Vec(sk);
  
  % stator eddy-current iron losses [W]
  Res.FFTLosses.Lamination.Stator.EddyCurrent.Vec(sk) = Res.FFTLosses.Lamination.Stator.Teeth.EddyCurrent.Vec(sk) + Res.FFTLosses.Lamination.Stator.Yoke.EddyCurrent.Vec(sk);
  
  
  %% Rotor iron losses
  
  % get the rotor properties (Index, Az, Bx, By, Volume)
  RotorIndex = (ElmGroup == r.IronGroup);
  RotorAz = Skew.ElmAz_mat(:,RotorIndex,sk);
  RotorBx = Skew.ElmBx_mat(:,RotorIndex,sk);
  RotorBy = Skew.ElmBx_mat(:,RotorIndex,sk);
  RotorVolume = ElmArea(RotorIndex)*r.geo.StackLength;
  
  % mirror the rotor elememt values to complete an electric period
  %     Bx              -Bx
  % [0 --> 180] ... [180 --> 360]
  if SD.MirrorHalfPeriod == 1
    RotorAz = [RotorAz; RotorAz];
    RotorBx = [RotorBx; RotorBx];
    RotorBy = [RotorBy; RotorBy];
  end
  
  % save flux density values for each rotor mesh element (heavy file)
  if SD.SaveMeshElementsValues == 1
    Res.Mesh.Rotor.NumElements = size(RotorBx,2);
    Res.Mesh.Rotor.Az(:,:,sk) = RotorAz;
    Res.Mesh.Rotor.FluxDensityX(:,:,sk) = RotorBx;
    Res.Mesh.Rotor.FluxDensityY(:,:,sk) = RotorBy;
    Res.Mesh.Rotor.ElmNode = ElmNodes(RotorIndex,:);
    Res.Mesh.Rotor.ElmBarycenter = ElmBarycenter(RotorIndex,:);
    Res.Mesh.Rotor.ElmArea = ElmArea(RotorIndex,:);
    Res.Mesh.Rotor.ElmGroup = ElmGroup(RotorIndex,:);
  end
  
  % compute rotor specific iron losses for each element [W/kg]
  [RotorElmHarmPhy, RotorElmHarmPec, ElFreqVec] = calc_specific_iron_losses_fft(RotorBx, RotorBy,  freq, RotorKhy, RotorAlphaCoeff, RotorBetaCoeff, RotorKec);
  
  % compute the global rotor hysteresis losses [W]
  Res.FFTLosses.Lamination.Rotor.Hysteresis.Vec(sk) = SymFactor*sum(RotorElmHarmPhy*RotorVolume)*RotorLamProp.MassDensity;
  
  % compute the global rotor eddy-current losses [W]
  Res.FFTLosses.Lamination.Rotor.EddyCurrent.Vec(sk) = SymFactor*sum(RotorElmHarmPec*RotorVolume)*RotorLamProp.MassDensity;
  
  % compute the total rotor losses [W]
  Res.FFTLosses.Lamination.Rotor.Total.Vec(sk) = Res.FFTLosses.Lamination.Rotor.Hysteresis.Vec(sk) + Res.FFTLosses.Lamination.Rotor.EddyCurrent.Vec(sk);
  
  
end % for sk = 1 : length(SD.Skew_vec)


%% Stator average FFT iron losses

% HYSTERESIS
% Average stator teeth hysteresis losses [W]
Res.FFTLosses.Lamination.Stator.Teeth.Hysteresis.Avg = mean(Res.FFTLosses.Lamination.Stator.Teeth.Hysteresis.Vec);
% Average stator yoke hysteresis losses [W]
Res.FFTLosses.Lamination.Stator.Yoke.Hysteresis.Avg = mean(Res.FFTLosses.Lamination.Stator.Yoke.Hysteresis.Vec);
% Average stator hysteresis losses [W]
Res.FFTLosses.Lamination.Stator.Hysteresis.Total = Res.FFTLosses.Lamination.Stator.Teeth.Hysteresis.Avg + Res.FFTLosses.Lamination.Stator.Yoke.Hysteresis.Avg;

% EDDY-CURRENT
% Average stator teeth eddy-current losses [W]
Res.FFTLosses.Lamination.Stator.Teeth.EddyCurrent.Avg = mean(Res.FFTLosses.Lamination.Stator.Teeth.EddyCurrent.Vec);
% Average stator yoke eddy-current losses [W]
Res.FFTLosses.Lamination.Stator.Yoke.EddyCurrent.Avg = mean(Res.FFTLosses.Lamination.Stator.Teeth.EddyCurrent.Vec);
% Average stator eddy-current losses [W]
Res.FFTLosses.Lamination.Stator.EddyCurrent.Total = Res.FFTLosses.Lamination.Stator.Teeth.EddyCurrent.Avg + Res.FFTLosses.Lamination.Stator.Yoke.EddyCurrent.Avg;

% Average stator total losses [W]
Res.FFTLosses.Lamination.Stator.Total = Res.FFTLosses.Lamination.Stator.Hysteresis.Total + Res.FFTLosses.Lamination.Stator.EddyCurrent.Total;


%% Rotor average FFT iron losses

% HYSTERESIS
% Average rotor hysteresis losses [W]
Res.FFTLosses.Lamination.Rotor.Hysteresis.Avg = mean(Res.FFTLosses.Lamination.Rotor.Hysteresis.Vec);

% EDDY-CURRENT
% Average rotor eddy-current losses [W]
Res.FFTLosses.Lamination.Rotor.EddyCurrent.Avg = mean(Res.FFTLosses.Lamination.Rotor.EddyCurrent.Vec);

% Average rotor total losses [W]
Res.FFTLosses.Lamination.Rotor.Total = Res.FFTLosses.Lamination.Rotor.Hysteresis.Avg + Res.FFTLosses.Lamination.Rotor.EddyCurrent.Avg;


%% Model average FFT iron losses
% Total model iron losses [W]
Res.FFTLosses.Lamination.Total = Res.FFTLosses.Lamination.Stator.Total + Res.FFTLosses.Lamination.Rotor.Total;
