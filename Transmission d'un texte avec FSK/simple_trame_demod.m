%% Programme de demodulation d'une trame FSK

%% Remise à zéro du contexte
clear;
clc;
close all;

%% initialisation des variables
fp = 2.414e9;                                   % Fréquence de la porteuse: à modifier selon votre numéro de canal 
f0 = 50e3;                                      % Fréquence de la sinusoïde à transmettre 
Fech = 640e3;                                   % Fréquence d'échantillonnage du signal c(t) transmis à l'Adalm Pluto 
Tech=1/Fech;                                    % Temps d'échantillonage
Nech=1216*2;                                    % Nombre d'échantillons transmis   
Nech_sym=32                                     % Nombre d'échantillons par symboles
Df = 100000                                     % Débit binaire de 100kbit/s
t=(0:Nech-1)*Tech;                              % Vecteur temps échantillonnée 
c = exp(1j*2*pi*f0*t);                          % signal avec un Sinus de fréquence f0 


%% configuration de l'ADALM PLUTO récepteur 
rx = sdrrx('Pluto', 'RadioID', 'usb:0', 'CenterFrequency', fp, 'BasebandSampleRate', Fech, 'SamplesPerFrame', Nech, 'OutputDataType', 'double', 'ShowAdvancedProperties', true); 

%% Réception des échantillons        
reception=rx().';   % on prend la transposée pour avoir un vecteur colonne... 
re_demod = fskdemod(reception, 2, Df, Nech_sym,Fech);
prb = [1 1 1 1 1 0 0 1 1 0 1 0 1]';
prbdet =  comm.PreambleDetector(prb,'Input', 'Bit', 'Threshold', 0.8);
idx = prbdet(re_demod');
re_demod_synced = re_demod((idx(1) - 12):end);
re_demod_m = re_demod_synced(14 : 22);


%% Affichage du chronogramme du signal
subplot(2,1,1);
stairs(re_demod_m,"b"); %t en ms
title('représentation du chronogramme du signal');
xlabel('t(ms)');
ylabel('Amplitude');
legend('signal(t)');
grid on;
