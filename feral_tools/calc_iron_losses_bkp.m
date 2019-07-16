%% Iron losses
Bmax_t      = MaxFluxDensityTeeth;
Bmax_yk     = MaxFluxDensityYoke;
Khy         = LamProp.HysteresisCoeff;
Kec         = LamProp.EddyCurrentCoeff;

if SD.IronLossesFFT == 1 % FFT
  
  for sk = 1 : length(SD.Skew_vec)
    
    %% STATOR iron losses
    StatorIndex = (ElmGroup == s.Group);
    StatorBx = Skew.ElmBx_mat(:, StatorIndex, sk);
    StatorBy = Skew.ElmBy_mat(:, StatorIndex, sk);
    StatorVolume = ElmArea(StatorIndex)*s.geo.StackLength;
    
    % usually is possible to mirror the flux density waveform
    %     Bx              -Bx
    % [0 --> T/2] ... [T/2 --> T]
    if SD.MirrorHalfPeriod == 1
      StatorBx = [StatorBx; -StatorBx];
      StatorBy = [StatorBy; -StatorBy];
    end
    
    % save flux density values for each stator mesh element (heavy file)
    if SD.SaveMeshElementsValues == 1
      Res.Mesh.Stator.NumElements = size(StatorBx,2);
      Res.Mesh.Stator.FluxDensityX(:,:,sk) = StatorBx;
      Res.Mesh.Stator.FluxDensityY(:,:,sk) = StatorBy;
    end
    
    % specific losses for each element and harmonic
    [StatorElmHarmPhy, StatorElmHarmPec] = calc_specific_iron_losses_fft(StatorBx, StatorBy,  freq, Khy, AlphaCoeff, BetaCoeff, Kec);
    %
    Res.Losses.Lamination.Stator.Hysteresis(sk) = SymFactor*sum(StatorElmHarmPhy*StatorVolume)*LamProp.MassDensity; % [W]
    Res.Losses.Lamination.Stator.EddyCurrent(sk) = SymFactor*sum(StatorElmHarmPec*StatorVolume)*LamProp.MassDensity; % [W]
    Res.Losses.Lamination.Stator.Total(sk) = Res.Losses.Lamination.Stator.Hysteresis(sk) + Res.Losses.Lamination.Stator.EddyCurrent(sk); % [W]
    
    %% ROTOR iron losses
    RotorIdx = (ElmGroup == r.Group);
    RotorBx = Skew.ElmBx_mat(:,RotorIdx,sk);
    RotorBy = Skew.ElmBx_mat(:,RotorIdx,sk);
    RotorVolume = ElmArea(RotorIdx)*r.geo.StackLength;
    
    if SD.MirrorHalfPeriod == 1
      RotorBx = [RotorBx; RotorBx];
      RotorBy = [RotorBy; RotorBy];
    end

    % save flux density values for each rotor mesh element (heavy file)
    if SD.SaveMeshElementsValues == 1
      Res.Mesh.Rotor.NumElements = size(RotorBx,2);
      Res.Mesh.Rotor.FluxDensityX(:,:,sk) = RotorBx;
      Res.Mesh.Rotor.FluxDensityY(:,:,sk) = RotorBy;
    end
    
    % save mesh nodes (heavy file)
    if SD.SaveMeshNodes == 1
      Res.Mesh.NumNodes = NumNodes;
      Res.Mesh.XY = [Xmsh, Ymsh];
    end
    
    [RotorElmHarmPhy, RotorElmHarmPec, ElFreqVec] = calc_specific_iron_losses_fft(RotorBx, RotorBy,  freq, Khy, AlphaCoeff, BetaCoeff, Kec);
    Res.Losses.Lamination.Rotor.Hysteresis(sk) = SymFactor*sum(RotorElmHarmPhy*RotorVolume)*LamProp.MassDensity; % [W]
    Res.Losses.Lamination.Rotor.EddyCurrent(sk) = SymFactor*sum(RotorElmHarmPec*RotorVolume)*LamProp.MassDensity; % [W]
    Res.Losses.Lamination.Rotor.Total(sk) = Res.Losses.Lamination.Rotor.Hysteresis(sk) + Res.Losses.Lamination.Rotor.EddyCurrent(sk); % [W]
    
  end % for sk = 1 : length(SD.Skew_vec)
  
  % total hysteresis losses [W]
  Res.Losses.Lamination.Hysteresis = mean(Res.Losses.Lamination.Stator.Hysteresis) + mean(Res.Losses.Lamination.Rotor.Hysteresis);
  % total eddy-current losses [W]
  Res.Losses.Lamination.EddyCurrent = mean(Res.Losses.Lamination.Stator.EddyCurrent) + mean(Res.Losses.Lamination.Rotor.EddyCurrent);
  
else % normal
  
  %% Stator iron losses only (teeth + yoke)
  % Compute iron losses in the teeth
  Losses.Teeth.Hysteresis           = Khy * Bmax_t^AlphaCoeff  * freq^BetaCoeff * Res.Weight.Teeth;
  Losses.Teeth.EddyCurrent          = Kec * (Bmax_t * freq)^2 * Res.Weight.Teeth;
  Losses.Teeth.Total                = Losses.Teeth.Hysteresis + Losses.Teeth.EddyCurrent;
  
  % Compute iron losses in the yoke
  Losses.Yoke.Hysteresis            = Khy * Bmax_yk^AlphaCoeff  * freq^BetaCoeff * Res.Weight.Yoke;
  Losses.Yoke.EddyCurrent           = Kec * (Bmax_yk * freq)^2 * Res.Weight.Yoke;
  Losses.Yoke.Total                 = Losses.Yoke.Hysteresis + Losses.Yoke.EddyCurrent;
  
  % Total hysteresis losses [W]
  Res.Losses.Lamination.Hysteresis = Losses.Teeth.Hysteresis + Losses.Yoke.Hysteresis;
  % Total eddy-current losses [W]
  Res.Losses.Lamination.EddyCurrent = Losses.Teeth.EddyCurrent + Losses.Yoke.EddyCurrent;

end % if SD.IronLossesFFT == 1

% total lamination losses [W]
Res.Losses.Lamination.Total = Res.Losses.Lamination.Hysteresis + Res.Losses.Lamination.EddyCurrent;
