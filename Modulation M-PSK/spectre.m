function [X, f] = spectre(signal_NRZ, fe, Nech)
% cette fonction génére par FFT le spectre unilatéral en amplitude, X(f), 
% du signal x(t). On crée aussi le vecteur fréquence, f/
    df = fe / Nech;                     % les échantillons fréquentiels sont espacés de fe/Nech
    L = length(signal_NRZ);             % Taille réelle du signal
    f = 0:df:(fe / 2 - df);             %création d'un vecteur fréquence constitué de Nech/2 points
                                        %répartis entre 0 et fe/2
                 
    %calcul et affichage du spectre du signal NRZ  
    X = fft(signal_NRZ) / L;
    if floor(L / 2) > 1
        X = [X(1) 2*X(2:floor(L / 2))]; %passage du spectre bilatéral au spectre unilatéral...
    else
        X = [X(1)];
    end
    
    % Ajuster la taille de f si nécessaire
    f = f(1:length(X));                 % f est redimenssioné pour correspondre à X
    X = 20 * log10(abs(X));             % module en dBuV
end       
