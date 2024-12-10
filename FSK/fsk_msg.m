m = [1 0 1 0 1 1 0 1 0];   % Message numérique à transmettre
Nb = 9;                     % Nombre de bits du message
D = 20e3;                   % Débit binaire en bits par seconde (20 kbits/s)
Tb = 1 / D;                 % Durée d'un bit (s)
fp = 2.4e9;                 % Fréquence porteuse en Hz (2.4 GHz)
Df = 100e3;                 % Déviation de fréquence en Hz (100 kHz)
