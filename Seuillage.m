function [ ImSeuil ] = Seuillage( seuil, newFrame)
    ImSeuil =  newFrame;
    for i = 1:size(newFrame,1)
        for j = 1:size(newFrame,2)
            if (newFrame(i,j) < seuil)
                ImSeuil(i,j) =1;
            else
                ImSeuil(i,j) =0;
            end
            
        end
    end
end
