function add_boundary2model(NumOfPeriodicBC,NumOfAntiPeriodicBC)
%ADD_BOUNDARY2MODEL add the boundary condition properties to a femm model
%   Az = 0 is loaded by default
%   NumOfPeriodicBC periodic boundary conditions are created
%   NumOfAntiPeriodicBC anti-periodic boundary conditions are created

%% Add Az=0 boundary condition
mi_deleteboundprop('Az=0'); % to avoid multiple definition
mi_addboundprop('Az=0', 0, 0, 0, 0, 0, 0, 0, 0, 0);

%% Add periodic boundary conditions
for bc = 1:NumOfPeriodicBC
  mi_deleteboundprop(['PeriodicBC', num2str(bc)]) % to avoid multiple definitions
  mi_addboundprop(['PeriodicBC', num2str(bc)], 0, 0, 0, 0, 0, 0, 0, 0, 4);
end

%% Add antiperiodic boundary conditions
for bc = 1:NumOfAntiPeriodicBC
  mi_deleteboundprop(['AntiPeriodicBC', num2str(bc)]) % to avoid multiple definitions
  mi_addboundprop(['AntiPeriodicBC', num2str(bc)], 0, 0, 0, 0, 0, 0, 0, 0, 5);
end

end % function