
 %配置方位图扇形显示
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function []=plotSemiCircularGrid(R)

if (R/4 <=2)
        range_grid_arc = 0.1;
elseif (R<=2)
    range_grid_arc = 0.05;
elseif (R<=4)
    range_grid_arc = 0.15;
elseif (R<=20)
    range_grid_arc = 1;
elseif (R<=24)
    range_grid_arc = 1.2;
else
    range_grid_arc = 2;
end

sect_width=pi/12;  
offset_angle=pi/6:sect_width:5*pi/6;
r=[0:range_grid_arc:R];
w=linspace(pi/6,5*pi/6,128);

for n=2:length(r)
    plot(real(r(n)*exp(1j*w)),imag(r(n)*exp(1j*w)),'color',[0.5 0.5 0.5], 'linestyle', ':')
end


for n=1:length(offset_angle)
    plot(real([0 R]*exp(1j*offset_angle(n))),imag([0 R]*exp(1j*offset_angle(n))),'color',[0.5 0.5 0.5], 'linestyle', ':')
end
return
