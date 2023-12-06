%% 改进变异算子
function chrom = Mutate(chrom, Pm)
    % 变异函数
    % pm 变异概率
    [px, py] = size(chrom);
    
    for i = 1:px
        if Pm >= rand
            % 交换变异
            R = randperm(py-1);
            j = find(R == 1);
            R(j) = [];
            chrom(i, R(1:2)) = chrom(i, R(2:-1:1));
            
            % 逆转变异
            start_idx = randi([1, py-2]);
            end_idx = randi([start_idx+1, py-1]);
            if end_idx <= py && start_idx <= end_idx
                chrom(i, start_idx:end_idx) = chrom(i, end_idx:-1:start_idx);
            end
        end
    end
end

%% 传统变异算子
% function chrom=Mutate(chrom,Pm)
% % 变异函数
% % pm 变异概率
% [px,py]=size(chrom);
% for i=1:px
%     if Pm>=rand
%         R=randperm(py-1);
%         j=find(R==1);
%         R(j)=[];
%         chrom(i,R(1:2))=chrom(i,R(2:-1:1));
%     end            
% end
