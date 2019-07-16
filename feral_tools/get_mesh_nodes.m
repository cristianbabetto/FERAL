function [xmsh, ymsh, NumNodes] = get_mesh_nodes(FilePath)

% set default path if not defined
if nargin < 1
  FilePath = '.';
end

% create Lua function if does not exist
if ~exist([FilePath, '/get_mesh_nodes.lua'], 'file')
  fid = fopen([FilePath, '/get_mesh_nodes.lua'], 'wt');
  fprintf(fid, 'function get_mesh_nodes(myFile) \n');
  fprintf(fid, '\t numnode = mo_numnodes(); \n');
  fprintf(fid, '\t handle=openfile(myFile,"w"); \n');
  fprintf(fid, '\t for k=1,numnode do \n');
  fprintf(fid, '\t\t xx, yy = mo_getnode(k); \n');
  fprintf(fid, '\t\t -- Write (x,y) to disk \n');
  fprintf(fid, '\t\t write(handle, xx, "\\t", yy, "\\n"); \n');
  fprintf(fid, '\t end \n');
  fprintf(fid, '\t closefile(handle); \n');
  fprintf(fid, 'end \n');
  fclose(fid);
end

% load function Lua
callfemm(['dofile("', FilePath, '/get_mesh_nodes.lua")']);

% use function Lua
callfemm(['get_mesh_nodes(''', FilePath,'/MeshNodes.txt'')']);

% load the coordinates from the generated file
MeshNodes = load([FilePath,'/MeshNodes.txt']);

% coordinates (x,y) of mesh nodes
xmsh = MeshNodes(:,1);
ymsh = MeshNodes(:,2);

% number of mesh nodes
NumNodes = length(xmsh);

end