function [X f]=spectre(signal_NRZ,fe,Nech)
% cette fonction génére par FFT le spectre unilatéral en amplitude, X(f), 
% du signal x(t). On crée aussi le vecteur fréquence, f/

df=fe/Nech;        % les échantillons fréquentiels sont espacés de fe/Nech
f=0:df:fe/2-df;  %création d'un vecteur fréquence constitué de Nech/2 points
                 %répartis entre 0 et fe/2

                 
%calcul et affichage du spectre du signal NRZ           
X=fft(signal_NRZ)/Nech;
X=[X(1) 2*X(2:Nech/2)];   %passage du spectre bilatéral au spectre unilatéral...
X=20*log10(abs(X));      % module en dBuV
end