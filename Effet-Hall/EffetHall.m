%%%%%%%%%%%%
%Unites SI %
%%%%%%%%%%%%
%%
clc
clear workspace
%%
%plot de Vh et de V_circuit en fonction de l'intensit? I ds le
%semi-conducteur
%B = 100mT = 0.1T
%Vh en mV reconverti en V; V_circuit en V; I en mA reconverti en A

I = [-58, -55:5:60]*10^-3;
Vh = [40.7, 38.2, 36.2, 31.4, 28.7, 24.8, 20.5, 18.1, 14.6, 10.8 6.9, 3.8, 0, -3.5, -6.6, -10.4, -13.2, -16.2, -20.3, -23.5, -26.4, -29.7, -33.7, -37.5, -41]*10^-3;
V_circuit = [2.41, 2.26, 2.14, 1.86, 1.698, 1.472, 1.225, 1.078, 0.892, 0.672, 0.45, 0.268, 0, -0.154, -0.336, -0.557, -0.722, -0.902, -1.140, -1.325, -1.498, -1.703, -1.923, -2.15, -2.36];

fprintf('Regression lineaire de la tension de Hall en fonction de l''intensite du courant\n');
lmdl1 = linearRegr([I; Vh])
fprintf('Calcul du coefficient de determination\n');
lmdl1.Rsquared()

fprintf('Regression lineaire de la tension aux bornes du Ge en fonction de l''intensite du courant\n');
lmdl2 = linearRegr([I; V_circuit])
fprintf('La pente de la droite (a) donne la resistance du Ge\n');
fprintf('Calcul du coefficient de determination\n');
lmdl2.Rsquared()

%%
%plot de la tension de Hall en fct de l'intensite du champ magnetique
%le courant est constant = 30mA = 0.03A
%intensite du champ magnetique en mT reconverti en T
%tension de Hall en mV reconverti en V
I = [10.3,20,30,40,50,60,70,80,90,100,110,120,130,140,150,160,170]*10^-3;
Vh = [-1.6,-3.6,-5.6,-7.6,-9.6,-11.6,-13.7,-15.7,-17.7,-19.7,-21.7,-23.7,-26.7,-28.2,-30.4,-32.3,-34.1]*10^-3;

fprintf('Regression lineaire de la tension de Hall en fonction de l''intensite du champ magnetique\n');
lmdl3 = linearRegr([I; Vh])
fprintf('Calcul du coefficient de determination\n');
lmdl3.Rsquared()