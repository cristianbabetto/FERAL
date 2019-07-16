function draw_node(x, y, propname, group)
%DRAW_NODE draw a node with properties in femm
%   see 'mi_addnode' and 'mi_setnodeprop' in FEMM manual

mi_addnode(x, y);
mi_selectnode(x, y);
mi_setnodeprop(propname, group);
mi_clearselected();

end % function