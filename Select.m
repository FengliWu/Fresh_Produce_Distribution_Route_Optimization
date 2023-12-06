%% 改进选择算子
% 输入：
% X         种群
% fitness   适应度值
% Gap       选择概率
% 输出：
% XSel      被选择的个体
function XSel = Select(X, fitness, Gap)
NP = size(X, 1);

Px = fitness / sum(fitness);                % 概率归一化
Px = cumsum(Px);                            % 轮盘赌概率累加

XSel(1:NP * Gap, :) = X(1:NP * Gap, :);     % 根据代沟概率确定进行选择交叉变异的个体数量

% 精英选择策略
bestFit = max(fitness);                     % 初始化当前最优适应度值为当前代的最大适应度值
bestIndex = find(fitness == bestFit, 1);    % 找到最优个体的索引
bestIndividual = X(bestIndex, :);           % 记录最优个体

% 将当前最优个体复制并替换当前种群中的最差个体
[~, worstIndex] = min(fitness);
XSel(NP * Gap + 1, :) = bestIndividual;

% 进行轮盘赌选择
for i = 2 : NP * Gap
    sita = rand();
    for j = 1 : NP
        if sita <= Px(j)
            XSel(i, :) = X(j, :);       % 轮盘赌规则确定父亲
            break;
        end
    end
end
end

%% 原始遗传算法
% 选择操作
% 输入
% X   种群
% fit 适应度值
% Gap：选择概率
% 输出
% XSel  被选择的个体
% function XSel=Select(X,fitness,Gap)
% NP=size(X,1);
% 
% Px=fitness/sum(fitness);  %概率归一化
% Px=cumsum(Px);                     %轮盘赌概率累加
% 
% XSel(1:NP*Gap,:)=X(1:NP*Gap,:);      %根据代沟概率确定进行选择交叉变异的个体数量%如果rand>PC则不交叉时，就保留原种群
% for i=1:NP*Gap
%     %% ------------------选择操作------------------%
%     sita=rand();
%     for j=1:NP
%         if sita<=Px(j)
%             XSel(i,:)=X(j,:);      %轮盘赌规则确定父亲
%             break;
%         end
%     end
% end
% end


