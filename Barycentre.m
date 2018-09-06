function[bary] = Barycentre(matrice,nbLabels)

% création d'une matrice de taille 2*4 remplie de 0
% la taille 2*4 correspond aux coordonnées x et y des 4 barycentres
% attendus
bary = zeros(2,4); 

for i = 1:nbLabels
    sumx = 0;
    sumy = 0;
    [zoney,zonex] = find (matrice == i);% concentration sur la zone i
    size = numel (zonex);%"Nbr pixels" dans ma zone

    for k= 1 : size
        sumx = sumx + zonex(k);
        sumy = sumy + zoney(k);
    end
    
    bary(1,i) = sumx/size;
    bary(2,i) = sumy/size;
end
end
