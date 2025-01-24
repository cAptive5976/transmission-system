%% Programme de modulation ASK

%% Remise à zéro du contexte
clear;
clc;
close all;

%% Initialisation des variables
D=1000;                         % Débit en bits/s
fp=5000;                        % Fréquence porteuse (Hz);
Tb=1/D;                         % Durée d'un bit=1symbole
R=D;                            % Rapidité
Ts=Tb;                          % Durée d'un symbole
fe=100000;                      % Fréquence échantillonnage
Te=1/fe;                        % Période d'échantillonnage   

data=[1 0 1 1 0 0 1 0 0 1];     % Séquence utilisateur à transmettre
data=[data randi([0 1],1,1000)];% Ajout d'une séquence aléatoire à la suite de la séquence utilisateur.

Nb=size(data,2);                % Nombre de bits à transmettre
Nech_symb=fe/D;                 % Nombre d'échantillons par symbole
Nech=Nb*Nech_symb;              % Nombre total d'échantillons
Tmax=Nb*Tb;                     % Durée totale de la trame  

%% Codage des données binaires en NRZ
signal_NRZ=[];                  % Initialisation du signal codé en NRZ
symbole_1=ones(1,Nech_symb);
symbole_0=zeros(1,Nech_symb);

for n=1:Nb                      % Codage des différents bits
     if (data(n)==1)
        signal_NRZ=[signal_NRZ symbole_1];
     else
        signal_NRZ=[signal_NRZ symbole_0];
     end
end   


%% Création des signaux
t=0:Te:Tmax-Te;
porteuse=5*cos(2*pi*fp*t);  % création d'un vecteur 'porteuse' 
ASK=signal_NRZ.*porteuse;


%% Affichage des chronogrammes
subplot(3,1,1)
plot(t*1000,signal_NRZ,"b"); %t en ms
title('représentation du chronogramme du signal binaire')
xlabel('t(ms)')
ylabel('Volt')
legend('Signal binaire')
axis([0 10 0 1])  %affichage endant 3 périodes du signal modulant
grid on

subplot(3,1,2)
plot(t*1000,porteuse,"b"); %t en ms
title('représentation du chronogramme de la porteuse')
xlabel('t(ms)')
ylabel('Volt')
legend('porteuse(t)')
axis([0 10 -6 6])  %affichage endant 3 périodes du signal modulant
grid on

subplot(3,1,3)
plot(t*1000,ASK,"b"); %t en ms
title('représentation du chronogramme du signal modulé OOK')
xlabel('t(ms)')
ylabel('Volt')
legend('OOK(t)')
axis([0 10 -6 6])  %affichage endant 3 périodes du signal modulant
grid on

%% Calcul puis affichage des spectres 
[X f]=spectre(signal_NRZ,fe,Nech);
[Y f]=spectre(porteuse,fe,Nech);
[Z f]=spectre(ASK,fe,Nech);
figure;
subplot(3,1,1);
plot(f,X,"b");
title('Spectre en amplitude du signal binaire (NRZ)')
xlabel('f(Hz)')
ylabel('Volt')
legend('|NRZ(f)|')
axis([0 2*fp -60 -20])  
grid on

subplot(3,1,2);
plot(f,Y,"b");
title('Spectre en amplitude de la porteuse')
xlabel('f(Hz)')
ylabel('Volt')
legend('|Porteuse(f)|')
axis([0 2*fp -20 20])  
grid on

subplot(3,1,3);
plot(f,Z,"b");
title('Spectre en amplitude du signal modulé OOK')
xlabel('f(Hz)')
ylabel('Volt')
legend('|OOK(f)|')
axis([0 2*fp -60 20]) 
grid on