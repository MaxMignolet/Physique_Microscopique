%%
%recherche des minima locaux
%prend en entree un vecteur X qui est un echantillon d'une fonction
%renvoie les valeurs des minimas locaux ainsi que leurs indices
function [M, I] = findMin(X)

k=1;

for i=2:length(X)-1
    if(and(X(i) < X(i-1), X(i) < X(i+1)))
        M(k) = X(i);
        I(k) = i;
        k = k + 1;
    end
end

end