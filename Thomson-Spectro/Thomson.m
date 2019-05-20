%%%%%%%%%%%%
%Unites SI %
%%%%%%%%%%%%
%%
clc
clear workspace
clear variables
set(0,'defaultaxesfontsize',15)
set(0,'defaulttextfontsize',15)
set(0,'defaultlinelinewidth',2)
%%
% distance les barreaux au canon // correspond au double du rayon de Larmor
% Canon placer en 32,181cm
d = [28.334, 26.376, 24.438, 22.61];% en cm 

% si tu veux la distance des bareaux par rapport au canon les voici 
% correspond aux diametres
D = zeros(4, 1);
for i=1:4
D(i) = 32.181 - d(i);
end

%conversion de cm en m
D = D * 0.01;
R = D / 2; %diametre -> rayon

%V fixe et I variant
%le premier element de chaque colonne correspond a la valeur de V
%le reste de la colonne correspond aux valeurs de I pour le 1er, 2eme, ..
%barreau
V_fixe = [
    [148,165,181,199]
    [2.62,1.61,1.11,0.88]
    [2.78,1.69,1.21,0.98]
    [2.86,1.75,1.30,1.05]
    [3.02,1.87,1.39,1.1]
    ];

%I fixe et V variant
%le premier element de chaque colonne correspond a la valeur de I
%le reste de la colonne correspond aux valeurs de V pour le 1er, 2eme, ..
%barreau
I_fixe = [
    [1,1.26,1.5,1.61]
    [66.2,93.7,138.1,173.3]
    [67,127,174,241]
    [81.7,156.5,224,335]
    [84,171,257,374]
    ];

%%
%mise des donnees sous forme de triplets (V, I, D)

dim_V_fixe = size(V_fixe);
dim_I_fixe = size(I_fixe);

len = (dim_I_fixe(1) - 1) * dim_I_fixe(2) + (dim_V_fixe(1) - 1) * dim_V_fixe(2);
    % ne pas oublier de retirer la premiere colonne
triplets = zeros(3, len);

k = 1;
for i = 1 : dim_V_fixe(2) %colonne
    for j = 2 : dim_V_fixe(1) %ligne
                              %on commence a 2 car la premiere ligne
                              %indique la tension fixee
        triplets(1, k) = V_fixe(1, i);
        triplets(2, k) = V_fixe(j, i);
        triplets(3, k) = R(j - 1);
        k = k + 1;
    end
end

for i = 1 : dim_I_fixe(2) %colonne
    for j = 2 : dim_I_fixe(1) %ligne
                              %on commence a 2 car la premiere ligne
                              %indique le courant fixe
        triplets(1, k) = I_fixe(j, i);
        triplets(2, k) = I_fixe(1, i);
        triplets(3, k) = R(j - 1);
        k = k + 1;
    end
end

%%
%
triplets = cat(2, triplets, [145; 2; R(1)]);
triplets = cat(2, triplets, [220; 2; R(2)]);
triplets = cat(2, triplets, [373; 2; R(3)]);

%%
%determination du rapport e/m
% e/m = A * V / (I^2 * R^2), A = 3296700 A^2/T^2
%regression au sens des moindres carr?s = une simple moyenne

A = 3296700;
%e_m = A * triplets(1, :) ./ (triplets(2, :).^2 .* triplets(3, :).^2);
e_m = zeros(1, length(triplets));
for i = 1 : length(triplets)
    if i == 13 || i == 9
        continue;
    end
    e_m(i) = A * triplets(1, i) / (triplets(2, i)^2 * triplets(3, i)^2);
end
rapport_e_m = sum(e_m) / (length(triplets) - 2);
display(rapport_e_m);
scatter(1:length(e_m), e_m);
hold on
plot([1 length(e_m)], [rapport_e_m rapport_e_m]);
hold off
ylabel('Rapport charge sur masse en C/kg');
title({'Rapport charge sur masse pour', 'chaque triplet (V, I, R)'});
%variance
variance = var(e_m);
display(variance);

%erreur relative
rapport_reel = 1.758820024e11; %C/kg
err = (rapport_reel - rapport_e_m) / rapport_reel;
display(err);
hold on
plot([1 length(e_m)], [rapport_reel rapport_reel]);
hold off
legend('Valeur de e/m pour chaque triplet', 'Rapport e/m experimental', 'Rappport e/m reel');
%%
% %exxtra attempt
% %compute the mean of V /I^2 for each radius
% 
% V_I2 = zeros(1, 4);
% N = zeros(1, 4);
% for i = 1 : length(triplets)
%     if i == 13 || i == 9
%         continue;
%     end
%     switch triplets(3, i)
%         case R(1)
%             V_I2(1) = V_I2(1) + triplets(1, i) / triplets(2, i)^2;
%             N(1) = N(1) + 1;
%         case R(2)
%             V_I2(2) = V_I2(2) + triplets(1, i) / triplets(2, i)^2;
%             N(2) = N(2) + 1;
%         case R(3)
%             V_I2(3) = V_I2(3) + triplets(1, i) / triplets(2, i)^2;
%             N(3) = N(3) + 1;
%         case R(4)
%             V_I2(4) = V_I2(4) + triplets(1, i) / triplets(2, i)^2;
%             N(4) = N(4) + 1;
%         otherwise
%             continue;
%     end
% end
% 
% V_I2_moy= [V_I2(1) / N(1)  V_I2(2) / N(2)  V_I2(3) / N(3)  V_I2(4) / N(4)];
% e_m_bis = A * (V_I2_moy(1) / R(1)^2 + V_I2_moy(2) / R(2)^2 + V_I2_moy(3) / R(3)^2 + V_I2_moy(4) / R(4)^2) / 4;
% display(e_m_bis);
% err = (rapport_reel - e_m_bis) / rapport_reel;
% display(err);
% plot(V_I2);
% 
% %excluding the first radius
% V_I2_moy= [V_I2(2) / N(2)  V_I2(3) / N(3)  V_I2(4) / N(4)];
% e_m_tierce = A * (V_I2_moy(1) / R(1)^2 + V_I2_moy(2) / R(2)^2 + V_I2_moy(3) / R(3)^2) / 3;
% display(e_m_tierce);
% err = (rapport_reel - e_m_tierce) / rapport_reel;
% display(err);