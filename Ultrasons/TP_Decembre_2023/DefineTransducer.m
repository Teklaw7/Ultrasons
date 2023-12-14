
%
%  DefineTransducer
%  Generate the apertures for send and receive
%
%       transducer initial parameters
%       transducer impulse response g(t)
%       excitation signal e(t) to the emission aperture --> moved to PressureField
%

% transducer initial parameters
%-------------------------------
nus = 50e6;             %  Sampling frequency [Hz]
nu0 = 1e6;              %  Transducer center frequency [Hz] (ultrasound)
c = 1540;               %  Speed of sound [m/s]
lambda = c/nu0;         %  Wavelength [m]
Nelements = 32;          %  Number of physical elements (along x)
width=lambda;            %  Width of element
kerf=0.1/1000            %  Space free between the elements [m] (along x)
pitch=width +kerf        %  distance between the center of 2 successive elements [m] (along x)
%taille_sonde=(Nelements -1)*pitch % Size of the array along axis x
%position_elem=[-pitch/2*(Nelements-1) : pitch : pitch/2*(Nelements-1)]; %position of the elements
height = 4/1000;        %  Height of element [m] (along y)
focus = [0 0 30000]/1000;  %  possibility to set the emission and reception focal points [m] (here along x)

%  Set the sampling frequency and period
set_sampling(nus);
Ts = 1/nus;

%  Generate aperture for emission and reception = transducer
emit_aperture = xdc_linear_array (Nelements, width, height, kerf, 1, 1, focus);
%receive_aperture = xdc_linear_array (Nelements, width, height, kerf, 1, 1, focus);

%  transducer impulse response g(t)
%-----------------------------------
Bg = 10e6;          % transducer spectral bandwidth [Hz]
Tg = 2/nu0;         % signal g(t) duration [sec]
tg = (0:Ts:Tg);     % sampled time vector [sec]
if(~rem(length(tg),2)), tg = [tg tg(end)+Ts]; end % even Ng
Ng = length(tg);    % sampled time vector length [number of samples]
g = sinc(Bg*(tg-Tg/2)).*hanning(Ng)';
%g = sin(2*pi*nu0*tg).*hanning(Ng)';
%  Set the emission aperture transducer impulse response
xdc_impulse(emit_aperture, g);
%xdc_impulse(receive_aperture, g);


%  excitation signal e(t) to the emission aperture
%--------------------------------------------------
Te = 1/nu0;         % signal duration [sec]
te = (0:Ts:Te);     % sampled time vector [sec]
Ne = length(te);    % sampled time vector length [number of samples]
e = sin(2*pi*nu0*te).*hanning(Ne)';
% e = zeros(1,length(te));
% e(round(length(te)/2)) = 1;
%  Set the excitation to the emission aperture
xdc_excitation (emit_aperture, e);


if(1)
figure,

% equivalent input signal x(t)
x = conv(g,e);
Nx = length(x);             % sampled time vector length [number of samples]

Nfft = 2*Nx;
nu = [-Nfft/2:Nfft/2-1]/Nfft*nus; % sampled frequency vector [Hz]

tx = (0:Nx-1)*Ts;           % sampled time vector [sec]
subplot(233),
plot(tx,x);
xlabel('time t [sec]');
ylabel('amplitude');
title('input signal x(t)');
subplot(236),
plot(nu,fftshift(abs(fft(x,Nfft).^2)));
xlabel('frequency \nu [Hz]');
ylabel('modulus');
title('input spectrum |X(\nu)|^2');

% excitation signal e(t)
subplot(231),
plot(te,e);
xlabel('time t [sec]');
ylabel('amplitude');
title('excitation signal e(t)');
subplot(234),
plot(nu,fftshift(abs(fft(e,Nfft).^2)));
xlabel('frequency \nu [Hz]');
ylabel('modulus');
title('excitation spectrum |E(\nu)|^2');

% transducer impulse response g(t)
subplot(232),
plot(tg,g);
xlabel('time t [sec]');
ylabel('amplitude');
title('transducer impulse response g(t)');
subplot(235),
plot(nu,fftshift(abs(fft(g,Nfft))));
xlabel('frequency \nu [Hz]');
ylabel('modulus');
title('transducer frequency response |G(\nu)|');

end





