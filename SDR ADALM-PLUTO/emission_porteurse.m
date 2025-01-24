%% Programme d'émission de porteuse sur l'ADALM Pluto

%% Remise à zéro du contexte
clear;
clc;
close all;

%% Initialisation des variables
fp = 2.414e9;               % Fréquence de la porteuse : à modifier selon votre numéro de canal  
f0 = 50e3;                  % Fréquence de la sinusoïde à transmettre  
Fech = 1e6;                 % Fréquence d'échantillonnage du signal c(t) transmis à l'Adalm Pluto  
Tech = 1/Fech;              % Période d'échantillonnage  
Nech = 10000;               % Nombre d'échantillons transmis  
t = (0:Nech-1)*Tech;        % Création de la base de temps échantillonnée  
c = exp(1j*2*pi*f0*t);      % Pour transmettre un sinus de fréquence f0  

%% Configuration de l'ADALM PLUTO émetteur 

tx = sdrtx('Pluto', 'RadioID', 'usb:0', 'CenterFrequency', fp, 'BasebandSampleRate', Fech, 'Gain', 0, 'ShowAdvancedProperties', true); 
release(tx); % réinitialisation de l’Adalm Pluto

transmitRepeat(tx, c.'); % émission du signal: s est transposé car la fonction émet des vecteur colonnes... 

%% Affichage du chronogramme du signal
subplot(2,1,1)
plot(t*1000,c,"b"); %t en ms
title('représentation du chronogramme du signal')
xlabel('t(ms)')
ylabel('Watt')
legend('signal(t)')
axis([0 0.5 -1 1])  
grid on

%% Calcul puis affichage du spectre su signal
[X f]=spectre(c,Fech,Nech);
subplot(2,1,2);
plot(f,X,"b");
title('Spectre en puissance du signal')
xlabel('f(Hz)')
ylabel('dBm')
legend('|signal(f)|')
axis([0 100e3 -20 20])  
grid on
