function  [Elements, Nodes, Barycenter, Area, Group, Az, Bx, By, Sigma, Energy, Hx, Hy]  = ...
            get_elements_values(FilePath)
       
% set default path if not defined
if nargin < 1
  FilePath = '.';
end

% create lua function if does not exist
if ~exist([FilePath, '/get_elements_values.lua'], 'file')
  fid = fopen([FilePath, '/get_elements_values.lua'], 'wt');
  fprintf(fid, 'function get_elements_values(myFile)\n');
  fprintf(fid, '\t numelm = mo_numelements();\n');
  fprintf(fid, '\t handle=openfile(myFile,"w");\n');
  fprintf(fid, '\t for k=1,numelm do\n');
  fprintf(fid, '\t\t pt1, pt2, pt3, xG, yG, area, group = mo_getelement(k);\n');
  fprintf(fid, '\t\t -- Evaluate properties at element centroid\n');
  fprintf(fid, '\t\t Az, Bx, By, Sigma, Energy, Hx, Hy = mo_getpointvalues(xG, yG);\n');
  fprintf(fid, '\t\t -- Write field to disk\n');
  fprintf(fid, '\t\t write(handle,pt1,"\\t",pt2,"\\t",pt3,"\\t",xG,"\\t",yG,"\\t",area,"\\t",group,"\\t",Az,"\\t",Bx,"\\t",By,"\\t",Sigma,"\\t",Energy,"\\t",Hx,"\\t",Hy,"\\n");\n');
  fprintf(fid, '\t end\n');
  fprintf(fid, '\t closefile(handle);\n');
  fprintf(fid, 'end\n');
  fclose(fid);
end

% load function Lua
callfemm(['dofile("',FilePath, '/get_elements_values.lua")']);

% use function Lua
callfemm(['get_elements_values(''', FilePath,'/ElementsValues.txt'')']);

ElementValues = load([FilePath,'/ElementsValues.txt']);

Nodes = ElementValues(:,1:3);
Barycenter = ElementValues(:,4:5);
Area = ElementValues(:,6);
Group = ElementValues(:,7);
Az = ElementValues(:,8);
Bx = ElementValues(:,9);
By = ElementValues(:,10);
Sigma = ElementValues(:,11);
Energy = ElementValues(:,12);
Hx = ElementValues(:,13);
Hy = ElementValues(:,14);

Elements.NumElements = size(Nodes,1);
Elements.Nodes = ElementValues(:,1:3);
Elements.Barycenter = ElementValues(:,4:5);
Elements.Area = ElementValues(:,6);
Elements.Group = ElementValues(:,7);
Elements.Az = ElementValues(:,8);
Elements.Bx = ElementValues(:,9);
Elements.By = ElementValues(:,10);
Elements.Sigma = ElementValues(:,11);
Elements.Energy = ElementValues(:,12);
Elements.Hx = ElementValues(:,13);
Elements.Hy = ElementValues(:,14);


end % function