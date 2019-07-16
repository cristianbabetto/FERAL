function get_new_material(MaterialName)

fid = fopen(['mtrl_', MaterialName,'.m'], 'wt');
fprintf(fid, ['function material = mtrl_', MaterialName, '() \n\n']);
fprintf(fid, 'FunctionName = mfilename; %% get function name \n');
fprintf(fid, 'MaterialName = FunctionName(6:end); %% get material name \n');
fprintf(fid, '\n');
fprintf(fid, 'material.Name = MaterialName; \n');
fprintf(fid, 'material.MassDensity = 0; %% [kg/m3]\n');
fprintf(fid, 'material.AlphaCoeff = 0; %% [-] for lamination materials\n');
fprintf(fid, 'material.BetaCoeff = 0; %% [- ]for lamination materials\n');
fprintf(fid, 'material.Cost = 0; %% [price/kg] \n\n');
fprintf(fid, '%% See FEMM reference manual \n');
fprintf(fid, '%% material.RelativePermeability = [1 1]; \n');
fprintf(fid, '%% material.CoercitiveField = 0; \n');
fprintf(fid, '%% material.AppliedCurrentDensity = 0; \n');
fprintf(fid, '%% material.ElConductivity = 0; \n');
fprintf(fid, '%% material.LaminationThickness = 0; \n');
fprintf(fid, '%% material.HysteresisLagAngle = 0; \n');
fprintf(fid, '%% material.LaminationFill = 0; \n');
fprintf(fid, '%% material.LaminationType = 0; \n');
fprintf(fid, '%% material.BHpoints = [B1 H1; B2 H2; B3 H3; ...]; %% BH curve \n');
fprintf(fid, '\n');
fprintf(fid, '%% add here other properties ... \n');
fprintf(fid, '\n');
fprintf(fid, 'end %% function \n');
fclose(fid);

end % function