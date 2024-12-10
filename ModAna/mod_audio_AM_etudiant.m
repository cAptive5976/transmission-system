clear;
clc;
close;
%% Initialisation des variables
fp = 10000; % fréquence porteuse (Hz)
Ep = 5;     % amplitude de la porteuse
fe = 100000; % fréquence d'échantillonnage

[audioData, audioFs] = audioread('musique.mp4'); % Lecture du fichier audio

m = 1;   % indice de modulation
Te = 1 / fe; % période d'échantillonnage   
Ne = 2000;  % nombre de points de simulation

t = (0:Ne-1) * Te;

%% Création des différents signaux : modulant, porteuse et signal AM

% Extraction du signal modulant
modulant = audioData(1:Ne, 1); 

% Normalisation du signal modulant
% Centrer sur 0 et ajuster à une amplitude crête-crête de 2V
modulant_mean = mean(modulant); % Moyenne du signal
modulant_min = min(modulant);  % Valeur minimale
modulant_max = max(modulant);  % Valeur maximale
modulant_norm = ((modulant - modulant_mean) / (modulant_max - modulant_min) * 2)'; 

% Ajuster l'amplitude crête-crête à 2V et centrer sur 0V
modulant_norm = modulant_norm * Ep / 2; 

% Signal porteur
pt = Ep * cos(2 * pi * fp * t); % Signal porteur p(t)

% Signal modulé
st = (1 + m * modulant_norm) .* pt; % Signal modulé s(t)

%% Affichage des chronogrammes
figure;
subplot(3,1,1)
plot(t * 1000, pt, "r")
title("Signal porteur")
xlabel('t (ms)')
ylabel('Volt')
axis([0 4 -10 10])
grid on

subplot(3,1,2)
plot(t * 1000, 5*m*modulant_norm+5, "b")
hold on
plot(t * 1000, st, "g")
title("Signal modulé (vert) avec son modulant normalisé (bleu)")
xlabel('t (ms)')
ylabel('Volt')
grid on

%% Calcul puis affichage des spectres
N = length(t);
S = fft(st); 
f = (0:N-1) * (fe / N); 

subplot(3,1,3)
plot(f, abs(S) / N)
xlabel('Fréquence (Hz)')
ylabel('Amplitude')
title('Spectre du signal modulé')
grid on
