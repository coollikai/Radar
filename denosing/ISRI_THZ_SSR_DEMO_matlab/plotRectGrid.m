 %设置速度坐标图的图案
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function []=plotRectGrid(maxRange, maxSpeed)

r = linspace(0,maxRange,10); 
s = linspace(-maxSpeed,maxSpeed,10); 
  
for n=1:length(r)
    rn = r(n)*[1 1]; 
    rs = [-maxSpeed maxSpeed];
    plot(rn,rs,'color',[0.5 0.5 0.5], 'linestyle', ':')
end


for n=1:length(s)
    rn = [0 maxRange]; 
    rs = s(n)*[1 1];
    plot(rn,rs,'color',[0.5 0.5 0.5], 'linestyle', '--')
end
    
return
