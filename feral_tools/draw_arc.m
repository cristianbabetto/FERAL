function draw_arc(x1, y1, x2, y2, xc, yc, maxseg, nodepropname, arcpropname, hide, group, addnode1, addnode2)
%DRAW_ARC draw an arc with properties in FEMM
%   see 'mi_addarc' and 'mi_setarcsegmentprop' in FEMM manual

%% Add arc nodes if required
if addnode1 == 1
  draw_node(x1, y1, nodepropname, group);
end
if addnode2 == 1
  draw_node(x2, y2, nodepropname, group);
end

%% Check radius compatibility
R1 = hypot((x1 - xc), (y1 - yc));
R2 = hypot((x2 - xc), (y2 - yc));
if round((R1/R2)*1e5)/1e5 ~= 1
  warning('Incompatible coordinates for an arc.');
else
  R = R1;
end

%% Compute node angles with respect to the arc center
ang1 = atan2d((y1 - yc), (x1 - xc));
ang2 = atan2d((y2 - yc), (x2 - xc));
arc_angle = ang2 - ang1;

%% Add arc
if ang1 == ang2
  warning('Null angle for an arc.')
elseif ang2 > ang1 || abs(arc_angle) == 180 % correct order
  mi_addarc(x1, y1, x2, y2, abs(arc_angle), maxseg);
  sgn_angle = 1;
elseif ang2 < ang1 % reverse order
  mi_addarc(x1, y1, x1, y1, -arc_angle, maxseg);
  sgn_angle = -1;
end

x_arc = (x1-xc)*cosd(sgn_angle*arc_angle/2) - (y1-yc)*sind(sgn_angle*arc_angle/2) + xc;
y_arc = (x1-xc)*sind(sgn_angle*arc_angle/2) + (y1-yc)*cosd(sgn_angle*arc_angle/2) + yc;

%% Set arc properties
mi_selectarcsegment(x_arc, y_arc);
mi_setarcsegmentprop(maxseg, arcpropname, hide, group);
mi_clearselected();


end % function