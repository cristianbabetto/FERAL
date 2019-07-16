function draw_segment(x1, y1, x2, y2, nodepropname, segpropname, elementsize, automesh, hide, group, addnode1, addnode2)
%%DRAW_SEGMENT draw a segment with properties in FEMM
%   see 'mi_addsegment' and 'mi_setsegmentprop' in FEMM manual

%% Add segment nodes if required
if addnode1 == 1
  draw_node(x1, y1, nodepropname, group);
end
if addnode2 == 1
  draw_node(x2, y2, nodepropname, group);
end

%% Add segment with properties
mi_addsegment(x1, y1, x2, y2);
mi_selectsegment((x1 + x2)/2, (y1 + y2)/2);
mi_setsegmentprop(segpropname, elementsize, automesh, hide, group);
mi_clearselected();

end