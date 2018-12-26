%定点去噪，把雷达监测出的固定点（固定不动的金属物质：电线杠、铁箱子等）去除
function [x, y] = denosing_micro( x_t, y_t )%根据目前的代码阅读，x和y应该是一维数组，single类型，要把一定时间内不动的点去除
global int xycontainer2;%用来存储xy的暂时容器，如果xy点重复5次及其以上认为是定点
global int xyindex;
global int nodecountforone;
global int nodedeviation;
x = x_t;
y = y_t;
%下面这一端有问题
% if(xyindex ~= 6)%xycontainer都没满，把xy填充进去后就返回原xy
%     xycontainer(2*int8(xyindex) - 1,1:length(x)) = x;
%     xycontainer(2*int8(xyindex) - 1,length(x)+1:nodecountforone) = 0;
%     xycontainer(2*int8(xyindex),1:length(y)) = y;
%     xycontainer(2*int8(xyindex) - 1,length(y)+1:nodecountforone) = 0;
%     X = x;
%     Y = y;
%     xyindex = xyindex + 1;
%     return;
% end


%查找定点是否在容器中重复的次数
xycounts = length(x);
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


%更新容器
xycontainer_2 = xycontainer2;%把最先放到容器中的xy数值调整到9、10行
xycontainer2(1:98,:) = xycontainer_2(3:100,:);
%circshift(xycontainer,8);%这句话不好用
xycontainer2(99,1:length(x)) = x;
xycontainer2(99,length(x)+1:nodecountforone) = 0;
xycontainer2(100,1:length(y)) = y;
xycontainer2(100,length(y)+1:nodecountforone) = 0;

for i = xycounts:-1:1%从尾巴开始删，否则数组长度有问题
    if (count(i) > 3)
        x(i) = [];
        y(i) = [];
    end
end
return;