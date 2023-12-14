

%field_init;
%close all;
clear all;

DefineTransducer
%close 

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

%%
% Code pour question I-b-ii
%apo=hanning(Nelements)';
%xdc_apodization(emit_aperture,0,apo);

% %% Code pour question I-c
% % Methode 1
% focus_point = [10 0 30]/1000;
% % calculate the delays
% infos = xdc_get(emit_aperture,'rect');
% center_points = infos(8:10,:)';
% % A completer...
% xdc_times_focus(emit_aperture,0,delays);
% 
% % Methode 2
% focus_point = [10 0 30]/1000;
% xdc_center_focus (emit_aperture,[focus_point(1) 0 0]); 
% % permet de spécifier le point central par rapport auquel est fait la focalisation = point de référence qui ne sera pas retardé
% xdc_focus (emit_aperture, 0, focus_point);



%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Affichage des champs de pression generes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Evaluate the pressure field at some points along axe x %
% Definition des points 
Deltax = 100/1000;  % taille de la zone [m]
dx = 1/1000;       % pas d'échantillonnage spatial [m]
y0 = 0;
z0 = 30/1000;
x = -Deltax/2:dx:Deltax/2;
x = x(:);
y = y0*ones(length(x),1);
z = z0*ones(length(x),1);
points = [x,y,z];

%calcul du champ
[hp,start_time] = calc_hp(emit_aperture,points);

% Affichage
figure,
axe_t = start_time+Ts*[0:size(hp,1)-1];
imagesc(1000*axe_t,1000*x,hp'); axis xy;
xlabel('time t [msec]');
ylabel('lateral displacement x [mm]');
title(['Champ de pression le long de l axe x : p(x,y_0,z_0,t), y_0=',num2str(y0*1000),', z_0=',num2str(z0*1000)]);

% utile pour faire de la visu de signaux decales
% hp = hp./max(max(hp));
% hp = hp + ones(size(hp,1),1)*[1:size(hp,2)];
% figure, plot(axe_t,hp);
% axis tight;


% Evaluate the pressure field at some points along axe z %
% Definition des points 
x0 = 0;
y0 = 0;
Deltaz = 100/1000;  % taille de la zone [m]
dz = 10/1000;       % pas d'échantillonnage spatial [m]
z = dz:dz:Deltaz;
z = z(:);
x = x0*ones(length(z),1);
y = y0*ones(length(z),1);
points = [x,y,z];

%calcul du champ
[hp,start_time] = calc_hp(emit_aperture,points);

% Affichage
figure,
axe_t = start_time+Ts*[0:size(hp,1)-1];
imagesc(1000*axe_t*c,1000*z,hp'); axis xy;
xlabel('time t [msec]');
ylabel('axial displacement z [mm]');
title(['Champ de pression le long de l axe z  : p(x_0,y_0,z,t), x_0=',num2str(x0*1000),', y_0=',num2str(y0*1000)]);


% Evaluate the pressure field at a given point x0,y0,z0 %
% Definition du point 
x0=0;
y0 = 0;
z0 = 30/1000;
x=x0;
y = y0;
z = z0;
points = [x,y,z];

%calcul du champ
[hp,start_time] = calc_hp(emit_aperture,points);
axe_t = start_time+Ts*[0:size(hp,1)-1];

% Affichage
figure
plot(axe_t, hp);
xlabel('time t [msec]');
ylabel('amplitude du signal recu');
title(['Signal temporel en 1 point :  pressure field field p(x_0,y_0,z_0,t), x_0=',num2str(x0*1000),', y_0=',num2str(y0*1000) ', z_0=',num2str(z0*1000)]);


xdc_free (emit_aperture)


