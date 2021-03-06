%这个函数用来确定一些点经常出现的位置，让该区域不再出现静态点
function [ x, y ] = denosing_area( detObj )
global int staticarea;%用来确定静态点区域的二维数组
global int xycontainer2;
global int arealen;
global int nodecountforone;
global int nodedeviation;
% global maxX;
% global maxY;
maxX=30;
maxY=30;
x = detObj.x;
y = detObj.y;
v = detObj.doppler;
%统计定点在area容器中重复的次数
xycounts = length(x);
for i= 1:xycounts %逐步判断xy在xycontainer中重复的次数
    if(v(i)==0)   %如果该点匹配的速度为0，则将其所在的静态点区域指数自增1
       xindex=int16(floor( x(i)/maxX*arealen ));
       yindex=int16(floor( y(i)/maxY*arealen ));
       staticarea( xindex+50, yindex) = staticarea( xindex+50, yindex) +1;
    end
end

%统计定点在micro容器中重复的次数
count = zeros(1, xycounts);
for i= 1:xycounts %逐步判断xy在xycontainer中重复的次数
    for j=1:10     %表示逐步判断xycontainer的五个存储层
        for k=1:nodecountforone
            if (abs(xycontainer2(2*j-1,k) - x(i)) < nodedeviation && abs(xycontainer2(2*j,k) - y(i)) < nodedeviation)
                count(i) = count(i) + 1;
            end
        end
    end
end

% disp(count);


%更新micro容器
xycontainer_2 = xycontainer2;%把最先放到容器中的xy数值调整到9、10行
xycontainer2(1:98,:) = xycontainer_2(3:100,:);
%circshift(xycontainer,8);%这句话不好用
xycontainer2(99,1:length(x)) = x;
xycontainer2(99,length(x)+1:nodecountforone) = 0;
xycontainer2(100,1:length(y)) = y;
xycontainer2(100,length(y)+1:nodecountforone) = 0;

for i = xycounts:-1:1%从尾巴开始删，否则数组长度有问题
%     if ( v(i) == 0 )  %若速度为0，就进行删除，如果速度不为0说明不是定点
        xindex=floor( x(i)/maxX*arealen );
        yindex=floor( y(i)/maxY*arealen );
        if ( staticarea( xindex +50, yindex) > 20 ) %如果点所在的区域指数超过20，直接删除
            x(i) = [];
            y(i) = [];
        else
            if (count(i) > 3)
                x(i) = [];
                y(i) = [];
            end
        end
%     end
end
return;

