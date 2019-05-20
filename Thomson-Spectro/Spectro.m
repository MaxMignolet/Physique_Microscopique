%%%%%%%%%%%%
%Unites SI %
%%%%%%%%%%%%
%%
%clc
clear workspace
clear variables
set(0,'defaultaxesfontsize',15)
set(0,'defaulttextfontsize',15)
set(0,'defaultlinelinewidth',2)
%%
%dans cette section tout les angles sont en degres
%ils seront convertis en radian dans la section suivante
ctr_angle = 263.4; %raie centrale
a100 = 1e-3 / 100; %largeur fente pour 100 traits par mm
a700 = 1e-3 / 700; %largeur fente pour 700 traits par mm

%ordre de diffraction; largeur fente; angle de diffraction
dark_blue = [
    [1 a100 266.2]
    [-1 a100 260.5]
    [2 a100 269.1]
    [-2 a100 257.7]
    [1 a700 282]
    [-1 a700 244.1]
    ];

light_blue = [
    [1 a100 266.2]
    [-1 a100 260.5]
    [2 a100 269.4]
    [-2 a100 257.3]
    [1 a700 282.4]
    [-1 a700 243.6]
    ];

green = [
    [1 a100 266.4]
    [-1 a100 260.4]
    [1 a700 283.7]
    [-1 a700 242.4]
    ];

red = [
    [1 a100 267.3]
    [-1 a100 259.6]
    [1 a700 289.3]
    [-1 a700 236.4]
    ];

%%
%angles relatifs au centre en radian
dark_blue(:, 3) = (dark_blue(:, 3) - ctr_angle) * (2*pi) / 360;
light_blue(:, 3) = (light_blue(:, 3) - ctr_angle) * (2*pi) / 360;
green(:, 3) = (green(:, 3) - ctr_angle) * (2*pi) / 360;
red(:, 3) = (red(:, 3) - ctr_angle) * (2*pi) / 360;

%%
%determination des longueurs d'onde
%sin theta = n lambda / a
y = sin(dark_blue(:, 3));
x = dark_blue(:, 1) ./ dark_blue(:, 2);
lmdl_dark_blue = linearRegr([x'; y']);
lmdl_dark_blue.scatteredPlot();
fprintf('Longueur d''onde de la raie bleu fonce: %f nm\n', lmdl_dark_blue.a * 10^9);

y = sin(light_blue(:, 3));
x = light_blue(:, 1) ./ light_blue(:, 2);
lmdl_light_blue = linearRegr([x'; y']);
lmdl_light_blue.scatteredPlot();
fprintf('Longueur d''onde de la raie bleu clair: %f nm\n', lmdl_light_blue.a * 10^9);

y = sin(green(:, 3));
x = green(:, 1) ./ green(:, 2);
lmdl_green = linearRegr([x'; y']);
lmdl_green.scatteredPlot();
fprintf('Longueur d''onde de la raie verte: %f nm\n', lmdl_green.a * 10^9);

y = sin(red(:, 3));
x = red(:, 1) ./ red(:, 2);
lmdl_red = linearRegr([x'; y']);
lmdl_red.scatteredPlot();
fprintf('Longueur d''onde de la raie rouge: %f nm\n', lmdl_red.a * 10^9);

%%
%comparaison des mesures pour n = 1 et n = 2 pour le bleu fonce et bleu
%clair

%separation des donnees en deux groupes (n=1 et n=2)
size_db = size(dark_blue);
size_lb = size(light_blue);
var dark_blue1;
var dark_blue2;
var light_blue1;
var light_blue2;
k = 1;
l = 1;
for i = 1 : size_db(1) %on parcourt les lignes
    switch dark_blue(i, 1)
        case {1, -1}
            dark_blue1(k, 1) = dark_blue(i, 1);
            dark_blue1(k, 2) = dark_blue(i, 2);
            dark_blue1(k, 3) = dark_blue(i, 3);
            k = k + 1;
        case {2, -2}
            dark_blue2(l, 1) = dark_blue(i, 1);
            dark_blue2(l, 2) = dark_blue(i, 2);
            dark_blue2(l, 3) = dark_blue(i, 3);
            l = l + 1;
    end
end

k = 1;
l = 1;
for i = 1 : size_lb(1) %on parcourt les lignes
    switch light_blue(i, 1)
        case {1, -1}
            light_blue1(k, 1) = light_blue(i, 1);
            light_blue1(k, 2) = light_blue(i, 2);
            light_blue1(k, 3) = light_blue(i, 3);
            k = k + 1;
        case {2, -2}
            light_blue2(l, 1) = light_blue(i, 1);
            light_blue2(l, 2) = light_blue(i, 2);
            light_blue2(l, 3) = light_blue(i, 3);
            l = l + 1;
    end
end

%traitement de ces donnees
y = sin(dark_blue1(:, 3));
x = dark_blue1(:, 1) ./ dark_blue1(:, 2);
lmdl_dark_blue1 = linearRegr([x'; y']);
lmdl_dark_blue1.scatteredPlot();
fprintf('Longueur d''onde de la raie bleu fonce de premier ordre: %f nm\n', lmdl_dark_blue1.a * 10^9);

y = sin(dark_blue2(:, 3));
x = dark_blue2(:, 1) ./ dark_blue2(:, 2);
lmdl_dark_blue2 = linearRegr([x'; y']); %besoin de transposer pour avoir des lignes
lmdl_dark_blue2.scatteredPlot();
fprintf('Longueur d''onde de la raie bleu fonce de second ordre: %f nm\n', lmdl_dark_blue2.a * 10^9);

y = sin(light_blue1(:, 3));
x = light_blue1(:, 1) ./ light_blue1(:, 2);
lmdl_light_blue1 = linearRegr([x'; y']);
lmdl_light_blue1.scatteredPlot();
fprintf('Longueur d''onde de la raie bleu clair de premier ordre: %f nm\n', lmdl_light_blue1.a * 10^9);

y = sin(light_blue2(:, 3));
x = light_blue2(:, 1) ./ light_blue2(:, 2);
lmdl_light_blue2 = linearRegr([x'; y']);
lmdl_light_blue2.scatteredPlot();
fprintf('Longueur d''onde de la raie bleu clair de second ordre: %f nm\n', lmdl_light_blue2.a * 10^9);

%%
%generation des graphiques en subplot
fig = figure();
[~, ax] = lmdl_dark_blue.scatteredPlot(fig);
subplot(2, 2, 1, ax);
title('Raie bleu fonc?');
xlabel('Valeur du rapport n/a');
ylabel('sinus de l''angle de diffraction');
[~, ax] = lmdl_light_blue.scatteredPlot(fig);
subplot(2, 2, 2, ax);
title('Raie bleu clair');
xlabel('Valeur du rapport n/a');
ylabel('sinus de l''angle de diffraction');
[~, ax] = lmdl_green.scatteredPlot(fig);
subplot(2, 2, 3, ax);
title('Raie verte');
xlabel('Valeur du rapport n/a');
ylabel('sinus de l''angle de diffraction');
[~, ax] = lmdl_red.scatteredPlot(fig);
subplot(2, 2, 4, ax);
title('Raie rouge');
xlabel('Valeur du rapport n/a');
ylabel('sinus de l''angle de diffraction');