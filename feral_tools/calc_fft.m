function [ch, phih, h] = calc_fft(y, RemoveLast)
%CALC_FFT compute the fft transform of the array y
%   RemoveLast = 1 (optional, default is 0) to remove the last element 
%   of the array y  
%   ch = peak value of h-harmonic, ch(1) is the average value
%   phih = phase of the h-harmonic
%   h = harmonic order
%   y = sum [ch*cos(h*w*t + phih)]

% Set default 'RemoveLast' value if not defined
if nargin < 2
    RemoveLast = 0;
end

% Remove the last element
if RemoveLast 
    y = y(1:end-1); % remove the last element because y(1) = y(end)
end

% Compute fft
N = length(y);
Y = fft(y)/N; % compute the fast fourier transform of y
Y = Y(1:ceil(end/2)); % use only the first half of array Y
h = 0:length(Y)-1; % harmonic order

ch    = 2*abs(Y); % amplitude of harmonic components of y
ch(1) = ch(1)/2; % average value of y
phih  = angle(Y); % phase of harmonic components of y

end