
%����ȥ�룬���״�����Ĺ̶��㣨�̶������Ľ������ʣ����߸ܡ������ӵȣ�ȥ��

function [x, y] = denosing_static( x_t, y_t )%����Ŀǰ�Ĵ����Ķ���x��yӦ����һά���飬single���ͣ�Ҫ��һ��ʱ���ڲ����ĵ�ȥ��
global int xycontainer;%�����洢xy����ʱ���������xy���ظ�5�μ���������Ϊ�Ƕ���
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


%���Ҷ����Ƿ����������ظ������
xycounts = length(x);
count = zeros(1, xycounts);
for i= 1:xycounts %���ж�xy��xycontainer���ظ��Ĵ���
    for j=1:10     %��ʾ���ж�xycontainer������洢��
        for k=1:nodecountforone
            if (xycontainer(2*j-1,k) == x(i) && xycontainer(2*j,k) == y(i))
                count(i) = count(i) + 1;
            end
        end
    end
end

% disp(count);


%��������
xycontainer_2 = xycontainer;%�����ȷŵ������е�xy��ֵ������9��10��
xycontainer(1:18,:) = xycontainer_2(3:20,:);
%circshift(xycontainer,8);%��仰������
xycontainer(19,1:length(x)) = x;
xycontainer(19,length(x)+1:nodecountforone) = 0;
xycontainer(20,1:length(y)) = y;
xycontainer(20,length(y)+1:nodecountforone) = 0;

for i = xycounts:-1:1%��β�Ϳ�ʼɾ���������鳤��������
    if (count(i) > 5)
        x(i) = [];
        y(i) = [];
    end
end

return;