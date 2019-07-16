function StringNumber = number2string(Number, DecimalSymbol, FormatNumber, CustomString)
%PRINT_NUMBER print a decimal number or an array as a string
%   the decimal point is replaced by 'DecimalSymbol'. The default is 'o'
%   For example 3.578 is printed as 3o578
%   an array 'x' is printed as follows: [x(1)_step_x(end)]
%   For example [1:2:10] is printed as [1-2-10]
%   The optional input 'DecimalSymbol' define how to replace the 
%   decimal point. It must be only 1 char

% Set default decimal symbol ('o') if not defined
if ~exist('DecimalSymbol', 'var') || strcmp(DecimalSymbol, '')
  DecimalSymbol = 'o';
end

% Set default format number ('%.5g') if not defined
if ~exist('FormatNumber', 'var') || strcmp(FormatNumber, '')
  FormatNumber = '%.5g'; % 5 significant digits
end

% Set default unit ('') if not defined
if ~exist('CustomString', 'var')
  CustomString = '';
end

if length(Number) > 1 % is an array
  
  % first element
  StringNumber1 = num2str(Number(1), FormatNumber);
  Idx = find(StringNumber1 =='.');
  if ~isempty(Idx)
    StringNumber1(Idx) = DecimalSymbol;
  end
  % last element
  StringNumber2 = num2str(Number(end), FormatNumber);
  Idx = find(StringNumber2 =='.');
  if ~isempty(Idx)
    StringNumber2(Idx) = DecimalSymbol;
  end
  % step
  StringNumber3 = num2str(Number(2)-Number(1), FormatNumber);
  Idx = find(StringNumber3 =='.');
  if ~isempty(Idx)
    StringNumber3(Idx) = DecimalSymbol;
  end
  
  StringNumber = ['[',StringNumber1,'-',StringNumber3,'-',StringNumber2,']'];

else % is a single number
  StringNumber = num2str(Number, FormatNumber);
  Idx = find(StringNumber == '.');
  if ~isempty(Idx)
    StringNumber(Idx) = DecimalSymbol; % replace the decimal point
  end
end

StringNumber = [StringNumber, CustomString]; % append other string

end % function