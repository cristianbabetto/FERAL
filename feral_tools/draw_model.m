close all
clear 
clc

%% Name of the file .fem and unit
openfemm(1)
newdocument(0)

MACHINE_DATA

add_materials2model(Stator,Rotor);

draw_stator(Stator);

draw_rotor(Rotor);

mi_zoomnatural;

mi_saveas([ModelData.ModelName,'.fem'])
