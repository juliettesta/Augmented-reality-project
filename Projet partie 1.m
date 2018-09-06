% -------------PARTIE I--------------- %
clear all;
close all;

%Chargement de la vid�o
v = VideoReader('H:\Traitement du Signal\Projet\vid_in.mp4');

%Detection du mod�le sur une image
myFrame=read(v,1); % Affiche la premi�re image de la vid�o
image(myFrame)
DetectionModele(myFrame, 500, 'Modele_Seuil');

%Detection du mod�le de la main
myFrame=read(v,70); %Selection de l'image 70 car on y voit la main correctement
image(myFrame)
DetectionModele(myFrame, 30,'Modele_Main');
