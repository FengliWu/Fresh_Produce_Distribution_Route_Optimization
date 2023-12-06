%% �������

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


    
% OX���溯��
function [a,b]=oxcross(a,b)

L=length(a);                % ��ȡȾɫ�峤��
r1=0;
r2=0;
while r1==r2
    r1=randsrc(1,1,[1:L]);  % ���ѡ�񽻲��
    r2=randsrc(1,1,[1:L]);
end
s=min([r1,r2]);             % ��ȡ��������ʼλ��
e=max([r1,r2]);             % ��ȡ�����Ľ���λ��
aa=a(s:e);                  % �ֱ��ȡ����Ƭ��
a0=a(s:e);
bb=b(s:e);
b0=b(s:e);
a(s:e)=[];                  % ȥ�����沿��
b(s:e)=[];
lon=length(a);              % ����ʣ�����Ƭ�εĳ���
lo=e-s+1;                   % ���㽻��Ƭ�εĳ���

% �Ƴ��ظ�Ԫ��
for i=1:lo          
    for j=1:lo
        if aa(i)==bb(j)
           aa(i)=0;         % ����ظ�Ԫ��Ϊ0
           bb(j)=0;
        end
    end
end
i0=find(aa==0);             % �Ƴ����Ϊ0��Ԫ��
aa(i0)=[];
i1=find(bb==0);
bb(i1)=[];
loo=length(aa);     %���沿��ȥ����ͬԪ�غ󳤶�
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
 