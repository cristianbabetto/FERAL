function [  ] = draw_gap_lines( MD, AirgapMeshSize, SlidingBandMinArcDeg)

% Define some variables
s = MD.Stator;
s.geo = MD.Stator.Geometry;
r = MD.Rotor;
r.geo = MD.Rotor.Geometry;
Airgap = MD.Airgap;
SymFactor = 2*MD.PolePairs/MD.SimPoles;
PeriodAngle = 2*pi/SymFactor;
PolePitchAngle = pi/MD.PolePairs;
RotorRadius = r.geo.OuterDiameter/2;
RotorHandle = RotorRadius + Airgap/3;
StatorRadius = s.geo.InnerDiameter/2;
StatorHandle = StatorRadius - Airgap/3;

if nargin < 2
  AirgapMeshSize = gap/3/2;
end

if nargin < 3
  SlidingBandMinArcDeg = 1;
end



%% Scheme
% x                                  x
% |                                  |
% |              STATOR              |
% S3---------------------------------S2 <-- stator radius
% |         label stator gap         |
% S4---------------------------------S1 <-- stator handle
%
%                  GAP
%
% R3--------------------------------R2 <-- rotor handle
% |          label rotor gap         |
% R4--------------------------------R1 <-- rotor radius
% |               ROTOR              |
% |                                  |
% x                                  x
%          <-----PeriodAngle---------0

%% Add boundary conditions (BCs)

% set BC names
if SymFactor == 1 || mod(MD.SimPoles, 2) == 0
  SB_BdryFormat = 6;
  LabelGapBC = {'Periodic_1', 'Periodic_2'};
else
  SB_BdryFormat = 7;
  LabelGapBC = {'AntiPeriodic_1', 'AntiPeriodic_2'};
end

% Sliding band properties
mi_addboundprop('GapSlidingBand', 0, 0, 0, 0, 0, 0, 0, 0, SB_BdryFormat, 0, 0);

% define stator coordinates
xS1 = StatorHandle;
yS1 = 0;

xS2 = StatorRadius;
yS2 = 0;

xS3 = StatorRadius * cos(PeriodAngle);
yS3 = StatorRadius * sin(PeriodAngle);

xS4 = StatorHandle * cos(PeriodAngle);
yS4 = StatorHandle * sin(PeriodAngle);

% define rotor coordinates
xR1 = RotorRadius;
yR1 = 0;

xR2 = RotorHandle;
yR2 = 0;

xR3 = RotorHandle * cos(PeriodAngle);
yR3 = RotorHandle * sin(PeriodAngle);

xR4 = RotorRadius * cos(PeriodAngle);
yR4 = RotorRadius * sin(PeriodAngle);

if SymFactor ~= 1 % if periodic BC are used
  
  % periodic/antiperiodic
  mi_deleteboundprop(LabelGapBC{1});
  mi_addboundprop(LabelGapBC{1}, 0, 0, 0, 0, 0, 0, 0, 0, SB_BdryFormat, 0, 0);
  mi_deleteboundprop(LabelGapBC{2});
  mi_addboundprop(LabelGapBC{2}, 0, 0, 0, 0, 0, 0, 0, 0, SB_BdryFormat, 0, 0);
  
  % add nodes to model
%   mi_addnode(xS1, yS1); mi_addnode(xS4, yS4);
%   mi_selectnode([xS1, xS4], [yS1, yS4]);
%   mi_setnodeprop('', s.Group);
  
  % draw stator handles
%   mi_addsegment(xS1, yS1, xS2, yS2);
%   mi_addsegment(xS3, yS3, xS4, yS4);
%   
%   mi_selectsegment((xS1 + xS2)/2, (yS1 + yS2)/2);
%   mi_setsegmentprop(LabelGapBC{1}, 0, 1, 1, s.Group);
%   mi_clearselected();
%   
%   mi_selectsegment((xS3 + xS4)/2, (yS3 + yS4)/2);
%   mi_setsegmentprop(LabelGapBC{1}, 0, 1, 1, s.Group);
%   mi_clearselected();
  
  draw_segment(xS1, yS1, xS2, yS2, '', LabelGapBC{1}, 0, 1, 1, s.Group, 1, 0);
  draw_segment(xS3, yS3, xS4, yS4, '', LabelGapBC{1}, 0, 1, 1, s.Group, 0, 1);
  
 
  % draw stator arc
  draw_arc(xS1, yS1, xS4, yS4, 0, 0, SlidingBandMinArcDeg, '', 'GapSlidingBand', 1, s.Group, 0, 0);
%   x_arc = xS1 * cos(PeriodAngle/2) - yS4 * sin(PeriodAngle/2);
%   y_arc = xS1 * cos(PeriodAngle/2) + yS4 * sin(PeriodAngle/2);
%   mi_selectarcsegment(x_arc, y_arc);
%   mi_setarcsegmentprop(SlidingBandMinArcDeg, 'GapSlidingBand', 1, s.Group);
  
  % add nodes to model
%   mi_addnode(xS2, yS2); mi_addnode(xS3, yS3);
%   mi_selectnode([xS2, xS3], [yS2, yS3]);
%   mi_setnodeprop('', r.Group);
%   
%   % draw rotor handles
%   mi_addsegment(xR1, yR1, xR2, yR2);
%   mi_addsegment(xR3, yR3, xR4, yR4);
  
  draw_segment(xR1, yR1, xR2, yR2, '', LabelGapBC{2}, 0, 1, 1, r.Group, 0, 1);
  draw_segment(xR3, yR3, xR4, yR4, '', LabelGapBC{2}, 0, 1, 1, r.Group, 1, 0);
  
%   mi_selectsegment((xR1 + xR2)/2, (yR1 + yR2)/2);
%   mi_setsegmentprop(LabelGapBC{2}, 0, 1, 1, r.Group);
%   mi_clearselected();
%   
%   mi_selectsegment((xR3 + xR4)/2, (yR3 + yR4)/2);
%   mi_setsegmentprop(LabelGapBC{2}, 0, 1, 1, r.Group);
%   mi_clearselected();
  
  % draw rotor arc
  draw_arc(xR2, yR2, xR3, yR3, 0, 0, SlidingBandMinArcDeg, '', 'GapSlidingBand', 1, s.Group, 0, 0);
  
%   mi_addarc(xS1, yS1, xS2, yS2, PeriodAngle, SlidingBandMinArcDeg);
%   x_arc = xS1 * cos(PeriodAngle/2) - yS1 * sin(PeriodAngle/2);
%   y_arc = xS1 * cos(PeriodAngle/2) + yS1 * sin(PeriodAngle/2);
%   mi_selectarcsegment(x_arc, y_arc);
%   mi_setarcsegmentprop(sSlidingBandMinArcDeg, 'GapSlidingBand', 1, s.Group);
  
  
else % full model
  
  % add nodes to model
  mi_addnode(xS1, yS1); mi_addnode(-xS1, yS1);
  mi_selectnode([xS1, -xS1], [yS1, -yS1]);
  mi_setnodeprop('', s.Group);
  
  % stator arc
  mi_addarc(xS1, yS1, -xS1, yS1, 180, SlidingBandMinArcDeg);
  mi_addarc(-xS1, yS1, +xS1, yS1, 180, SlidingBandMinArcDeg);
  mi_selectarcsegment(yS1, xS1);
  mi_selectarcsegment(yS1, -xS1);
  mi_setarcsegmentprop(SlidingBandMinArcDeg, 'GapSlidingBand', 1, s.Group);
  
  % add nodes to model
  mi_addnode(xR2, yR2); mi_addnode(-xR2, yR2);
  mi_selectnode([xR2, -xR2], [yR2, -yR2]);
  mi_setnodeprop('', s.Group);
  
  % rotor arc
  mi_addarc(xR2, yR2, -xR2, yR2, 180, SlidingBandMinArcDeg);
  mi_addarc(-xR2, yR2, xR2, yR2, 180, SlidingBandMinArcDeg);
  mi_selectarcsegment(yR2, xR2);
  mi_selectarcsegment(yR2, -xR2);
  mi_setarcsegmentprop(SlidingBandMinArcDeg, 'GapSlidingBand', 1, r.Group);
  mi_clearselected();
  
  % set no mesh in the middle airgap
  MiddleAirgap = StatorRadius - Airgap/2;
  xlb = MiddleAirgap * cos(PolePitchAngle/2);
  ylb = MiddleAirgap * sin(PolePitchAngle/2);
  mi_addblocklabel(xlb, ylb);
  mi_selectlabel(xlb, ylb);
  mi_setblockprop('<No Mesh>', 0, 0, 0, 0, 0, 0);
  mi_clearselected();
  
end

%% add band materials
% stator gap label
StatorGapRadiusLabel = StatorRadius - Airgap/6;
xlb = StatorGapRadiusLabel * cos(PolePitchAngle/2);
ylb = StatorGapRadiusLabel * sin(PolePitchAngle/2);
draw_label(xlb, ylb, 'Air', AirgapMeshSize, 0, '', 0, 0, 0);
% mi_addblocklabel(xlb, ylb);
% mi_selectlabel(xlb, ylb);
% mi_setblockprop('Air', 0, AirgapMeshSize, 0, 0, 0, 0);

% rotor gap label
RotorGapRadiusLabel = RotorRadius + Airgap/6;
xlb = RotorGapRadiusLabel * cos(PolePitchAngle/2);
ylb = RotorGapRadiusLabel * sin(PolePitchAngle/2);
draw_label(xlb, ylb, 'Air', AirgapMeshSize, 0, '', 0, 0, 0);

% mi_addblocklabel(xlb, ylb);
% mi_selectlabel(xlb, ylb);
% mi_setblockprop('Air', 0, AirgapMeshSize, 0, 0, 0, 0);


end % function