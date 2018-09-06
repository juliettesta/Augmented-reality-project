function [matDistanceBarys]=calculDistancesBarys(xBarys1, yBarys1, xBarys2, yBarys2)

nBLabels = numel(xBarys2);
for j=1: nBLabels
    for i=1:4
        matDistanceBarys(i,j) = (yBarys2(j)-yBarys1(i))^2 + (xBarys2(j)-xBarys1(i))^2;
    end
end
