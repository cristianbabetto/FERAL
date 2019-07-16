function MD = add_slotlabels2model(MD)
%ADD_SLOTLABELS2MODEL add the labels and the circuits
%   for stator slots and slot opening into a FEMM model

SymFactor = (MD.PolePairs*2)/MD.SimPoles;

% set default circuits name if not defined
if ~isfield(MD.Stator.Winding, 'CircName')
  MD.Stator.Winding.CircName = 'Islot';
end

% set angle of the first slot
if ~isfield(MD.Stator.Geometry, 'FirstSlotAngle')
  MD.Stator.Geometry.FirstSlotAngle = 0;
end

% set material of the slot opening
if ~isfield(MD.Stator.Material, 'SlotOpening')
  add_materials2model(mtrl_Air);
  MD.Stator.Material.SlotOpening = mtrl_Air;
end

% set undefined mesh sizes
if ~isfield(MD.Stator, 'Mesh')
  MD.Stator.Mesh.Slot = MD.Stator.Geometry.SlotHeight/5;
  MD.Stator.Mesh.SlotOpening = MD.Stator.Geometry.SlotOpeningHeight/3;
else
  if ~isfield(MD.Stator.Mesh, 'Slot')
    MD.Stator.Mesh.Slot = MD.Stator.Geometry.SlotHeight/5;
  end
  if ~isfield(MD.Stator.Mesh, 'SlotOpening')
    MD.Stator.Mesh.SlotOpening = MD.Stator.Geometry.SlotOpeningHeight;
  end
end

%% compute the radius for slot and slot opening
SlotRadius = (MD.Stator.Geometry.InnerDiameter + MD.Stator.Geometry.SlotHeight)/2;
SlotOpeningRadius = (MD.Stator.Geometry.InnerDiameter + MD.Stator.Geometry.SlotOpeningHeight)/2;
alphas = 2*pi/MD.Stator.Geometry.Slots;


for ii = 1 : MD.Stator.Geometry.Slots/SymFactor
  
  % delete existing circuits to avoid duplicates
  mi_deletecircuit([MD.Stator.Winding.CircName,num2str(ii)]);
  mi_addcircprop([MD.Stator.Winding.CircName,num2str(ii)], 0, 0);
  
  % slot material
  x_slot = SlotRadius*cos(alphas * (ii-1) + MD.Stator.Geometry.FirstSlotAngle);
  y_slot = SlotRadius*sin(alphas * (ii-1) + MD.Stator.Geometry.FirstSlotAngle);
  draw_label(x_slot, y_slot, MD.Stator.Material.Slot.Name, MD.Stator.Mesh.Slot, 0, [MD.Stator.Winding.CircName,num2str(ii)], 0, MD.Stator.Group + ii, 0);
  
  % slot opening material
  x_slotopening = SlotOpeningRadius*cos(alphas * (ii-1) + MD.Stator.Geometry.FirstSlotAngle);
  y_slotopening = SlotOpeningRadius*sin(alphas * (ii-1) + MD.Stator.Geometry.FirstSlotAngle);
  draw_label(x_slotopening, y_slotopening, MD.Stator.Material.SlotOpening.Name, MD.Stator.Mesh.SlotOpening, 0, '', 0, MD.Stator.Group, 0);
  
end % for ii = 1 : MD.Stator.Geometry.Slots/SymFactor

end % function