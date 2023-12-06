%% 时间惩罚函数
function [nowTime,punish]=timepunish(ET1,LT1,ET2,LT2,route,partdistance,j,partspeed,nowTime,H,cew,clw,P1,demand)
% ET                节点时间窗最早时间
% LT                节点时间窗最晚时间
% route             路径
% partDistance      由一个城市到达另一个城市之间的路程
% speed             车辆平均速度
% nowTime           前个节点的到达时间
nowTime=nowTime+partdistance/partspeed;
earlyPunish=0;
latePunish=0;
punish = 0;
if nowTime < ET2(route(j)) || nowTime>LT2(route(j))
    punish = H;
% 提前到达
elseif nowTime<ET1(route(j))       
    dT = (ET1(route(j))-nowTime);
    earlyPunish= dT * cew * P1 * demand(route(j));
% 延迟到达
elseif nowTime>LT1(route(j))        
    dT = nowTime-LT1(route(j));
    latePunish= dT * clw * P1 * demand(route(j));
else
    earlyPunish=0;
    latePunish=0;
end
punish=punish + earlyPunish+latePunish;
