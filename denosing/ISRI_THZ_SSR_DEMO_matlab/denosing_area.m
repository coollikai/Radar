%�����������ȷ��һЩ�㾭�����ֵ�λ�ã��ø������ٳ��־�̬��
function [ x, y ] = denosing_area( detObj )
global int staticarea;%����ȷ����̬������Ķ�ά����
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
%ͳ�ƶ�����area�������ظ��Ĵ���
xycounts = length(x);
for i= 1:xycounts %���ж�xy��xycontainer���ظ��Ĵ���
    if(v(i)==0)   %����õ�ƥ����ٶ�Ϊ0���������ڵľ�̬������ָ������1
       xindex=int16(floor( x(i)/maxX*arealen ));
       yindex=int16(floor( y(i)/maxY*arealen ));
       staticarea( xindex+50, yindex) = staticarea( xindex+50, yindex) +1;
    end
end

%ͳ�ƶ�����micro�������ظ��Ĵ���
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


%����micro����
xycontainer_2 = xycontainer2;%�����ȷŵ������е�xy��ֵ������9��10��
xycontainer2(1:98,:) = xycontainer_2(3:100,:);
%circshift(xycontainer,8);%��仰������
xycontainer2(99,1:length(x)) = x;
xycontainer2(99,length(x)+1:nodecountforone) = 0;
xycontainer2(100,1:length(y)) = y;
xycontainer2(100,length(y)+1:nodecountforone) = 0;

for i = xycounts:-1:1%��β�Ϳ�ʼɾ���������鳤��������
%     if ( v(i) == 0 )  %���ٶ�Ϊ0���ͽ���ɾ��������ٶȲ�Ϊ0˵�����Ƕ���
        xindex=floor( x(i)/maxX*arealen );
        yindex=floor( y(i)/maxY*arealen );
        if ( staticarea( xindex +50, yindex) > 20 ) %��������ڵ�����ָ������20��ֱ��ɾ��
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

