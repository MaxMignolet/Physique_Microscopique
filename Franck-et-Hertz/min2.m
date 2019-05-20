function [M, I] = min2(tab)

i = 1;
for k = 3 : length(tab - 2)
    if (tab(k-2) >= tab(k-1)) && (tab(k-1) > tab(k)) && ...
        (tab(k) < tab(k+1)) && tab(k+1) <= tab(k+2)
        M(i) = tab(k);
        I(i) = k;
        i = i + 1;
    end
end

end