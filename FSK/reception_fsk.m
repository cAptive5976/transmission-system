%% Remise à zéro du contexte
clear ;
clc ;
close ;

%% initialisation des variables
fp = 2.414e9; %fréquence de la porteuse: à modifier selon votre numéro de canal 
f0 = 50e3;  %fréquence de la sinusoïde à transmettre 
Fech = 1e6; %fréquence d'échantillonnage du signal c(t) transmis à l'Adalm Pluto 
Tech=1/Fech; 
Nech=10000;  %nombre d'échantillons transmis   
t=(0:Nech-1)*Tech;  %création de la base de temps échantillonnée 
c = exp(1j*2*pi*f0*t);  % pour transmettre un sinus de fréquence f0 


 %% configuration de l'ADALM PLUTO récepteur 

rx = sdrrx('Pluto', 'RadioID', 'usb:0', 'CenterFrequency', fp, 'BasebandSampleRate', Fech, 'SamplesPerFrame', Nech, 'OutputDataType', 'double', 'ShowAdvancedProperties', true); 
%% Réception des échantillons        

reception= rx(); % réception d'une trame de Nech échantillons 

reception=reception';   % on prend la transposée pour avoir un vecteur colonne... 
save reception;

%% Affichage du chronogramme du signal
subplot(2,1,1)
plot(t*1000,reception,"b"); %t en ms
title('représentation du chronogramme du signal')
xlabel('t(ms)')
ylabel('Watt')
legend('signal(t)')
axis([0 0.5 -1 1])  
grid on

%% Calcul puis affichage du spectre su signal
[X f]=spectre(reception,Fech,Nech);
subplot(2,1,2);
plot(f,X,"b");
title('Spectre en puissance du signal')
xlabel('f(Hz)')
ylabel('dBm')
legend('|signal(f)|')
axis([0 100e3 -100 0])  
grid on
