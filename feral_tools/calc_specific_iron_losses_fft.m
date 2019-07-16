function [phy, pec, ElFreq] = calc_specific_iron_losses_fft(Bx, By,  FreqBase, Khy, alpha, beta, Kec)
%CALC_SPECIFIC_IRON_LOSSES_FFT compute the specific iron losses for each
%mesh element with FFT method
%   Bx, By = component x and y of the flux density,
%   FreqBase = frequency base [Hz], it is the fundamental frequency of the
%   flux density waveform
%   Steinmetz equation = Khy * f^alpha * B^beta + Kec * (f*B)^2
%   Khy = hysteresis coefficient
%   alpha, beta = additional coefficients for frequency and flux density
%   Kec = eddy-currents coefficient

% flux density matrix scheme
% Bx(i,j) = x-component of flux density of j-th element at i-th rotor
% position

%                elm(1)   ...   elm(m)
%
%   thm(1)    |  Bx(1,1)       Bx(1,m)  |
%             |                         |
%   ...       |                         |
%             |                         |
%   thm(n)    |  Bx(n,1)       Bx(n,m)  |

NN = size(Bx,1);
Nelm = size(Bx,2);

bxfft = abs(fft(Bx))*(2/NN);
byfft = abs(fft(By))*(2/NN);
bfft = sqrt((bxfft.*bxfft) + (byfft.*byfft));

% fft flux density matrix scheme
% bfft(i,j) = i-th flux density harmonic of j-th element 
%
%                          elm(1)   ...   elm(m)
%
%   harm = 0          |  bfft(1,1)       bfft(1,m)  | --> mean value
%   harm = 1          |                             | --> fundamental
%   ...               |                             |
%                     |                             |
%   harm = (NN-1)/2   |  bfft(n,1)       bffy(n,m)  |


% generate the frequency array
ElFreq = 0:(NN-1); % [0 1 2 ... NN/2]
% remove harmonics higher than NN/2*FreqBase
ElFreq = FreqBase * ElFreq .* (ElFreq<(NN/2)); % [0 1*f 2*f ... (NN-1)/2*f 0 ... 0]

% compute hysteresis and eddy-current iron losses for each element and
% harmonic
phy = Khy * repmat(ElFreq',1,Nelm).^alpha .* bfft.^beta; % [W/kg]
pec = Kec * repmat(ElFreq',1,Nelm).^2 .* bfft.^2; % [W/kg]

% iron losses matrix scheme
% phy(i,j) = hysteresis losses of j-th element due to i-th harmonic 

%                       elm(1)   ...   elm(m)
%
%   harm = 0        |  phy(1,1)       phy(1,m)  |
%                   |                           |
%   ...             |                           |
%                   |                           |
%   harm = (NN-1)/2 |  phy(n,1)       phy(n,m)  |  



end % function