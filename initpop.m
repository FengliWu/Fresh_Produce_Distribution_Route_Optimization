% ·����ʼ��
function X = initpop(NP,CusNum,demand,CarLoad)
for i = 1 : NP
    x = randperm(CusNum); % �������
    x = Tsp2Vrp(x,demand,CarLoad) + 1 ; % TSPת��ΪVRP
    X(i,:) = x;
end
