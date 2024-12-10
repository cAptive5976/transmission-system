%% 
clear;
clc;
close;
%% Définition des variables
D=1000;          %débit en bits/s
Nech_bit=40;    % nombre d'échantillons par symbole; doit être pair.
fe=D*Nech_bit;  %fréquence d'échantillonnage.

Te=1/fe;  % période d'échantillonnage
Tb=1/D;   % durée d'un bit

data=[0 1 1 1 0 1 1 0 0 0 0 0 0 0  1 0 ];  %séquence utilisateur de 10 bits
alea=randi([0 1],1,10000);
data=[data alea];  %ajoute 10000 bits aléatoires
                                         %après la séquence utilisateur

Nb=size(data,2);          %Nb de bits à transmettre
Nech=Nech_bit*Nb;        %nombre total d'échantillons                   
Tmax=Nb*Tb;               %durée de la trame

t=0:Te:Tmax-Te;           %vecteur temps constitué de Ns*Nb échantilllons   


%% Création du signal MLT3
signal_MLT3=[];             %initialisation du signal codé en MLT3
symbole_POS=5*ones(1,Nech_bit); % Dans le cas ou on a un bit de '1' on a une amplitude de 5V, on envoit donc une suite de 1 (ones)
symbole_NEG=-5*ones(1,Nech_bit); % Dans le cas ou on a un bit de '0' on a une amplitude de -5V, on envoit donc une suite de 1 (ones)
symbole_null=zeros(1,Nech_bit);
symbole_same=ones(1,Nech_bit);

state=true;
pos=0;
for n=1:Nb      %codage des différents bits
     if (data(n)==1 && state==true && pos==0)
        signal_MLT3=[signal_MLT3 symbole_POS];
        state=false;
        pos=1;
     elseif (data(n)==1 && state==false && pos==1)
        signal_MLT3=[signal_MLT3 symbole_null];
        state=false;
        pos=0;
     elseif (data(n)==1 && state==false && pos==0)
        signal_MLT3=[signal_MLT3 symbole_NEG];
        state=true;
        pos=-1;
     elseif (data(n)==1 && state==true && pos==-1)
        signal_MLT3=[signal_MLT3 symbole_null];
        state=true;
        pos=0;   
     else
         signal_MLT3=[signal_MLT3 symbole_same*pos*5];
         state=state;
     end
    
end   


%% Affichage du chronogramme du signal MLT3
subplot(2,1,1)
plot(t*1000,signal_MLT3,"b"); %t en ms
title('représentation du chronogramme du signal MLT3')
xlabel('t(ms)')
ylabel('Volt')
legend('MLT3(t)')
axis([0 1000*10/D -10 10])  %affichage de 10 symboles
grid on

%% Calcul puis affichage du spectre su signal MLT3 
[X f]=spectre(signal_MLT3,fe,Nech);
subplot(2,1,2);
plot(f,X,"b");
title('Spectre en amplitude du signal codé en MLT3')
xlabel('f(Hz)')
ylabel('dBV')
legend('|MLT3(f)|')
axis([0 4*D -60 0])  %affichage entre 0 et 2*D (Hz)
grid on

