%% Plot propeerties

% Color
DefaultColors = {
'PhaseA',                          [255,0,0]/255;
'PhaseB',                          [34,139,34]/255;
'PhaseC',                          [0,0,255]/255;
'AxisD',                           [255,0,0]/255;
'AxisQ',                           [0,0,255]/255;
'FluxDensity',                     [0,0,255]/255;
'FluxDensityFund',                 [0,0,0]/255;
'TorqueDQ',                        [255,0,0]/255;
'TorqueMXW',                       [0,0,255]/255;
'TorqueHarm',                      [0,0,0]/255;
'BarPlot',                         [0,0,0]/255;
'BarPlotSkew',                     [255,0,0]/255;
'MTPA',                            [255,0,0]/255;    
'FW',                              [34,139,34]/255;
'MTPV',                            [0,0,255]/255;
'Ilim',                            [255,0,255]/255;
'TorqueMTPA',                      [255,0,0]/255;
'TorqueFW',                        [34,139,34]/255;
'TorqueMTPV',                      [0,0,255]/255;
'PowerMTPA',                       [255,0,0]/255;
'PowerFW',                         [34,139,34]/255;
'PowerMTPV',                       [0,0,255]/255;
'IpeakMTPA',                       [255,0,0]/255;
'IpeakFW',                         [34,139,34]/255;
'IpeakMTPV',                       [0,0,255]/255;
'FluxD0',                          [255,0,0]/255;
'FluxD',                           [0,0,0]/255;
'FluxQ0',                          [255,0,0]/255;
'FluxQ',                           [0,0,0]/255;
'IsoTorque',                       [0,0,255]/255;
'IsoFlux',                         [0,0,0]/255;
};

% Line style
DefaultLineStyles = {
'PhaseA',                          '-';
'PhaseB',                          '-';
'PhaseC',                          '-';
'AxisD',                           '-';
'AxisQ',                           '-';
'FluxDensity',                     '-';
'FluxDensityFund',                 '--';
'TorqueDQ',                        '-o';
'TorqueMXW',                       '-d';
'MTPA',                            '-';    
'FW',                              '-';
'MTPV',                            '-';
'Ilim',                            '-';
'IsoTorque',                       '-';
'IsoFlux',                         '-';
'TorqueMTPA',                      '-';
'TorqueFW',                        '-';
'TorqueMTPV',                      '-';
'PowerMTPA',                       '-';
'PowerFW',                         '-';
'PowerMTPV',                       '-';
'IpeakMTPA',                       '-';
'IpeakFW',                         '-';
'IpeakMTPV',                       '-';
'FluxD0',                          '-';
'FluxD',                           '-';
'FluxQ0',                          '-';
'FluxQ',                           '-';
};

% Line width
DefaultLineWidths = {
'PhaseA',                          2;
'PhaseB',                          2;
'PhaseC',                          2;
'AxisD',                           2;
'AxisQ',                           2;
'FluxDensity',                     2;
'FluxDensityFund',                 2;
'TorqueDQ',                        2;
'TorqueMXW',                       2;
'MTPA',                            2;    
'FW',                              2;
'MTPV',                            2;
'Ilim',                            2;
'IsoTorque',                       1;
'IsoFlux',                         1;
'TorqueMTPA',                      2;
'TorqueFW',                        2;
'TorqueMTPV',                      2;
'PowerMTPA',                       2;
'PowerFW',                         2;
'PowerMTPV',                       2;
'IpeakMTPA',                       2;
'IpeakFW',                         2;
'IpeakMTPV',                       2;
'FluxD0',                          2;
'FluxD',                           0.5;
'FluxQ0',                          2;
'FluxQ',                           0.5;
};

% Legend
DefaultLegends = {
'PhaseA',                          'A';
'PhaseB',                          'B';
'PhaseC',                          'C';
'AxisD',                           'D-axis';
'AxisQ',                           'Q-axis';
'FluxDensity',                     'B_g(\theta_m)';
'FluxDensityFund',                 'B_g^1';
'TorqueDQ',                        'TorqueDQ';
'TorqueMXW',                       'TorqueMXW';
'MTPA',                            'MTPA';    
'FW',                              'FW';
'MTPV',                            'MTPV';
'Ilim',                            'Current limit';
'IsoTorque',                       'Const. Torque loci';
'IsoFlux',                         'Const. Flux loci';
'TorqueMTPA',                      'MTPA';
'TorqueFW',                        'FW';
'TorqueMTPV',                      'MTPV';
'PowerMTPA',                       'MTPA';
'PowerFW',                         'FW';
'PowerMTPV',                       'MTPV';
'IpeakMTPA',                       'MTPA';
'IpeakFW',                         'FW';
'IpeakMTPV',                       'MTPV';
'FluxD0',                          'I_q = 0';
'FluxD',                           '';
'FluxQ0',                          'I_d = 0';
'FluxQ',                           '';
};

%% Font properties

DefaultFontName = {
'Label',                          'Arial';
'Legend',                         'Arial';
'Axis',                           'Arial';
};

DefaultFontSize = {
'Label',                          10;
'Legend',                         10;
'Axis',                           10;
};

DefaultFontWeight = {
'Label',                          'normal';
'Legend',                         'normal';
'Axis',                           'normal'
};