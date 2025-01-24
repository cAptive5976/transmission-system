%% Programme d'émission de porteuse sur l'ADALM Pluto (version simple)

%% Remise à zéro du contexte
clear;
clc;
close all;

%% Initialisation des variables
fp = 2.414e9;               % Fréquence de la porteuse : à modifier selon votre numéro de canal  
Fech = 1e6;                 % Fréquence d'échantillonnage du signal c(t) transmis à l'Adalm Pluto  
Nech = 10000;               % Nombre d'échantillons à transmettre  

%% Calcul des symboles complexes c à transmsttre au modulateur IQ de l'Adalm Pluto 
c=complex(ones(1,Nech),zeros(1,Nech)); % pour transmettre la porteuse C=1+0.j  (I=1 et Q=0)
 
%% Configuration de l'ADALM PLUTO émetteur
tx = sdrtx('Pluto', 'RadioID', 'usb:0', 'CenterFrequency', fp,'BasebandSampleRate', Fech);
release(tx); % réinitialisation de l’Adalm Pluto 

%% Emission en continu des données
transmitRepeat(tx, c.'); % émission du signal: c.' est le transposé de c car la fonction émet des vecteurs colonnes...