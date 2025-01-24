%% Programme de representaion du modulateur IQ

%% Remise à zéro du contexte
clear;
clc;
close all;

%% Définition des paramètres
t = 0:1e-6:1e-3;              % Temps (1 ms avec un pas de 1 µs)
Df = 100e3;                   % Déviation de fréquence en Hz (100 kHz)
I0 = cos(2 * pi * Df * t);   % I(t) pour 0
Q0 = sin(2 * pi * Df * t);   % Q(t) pour 0
I1 = cos(2 * pi * Df * t);   % I(t) pour 1
Q1 = -sin(2 * pi * Df * t);  % Q(t) pour 1

%% Création de la figure avec 4 subplots
figure;

% Subplot 1 : I(t) pour 0
subplot(2,2,1);
plot(t, I0);
title('I(t) pour 0');
xlabel('Temps (s)');
ylabel('Amplitude');
axis([0 max(t)/8 -1 1]); 
grid on;

% Subplot 2 : Q(t) pour 0
subplot(2,2,2);
plot(t, Q0);
title('Q(t) pour 0');
xlabel('Temps (s)');
ylabel('Amplitude');
axis([0 max(t)/8 -1 1]); 
grid on;

% Subplot 3 : I(t) pour 1
subplot(2,2,3);
plot(t, I1);
title('I(t) pour 1');
xlabel('Temps (s)');
ylabel('Amplitude');
axis([0 max(t)/8 -1 1]); 
grid on;

% Subplot 4 : Q(t) pour 1
subplot(2,2,4);
plot(t, Q1);
title('Q(t) pour 1');
xlabel('Temps (s)');
ylabel('Amplitude');
axis([0 max(t)/8 -1 1]); 
grid on;
