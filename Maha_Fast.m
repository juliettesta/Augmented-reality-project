function [DistMaha] = Maha_Fast(myFrame,moy,Matcov)

for i = 1:3 % Ecart � la moyenne (de la s�lection) des valeurs de l'image
    ecartMoy(:,:,i) = double(myFrame(:,:,i))-moy(i);
end

S = size(ecartMoy);
Z = reshape(ecartMoy,[S(1)*S(2),S(3)]);
W = Z*(inv(Matcov));
H = reshape(W,[S(1),S(2),S(3)]);
%Matrice des distances de Mahalanobis
DistMaha=sum(H.*ecartMoy,3);