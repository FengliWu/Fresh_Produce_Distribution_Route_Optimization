%% ��Ӧ�Ⱥ���
function [allcost,fit,cost2,cost5,cost4,cost3]=fit(distance,demand,chrom,ET1,LT1,ET2,LT2,ST,CarDistance,CarLoad,speed,fitmax,H,F,c2,CarNum)
% distance          ���о������
% demand            ���е�����������
% chrom             �����ĳ�ʼ��Ⱥ
% ET                �������ʱ��
% LT                �������ʱ��
% CE                �絽�ͷ�ϵ��
% CL                ���ͷ�ϵ��
% NP                ��Ⱥ����
% CarDistance       ���������ʻ����
% CarLoad           ��������ػ���
% fit               ��Ӧ��
% fitmax            һ���ܴ��ֵ�����Ӧ��
% N                 ��ʼ���峤
global lmt1 lmt2 cew clw P1 beta R S dT Cr Vk alpha c0 w e0 rou0 rou1
Qk1 = (1 + beta) * R * S * dT;
Qk2 = (0.54 * Vk + 3.22 ) * dT * alpha;
[NP,N]=size(chrom);
for i=1:NP
    cost = 0;                       % ����·�������гɱ�
    cost2 = 0;                      % �ͺ��ܳɱ�
    cost3 = 0;                      % �ͷ��ɱ�
    cost4 = 0;                      % ����ɱ�
    cost5 = 0;                      % �����ܳɱ�
    cost6 = 0;                      % ̼�ŷųɱ�
    
    C41 = 0;
    C42 = 0;
    C6 = 0; 
    C3 = 0;                         % ��·���ͷ��ɱ�
    Kcar=1;
    driveDistance=0;                % �����Ѿ���ʻ�ľ���
    delivery=0;                     % �����Ѿ��ͻ��������Ѿ�������������֮��
    tsi = 0;
    nowTime=ET1(1);                 % ��ǰʱ��
    route=chrom(i,:);
    
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
        Qi = Qi - demand(route(l1));                                            % װ����
        rho = rou0 + (rou1 - rou0) / CarLoad * Qi;                              % ��λ�������ͺ�
        C2 = driveDistance * rho * c2;                                          % �ͺĳɱ�
        C3 = C3 + punish;                                                       % ʱ��ͷ��ɱ�
        C41 = C41 + P1 * demand(route(l1)) * (1 - exp(- lmt1 * (nowTime - ET1(1)))) ;
        C42 = C42 + P1 * Qi * (1 - exp(- lmt2 * ST(route(l1))));
        nowTime = nowTime + ST(route(l1));                                      % ���ϵ�j���ڵ�ķ���ʱ��
        tsi = tsi + ST(route(l1));
        C5a = Cr * Qk1 * driveDistance / speed(route(l1-1),route(l1));          % ���������
        C5b = Cr * Qk2 * tsi;
        C6 = C6 + c0 * distance(route(l1-1),route(l1)) * (e0 * rho + w * Qi);	% ̼��=̼˰*����*��̼�ŷ�ϵ��*�ͺ�+��λ��������̼�ŷ�*��������
        
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
            % ���㳵װ����
            Qi = 0;
            for k = l1+1 : N
                Qi = Qi + demand(route(k));
                if route(k)==1&&route(k-1)>1    % ����õ�����������
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

