%% Remise à zéro du contexte
clear ;
clc ;
close ;

% Définition des paramètres
Df = 100e3;                   % Déviation de fréquence en Hz (100 kHz)
Nb = 29;                     % Nombre de bits du message
m = [1 0 1 0 1 1 0 1 0 ones(1,20)];   % Message numérique à transmettre
D = 20e3;                   % Débit binaire en bits par seconde (20 kbits/s)
Tb = 1 / D;                 % Durée d'un bit (s)
fp = 2.414e9;                 % Fréquence porteuse en Hz (2.4 GHz)

Nech_symb=32;   %nombre déchantillons par symbole
Te=Tb/Nech_symb; % temps d'échantillonage
fe=Nech_symb*D; % freq d'échantillonage
Nech=Nech_symb*Nb;
t = (0:Nech-1)*Te;              % Temps (1 ms avec un pas de 1 µs)
c1 = exp(1*j*2*pi*Df*t);
c2 = exp(-1*j*2*pi*Df*t);


%% Codage des données binaires en NRZ
signal_NRZ=[];             %initialisation du signal codé en NRZ
symbole_1=ones(1,Nech_symb);
symbole_0=zeros(1,Nech_symb);

for n=1:Nb      %codage des différents bits
     if (m(n)==1)
        signal_NRZ=[signal_NRZ symbole_1];
     else
        signal_NRZ=[signal_NRZ symbole_0];
     end
    end  

c = c1.*signal_NRZ + c2.*(1-signal_NRZ);

tx = sdrtx('Pluto', 'RadioID', 'usb:0', 'CenterFrequency', fp, 'BasebandSampleRate', fe, 'Gain', 0, 'ShowAdvancedProperties', true); 
release(tx); % réinitialisation de l’Adalm Pluto
transmitRepeat(tx, c.'); % émission du signal: s est transposé car la fonction émet des vecteur colonnes... 
% Création de la figure avec 3 subplots
figure;
I=real(c);
Q=imag(c);

subplot(3,1,1);
plot(t, signal_NRZ);
title('Signal NRZ');
xlabel('Temps (s)');
ylabel('Amplitude');
axis([0 25/D -1 2]); 
grid on;

subplot(3,1,2);
plot(t, I);
title('I modulé FSK');
xlabel('Temps (s)');
ylabel('Amplitude');
axis([0 25/D -1 1]); 
grid on;

subplot(3,1,3);
plot(t, Q);
title('Q modulé FSK');
xlabel('Temps (s)');
ylabel('Amplitude');
axis([0 25/D -1 1]); 
grid on;
