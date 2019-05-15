%%
%fonction additionnelle afin d'alleger le code
%recoit en entree la charge de chaque goutte 
%et une estimation e de la charge elementaire
%determine pour chaque goutte de charge q_i le nombre k_i t.q. 
%abs(q_i - k_i * e) est minimis? (i.e. determine le nombre d'electrons
%arraches a la goutte en supposant que e est la charge d'un electron)
%renvoie ensuite la somme des carres des residus
%i.e. sum_i (q_i - k_i * e)^2
function res = objFunc(q, e)

len = length(q);
k = zeros(len, 1);

for i=1:len
    k(i) = int16(q(i) / e);
end

res = 0;
for i=1:len
    res = res + (q(i) - k(i) * e)^2;
end

end