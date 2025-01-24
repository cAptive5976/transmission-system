%% Programme d'emission d'un message avec FSK

%% Remise à zéro du contexte
clear;
clc;
close all;

%% Définition des paramètres
Df = 100e3;                                     % Déviation de fréquence en Hz (100 kHz)
D = 20e3;                                       % Débit binaire en bits par seconde (20 kbits/s)
Tb = 1 / D;                                     % Durée d'un bit (s)
Nech_symb=32;                                   % Nombre déchantillons par symbole
Te=Tb/Nech_symb;                                % Temps d'échantillonage
fe=Nech_symb*D;                                 % Fréquence d'échantillonage
fp = 2.414e9;                                   % Fréquence porteuse en Hz (2.4 GHz)

synchro = [1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0];    % Bits de synchro
preambule = [1 1 1 1 1 0 0 1 1 0 1 0 1];        % Préambule de la trame
Message = input('Entrez le message à transmettre:',"s");    % Message (string)

%% Conversion de la chaîne en binaire
Message_bin = dec2bin(cast(Message, 'uint8'), 8);   % Chaque caractère est codé sur 8 bits
Message_bin = reshape(Message_bin.', 1, []);        % Convertir en un vecteur binaire (ligne)
Message_bin = double(Message_bin) - 48;             % Transformer les caractères '0' et '1' en valeurs 0 et 1

Nbit_message = length(Message_bin);                 % Nombre de bits du message

%% Calcul du CRC
crc_gen = comm.CRCGenerator();                      % Exemple de polynôme CRC
Message_avec_crc = crc_gen(Message_bin.');          % CRC appliqué au message
CRC = Message_avec_crc(Nbit_message+1:end).';       % Extraction des bits CRC (fin)
Nbit_message_bin = double(dec2bin(Nbit_message, 16)) - 48; % Nombre de bits codé sur 16 bits (vecteur binaire)

%% Construction de la trame
Trame = [synchro, preambule, Nbit_message_bin, Message_bin, CRC];   % Construction de la trame binaire
Nb = length(Trame);                                                 % Nombre de bits, soit la longueur de la trame binaire
Nech=Nech_symb*Nb;                                                  % Nombre d'échantillons
t = (0:Nech-1)*Te;                                                  % Temps (1 ms avec un pas de 1 µs)
c1 = exp(1*j*2*pi*Df*t);                                            % Signal complexe c1
c2 = exp(-1*j*2*pi*Df*t);                                           % Signal complexe c2


%% Codage des données binaires en NRZ
signal_NRZ=[];             % Initialisation du signal codé en NRZ
symbole_1=ones(1,Nech_symb);
symbole_0=zeros(1,Nech_symb);

for n=1:Nb                 % Codage des différents bits
     if (Trame(n)==1)
        signal_NRZ=[signal_NRZ symbole_1];
     else
        signal_NRZ=[signal_NRZ symbole_0];
     end
end  


%% Tranmission a l'ADALM Pluto   
c = c1.*signal_NRZ + c2.*(1-signal_NRZ);
tx = sdrtx('Pluto', 'RadioID', 'usb:0', 'CenterFrequency', fp, 'BasebandSampleRate', fe, 'Gain', 0, 'ShowAdvancedProperties', true); 
release(tx); % réinitialisation de l’Adalm Pluto
transmitRepeat(tx, c.'); % émission du signal: s est transposé car la fonction émet des vecteur colonnes... 