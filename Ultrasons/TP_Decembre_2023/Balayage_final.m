
%
%  DefineTransducer
%  Generate the apertures for send and receive
%
%       transducer initial parameters
%       transducer impulse response g(t)
%       excitation signal e(t) to the emission aperture --> moved to PressureField
%
clear all

% transducer initial parameters
%-------------------------------
nus = 50e6;             %  Sampling frequency [Hz]
nu0 = 1e6;              %  Transducer center frequency [Hz] (ultrasound)
c = 1540;               %  Speed of sound [m/s]
lambda = c/nu0;         %  Wavelength [m]
Nelements = 128;          %  Number of physical elements (along x)
width=lambda/2;            %  Width of element
kerf=width/10;            %  Space free between the elements [m] (along x)
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
%% receive aperture
receive_aperture = xdc_linear_array (Nelements, width, height, kerf, 1, 1, focus);

%  transducer impulse response g(t)
%-----------------------------------
Bg = 10e6;          % transducer spectral bandwidth [Hz]
Tg = 2/nu0;         % signal g(t) duration [sec]
tg = (0:Ts:Tg);     % sampled time vector [sec]
if(~rem(length(tg),2)), tg = [tg tg(end)+Ts]; end % even Ng
Ng = length(tg);    % sampled time vector length [number of samples]
%g = sinc(Bg*(tg-Tg/2)).*hanning(Ng)';
g = sin(2*pi*nu0*tg).*hanning(Ng)';
%  Set the emission aperture transducer impulse response
xdc_impulse(emit_aperture, g);
xdc_impulse(receive_aperture, g);


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


% parametres permettant le balayages

Nlines = XXX  ;  % nombre de lignes RF dans l'image , il s'agit des colonnes de l'images par exemple 100
image_width = XXX /1000;  % largeur de l'image , par exemple 5 cm
dx = XXX;  % espacement entre deux lignes RF (deux colonnes de l'image)
xstart = XXX ; % position en X de la première ligne RF
zfoc = 30/1000;  % profondeur de focalisation
 


% Define the medium, dans ce premier exemple on a mis un seul diffuseur
% acoustique. Vous povez bien sûr reprendre les 5 diffuseurs de l'exemple
% précédent, ou encore en mettre ailleurs

scatter_position = [ 10 0 30]/1000;
scatter_amplitude =  [1];

%%% boucle perpettant de calculer toutes les lignes RF

for i = 1:Nlines
  
    xcurent = xstart+(i-1)*dx
    
    % la focalisation ligne par ligne se fait en deux étapes, positionner
    % la reference de calcul des retards , sur la sonde et à la bonne
    % position laterale, puis indiquer le point focal en pofondeur. Ceci
    % doit être fait pour la sonde en émission et en réception

    
    xdc_center_focus (emit_aperture,XXX);   % références en émission et en reception
    xdc_center_focus (receive_aperture,XXX);   
    

    xdc_focus (emit_aperture, 0, XXX);  % références en émission et en reception
    xdc_focus (receive_aperture, 0, XXX);
   
    
%%    a decommenter si tout le reste est réalisé, permet de rajoutyer une
%%   pondération, apodization sur les éléments
    
%    xdc_apodization (emit_aperture, 0,XXX);  
%    xdc_apodization (receive_aperture, 0, XXX);
     
% calcul des données brutes en reception, vous pouvez imaginer une variante
% avec la fonction calc_scat
    
    [rf_data, tstart] = calc_scat_multi(emit_aperture, receive_aperture, scatter_position, scatter_amplitude); % faire help calcul scat multi pour savoir ce que représente rf_data et tstart

    %%%%%%%%%%%
    % Sommation pour calculer une ligne RF beamformee, cad une colonne de
    % l'image finale
    %%%%%%%%%%%
    rfi = sum(XXXX)
    
    % l'étape suivante peut se faire de différentes manières, il faut
    % positionner dans la mattrice image le signal RF beamforme "au bon endroit". Il
    % faut simplement positionner avant le signal RF calcule, suffisament
    % de zeros correspondant au tstart
    
    rfi_avec_zeros = [zeros(XXX);rfi] ; % methode sugeree on cree un vecteur colonne compose de zeros puis du signal rfi
    image_RF_finale( xxx , i)  =  rfi_avec_zeros; % on affecte ce vecteur dans la bonne colonne de la matrice finale, attention aux problemes de taille
    
     
    
end

%%% ajouter ici le calcul de l'enveloppe et la visualisatiuon en echelle
%%% lineaire ou log

figure


