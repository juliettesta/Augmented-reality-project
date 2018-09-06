function [] = DetectionModele(myFrame, seuil, nom)

% Sélection d'une zone plus petite
[x,y] = ginput(2);
l1 = fix(y(1));
l2 = fix(y(2));
c1 = fix(x(1));
c2 = fix(x(2));
newFrame= myFrame(l1: l2, c1: c2, 1:3);
image(newFrame)
% Sélection d'une zone d'intêret
[x,y] = ginput(2);
l1 = fix(y(1));
l2 = fix(y(2));
c1 = fix(x(1));
c2 = fix(x(2));
newFrame= newFrame(l1: l2, c1: c2, 1:3);
image(newFrame)
newFrame = double(newFrame);

%Calcul des matrices RVB
R=newFrame(:,:,1);
G=newFrame(:,:,2);
B=newFrame(:,:,3);
%Calcul de la moyenne de tous les pixels de newFrame par couleur RGB
mr=mean(R(:));
mg=mean(G(:));
mb=mean(B(:));
%Matrice de covariance
c11 = sum(sum((R-mr).^2)); % 2 sum pour sommer les lignes et les colonnes
c12 = sum(sum((R-mr).*(G-mg)));
c13 = sum(sum((R-mr).*(B-mb)));
c21 = c12;
c22 = sum(sum((G-mg).^2));
c23 = sum(sum((G-mg).*(B-mb)));
c31 = c13;
c32 = c23;
c33 = sum(sum((B-mb).^2));
N= size(newFrame,1)* size(newFrame,2);
MatCov = [c11 c12 c13; c21 c22 c23; c31 c32 c33].*(1/N);

% Distance de Segmentation : Mahalanobis
moy = [mr mg mb];
Dmaha = Mahalanobis(myFrame,moy,MatCov);

%Tests des seuils
ImSeuil = Seuillage(seuil,Dmaha);
figure, imagesc(ImSeuil), colorbar
colormap(gray)

save(nom,'moy','MatCov','seuil');
end

