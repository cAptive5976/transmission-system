%% Programme du codage BdB Manchester

%% Remise à zéro du contexte
clear;
clc;
close all;

%% Définition des variables
D=1000;                 % Débit en bits/s
Nech_bit=40;            % Nombre d'échantillons par symbole; doit être pair.
fe=D*Nech_bit;          % Fréquence d'échantillonnage.

Te=1/fe;                % Période d'échantillonnage
Tb=1/D;                 % Durée d'un bit

data=[0 1 1 1 0 1 1 0 0 0 0 0 0 0  1 0 ];  % Séquence utilisateur de 10 bits
data=[data randi([0 1],1,10000)];   % Ajoute 10000 bits aléatoires après la séquence utilisateur

Nb=size(data,2);        % Nombre de bits à transmettre
Nech=Nech_bit*Nb;       % Nombre total d'échantillons
Nech_half=Nech_bit/2;   % Moitier du nombre d'échantillons
Tmax=Nb*Tb;             % Durée de la trame
t=0:Te:Tmax-Te;         % Vecteur temps constitué de Ns*Nb échantilllons   


%% Création du signal Manchester
signal_Manchester=[];             %initialisation du signal codé en Manchester
symbole_1=5*ones(1,Nech_half); % Dans le cas ou on a un bit de '1' on a une amplitude de 5V, on envoit donc une suite de 1 (ones)
symbole_0=-5*ones(1,Nech_half); % Dans le cas ou on a un bit de '0' on a une amplitude de -5V, on envoit donc une suite de 1 (ones)

for n=1:Nb      %codage des différents bits
     if (data(n)==1)
        signal_Manchester=[signal_Manchester symbole_1 symbole_0];
     else
        signal_Manchester=[signal_Manchester symbole_0 symbole_1];
     end
    
end   


%% Affichage du chronogramme du signal Manchester
subplot(2,1,1)
plot(t*1000,signal_Manchester,"b"); %t en ms
title('représentation du chronogramme du signal Manchester')
xlabel('t(ms)')
ylabel('Volt')
legend('Manchester(t)')
axis([0 1000*10/D -10 10])  %affichage de 10 symboles
grid on

%% Calcul puis affichage du spectre su signal Manchester 
[X f]=spectre(signal_Manchester,fe,Nech);
subplot(2,1,2);
plot(f,X,"b");
title('Spectre en amplitude du signal codé en Manchester')
xlabel('f(Hz)')
ylabel('dBV')
legend('|Manchester(f)|')
axis([0 4*D -60 0])  %affichage entre 0 et 2*D (Hz)
grid on

