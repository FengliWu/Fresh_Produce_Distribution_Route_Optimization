%% TSPתΪVRP����
function routeVrp = Tsp2Vrp (route, demand, CarLoad)
% TSPתΪVRP·������������Ϊ0
CusNum = length(route);                 % �ͻ�����
route = [0 route 0];                    % ��β����������
routeVrp = zeros (1, CusNum * 2 + 1);   % VRP·�������CusNum * 2 + 1��Ԫ��
delivery = 0;
k = 1;
for i = 2 : CusNum + 1
    if delivery + demand(route(i)+1) <= CarLoad  % �ﵽ�ó���ʱ������������С����������������δ����
        delivery = delivery + demand(route(i) + 1);
        k = k + 1;
        routeVrp (k) = route (i);
    else                                         % ���򣬱�ʾ�������أ���ص���ɢ����
        delivery = 0;
        k = k + 1;
        routeVrp (k) = 0;
        % ��ȥ��һ������
        delivery = demand(route(i) + 1);
        k = k + 1;
        routeVrp (k) = route (i);
    end
end