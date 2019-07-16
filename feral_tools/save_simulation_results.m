if SD.SaveResults == 1
  
  % Set skew string
  if (length(SD.Skew_vec) == 1 && SD.Skew_vec(1) ~= 0)
    SkewString = 'skew_';
  elseif length(SD.Skew_vec) > 1
    SkewString = 'skew_';
  else
    SkewString = '';
  end
  
  CurrentAmplitudeString = ['Ipk_', number2string(Ipeak, SD.DecimalSymbol, SD.FormatNumber),'_A'];
  CurrentAngleString = ['aie_', number2string(alphaie, SD.DecimalSymbol, SD.FormatNumber),'_deg'];
  CurrentString = [CurrentAmplitudeString,'_',CurrentAngleString];
  RotorPositionString = ['thme_', number2string(SD.RotorPositions*pp, SD.DecimalSymbol, SD.FormatNumber),'_deg'];
  
  % Set the file results name
  if ~isfield(SD,'FileResultsName')
    SD.FileResultsName = ['vrp_',SkewString,CurrentString,'_',RotorPositionString,'_',datestr(clock,30),'.mat'];
    CompleteFileNameResults = [SD.ResultsFolder, '\', SD.FileResultsPrefix, SD.FileResultsName];
  else
    CompleteFileNameResults = SD.FileResultsName;
  end % if ~isfield(SimInput,'FileResultsName')
  
  
  % Clear the output structures if not required
  if nargout == 1
    Vec = [];
    Skew = [];
  elseif nargout == 2
    Skew = [];
  end
  
  % Save the results
  if isOctave
    save(CompleteFileNameResults, 'Res', 'Vec', 'Skew','-V7'); % Matlab-Octave compatibility option
  else
    save(CompleteFileNameResults, 'Res', 'Vec', 'Skew');
  end % if isOctave
  
end % if SimInput.SaveResults == 1