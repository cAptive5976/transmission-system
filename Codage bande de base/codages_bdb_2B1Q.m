%% Programme du codage BdB 2B1Q

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
Nech_double=Nech_bit*2  % Double du nombre d'échantillons
Tmax=Nb*Tb;             % Durée de la trame
t=0:Te:Tmax-Te;         % Vecteur temps constitué de Ns*Nb échantilllons   


%% Création du signal 2B1Q
signal_2B1Q=[];             %initialisation du signal codé en 2B1Q
symbole_10=5*ones(1,Nech_double); 
symbole_11=(5/3)*ones(1,Nech_double);
symbole_01=-(5/3)*ones(1,Nech_double);
symbole_00=-5*ones(1,Nech_double);

for n=1:2:Nb      %codage des différents bits
     if (data(n)==1 && data(n+1)==0)
        signal_2B1Q=[signal_2B1Q symbole_10];
     elseif (data(n)==1 && data(n+1)==1)
        signal_2B1Q=[signal_2B1Q symbole_11];
     elseif (data(n)==0 && data(n+1)==1)
        signal_2B1Q=[signal_2B1Q symbole_01];   
     elseif (data(n)==0 && data(n+1)==0)
        signal_2B1Q=[signal_2B1Q symbole_00];   
     end
    
end   


%% Affichage du chronogramme du signal 2B1Q
subplot(2,1,1)
plot(t*1000,signal_2B1Q,"b"); %t en ms
title('représentation du chronogramme du signal 2B1Q')
xlabel('t(ms)')
ylabel('Volt')
legend('2B1Q(t)')
axis([0 1000*10/D -10 10])  %affichage de 10 symboles
grid on

%% Calcul puis affichage du spectre su signal 2B1Q 
[X f]=spectre(signal_2B1Q,fe,Nech);
subplot(2,1,2);
plot(f,X,"b");
title('Spectre en amplitude du signal codé en 2B1Q')
xlabel('f(Hz)')
ylabel('dBV')
legend('|2B1Q(f)|')
axis([0 4*D -60 0])  %affichage entre 0 et 2*D (Hz)
grid on

