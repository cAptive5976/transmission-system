%% Programme de demodulation d'une reception FSK v2

%% Remise à zéro du contexte
clear;
clc;
close all;

%% Définition des paramètres
fp = 2.414e9;                           % Fréquence porteuse en Hz (2.4 GHz)
f0 = 50e3;                              % Fréquence de la sinusoïde à transmettre 
Fech = 1e6;                             % Fréquence d'échantillonnage du signal c(t) transmis à l'Adalm Pluto 
Tech=1/Fech;                            % Temps d'échantillonage
t=(0:Nech-1)*Tech;                      % Création de la base de temps échantillonnée 
c = exp(1j*2*pi*f0*t);                  % pour transmettre un sinus de fréquence f0 

Nech=928*2;                             % Nombre d'échantillons transmis   
Nech_sym=32                             % Nombre d'échantillons par symbole
Df = 100000                             % Débit de 100 kbit/s

%% configuration de l'ADALM PLUTO récepteur 
rx = sdrrx('Pluto', 'RadioID', 'usb:0', 'CenterFrequency', fp, 'BasebandSampleRate', Fech, 'SamplesPerFrame', Nech, 'OutputDataType', 'double', 'ShowAdvancedProperties', true); 

%% Réception des échantillons        

reception= rx().'; % réception d'une trame de Nech échantillons que l'on prend la transposée pour avoir un vecteur colonne 
re_demod = fskdemod(reception, 2, Df, Nech_sym,Fech); % Avec fskdemod on fait la demodulation

%% Affichage du chronogramme du signal
subplot(2,1,1);
stem(re_demod,"b"); 
title('représentation du chronogramme du signal');
xlabel('t(ms)');
ylabel('Amplitude');
legend('signal(t)');
grid on;
