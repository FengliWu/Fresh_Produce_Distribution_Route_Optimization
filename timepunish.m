%% ʱ��ͷ�����
function [nowTime,punish]=timepunish(ET1,LT1,ET2,LT2,route,partdistance,j,partspeed,nowTime,H,cew,clw,P1,demand)
% ET                �ڵ�ʱ�䴰����ʱ��
% LT                �ڵ�ʱ�䴰����ʱ��
% route             ·��
% partDistance      ��һ�����е�����һ������֮���·��
% speed             ����ƽ���ٶ�
% nowTime           ǰ���ڵ�ĵ���ʱ��
nowTime=nowTime+partdistance/partspeed;
earlyPunish=0;
latePunish=0;
punish = 0;
if nowTime < ET2(route(j)) || nowTime>LT2(route(j))
    punish = H;
% ��ǰ����
elseif nowTime<ET1(route(j))       
    dT = (ET1(route(j))-nowTime);
    earlyPunish= dT * cew * P1 * demand(route(j));
% �ӳٵ���
elseif nowTime>LT1(route(j))        
    dT = nowTime-LT1(route(j));
    latePunish= dT * clw * P1 * demand(route(j));
else
    earlyPunish=0;
    latePunish=0;
end
punish=punish + earlyPunish+latePunish;
