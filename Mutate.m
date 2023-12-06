%% �Ľ���������
function chrom = Mutate(chrom, Pm)
    % ���캯��
    % pm �������
    [px, py] = size(chrom);
    
    for i = 1:px
        if Pm >= rand
            % ��������
            R = randperm(py-1);
            j = find(R == 1);
            R(j) = [];
            chrom(i, R(1:2)) = chrom(i, R(2:-1:1));
            
            % ��ת����
            start_idx = randi([1, py-2]);
            end_idx = randi([start_idx+1, py-1]);
            if end_idx <= py && start_idx <= end_idx
                chrom(i, start_idx:end_idx) = chrom(i, end_idx:-1:start_idx);
            end
        end
    end
end

%% ��ͳ��������
% function chrom=Mutate(chrom,Pm)
% % ���캯��
% % pm �������
% [px,py]=size(chrom);
% for i=1:px
%     if Pm>=rand
%         R=randperm(py-1);
%         j=find(R==1);
%         R(j)=[];
%         chrom(i,R(1:2))=chrom(i,R(2:-1:1));
%     end            
% end
