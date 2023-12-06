%% 输出函数
function OutputResult(distance,demand,route,ET1,LT1,ET2,LT2,ST,CarDistance,CarLoad,speed,fitmax,H,F,c2,Idx,CarNum)
% 输入参数
global lmt1 lmt2 cew clw P1 beta R S dT Cr Vk alpha c0 w e0 rou0 rou1
Qk1 = (1 + beta) * R * S * dT;
Qk2 = (0.54 * Vk + 3.22 ) * dT * alpha; % （0.54*车厢体积+3.22）*环境温度差*开门系数
%%

N=length(route);
disp('最优配送路径为：')
Path=num2str(route(1));
for i=2:N
    Path=[Path,'—>',num2str(Idx(route(i)+1))];
end
disp(Path)

%% 子路径信息计算输出
route=route+1;      % 将配送中心由0改为1
cost = 0;           % 整个路径的所有成本
cost2 = 0;          % 运输总成本
cost3 = 0;          % 惩罚成本
cost4 = 0;          % 货损成本
cost5 = 0;          % 制冷总成本
cost6 = 0;          % 碳排放成本

C41 = 0;
C42 = 0;
C6 = 0;
C3 = 0;             % 子路径惩罚成本
Kcar=1;
driveDistance=0;    % 汽车已经行驶的距离
delivery=0;         % 汽车已经送货量，即已经到达点的需求量之和
tsi = 0;
nowTime=ET1(1);     % 当前时刻
mPath='0';
mTime=num2str(ET1(1));
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
    C41 = C41 + P1 * demand(route(l1)) * (1 - exp(- lmt1 * (nowTime - ET1(1)))) ;
    C42 = C42 + P1 * Qi * (1 - exp(- lmt2 * ST(route(l1))));
    rho = rou0 + (rou1 - rou0) / CarLoad * Qi;
    C6 = C6 + c0 * distance(route(l1-1),route(l1)) * (e0 * rho + w * Qi);
    C5a = Cr * Qk1 * driveDistance / speed(route(l1-1),route(l1));
    C3 = C3 + punish;
    mPath=[mPath,'—>',num2str(Idx(route(l1)))];
    mTime=[mTime,'—',num2str(nowTime)];
    nowTime=nowTime+ST(route(l1)); % 加上第j个节点的服务时间
    tsi = tsi + ST(route(l1));
    Qi = Qi - demand(route(l1));
    C2 =  driveDistance * rho * c2;      % 油耗成本
    C5b = Cr * Qk2 * tsi;
    if driveDistance>CarDistance||delivery>CarLoad
        cost=fitmax;
        break;
    end
    if route(l1)==1&&route(l1-1)>1 % 如果是配送中心
        cost = cost + F + C2 + C3 + C41 + C42 + C5a + C5b + C6;
        cost2 = cost2 + C2;
        cost3 = cost3 + C3;
        cost4 = cost4 + C41 + C42;
        cost5 = cost5 + C5a + C5b;
        cost6 = cost6 + C6;
        disp('----------------------------------------------------------------------------------------------------------------------------')
        fprintf('第 %d 辆车：行驶路程为 %.3f,载重量为 %f \n行驶路径为 %s \n',Kcar,driveDistance,delivery,mPath)
        fprintf('到达各客户点的时间 %s \n',mTime)
        fprintf('油耗成本为%.3f, 货损成本为 %.3f, 制冷成本 %.3f, 碳排放成本 %.3f, 惩罚成本为 %.3f;\n',C2,C41+C42,C5a + C5b,C6,C3)
        Kcar=Kcar+1;
        if Kcar<=CarNum+1
            cost=cost+0;
        else
            cost=cost+1000000;
        end
        % 计算车装载量
        Qi = 0;
        for k = 2 : N
            Qi = Qi + demand(route(k));
            if route(k)==1&&route(k-1)>1 % 如果该点是配送中心
                break
            end
        end
            driveDistance=0;
            delivery=0;
            tsi = 0;
            nowTime=ET1(1);
            C6 = 0;
            C3 = 0;
            C41 = 0;
            C42 = 0;
            Qi = 0;
        mTime=num2str(ET1(1));
        mPath='0';
    end
end
fprintf('最优解对应的总成本为： %f \n',cost)
fprintf('最优解对应的油耗总成本为： %f \n',cost2)
fprintf('最优解对应的惩罚总成本为： %f \n',cost3)
fprintf('最优解对应的货损总成本为： %f \n',cost4)
fprintf('最优解对应的制冷总成本为： %f \n',cost5)
fprintf('最优解对应的碳排放总成本为： %f \n',cost6)


