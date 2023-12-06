%%清空变量
clc;clear;close all

%%导入算例数据
data = xlsread('自定义数据.xlsx',1,'A:I');       % 客户点位置信息数据
D = xlsread('自定义数据.xlsx',2);                % 客户点距离矩阵
sd = xlsread('自定义数据.xlsx',3);               % 车辆行驶速度矩阵

%%参数设定
global  c0 w e0 rou0 rou1 lmt1 lmt2 cew clw P1 beta R S dT Cr Vk alpha
c0 = 3;                                 % 碳税
w = 0.000066;                           % 制冷碳排放系数
e0 = 0.0263;                            % 燃油碳排放系数
rou0 = 0.165;                           % 空载燃油消耗量
rou1 = 0.377;                           % 满载燃油消耗量
lmt1 = 0.001;                           % 运输过程中车门保持关闭的腐败速率
lmt2 = 0.0015;                          % 卸货过程中车门保持开启的腐败速率
cew = 0.001;                            % 早到时间惩罚系数
clw = 0.004;                            % 晚到时间惩罚系数
P1 = 6000;                              % 生鲜农产品的单位价值（元/吨）
beta = 0.14;                            % 冷藏车箱体的损坏程度
R = 2.3;                                % 热传率
S = 5.7;                                % 太阳辐射的面积
dT = 16;                                % 环境温度差
Cr = 0.5;                               % 单位制冷剂费用
Vk = 18.015;                            % 车厢体积
alpha = 0.25;                           % 车厢门开门的程度系数
CarDistance = 3000000;                  % 车最大行驶距离
CarLoad = 20;                           % 车容量
F = 200;                                % 每辆车固定使用成本
c2 = 3;                                 % 油价（元/L）  
fitmax = 100000;                        % 超出里程的惩罚
H = 2000;                               % 违反硬时间窗惩罚成本
data(:,5:8) = data(:,5:8) * 24;         % 时间单位转换为小时
CusNum = size(data,1) - 1;              % 需求节点数
CarNum = 4;                             % 最大车辆数
NP = 100;                               % 种群大小
maxgen = 400;                           % 最大迭代次数
Pc = 0.8;                               % 交叉概率
Pm = 0.25;                              % 变异概率
Gap = 0.9;                              % 代沟
Idx = data(:,1);                        % 节点编号
position = data(:,2:3);                 % 客户点坐标
demand =  data(:,4);                    % 客户需求量
ET1 = data(:,5);                        % 期望早到时间
LT1 = data(:,6);                        % 期望晚到时间
ET2 = data(:,7);                        % 可接受早到时间
LT2 = data(:,8);                        % 可接受晚到时间
ST = data(:,9) / 60;                    % 服务时长
ET1(1) = 5.5;                           % 车辆出发时间


%% 主程序
% 路径初始化
X=initpop(NP,CusNum,demand,CarLoad);    % 种群大小，客户节点数量，需求量，车容量
Xa=X(1,:);
% 迭代
gen = 1;
while gen <= maxgen
    % 计算适应度矩阵
    [allcost,fitness]=fit(D,demand,X,ET1,LT1,ET2,LT2,ST,CarDistance,CarLoad,sd,fitmax,H,F,c2,CarNum);
    % 找出最优个体适应度
    [leastcost,bestindex]=min(allcost);
    bestindex=bestindex(1);
    % 最小适应度fit的集
    fpbest(gen)=leastcost;
    % 最优个体集
    pbest(gen,:)=X(bestindex,:);
    % 选择
    XSel=Select(X,fitness,Gap);
    % 交叉操作
    XSel=Cross(XSel,Pc);
    % 变异
    XSel=Mutate(XSel,Pm);
    % 逆转操作
    if gen < maxgen
        XSel=Reverse(D,demand,XSel,ET1,LT1,ET2,LT2,ST,CarDistance,CarLoad,sd,fitmax,H,F,c2,CarNum);
    end
    % 重插入子代的新种群
    X=Reins(X,XSel,fitness);
     gen=gen+1;
end
  
% 找出最优的适应度及个体
[fgbest,minindex]=min(fpbest);
minindex=minindex(1);
% 取最优个体
gbest=pbest(minindex,:);
Path=gbest;
for i=1:length(Path)-1
    if Path(i)-Path(i+1)==0
        Path(i)=0;
    end
end

ii=find(Path==0);
Path(ii)=[];
for j=1:length(Path)
    Path(j)= Path(j)-1;
end

% 计算结果输出
clc
fprintf('最终迭代次数为：%d\n',maxgen)
OutputResult(D,demand,Path,ET1,LT1,ET2,LT2,ST,CarDistance,CarLoad,sd,fitmax,H,F,c2,Idx,CarNum)
disp('----------------------------------------------------------------------------------------------------------------------------')
% 绘制实际路线
figure(1)
% 设置路径颜色
colors = [  1 0 0
            0 1 0
            0 0 1
            1 0 1
            0.8 0.2 1
            0 0 0
            0.5 0.2 0.2  ];
k = 1;
for i = 1 : length(Path)-1
    if k <= 7
        ck = colors(k,:);
    else
        ck = rand(1,3);
    end
    plot(position(Path(i:i+1)+1,1),position(Path(i:i+1)+1,2),'o-','Color',ck,'MarkerFaceColor','g','LineWidth',1)
    if Path(i+1) == 0
        k = k + 1;
    end
    hold on
end

% 绘制路线图
plot(position(1,1),position(1,2),'bp','MarkerFaceColor','r','MarkerSize',15)
title('生鲜配送路线图')
xlabel('坐标X')
ylabel('坐标Y')

% 绘制迭代图
figure
plot(fpbest)
title('遗传算法优化过程')
xlabel('迭代次数')
ylabel('最优值')

