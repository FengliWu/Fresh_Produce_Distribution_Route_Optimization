%% TSP转为VRP函数
function routeVrp = Tsp2Vrp (route, demand, CarLoad)
% TSP转为VRP路径，配送中心为0
CusNum = length(route);                 % 客户点数
route = [0 route 0];                    % 首尾是配送中心
routeVrp = zeros (1, CusNum * 2 + 1);   % VRP路径最多有CusNum * 2 + 1个元素
delivery = 0;
k = 1;
for i = 2 : CusNum + 1
    if delivery + demand(route(i)+1) <= CarLoad  % 达到该城市时的汽车运载量小于汽车载重量，即未超重
        delivery = delivery + demand(route(i) + 1);
        k = k + 1;
        routeVrp (k) = route (i);
    else                                         % 否则，表示汽车超重，需回到集散中心
        delivery = 0;
        k = k + 1;
        routeVrp (k) = 0;
        % 再去下一个城市
        delivery = demand(route(i) + 1);
        k = k + 1;
        routeVrp (k) = route (i);
    end
end