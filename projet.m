% -------------PARTIE II--------------- %
clear all;
close all;

v = VideoReader('H:\Traitement du Signal\Projet\vid_in.mp4');
nbrFrames = v.NumberOfFrames;

%chargement de la vidéo à incruster
vl = VideoReader('H:\Traitement du signal\Projet\Lion2.mp4');

%Récupération des données 
m1=load('Modele_Seuil','moy','MatCov','seuil');
m2=load('Modele_Main','moy','MatCov','seuil');

%Ouverture de la vidéo
NewVideo = VideoWriter('NewVideo.avi','Uncompressed AVI');
NewVideo.FrameRate = 25;
open(NewVideo)


for i= 1:nbrFrames
    myFrame=read(v,i);% lecture de l'image i de la vidéo
    % Distance de Segmentation : Mahalanobis
    Dmaha = Maha_Fast(myFrame,m1.moy,m1.MatCov);
    %image seuillée
    ImSeuil = Seuillage(m1.seuil,Dmaha);

    %Labelisation
    [labels, nbLabels] = bwlabeln (ImSeuil);

    %Calcul des barycentres pour chaque label
    bary = Barycentre(labels,nbLabels);

    if i==1

        %On ordonne les labels manuellement
        xbary1 = bary(1,1);
        ybary1 = bary (2,1);
        bary(1,1) = bary(1,2);
        bary(2,1) = bary(2,2);
        bary(1,2) = bary(1,4);
        bary(2,2) = bary(2,4);
        bary(1,4) = xbary1;
        bary(2,4) = ybary1;

        %on sauvegarde les coordonnées des barycentres de la 1ère image
        %pour calculer la matrice des distances des barycentres entre la
        %1ère image et la 2ème image
        xbaryPrcdnt = bary(1,:);
        ybaryPrcdnt = bary(2,:);

    end       
    %récupère les ordonnées des barycentres
    xbaryPrvsrs = bary(1,:);
    %récupère les abscisses des barycentres
    ybaryPrvsrs = bary(2,:);

    %calcul de la matrice des distances des barycentres
    matDistanceBarys = calculDistancesBarys(xbaryPrcdnt, ybaryPrcdnt, xbaryPrvsrs, ybaryPrvsrs);

    %on sélectionne les distances les plus courtes pour savoir les
    %barycentres de quels labels correspondent aux barycentres 1, 2, 3 et 4
    %de l'image précédente
    matIndex = selectionDistancesBarys(matDistanceBarys);
    
    %on ordonne les barycentres
    xbary(1) = bary(1,matIndex(1,2));
    ybary(1) = bary(2,matIndex(1,2));
    xbary(2) = bary(1,matIndex(2,2));
    ybary(2) = bary(2,matIndex(2,2));
    xbary(3) = bary(1,matIndex(3,2));
    ybary(3) = bary(2,matIndex(3,2));
    xbary(4) = bary(1,matIndex(4,2));
    ybary(4) = bary(2,matIndex(4,2));

    %on enregistre ces valeurs pour calculer la matrice des distances
    %des barycentres entre cette image et la suivante     
    xbaryPrcdnt = xbary;
    ybaryPrcdnt = ybary;
    
    %chargement de l'image à incruster : ici image de fond (savane)
    myPicture = imread ('savane_seche.jpg');
    
    %chargement de l'image à incruster : ici image de 1er plan(lion)
    %on incruste une vidéo, ainsi on parcourt la vidéo image par image
    myPicture2 = read(vl,999+i);
    blackBg = zeros(720,1280,3);
    
    %on enlève le fond vert et on remplace le vert par du noir
    myPicture3 = chromaKeying (blackBg, myPicture2);

    % Calcul du mask de la main
    % Distance de Segmentation : Mahalanobis MAIN
    DmahaMain = Maha_Fast(myFrame,m2.moy,m2.MatCov);
    % image seuillée MAIN
    ImSeuilMain = Seuillage(m2.seuil,DmahaMain);

    
    %incrustation de l'image avec fond noir, mask de la main
    %ici, on remarque que l'échelle varie à chaque image, cette procédure
    %sera détaillée dans le rapport
    NewImage=motif2frame(myPicture3,myFrame,xbary,ybary,0.6+i*0.002, ImSeuilMain);
    
    %calcul du mask pour le background
    %ce masque nous permettra d'incruster le lion sans le fond vert
    maskLion = zeros(520,576);
    maskLion((NewImage(:,:,1)==0) & (NewImage(:,:,2)==0) & (NewImage(:,:,3)==0))=1;
    
    
    %incrustation de l'image de fond (savane) avec mask
    NewImage=motif2frame(myPicture,myFrame,xbary,ybary,0.81, ImSeuilMain);  
    
    %le mask finalement utilisé est une somme des masques de la main et du
    %lion
    maskFinal = ImSeuilMain+maskLion;
    %incrustation du lion avec mask du fond noir
    Final = motif2frame(myPicture3,NewImage,xbary,ybary,0.6+i*0.002, maskFinal);
    writeVideo(NewVideo,Final);

end

%récupération de la vidéo créée
close(NewVideo);
implay('NewVideo.avi');
save('NewVideo');
