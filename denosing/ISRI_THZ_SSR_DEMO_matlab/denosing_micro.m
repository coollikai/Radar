%����ȥ�룬���״�����Ĺ̶��㣨�̶������Ľ������ʣ����߸ܡ������ӵȣ�ȥ��
function [x, y] = denosing_micro( x_t, y_t )%����Ŀǰ�Ĵ����Ķ���x��yӦ����һά���飬single���ͣ�Ҫ��һ��ʱ���ڲ����ĵ�ȥ��
global int xycontainer2;%�����洢xy����ʱ���������xy���ظ�5�μ���������Ϊ�Ƕ���
global int xyindex;
global int nodecountforone;
global int nodedeviation;
x = x_t;
y = y_t;
%������һ��������
% if(xyindex ~= 6)%xycontainer��û������xy����ȥ��ͷ���ԭxy
%     xycontainer(2*int8(xyindex) - 1,1:length(x)) = x;
%     xycontainer(2*int8(xyindex) - 1,length(x)+1:nodecountforone) = 0;
%     xycontainer(2*int8(xyindex),1:length(y)) = y;
%     xycontainer(2*int8(xyindex) - 1,length(y)+1:nodecountforone) = 0;
%     X = x;
%     Y = y;
%     xyindex = xyindex + 1;
%     return;
% end


%���Ҷ����Ƿ����������ظ��Ĵ���
xycounts = length(x);
count = zeros(1, xycounts);
for i= 1:xycounts %���ж�xy��xycontainer���ظ��Ĵ���
    for j=1:10     %��ʾ���ж�xycontainer������洢��
        for k=1:nodecountforone
            if (abs(xycontainer2(2*j-1,k) - x(i)) < nodedeviation && abs(xycontainer2(2*j,k) - y(i)) < nodedeviation)
                count(i) = count(i) + 1;
            end
        end
    end
end

% disp(count);


%��������
xycontainer_2 = xycontainer2;%�����ȷŵ������е�xy��ֵ������9��10��
xycontainer2(1:98,:) = xycontainer_2(3:100,:);
%circshift(xycontainer,8);%��仰������
xycontainer2(99,1:length(x)) = x;
xycontainer2(99,length(x)+1:nodecountforone) = 0;
xycontainer2(100,1:length(y)) = y;
xycontainer2(100,length(y)+1:nodecountforone) = 0;

for i = xycounts:-1:1%��β�Ϳ�ʼɾ���������鳤��������
    if (count(i) > 3)
        x(i) = [];
        y(i) = [];
    end
end
return;