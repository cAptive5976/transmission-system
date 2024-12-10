%% Remise à zéro du contexte
clear ;
clc ;
close ;

%% initialisation des variables
fp = 2.414e9; %fréquence de la porteuse: à modifier selon votre numéro de canal 
f0 = 50e3;  %fréquence de la sinusoïde à transmettre 
Fech = 1e6; %fréquence d'échantillonnage du signal c(t) transmis à l'Adalm Pluto 
Tech=1/Fech; 
Nech=928*2;  %nombre d'échantillons transmis   
Nech_sym=32
Df = 100000
t=(0:Nech-1)*Tech;  %création de la base de temps échantillonnée 
c = exp(1j*2*pi*f0*t);  % pour transmettre un sinus de fréquence f0 


 %% configuration de l'ADALM PLUTO récepteur 

rx = sdrrx('Pluto', 'RadioID', 'usb:0', 'CenterFrequency', fp, 'BasebandSampleRate', Fech, 'SamplesPerFrame', Nech, 'OutputDataType', 'double', 'ShowAdvancedProperties', true); 
%% Réception des échantillons        

reception= rx(); % réception d'une trame de Nech échantillons 

reception=reception.';   % on prend la transposée pour avoir un vecteur colonne... 
re_demod = fskdemod(reception, 2, Df, Nech_sym,Fech);

%% Affichage du chronogramme du signal
subplot(2,1,1);
stem(re_demod,"b"); %t en ms
title('représentation du chronogramme du signal');
xlabel('t(ms)');
ylabel('Amplitude');
legend('signal(t)');
grid on;
