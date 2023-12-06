%% 进化逆转函数
% 输入：
% XSel      被选择的个体
% D         个城市的距离矩阵
% 输出：
% XSel      进化逆转后的个体
function XSel=Reverse(distance,demand,XSel,ET1,LT1,ET2,LT2,ST,CarDistance,CarLoad,speed,fitmax,H,c0,F,CarNum)
[allcost,~]=fit(distance,demand,XSel,ET1,LT1,ET2,LT2,ST,CarDistance,CarLoad,speed,fitmax,H,c0,F,CarNum);
XSel2=XSel;
XSel2=Mutate(XSel2,1);
allcostNew=fit(distance,demand,XSel2,ET1,LT1,ET2,LT2,ST,CarDistance,CarLoad,speed,fitmax,H,c0,F,CarNum);
index=allcostNew<allcost;
XSel(index,:)=XSel2(index,:);