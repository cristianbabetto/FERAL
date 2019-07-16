%% Setting the problem
mi_probdef( MD.ModelFrequency, ...
  MD.ModelUnit, ...
  MD.ModelType, ...
  MD.ModelPrecision, ...
  MD.StackLength*MD.PackFactor, ...
  MD.MeshMinAngle, ...
  MD.ACSolver);

% set smart mesh option
smartmesh(SD.SmartMesh);

%% Sliding Band or Rotation of the rotor
if SD.MoveRotatingParts
  % rotate physically the rotating parts (useful to view the .ans file properly)
  
  % select all the motion groups
  for MotionGroup = SD.MotionGroups
    mi_selectgroup(MotionGroup)
  end
  
  % rotate the selected geometry
  mi_moverotate(0, 0, thetam + skew + r.Alignment)
  
  % assign the sliding band boundary condition
  mi_modifyboundprop('GapSlidingBand', 10, -(thetam + skew + r.Alignment))
  
else
  % do not move the rotating parts in the model
  mi_modifyboundprop('GapSlidingBand', 10, thetam + skew + r.Alignment);
end

% electric rotor position
thetame = MD.PolePairs * thetam; 

%% Disable permanent magnets
if ~isempty(SD.DisableMagnet)

  % convert to cell
  if ~iscell(SD.DisableMagnet)
    MagnetNames = {SD.DisableMagnet};
  else
    MagnetNames = SD.DisableMagnet;
  end % ~iscell(SD.DisableMagnet)
  
  % set all the MagnetNames coercitive fields equal to 0
  for pm_idx = 1:length(MagnetNames)
    mi_modifymaterial(MagnetNames{pm_idx}, 3, 0);
  end

end % SD.DisableMagnet ~= 0

%% Compute the current components
% dq currents computation
Id = Ipeak * cos(alphaie*pi/180);
Iq = Ipeak * sin(alphaie*pi/180);
% phase current computation (ia, ib, ic)
[ia, ib, ic] = calc_dq2abc(Id, Iq, thetame);

%% Assign the current to the stator circuits
for qq = 1 : SimulatedSlots
  CurrentInSlot(qq) = ncs * (ia * K(qq,1) + ib *  K(qq,2) + ic * K(qq,3));
  mi_modifycircprop([MD.CircName, num2str(qq)], 1, CurrentInSlot(qq));
end

%% Load previous solution to reduce solving time
try
  if SD.UsePreviousSolution 
    mi_setprevious([SD.TempFileName, '.ans'], SD.PrevSolutionType);
  end
catch
    disp('To use UsePreviousSolution please install the latest FEMM 4.2 release')
end

%% Save model and solve
mi_saveas([SD.TempFolder,'\', SD.TempFileName, '.fem']); % save the model as temp
mi_analyze(1); % solve the model

mi_loadsolution;