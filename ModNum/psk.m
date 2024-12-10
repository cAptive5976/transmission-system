clear;
clc;
close;
%% Initialisation des variables
D=1000;  %débit en bits/s
fp=5000; %fréquence porteuse (Hz);
Tb=1/D; %durée d'un bit=1symbole
R=D;    %Rapidité
Ts=Tb;  %durée d'un symbole
fe=100000;    %fréquence échantillonnage
Te=1/fe; %période d'échantillonnage   



data=[1 0 1 1 0 0 1 0 0 1];           %séquence utilisateur à transmettre
data=[data randi([0 1],1,1000)];       %ajout d'une séquence aléatoire à la suite de la séquence utilisateur.

Nb=size(data,2);   % nombre de bits à transmettre
Nech_symb=fe/D;    %nombre déchantillons par symbole
Nech=Nb*Nech_symb;
Tmax=Nb*Tb;        %durée totale de la trame  


%% Codage des données binaires en NRZ
signal_NRZ=[];             %initialisation du signal codé en NRZ
symbole_1=ones(1,Nech_symb);
symbole_0=zeros(1,Nech_symb);

for n=1:Nb      %codage des différents bits
     if (data(n)==1)
        signal_NRZ=[signal_NRZ symbole_1];
     else
        signal_NRZ=[signal_NRZ symbole_0];
     end
    end   

%% Création des signaux
t=0:Te:Tmax-Te;
porteuse=5*cos(2*pi*fp*t);  % création d'un vecteur 'porteuse' 
porteuse_dephase=5*cos(2*pi*fp*t+pi); % création d'un vecteur porteuse déphasé de pi
PSK=[];


for n = 1:Nb % Codage des différents bits
    % Générer la porteuse correspondante pour le symbole actuel
    if data(n) == 1
        PSK = [PSK (symbole_1 .* porteuse((n-1)*Nech_symb+1 : n*Nech_symb))];
    else
        PSK = [PSK (symbole_1 .* porteuse_dephase((n-1)*Nech_symb+1 : n*Nech_symb))];
    end
end 



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
plot(t*1000,PSK,"b"); %t en ms
title('représentation du chronogramme du signal modulé PSK')
xlabel('t(ms)')
ylabel('Volt')
legend('PSK(t)')
axis([0 10 -6 6])  %affichage endant 3 périodes du signal modulant
grid on

%% Calcul puis affichage des spectres 
[X f]=spectre(signal_NRZ,fe,Nech);
[Y f]=spectre(porteuse,fe,Nech);
[Z f]=spectre(PSK,fe,Nech);
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
title('Spectre en amplitude du signal modulé PSK')
xlabel('f(Hz)')
ylabel('Volt')
legend('|PSK(f)|')
axis([0 2*fp -60 20]) 
grid on