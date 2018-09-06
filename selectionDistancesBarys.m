function [matIndex]=selectionDistancesBarys(matDistances)
%renvoie une matrice qui associe à chaque barycentre de l'image précédente
%la position (en colonne) du barycentre correspondant dans l'image traitée
[r,c]=size(matDistances);

for j = 1:r
    [m,i] = min(matDistances(j,:));
    matIndex(j,1) = j;
    matIndex(j,2) = i;
        for l = 1:r
            matDistances(l,i)= 1000000;
        end
end

