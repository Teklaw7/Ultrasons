
clear all;

DefineTransducer2
close all;


%%%%%%%%%%%%%%%%%%%
% Morceaux de code pour aider
% Attention � l'ordre d'utilisation
%%%%%%%%%%%%%%%%%%%
focus_point = [0 0 50]/1000;
xdc_center_focus (emit_aperture,[focus_point(1) 0 0]); 
% % permet de sp�cifier le point central par rapport auquel est fait la focalisation = point de r�f�rence qui ne sera pas retard�
xdc_focus (emit_aperture, 0, focus_point);
%%%%%%%
% Focalisation a la reception
%%%%%%%%%%%

focus_point = [0 0 50]/1000;
xdc_center_focus (receive_aperture,[focus_point(1) 0 0]); 
% % permet de sp�cifier le point central par rapport auquel est fait la focalisation = point de r�f�rence qui ne sera pas retard�
xdc_focus (receive_aperture, 0, focus_point);


% Define a single scatter
scatter_position = [0 0 50]/1000;%;10 0 50]/1000; %;0 0 30]/1000;
scatter_amplitude = [1];%;1];
% scatter_position2 = [0 0 30]/1000; %;0 0 30]/1000;
% scatter_amplitude2 = [1];%;1];
Npoints = 5;
% Number of scatters
dz = 10/1000;
% Distance between scatters [m]
zstart = 50/1000; % Starting point [m]
position = [zeros(1,Npoints);zeros(1,Npoints);(0:Npoints-1)*dz+zstart]';
amplitude = ones(Npoints,1);


% Evaluate the pressure field along the receive aperture
% A completer
[rf_data, tstart] = calc_scat_multi(emit_aperture, receive_aperture, scatter_position, scatter_amplitude);
[rf_data2, tstart2] = calc_scat_multi(emit_aperture, receive_aperture, position, amplitude);
%[rf_data2, tstart2] = calc_scat_multi(emit_aperture, receive_aperture, scatter_position2, scatter_amplitude2);
% A completer
imagesc(rf_data2)


%%%%%%%%%%%
% Sommation apr�s la double focalisation
% Question II.c
%%%%%%%%%%%
x = sum(rf_data,2);