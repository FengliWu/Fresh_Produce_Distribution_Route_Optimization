%% �Ľ�ѡ������
% ���룺
% X         ��Ⱥ
% fitness   ��Ӧ��ֵ
% Gap       ѡ�����
% �����
% XSel      ��ѡ��ĸ���
function XSel = Select(X, fitness, Gap)
NP = size(X, 1);

Px = fitness / sum(fitness);                % ���ʹ�һ��
Px = cumsum(Px);                            % ���̶ĸ����ۼ�

XSel(1:NP * Gap, :) = X(1:NP * Gap, :);     % ���ݴ�������ȷ������ѡ�񽻲����ĸ�������

% ��Ӣѡ�����
bestFit = max(fitness);                     % ��ʼ����ǰ������Ӧ��ֵΪ��ǰ���������Ӧ��ֵ
bestIndex = find(fitness == bestFit, 1);    % �ҵ����Ÿ��������
bestIndividual = X(bestIndex, :);           % ��¼���Ÿ���

% ����ǰ���Ÿ��帴�Ʋ��滻��ǰ��Ⱥ�е�������
[~, worstIndex] = min(fitness);
XSel(NP * Gap + 1, :) = bestIndividual;

% �������̶�ѡ��
for i = 2 : NP * Gap
    sita = rand();
    for j = 1 : NP
        if sita <= Px(j)
            XSel(i, :) = X(j, :);       % ���̶Ĺ���ȷ������
            break;
        end
    end
end
end

%% ԭʼ�Ŵ��㷨
% ѡ�����
% ����
% X   ��Ⱥ
% fit ��Ӧ��ֵ
% Gap��ѡ�����
% ���
% XSel  ��ѡ��ĸ���
% function XSel=Select(X,fitness,Gap)
% NP=size(X,1);
% 
% Px=fitness/sum(fitness);  %���ʹ�һ��
% Px=cumsum(Px);                     %���̶ĸ����ۼ�
% 
% XSel(1:NP*Gap,:)=X(1:NP*Gap,:);      %���ݴ�������ȷ������ѡ�񽻲����ĸ�������%���rand>PC�򲻽���ʱ���ͱ���ԭ��Ⱥ
% for i=1:NP*Gap
%     %% ------------------ѡ�����------------------%
%     sita=rand();
%     for j=1:NP
%         if sita<=Px(j)
%             XSel(i,:)=X(j,:);      %���̶Ĺ���ȷ������
%             break;
%         end
%     end
% end
% end


