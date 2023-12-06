% 路径初始化
function X = initpop(NP,CusNum,demand,CarLoad)
for i = 1 : NP
    x = randperm(CusNum); % 随机种子
    x = Tsp2Vrp(x,demand,CarLoad) + 1 ; % TSP转化为VRP
    X(i,:) = x;
end
