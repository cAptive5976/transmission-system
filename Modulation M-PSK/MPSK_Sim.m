%% Programme de simulation M-PSK

%% Remise à zéro du contexte
clear;
clc;
close all;

%% Définition des paramètres
Nb = 40320;            % Nombre de bits
D = 20e3;              % Débit binaire (20 kbits/s)
Tb = 1/D;              % Durée d'un bit
M = 4;                 % Ordre de la modulation (4-PSK)
Nb_sym = log2(M);      % Nombre de bits par symbole
Nech_symb = 32;        % Nombre d'échantillons par symbole
Nech = Nb*Nech_symb;   % Nombre d'échantillons
Te = Tb/Nech_symb;     % Période d'échantillonnage
fe = 1/Te;             % Fréquence d'échantillonnage
Ns = Nb / Nb_sym;      % Nombre de symboles
alpha = 0.4;           % Facteur de roll-off du filtre Nyquist

%% Génération d'un message binaire aléatoire
message_binaire = randi([0, 1], 1, Nb); % Création d'une trame binaire avec les 0 et 1 aléatoire sur Nb-bits
message_binaire = bi2de(reshape(message_binaire, Nb_sym, []).'); % Passage en groupes de 2 bits en decimales (0,1,2,3) et inversion de la matrice


%% Modulation M-PSK (ancienne méthode)
psk_mod = comm.PSKModulator(...
    'ModulationOrder', M, ...
    'PhaseOffset', 0);
message_psk = psk_mod.step(message_binaire); % On utilise l'objet PSKModulator du module comm puis la méthode step pour modulé le signal en PSK

%% Modulation M-PSK (nouvelle méthode)
message_psk = pskmod(message_binaire, M, 0); % On utilise la fonction pskmod de matlab (depuis R2023a) pour faire la modulation 


%% Filtrage avec un filtre de Nyquist en cosinus raidi
filtre_nyquist = comm.RaisedCosineTransmitFilter(...
    'RolloffFactor', alpha, ...
    'OutputSamplesPerSymbol', Nech_symb, ...
    'Gain', sqrt(Nech_symb));
signal_nyquist = filtre_nyquist(message_psk);
% On utilise l'objet RaisedCosineTransmitFilter qui prend en argument le coef de roll-off et le nombre d'échantillons par symboles 


%% Visualisation des chronogrammes I et Q
I = real(signal_nyquist(1:100*Nech_symb)); % Partie réel du signal (I)
Q = imag(signal_nyquist(1:100*Nech_symb)); % Partie imaginaire du signal (Q)

f1 = figure;
f1.Name = 'Chronogrammes';
subplot(2, 1, 1);
plot(I);
title('Chronogramme I');
xlabel('Temps (échantillons)');
ylabel('Amplitude');
grid on;

subplot(2, 1, 2);
plot(Q);
title('Chronogramme Q');
xlabel('Temps (échantillons)');
ylabel('Amplitude');
grid on;

%% Visualisation du spectre du signal modulé  sans filtre de Nyquist
f2 = figure;
f2.Name = 'Spectre';
[X f] = spectre(message_psk.',fe,Nech);
plot(f,X);
axis([0 4*D -120 20]);
xlabel('f(Hz)')
ylabel('dBV')
grid on
title('Spectre du signal M-PSK filtré');

%% Visualisation du spectre du signal modulé
f3 = figure;
f3.Name = 'Spectre Nyquist';
[X f] = spectre(signal_nyquist.',fe,Nech);
plot(f,X);
axis([0 4*D -120 20]);
xlabel('f(Hz)')
ylabel('dBV')
grid on
title('Spectre du signal M-PSK filtré');

%% Visualisation de la constellation
constellation = comm.ConstellationDiagram('SamplesPerSymbol', Nech_symb);
release(constellation);
constellation(signal_nyquist(1:Nech_symb:end));

%% Visualisation du diagramme de l'œil
eyediagram(signal_nyquist, 2*Nech_symb);

