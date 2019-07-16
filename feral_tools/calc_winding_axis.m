function [winding_axis_angle_vec] = calc_winding_axis(PolePairs, SlotMatrix, FirstSlotAngle)
%CALC_WINDING_AXIS compute the angular position of winding axis 
%   FirstSlotAngle is the angle of the first slot axis

% Get number of slots
Slots = size(SlotMatrix, 1);

% Set default FirstSlotAngle if not defined
if nargin < 3
  FirstSlotAngle = 360/Slots/2;
end

% slot angle 
alphas = 2*pi/Slots;
% slot angular positions
alphas_vec = (FirstSlotAngle*pi/180 +  alphas*(0:Slots-1))';
% phasor of each slot
phasor = exp(1i*alphas_vec*PolePairs);
% phasor of phase a
phaseA = sum(phasor .* SlotMatrix);
% angular positions of the a-axes (PolePairs axes)
winding_axis_angle_vec = ((angle(phaseA)/PolePairs + pi/2/PolePairs) + (0:PolePairs-1)*pi/PolePairs)*180/pi;
% normalize the angle between 0 and 2*pi, and get the closest to x-axis
[~, idx_min] = min(abs(angle(exp(1i*winding_axis_angle_vec)))); 
