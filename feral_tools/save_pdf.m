function save_pdf(Filename, PrintPDF, FigureWidth, FigureHeight)
%SAVE_PDF saves a pdf of the current figure
%   Filename = name of the final pdf file (it can contain the file path)
%   PrintPDF = 1 enable pdf print
%   FigSize = [width, height]

%% Set figure size
if nargin < 3
  FigureWidth = 12;
  FigureHeight = 10;
end

set(gcf, 'PaperPosition', [0 0 FigureWidth FigureHeight]); %Position plot at left hand corner with width and height
set(gcf, 'PaperSize', [FigureWidth FigureHeight]); %Set the paper to have width 11.5 and height 9.

%% print PDF 
if PrintPDF
  saveas(gcf, Filename, 'pdf');
end

end % function