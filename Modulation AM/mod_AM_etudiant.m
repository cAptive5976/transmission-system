%% Programme de modulation AM

%% Remise à zéro du contexte
clear;
clc;
close all;

%% Initialisation des variables
fp=10000;       % Fréquence porteuse (Hz)
Ep=5;           % Amplitude de la porteuse
fm=500;         % Fréquence du modulant sinusoïdal
Tm=1/fm;        % Période du modulant sinusoïdal
m=0.5;          % Indice de modulation
fe=100000;      % Fréquence échantillonnage
Te=1/fe;        % Période d'échantillonnage   
Ne=2000;        % Nombre de points de simulation
t=(0:Ne-1)*Te;  % Vecteur temps

%% Création des différents signaux: modulant, porteuse et signal AM

mt=1*cos(2*pi*fm*t);    % Signal modulant m(t)
pt=Ep*cos(2*pi*fp*t);   % Signal porteur p(t)

st=(1+m*mt).* pt;       % Signal modulé en amplitude s(t)


%% Affichage des chronogrammes
subplot(3,1,1)
plot(t*1000,pt,"r")
title("Signal porteur")
xlabel('t(ms)')
ylabel('Volt')
axis([0 4 -10 10])

subplot(3,1,2)
plot(t*1000,5*m*mt+5,"b")
hold on
plot(t*1000,st,"g")
title("Signal modulé avec son modulant")
xlabel('t(ms)')
ylabel('Volt')
axis([0 4 -10 10])

%% Calcul puis affichage des spectres 

N = length(t);
S = fft(st);        % FFT permet de générer une transformé de fourier, que l'on utilise pour représenté les raies du spectre
f = (0:N-1)*(fe/N); % fe est la fréquence d'échantillonnage

subplot(3,1,3)
plot(f, abs(S)/N)
xlabel('Fréquence (Hz)')
ylabel('Amplitude')
title('Spectre du signal modulé')