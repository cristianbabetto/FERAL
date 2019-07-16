for sk = 1 : length(SD.Skew_vec)
  
  MagnetIdx = find(any(ElmGroup == r.Magnet.Groups, 2));
  MagnetAz = Skew.ElmAz_mat(:,MagnetIdx,sk);
  MagnetElmArea = ElmArea(MagnetIdx);
  MagnetElmVolume = MagnetElmArea*r.geo.StackLength;
  
  if SD.MirrorHalfPeriod == 1
    MagnetAz = [MagnetAz; MagnetAz];
  end
  
  % compute fft of Az and then Jeddy
  NN = size(MagnetAz,1);
  sigmaPM = r.Material.Magnet.ElConductivity; % [Ohm.m]
  MagnetAzFFT = fft(MagnetAz)*2/NN;
  JeFFT = -1i*sigmaPM*2*pi*repmat(ElFreqVec',1,size(Az,2)).*MagnetAzFFT;
  
  for MagIdx = r.Magnet.Groups
    ThisMagnetElm = ElmGroup(MagnetIdx) == MagIdx;
    ThisMagnetElmIdx = find(ThisMagnetElm);
    ThisMagnetElmArea = MagnetElmArea(ThisMagnetElmIdx);
    ThisMagnetArea = sum(ThisMagnetElmArea);
    Javg = JeFFT(:,ThisMagnetElmIdx)*ThisMagnetElmArea/ThisMagnetArea;
    JeFFT = JeFFT - Javg*ThisMagnetElm';
  end
  
  MagnetLosses(sk) = SymFactor/(2*sigmaPM)*sum(abs(JeFFT).^2*MagnetElmVolume); % [W]
  
end % for sk = 1 : length(SD.Skew_vec)

Res.Losses.Magnet = mean(MagnetLosses);
