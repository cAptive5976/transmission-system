%% Programme de demodulation d'une reception FSK v1

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

Nech=10000;                             % Nombre d'échantillons transmis

%% configuration de l'ADALM PLUTO récepteur 
rx = sdrrx('Pluto', 'RadioID', 'usb:0', 'CenterFrequency', fp, 'BasebandSampleRate', Fech, 'SamplesPerFrame', Nech, 'OutputDataType', 'double', 'ShowAdvancedProperties', true); 

%% Réception des échantillons        

reception= rx().'; % réception d'une trame de Nech échantillons que l'on prend la transposée pour avoir un vecteur colonne 
save reception; % On enregistre sous forme d'un fichier mat pour pouvoir le conservé au cas ou

%% Affichage du chronogramme du signal
subplot(2,1,1)
plot(t*1000,reception,"b"); %t en ms
title('représentation du chronogramme du signal')
xlabel('t(ms)')
ylabel('Watt')
legend('signal(t)')
axis([0 0.5 -1 1])  
grid on

%% Calcul puis affichage du spectre su signal
[X f]=spectre(reception,Fech,Nech);
subplot(2,1,2);
plot(f,X,"b");
title('Spectre en puissance du signal')
xlabel('f(Hz)')
ylabel('dBm')
legend('|signal(f)|')
axis([0 100e3 -100 0])  
grid on
