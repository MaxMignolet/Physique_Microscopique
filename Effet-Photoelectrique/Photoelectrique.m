%%
% Donnees experimentales

% pour Lambda  = 400nm et 12V d'intensite lumineuse
% Potentilen en volt et courant en picoampere
DiffPotentiel1 = [-1.208 ,-0.96 ,-0.53 ,0 ,0.58 ,0.97 ,1.54 ,1.99 ,2.44 ,2.94 ,3.58 ,4.02 ,4.55 ,4.99 ,5.6 ,5.94 ,6.42 ,7.04 ,7.5 ,8.02 ,8.56 ,9.05 ,9.5 ,10.11 ,10.48 ,11.08 ,11.58 ,12.12 ,13.06 ,13.49 ,14.01 ,14.47 ,15.12 ,15.46 ,16.06 ,16.57 ,17.14 ,17.66];
Courant1 = [0 ,0.003 ,0.01 ,0.046 ,0.0974 ,0.135 ,0.187 ,0.235 ,0.29 ,0.35 ,0.418 ,0.46 ,0.5 ,0.56 ,0.6 ,0.63 ,0.66 ,0.69 ,0.72 ,0.73 ,0.75 ,0.76 ,0.8 ,0.81 ,0.82 ,0.84 ,0.87 ,0.88 ,0.91 ,0.92 ,0.93 ,0.94 ,0.96 ,0.97 ,0.99 ,1 ,1.01 ,1.02 ];

% pour Lambda  = 450nm et 12V d'intensite lumineuse
% Potentilen en volt et courant en picoampere
DiffPotentiel2 = [-0.929 ,-0.55 ,0 ,0.52 ,1.06 ,1.51 ,1.91 ,2.67 ,3.08 ,3.5 ,4.05 ,4.54 ,5.11 ,5.51 ,6.11 ,6.47 ,7.07 ,7.49 ,8.05 ,8.63 ,9 ,9.59 ,10.01 ,10.56 ,11.09 ,11.59 ,12.06 ,12.66 ,13.01 ,14.06 ,14.58 ,15.15 ,15.69 ,16.17 ,16.40 ,16.8 ,16.88];
Courant2 = [0.001 ,0.012 ,0.06 ,0.14 ,0.23 ,0.3 ,0.36 ,0.5 ,0.56 ,0.63 ,0.7 ,0.76 ,0.81 ,0.85 ,0.9 ,0.93 ,0.97 ,1 ,1.04 ,1.07 ,1.08 ,1.13 ,1.15 ,1.18 ,1.2 ,1.22 ,1.24 ,1.26 ,1.28 ,1.32 ,1.34 ,1.36 ,1.38 ,1.39 ,1.4 ,1.41 ,1.4];

% pour Lambda  = 500nm et 12V d'intensite lumineuse
% Potentilen en volt et courant en nanometre
DiffPotentiel3 = [-0.648 ,-0.53 ,0 ,0.54 ,0.96 ,1.47 ,2.04 ,2.55 ,3.09 ,3.52 ,4.12 ,4.73 ,5.08 ,5.47 ,6.18 ,6.58 ,6.95 ,6.97 ,7.6 ,8.13 ,8.6 ,9.13 ,9.64 ,9.97 ,10.58 ,11.02 ,11.5 ,12.07 ,12.55 ,13.07 ,13.48 ,14.07 ,14.6 ,15.08 ,15.49 ,16.03 ,16.76];
Courant3 = [0.0003 ,0.001 ,0.03 ,0.12 ,0.19 ,0.26 ,0.34 ,0.43 ,0.51 ,0.58 ,0.65 ,0.7 ,0.74 ,0.78 ,0.83 ,0.86 ,0.87 ,0.9 ,0.93 ,0.96 ,0.99 ,1.02 ,1.05 ,1.06 ,1.09 ,1.1 ,1.12 ,1.15 ,1.17 ,1.18 ,1.2 ,1.22 ,1.23 ,1.25 ,1.25 ,1.27 ,1.29];


% Vstop en fonction de l'intensite lumineuse  a 400nm
Intensite = [2 ,4 ,6 ,8 ,10 ,12];
Vstop = [-1.212 ,-1.2 ,-1.198 ,-1.228 ,-1.202 ,-1.208];

% Vstop en fonction de la longueur d'onde
lambda = [400 ,410 ,420 ,430 ,440 ,450 ,460 ,470 ,480 ,490 ,500];
V_arret = [-1.266 ,-1.248 ,-1.146 ,-1.112 ,-1.012 ,-0.907 ,-0.910 ,-0.915 ,-0.772 ,-0.762 ,-0.715];

%%
% conversion aux unites SI
Courant1 = Courant1 * 10^-12;
Courant2 = Courant2 * 10^-12;
Courant3 = Courant3 * 10^-12;
lambda = lambda * 10^-9;
%%
% Determination de la constante de Planck et du travail d'extraction a 
% partir des tensions d'arret en fonction de la longueur d'onde de la 
% lumi?re

% modele Th: V_arret = h * (v - v_seuil) / q_e = (h * v / q_e) - (W / q_e)
% ou v = c / lambda est la frequence de la lumiere emise, v_seuil est la
% frequence seuil, W le travail d'extraction et q_e la charge de l'?lectron
c = 299792458; % m/s
q_e = -1.602176620 * 10^-19; % C
freq = c./lambda; % Hz
lmdl = linearRegr([freq; V_arret]);
h = lmdl.a * q_e;
W = -lmdl.b * q_e;
hreel = 6.62607015 * 10^-34; %pour calculer l'erreur relative
erreur = (hreel - h) / hreel;

fprintf('Les coefficients de la doite sont: a = %e et b = %e \n', lmdl.a, lmdl.b);
fprintf('Valeur de l''estimation de la constante de Planck : %e Js \n', h);
fprintf('Erreur relative ( vraie valeur de h etant %e) : %e \n', hreel, erreur);
fprintf('Coefficient de correlation de la regression utilis?e pour trouver h : %f \n', sqrt(lmdl.Rsquared()));
fprintf('Valeur de l''estimation du travail d''extraction : %e J \n', W);
fprintf('\t W = %e eV \n', W / abs(q_e));
%%
%Graphiques
figure;
set(0,'defaultaxesfontsize',15);
set(0,'defaulttextfontsize',15);
set(0,'defaultlinelinewidth',1);
plot(freq, V_arret);
axis([6e14 7.5e14 -2 0]);
title('Potentiel d''arret en fonction de la frequence de la lumiere');
xlabel('Frequence (en Hz)');
ylabel('Potentiel d''arret (en V)');

figure;
plot(DiffPotentiel1, Courant1 * 10^12, DiffPotentiel2, Courant2 * 10^12, DiffPotentiel3, Courant3 * 10^12);
axis([-2 18 0 1.5]);
title(['Intensite du photocourant en fonction de la difference de', 'potentiel appliquee a intensite lumineuse fixe']);
xlabel('Difference de potentiel (en V)');
ylabel('Intensite du photocourant (en pA)');
legend('400 nm', '450 nm', '500 nm', 'location', 'southeast');

figure;
plot(Intensite, Vstop);
axis([2 12 -2 0]);
title(['Potentiel d''arret en fonction de l''intensite lumineuse', 'pour une longueur d''onde fixee (400 nm)']);
xlabel('Tension alimentant la source lumineuse (en V)');
ylabel('Potentiel d''arret (en V)');