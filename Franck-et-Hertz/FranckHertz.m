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
h = 4.135667662e-15; %constante de Planck en eV s
c = 299792458; %vitesse de la lumiere dans le vide en m/s
%%
%calcul des coefficients de proportionnalites
V1 =[10,20,30,40,30,33,36]; %tension reelle
V2 =[1.041,2.04,3.05,4.05,3.05,3.35,3.65]; %tension en sortie proportionnelle a V1
I1 =[0.2,1,4.5,12.5,6.3,1.3,18.3] * 10^-3; %courant reel
I2 =[0.06,0.2,0.9,2.41,1.28,0.24,3.60]; %tension en sortie proportionnelle a I1

lmdlV = linearRegr([V2; V1]);
lmdlI = linearRegr([I2; I1]);
coeffPropV = lmdlV.affine();
coeffPropI = lmdlI.affine();

%%
%mesures experimentales manuelles
manu.U = (0:0.5:40);
manu.I = [0.01,0.01,0.01,0.01,0.01,0.01,0.009,0.01,0.009,0.009,0.009,0.01, ...
    0.013,0.018,0.023,0.027,0.029,0.028,0.026,0.025,0.03,0.044,0.072,0.106, ...
    0.117,0.098,0.069,0.048,0.042,0.058,0.104,0.132,0.218,0.31,0.24,0.16, ...
    0.09,0.06,0.05,0.09,0.18,0.31,0.48,0.62,0.5,0.25,0.11,0.08,0.15,0.29, ...
    0.5,0.77,1.06,1.21,0.82,0.31,0.14,0.16,0.34,0.62,0.99,1.39,1.83,1.98, ...
    1.24,0.48,0.26,0.42,0.8,1.27,1.92,2.56,3.23,3.45,2.33,1.08,0.77,1.13, ...
    1.87,2.75,3.69] * coeffPropI;

[~, I] = min2(manu.I);
U_min = manu.U(I);
X = 1:length(U_min);

plot(manu.U, manu.I);
hold on
for i = 1 : length(I)
    plot([U_min(i) U_min(i)], [0 0.020]);
end
hold off
subtitle = '\parbox[b]{3in}{\centering Courant $I_A$ en fonction de la tension $U_1$ \\ Mesures prises manuellement}';
title(subtitle, 'interpreter', 'latex');
xlabel('Difference de potentiel $U_1$ (en V)', 'interpreter', 'latex');
ylabel('Courant $I_A$ (en mA)', 'interpreter', 'latex');

lmdl = linearRegr([X; U_min]);
E = lmdl.a; %l'energie est laiss?e en eV
display(E); %correspond a l'energie de permiere excitation en eV
nu = E / h;
lambda_argon = c / nu * 10^9; %pour avoir en nm
display(lambda_argon);

%%
%avec l'osciloscope
%*en Volt*%
%minimum = [0.18, 2.56; 0.44, 3.04; 0.94, 3.52; 1.70, 4.08];
%cal = (minimum(1,2)-minimum(1,1)/0.1004+minimum(2,2)-minimum(2,1)/0.1004+minimum(3,2)-minimum(3,1)/0.1004+minimum(4,2)-minimum(4,1)/0.1004)/4;
timestamp_min = [20.8, 25, 29.6, 34.2] * 10^-3;% temps entre le d?but et les minimum
delta_U = 3.92 * coeffPropV;
period_U = 34.2*10^-3;
U_oscillo_min = delta_U * timestamp_min / period_U;

X_oscillo = 1 : length(timestamp_min);
lmdl_oscillo = linearRegr([X_oscillo; U_oscillo_min]);
E_oscillo = lmdl_oscillo.a;
display(E_oscillo);
nu = E_oscillo / h;
lambda_argon_oscillo = c / nu * 10^9; %pour avoir en nm
display(lambda_argon_oscillo);

%%
%PC
%1ere colonne: difference de potentiel entre electrode et grille en V
%2eme colonne: courant en nA
T185 = dlmread('185.txt', '\t', 3, 0);
T195 = dlmread('195.txt', '\t', 3, 0);

% hold on
% plot(T185(:, 1), T185(:, 2));
% hold on
% plot(T195(:, 1), T195(:, 2));
% hold off
% legend('Manu', 'T = 185', 'T = 195');


U185_min = [13.94 18.73 23.46 28.22 33.11 38.16]; %obtenu graphiquement
U195_min = [13.96 18.82 23.41 28.25 33.13 38.11]; %obtenu graphiquement
X185 = 1:length(U185_min);
X195 = 1:length(U195_min);

figure;
subplot(1, 2, 1);
hold on
plot(T185(:, 1), T185(:, 2));
for i = 1 : length(U185_min)
    plot([U185_min(i) U185_min(i)], [0 20]);
end
hold off
subtitle = '\parbox[b]{3in}{\centering Courant $I_A$ en fonction de la tension $U_1$ \\ Mesures prises au pc \`a $185^{\circ}$C}';
title(subtitle, 'interpreter', 'latex');
xlabel('Difference de potentiel $U_1$ (en V)', 'interpreter', 'latex');
ylabel('Courant $I_A$ (en mA)', 'interpreter', 'latex');

%figure;
subplot(1, 2, 2)
hold on
plot(T195(:, 1), T195(:, 2));
for i = 1 : length(U195_min)
    plot([U195_min(i) U195_min(i)], [0 20]);
end
hold off
subtitle = '\parbox[b]{3in}{\centering Courant $I_A$ en fonction de la tension $U_1$ \\ Mesures prises au pc \`a $195^{\circ}$C}';
title(subtitle, 'interpreter', 'latex');
xlabel(['Difference de potentiel $U_1$ (en V)'], 'interpreter', 'latex');
ylabel('Courant $I_A$ (en mA)', 'interpreter', 'latex');

lmdl185 = linearRegr([X185; U185_min]);
lmdl195 = linearRegr([X195; U195_min]);
E185 = lmdl185.a;
E195 = lmdl195.a;
display(E185);
display(E195);

nu = E185 / h;
lambda_argon185 = c / nu * 10^9; %pour avoir en nm
display(lambda_argon185);
nu = E195 / h;
lambda_argon195 = c / nu  * 10^9; %pour avoir en nm
display(lambda_argon195);

%calcul ecart relatif entre les deux energies
ecart_rel = (E185 - E195) / ((E185 + E195)/2);
fprintf('L''ecart relatif entre les energies aux deux temperatures vaut : %f (en pourcent) \n', ecart_rel*100);
fprintf('La moyenne entre les deux vaut : %f \n', (E185 + E195)/2);

%%
% valeur reelle
lambda = 253.7 * 10^-9; %m, valeur reelle de la longueur d'onde
energie = h * c / lambda; %en eV
display(lambda);
display(energie);