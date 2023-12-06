%%��ձ���
clc;clear;close all

%%������������
data = xlsread('�Զ�������.xlsx',1,'A:I');       % �ͻ���λ����Ϣ����
D = xlsread('�Զ�������.xlsx',2);                % �ͻ���������
sd = xlsread('�Զ�������.xlsx',3);               % ������ʻ�ٶȾ���

%%�����趨
global  c0 w e0 rou0 rou1 lmt1 lmt2 cew clw P1 beta R S dT Cr Vk alpha
c0 = 3;                                 % ̼˰
w = 0.000066;                           % ����̼�ŷ�ϵ��
e0 = 0.0263;                            % ȼ��̼�ŷ�ϵ��
rou0 = 0.165;                           % ����ȼ��������
rou1 = 0.377;                           % ����ȼ��������
lmt1 = 0.001;                           % ��������г��ű��ֹرյĸ�������
lmt2 = 0.0015;                          % ж�������г��ű��ֿ����ĸ�������
cew = 0.001;                            % �絽ʱ��ͷ�ϵ��
clw = 0.004;                            % ��ʱ��ͷ�ϵ��
P1 = 6000;                              % ����ũ��Ʒ�ĵ�λ��ֵ��Ԫ/�֣�
beta = 0.14;                            % ��س�������𻵳̶�
R = 2.3;                                % �ȴ���
S = 5.7;                                % ̫����������
dT = 16;                                % �����¶Ȳ�
Cr = 0.5;                               % ��λ���������
Vk = 18.015;                            % �������
alpha = 0.25;                           % �����ſ��ŵĳ̶�ϵ��
CarDistance = 3000000;                  % �������ʻ����
CarLoad = 20;                           % ������
F = 200;                                % ÿ�����̶�ʹ�óɱ�
c2 = 3;                                 % �ͼۣ�Ԫ/L��  
fitmax = 100000;                        % ������̵ĳͷ�
H = 2000;                               % Υ��Ӳʱ�䴰�ͷ��ɱ�
data(:,5:8) = data(:,5:8) * 24;         % ʱ�䵥λת��ΪСʱ
CusNum = size(data,1) - 1;              % ����ڵ���
CarNum = 4;                             % �������
NP = 100;                               % ��Ⱥ��С
maxgen = 400;                           % ����������
Pc = 0.8;                               % �������
Pm = 0.25;                              % �������
Gap = 0.9;                              % ����
Idx = data(:,1);                        % �ڵ���
position = data(:,2:3);                 % �ͻ�������
demand =  data(:,4);                    % �ͻ�������
ET1 = data(:,5);                        % �����絽ʱ��
LT1 = data(:,6);                        % ������ʱ��
ET2 = data(:,7);                        % �ɽ����絽ʱ��
LT2 = data(:,8);                        % �ɽ�����ʱ��
ST = data(:,9) / 60;                    % ����ʱ��
ET1(1) = 5.5;                           % ��������ʱ��


%% ������
% ·����ʼ��
X=initpop(NP,CusNum,demand,CarLoad);    % ��Ⱥ��С���ͻ��ڵ���������������������
Xa=X(1,:);
% ����
gen = 1;
while gen <= maxgen
    % ������Ӧ�Ⱦ���
    [allcost,fitness]=fit(D,demand,X,ET1,LT1,ET2,LT2,ST,CarDistance,CarLoad,sd,fitmax,H,F,c2,CarNum);
    % �ҳ����Ÿ�����Ӧ��
    [leastcost,bestindex]=min(allcost);
    bestindex=bestindex(1);
    % ��С��Ӧ��fit�ļ�
    fpbest(gen)=leastcost;
    % ���Ÿ��弯
    pbest(gen,:)=X(bestindex,:);
    % ѡ��
    XSel=Select(X,fitness,Gap);
    % �������
    XSel=Cross(XSel,Pc);
    % ����
    XSel=Mutate(XSel,Pm);
    % ��ת����
    if gen < maxgen
        XSel=Reverse(D,demand,XSel,ET1,LT1,ET2,LT2,ST,CarDistance,CarLoad,sd,fitmax,H,F,c2,CarNum);
    end
    % �ز����Ӵ�������Ⱥ
    X=Reins(X,XSel,fitness);
     gen=gen+1;
end
  
% �ҳ����ŵ���Ӧ�ȼ�����
[fgbest,minindex]=min(fpbest);
minindex=minindex(1);
% ȡ���Ÿ���
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

% ���������
clc
fprintf('���յ�������Ϊ��%d\n',maxgen)
OutputResult(D,demand,Path,ET1,LT1,ET2,LT2,ST,CarDistance,CarLoad,sd,fitmax,H,F,c2,Idx,CarNum)
disp('----------------------------------------------------------------------------------------------------------------------------')
% ����ʵ��·��
figure(1)
% ����·����ɫ
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

% ����·��ͼ
plot(position(1,1),position(1,2),'bp','MarkerFaceColor','r','MarkerSize',15)
title('��������·��ͼ')
xlabel('����X')
ylabel('����Y')

% ���Ƶ���ͼ
figure
plot(fpbest)
title('�Ŵ��㷨�Ż�����')
xlabel('��������')
ylabel('����ֵ')

