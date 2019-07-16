function draw_label(x1, y1, blockname, meshsize, automesh, circuit, magdirection, group, turns)
%DRAW_LABEL add a label in FEMM
%   see 'mi_addblocklabel' and 'mi_setblockprop' in FEMM manual

mi_addblocklabel(x1,y1);
mi_selectlabel(x1,y1);
mi_setblockprop(blockname, automesh, meshsize, circuit, magdirection, group, turns);
mi_clearselected();

end