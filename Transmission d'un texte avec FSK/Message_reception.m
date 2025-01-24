%% Programme de reception d'un message avec FSK

%% Remise à zéro du contexte
clear;
clc;
close all;

%% Initialisation des variables
fp = 2.414e9;                                   % Fréquence de la porteuse
f0 = 50e3;                                      % Fréquence de la sinusoïde à transmettre
Fech = 640e3;                                   % Fréquence d'échantillonnage
Tech = 1 / Fech;
Nech = 4768 * 10;                               % Nombre d'échantillons transmis
Nech_sym = 32;                                  % Nombre d'échantillons par symbole
Df = 100000;                                    % Déviation de fréquence
t = (0:Nech-1) * Tech;                          % Temps d'échantillonnage
c = exp(1j * 2 * pi * f0 * t);                  % Signal sinusoïdal

%% Configuration de l'ADALM PLUTO récepteur
rx = sdrrx('Pluto', 'RadioID', 'usb:0', 'CenterFrequency', fp, ...
           'BasebandSampleRate', Fech, 'SamplesPerFrame', Nech, ...
           'OutputDataType', 'double', 'ShowAdvancedProperties', true);

%% Réception des échantillons
reception = rx().';                             % Transposée pour obtenir un vecteur colonne
re_demod = fskdemod(reception, 2, Df, Nech_sym, Fech); % Démodulation FSK

%% Détection du préambule
prb = [1 1 1 1 1 0 0 1 1 0 1 0 1]';             % Préambule attendu
prbdet = comm.PreambleDetector(prb, 'Input', 'Bit');
idx = prbdet(re_demod');
re_demod_synced = re_demod((idx(1) + 1): idx(2) - 29);

%% Extraction des champs de la trame
% Indices des champs
Nbit_message = re_demod_synced(1:16);
Nbit_message_received = bi2de(Nbit_message, 'left-msb'); % Taille du message (variable)
idx_message_start = 17;

idx_message_end = idx_message_start + Nbit_message_received - 1; % Fin du message

Message_received_bin = re_demod_synced(idx_message_start:idx_message_end); % Message
CRC_received = re_demod_synced(idx_message_end + 1:end); % CRC

%% Reconversion du message en chaîne de caractères
Message_received = char(bin2dec(reshape(char(Message_received_bin + '0'), 8, []).'));

%% Affichage du message (on inverse la matrice pour l'affichage horizontal)
disp('Message reçu :');
disp(Message_received');

%% Validation du CRC
crc_checker = comm.CRCDetector();
[~, err] = crc_checker([Message_received_bin, CRC_received].');

if err > 0
    disp('Erreur : CRC invalide !');
else
    disp('CRC valide.');
end


% Enregistrement des data
save Message.mat;

%% Affichage du chronogramme du signal
figure;
subplot(2,1,1);
stairs(re_demod_synced(1:50), "b"); % Affichage d'une partie de la trame synchronisée
title('Représentation du chronogramme du signal');
xlabel('t (ms)');
ylabel('Amplitude');
legend('signal(t)');
grid on;
