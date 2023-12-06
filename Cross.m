%% 交叉操作

function chrom=Cross(chrom,Pc)

%
[nx,ny]=size(chrom);

for i=1:2:nx-mod(nx,2)
    if Pc>=rand
            a=chrom(i,2:ny-1);
            b=chrom(i+1,2:ny-1);
            [a,b]=oxcross(a,b);
            chrom(i,2:ny-1)=a;
            chrom(i+1,2:ny-1)=b;
    end 
end
chrom;


    
% OX交叉函数
function [a,b]=oxcross(a,b)

L=length(a);                % 获取染色体长度
r1=0;
r2=0;
while r1==r2
    r1=randsrc(1,1,[1:L]);  % 随机选择交叉点
    r2=randsrc(1,1,[1:L]);
end
s=min([r1,r2]);             % 获取交叉点的起始位置
e=max([r1,r2]);             % 获取交叉点的结束位置
aa=a(s:e);                  % 分别获取交叉片段
a0=a(s:e);
bb=b(s:e);
b0=b(s:e);
a(s:e)=[];                  % 去除交叉部分
b(s:e)=[];
lon=length(a);              % 更新剩余基因片段的长度
lo=e-s+1;                   % 计算交叉片段的长度

% 移除重复元素
for i=1:lo          
    for j=1:lo
        if aa(i)==bb(j)
           aa(i)=0;         % 标记重复元素为0
           bb(j)=0;
        end
    end
end
i0=find(aa==0);             % 移除标记为0的元素
aa(i0)=[];
i1=find(bb==0);
bb(i1)=[];
loo=length(aa);     %交叉部分去除相同元素后长度
for i2=1:loo
    for j2=1:lon
        if bb(i2)==a(j2)
            a(j2)=aa(i2);
            break;
        end
    end
end
for i3=1:loo
    for j3=1:lon
        if aa(i3)==b(j3)
            b(j3)=bb(i3);
            break;
        end
    end
end

a=[a(1:s-1),b0,a(s:lon)];
b=[b(1:s-1),a0,b(s:lon)];
 