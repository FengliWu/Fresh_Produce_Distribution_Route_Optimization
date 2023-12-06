%% �������
function OutputResult(distance,demand,route,ET1,LT1,ET2,LT2,ST,CarDistance,CarLoad,speed,fitmax,H,F,c2,Idx,CarNum)
% �������
global lmt1 lmt2 cew clw P1 beta R S dT Cr Vk alpha c0 w e0 rou0 rou1
Qk1 = (1 + beta) * R * S * dT;
Qk2 = (0.54 * Vk + 3.22 ) * dT * alpha; % ��0.54*�������+3.22��*�����¶Ȳ�*����ϵ��
%%

N=length(route);
disp('��������·��Ϊ��')
Path=num2str(route(1));
for i=2:N
    Path=[Path,'��>',num2str(Idx(route(i)+1))];
end
disp(Path)

%% ��·����Ϣ�������
route=route+1;      % ������������0��Ϊ1
cost = 0;           % ����·�������гɱ�
cost2 = 0;          % �����ܳɱ�
cost3 = 0;          % �ͷ��ɱ�
cost4 = 0;          % ����ɱ�
cost5 = 0;          % �����ܳɱ�
cost6 = 0;          % ̼�ŷųɱ�

C41 = 0;
C42 = 0;
C6 = 0;
C3 = 0;             % ��·���ͷ��ɱ�
Kcar=1;
driveDistance=0;    % �����Ѿ���ʻ�ľ���
delivery=0;         % �����Ѿ��ͻ��������Ѿ�������������֮��
tsi = 0;
nowTime=ET1(1);     % ��ǰʱ��
mPath='0';
mTime=num2str(ET1(1));
% ���㳵װ����
Qi = 0;
for k = 2 : N
    Qi = Qi + demand(route(k));
    if route(k)==1&&route(k-1)>1 % ����õ�����������
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
    mPath=[mPath,'��>',num2str(Idx(route(l1)))];
    mTime=[mTime,'��',num2str(nowTime)];
    nowTime=nowTime+ST(route(l1)); % ���ϵ�j���ڵ�ķ���ʱ��
    tsi = tsi + ST(route(l1));
    Qi = Qi - demand(route(l1));
    C2 =  driveDistance * rho * c2;      % �ͺĳɱ�
    C5b = Cr * Qk2 * tsi;
    if driveDistance>CarDistance||delivery>CarLoad
        cost=fitmax;
        break;
    end
    if route(l1)==1&&route(l1-1)>1 % �������������
        cost = cost + F + C2 + C3 + C41 + C42 + C5a + C5b + C6;
        cost2 = cost2 + C2;
        cost3 = cost3 + C3;
        cost4 = cost4 + C41 + C42;
        cost5 = cost5 + C5a + C5b;
        cost6 = cost6 + C6;
        disp('----------------------------------------------------------------------------------------------------------------------------')
        fprintf('�� %d ��������ʻ·��Ϊ %.3f,������Ϊ %f \n��ʻ·��Ϊ %s \n',Kcar,driveDistance,delivery,mPath)
        fprintf('������ͻ����ʱ�� %s \n',mTime)
        fprintf('�ͺĳɱ�Ϊ%.3f, ����ɱ�Ϊ %.3f, ����ɱ� %.3f, ̼�ŷųɱ� %.3f, �ͷ��ɱ�Ϊ %.3f;\n',C2,C41+C42,C5a + C5b,C6,C3)
        Kcar=Kcar+1;
        if Kcar<=CarNum+1
            cost=cost+0;
        else
            cost=cost+1000000;
        end
        % ���㳵װ����
        Qi = 0;
        for k = 2 : N
            Qi = Qi + demand(route(k));
            if route(k)==1&&route(k-1)>1 % ����õ�����������
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
fprintf('���Ž��Ӧ���ܳɱ�Ϊ�� %f \n',cost)
fprintf('���Ž��Ӧ���ͺ��ܳɱ�Ϊ�� %f \n',cost2)
fprintf('���Ž��Ӧ�ĳͷ��ܳɱ�Ϊ�� %f \n',cost3)
fprintf('���Ž��Ӧ�Ļ����ܳɱ�Ϊ�� %f \n',cost4)
fprintf('���Ž��Ӧ�������ܳɱ�Ϊ�� %f \n',cost5)
fprintf('���Ž��Ӧ��̼�ŷ��ܳɱ�Ϊ�� %f \n',cost6)


