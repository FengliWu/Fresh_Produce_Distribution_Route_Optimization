%% 适应度函数
function [allcost,fit,cost2,cost5,cost4,cost3]=fit(distance,demand,chrom,ET1,LT1,ET2,LT2,ST,CarDistance,CarLoad,speed,fitmax,H,F,c2,CarNum)
% distance          城市距离矩阵
% demand            城市的需求量矩阵
% chrom             变更后的初始种群
% ET                最早服务时间
% LT                最晚服务时间
% CE                早到惩罚系数
% CL                晚到惩罚系数
% NP                种群数量
% CarDistance       单车最大行驶距离
% CarLoad           车辆最大载货量
% fit               适应度
% fitmax            一个很大的值替代适应度
% N                 初始个体长
global lmt1 lmt2 cew clw P1 beta R S dT Cr Vk alpha c0 w e0 rou0 rou1
Qk1 = (1 + beta) * R * S * dT;
Qk2 = (0.54 * Vk + 3.22 ) * dT * alpha;
[NP,N]=size(chrom);
for i=1:NP
    cost = 0;                       % 整个路径的所有成本
    cost2 = 0;                      % 油耗总成本
    cost3 = 0;                      % 惩罚成本
    cost4 = 0;                      % 货损成本
    cost5 = 0;                      % 制冷总成本
    cost6 = 0;                      % 碳排放成本
    
    C41 = 0;
    C42 = 0;
    C6 = 0; 
    C3 = 0;                         % 子路径惩罚成本
    Kcar=1;
    driveDistance=0;                % 汽车已经行驶的距离
    delivery=0;                     % 汽车已经送货量，即已经到达点的需求量之和
    tsi = 0;
    nowTime=ET1(1);                 % 当前时刻
    route=chrom(i,:);
    
    % 计算车装载量
    Qi = 0;
    for k = 2 : N
        Qi = Qi + demand(route(k));
        if route(k)==1&&route(k-1)>1 % 如果该点是配送中心
            break
        end
    end
    
    for l1=2:N
        driveDistance=driveDistance+distance(route(l1-1),route(l1));
        delivery=delivery+demand(route(l1));
        [nowTime,punish]=timepunish(ET1,LT1,ET2,LT2,route,distance(route(l1-1),route(l1)),l1,speed(route(l1-1),route(l1)),nowTime,H,cew,clw,P1,demand);
        Qi = Qi - demand(route(l1));                                            % 装载量
        rho = rou0 + (rou1 - rou0) / CarLoad * Qi;                              % 单位距离总油耗
        C2 = driveDistance * rho * c2;                                          % 油耗成本
        C3 = C3 + punish;                                                       % 时间惩罚成本
        C41 = C41 + P1 * demand(route(l1)) * (1 - exp(- lmt1 * (nowTime - ET1(1)))) ;
        C42 = C42 + P1 * Qi * (1 - exp(- lmt2 * ST(route(l1))));
        nowTime = nowTime + ST(route(l1));                                      % 加上第j个节点的服务时间
        tsi = tsi + ST(route(l1));
        C5a = Cr * Qk1 * driveDistance / speed(route(l1-1),route(l1));          % 制冷剂费用
        C5b = Cr * Qk2 * tsi;
        C6 = C6 + c0 * distance(route(l1-1),route(l1)) * (e0 * rho + w * Qi);	% 碳排=碳税*距离*（碳排放系数*油耗+单位载重制冷碳排放*车载量）
        
        if driveDistance>CarDistance||delivery>CarLoad
            cost=fitmax;
            break;
        end
        if route(l1) == 1&&route(l1-1)>1
            cost = cost + F + C2 + C41 + C42 + C5a + C5b + C6 + C3;
            cost2 = cost2 + C2;
            cost3 = cost3 + C3;
            cost4 = cost4 + C41 + C42;
            cost5 = cost5 + C5a + C5b;
            cost6 = cost6 + C6;
            Kcar=Kcar+1;
        if Kcar<=CarNum+1
            cost=cost+0;
        else
            cost=cost+1000000;
        end
            % 计算车装载量
            Qi = 0;
            for k = l1+1 : N
                Qi = Qi + demand(route(k));
                if route(k)==1&&route(k-1)>1    % 如果该点是配送中心
                    break
                end
            end
            %
            driveDistance=0;
            delivery=0;
            tsi = 0;
            nowTime=ET1(1);
            C6 = 0;
            C3 = 0;
            C41 = 0;
            C42 = 0;
            Qi = 0;
        end
    end
    allcost(i) = cost;
    fit(i) = 1 / allcost(i);
end

