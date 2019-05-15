%%%%%%%%%%%%
%Unites SI %
%%%%%%%%%%%%
%%
clc
clear workspace
%declaration des constantes
NB_GOUTTES = 17;
d = 10^(-3); % 1mm (3graduations)
rho_h = 1075; %masse volumique huile
rho_a = 1.293; %masse volumique air
g = 9.81; %acceleration gravifique
eta = 1.82*10^(-5); %viscosite dynamique de l'air a temp ambiante
U = 128.7; %tension aux bornes du condensateur
l = 2.5*10^(-3); %distance entre les deux plans du condensateur
%%
%convention:
%   1ere ligne: temps affiche sur chronometre de gauche
%   2eme ligne: temps affiche sur chronometre de droite
%   exemple: T{i} = {[23 45 80 112]; [34 65 93 134]}
%   on utilise des cells pour permettre des tableaux de longueurs
%   differentes


T = {
    {[22 44 65 87 109 131 152 172]; [70 142 221 298 368 443 525 609]};
    {[51 98 146 184 242 289 337 386 435 485 533 582 630 679 730]; [32 64 97 127 159 190 222 255 287 313 351 383 415 447 478]};
    {[19 42 63 86 109 130 158]; [26 53 79 106 133 161 187]};
    {[10 19 28 38]; [10 20 30 43]};
    {[14 27 42 57 71 86]; [16 31 47 64 81 97]};
    {[18 36 54 71 88 106 125 142 160 177 196 214 232 250 269 288 309 329 349 368 386 405 425]; [20 41 63 84 103 124 145 167 188 208 231 253 274 296 318 339 362 387 411 434 457 480 503]}; %celle-ci est endurante(je sais pas si ca ce dis
    {[28 55 83 110 137 164 190 217 244 272 300 328 355 381 407]; [32 66 99 133 167 201 234 268 303 336 371 406 440 473 506]};
    {[66 130 191 255 321 384 447 516]; [34 160 284 419 559 702 844 979]};
    {[58 116 176 237 303 365 426 487 549 612 670]; [41 83 127 168 211 251 295 338 380 421 461]};
    {[24 49 72 96 118 142 164 189]; [30 61 90 120 149 176 206 236]};
    {[23 48 72 95 119 143 166 191 215 239 263 286 310]; [34 68 102 137 171 205 239 274 310 343 378 413 447]};
    {[44 91 135 182 228 273 320 366 411 456 505 552 598 644 692 739 789 837 887]; [35 68 102 138 171 205 241 277 310 346 382 416 450 483 516 551 586 622 658]};
    {[26 48 70 92 115 138 164 186 208 231 254 278 300 323 345 369]; [20 39 57 76 95 114 135 154 173 192 212 230 249 268 288 309]};
    {[38 76 114 152 188 222 257 295 331 367]; [47 97 148 199 252 305 355 406 458 511]};
    {[34 69 102 137 171 206 239 271 302 333 366]; [29 57 85 112 140 166 196 222 248 273 302]};
    {[28 55 82 110 138 166 194 222 251 279 306 336 366 396 429 459 500]; [30 62 93 125 159 194 229 265 303 343 380 416 457 500 544 593 664]};
    {[15 31 46]; [14 28 39]}
    };
%conversion de decisecondes en secondes
for i=1:NB_GOUTTES
    T{i}{1} = T{i}{1} * 0.1;
    T{i}{2} = T{i}{2} * 0.1;
end
%obtention des vitesses moyennes:
q = zeros(NB_GOUTTES, 1);
v = cell(NB_GOUTTES, 2);
v_mean = zeros(2, NB_GOUTTES);
for i=1:NB_GOUTTES
    %vitesse chrono gauche
    v{i}{1}(1) = d / T{i}{1}(1);
    for j=2:length(T{i}{1})
        v{i}{1}(j) = d / (T{i}{1}(j) - T{i}{1}(j-1));
    end
    %vitesse chrono droite
    v{i}{2}(1) = d / T{i}{2}(1);
    for j=2:length(T{i}{2})
        v{i}{2}(j) = d / (T{i}{2}(j) - T{i}{2}(j-1));
    end
    v_mean(1, i) = mean(v{i}{1});
    v_mean(2, i) = mean(v{i}{2});
    q(i) = (9 * pi * l * eta^(3/2) * (v_mean(1, i) + v_mean(2, i)) * sqrt(abs(v_mean(1, i) - v_mean(2, i)))) / (2 * sqrt(rho_h - rho_a) * g * U);
end
v_mean = sort(v_mean', 2);
display(v_mean); %a rajouter ds le LaTeX
q = sort(q);
display(q);
X = 1:NB_GOUTTES;

%graphique
figure;
set(0,'defaultaxesfontsize',15)
set(0,'defaulttextfontsize',15)
scatter(X, q);
hold on
discr = [2.72E-19 3.61E-19 4.695E-19 5.79E-19];
set(0,'defaultlinelinewidth',1)
for k=1:4
    plot([0 17], [discr(k) discr(k)]);
end
hold off
title('Charge electrique de chaque goutte');
ylabel('Charge electrique (en C)');
axis([1 17 0 1.5E-18]); 

%Z = q / (1.6E-19);
%display(Z);
%nbZ = [1 2 3 3 4 4 4 4 4 5 6 7 8 8 8 9 10];
%scatter(nbZ, q);

%%
%determination de la charge elementaire
e = 1E-20:1E-25:2.5E-19;
res = zeros(length(e), 1);
for i=1:length(e)
    res(i) = objFunc(q, e(i));
end

figure();
set(0,'defaultaxesfontsize',15);
set(0,'defaulttextfontsize',15);
plot(e, res);
title(['Somme des carres des residus', 'en fonction de l''approximation q']);
xlabel('Approximation q (en C)');
ylabel('Somme des carr?s des r?sidus S(q)');
hold on
plot([0.886e-19 0.886e-19], [0 1.2e-37]);
plot([1.175e-19 1.175e-19], [0 1.2e-37]);
plot([1.556e-19 1.556e-19], [0 1.2e-37]);
plot([1.786e-19 1.786e-19], [0 1.2e-37]);
hold off
[M, I] = findMin(res);
%display(e(I));

figure;
subplot(2, 2, 1);
scatter(X, q);
title('q = 0.885517E-19 C'); 
ylabel('Charge ?lectrique (en C)');
hold on
for k=1:16
    plot([0 17], k * [0.886e-19 0.886e-19]);
end
hold off

subplot(2, 2, 2);
scatter(X, q);
title('q = 1.175083E-19 C'); 
ylabel('Charge ?lectrique (en C)');
hold on
for k=1:12
    plot([0 17], k * [1.175e-19 1.175e-19]);
end
hold off

subplot(2, 2, 3);
scatter(X, q);
title('q = 1.555994E-19 C'); 
ylabel('Charge ?lectrique (en C)');
hold on
for k=1:9
    plot([0 17], k * [1.556e-19 1.556e-19]);
end
hold off

subplot(2, 2, 4);
scatter(X, q);
title('q = 1.776399E-19 C'); 
ylabel('Charge ?lectrique (en C)');
hold on
for k=1:8
    plot([0 17], k * [1.786e-19 1.786e-19]);
end
hold off
%sgtitle('Repr?sentations des paliers pour diff?rentes approximation q',
%'FontSize', 30); %seulement possible pour les nouvelles verions de matlab


