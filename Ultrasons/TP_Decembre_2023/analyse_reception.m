
clear all;

DefineTransducer
close all;


%%%%%%%%%%%%%%%%%%%
% Morceaux de code pour aider
% Attention à l'ordre d'utilisation
%%%%%%%%%%%%%%%%%%%

% Define a single scatter
scatter_position = [0 0 50]/1000; %;0 0 30]/1000;
scatter_amplitude = [1];%;1];


% Evaluate the pressure field along the receive aperture
% A completer
[rf_data, tstart] = calc_scat_multi(.....);

% A completer
imagesc(rf_data)


%%%%%%%
% Focalisation a la reception
%%%%%%%%%%%

focus_point = [10 0 30]/1000;
xdc_center_focus (receive_aperture,[focus_point(1) 0 0]); 
% % permet de spécifier le point central par rapport auquel est fait la focalisation = point de référence qui ne sera pas retardé
xdc_focus (receive_aperture, 0, focus_point);


%%%%%%%%%%%
% Sommation après la double focalisation
% Question II.c
%%%%%%%%%%%
x = sum(rf_data,2);