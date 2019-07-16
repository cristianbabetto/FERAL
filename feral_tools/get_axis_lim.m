function vlim = get_axis_lim(v, delta)
%GET_AXIS_LIM computes the lower and upper limits with a given  margin

if nargin < 2
  delta = 0.2;
end

if length(delta) == 1
  delta_min = delta;
  delta_max = delta;
end

vmin = min(v);
vmax = max(v);

vlim_min = vmin - abs(vmin)*delta_min;
vlim_max = vmax + abs(vmax)*delta_max;

vlim = [vlim_min vlim_max];

end % function