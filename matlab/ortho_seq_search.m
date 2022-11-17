clc;
clear;
%Ѱ���������ж�

N=15;
record=zeros(8,2^N);
for v=0:2^N-1
    seq1=bitget(v,N:-1:1);
    seq2=double(~seq1);
    seq1(seq1==0)=-1;
    seq2(seq2==0)=-1;
    rep_seq1=repmat(seq1,1,3);
    rep_seq2=repmat(seq2,1,3);
    for i=2:2*N
        autocor1(:,i-1)=sum(rep_seq1(:,1:N).*rep_seq1(:,i:i+N-1));
        autocor2(:,i-1)=sum(rep_seq2(:,1:N).*rep_seq2(:,i:i+N-1));
        corr(:,i-1)=sum(rep_seq2(:,1:N).*rep_seq1(:,i:i+N-1));
    end

    [max_autocor1,p1]=max(autocor1);
    [max_autocor2,p2]=max(autocor2);
    [max_corr,pc]=max(corr);
    autocor1(:,p1)=0;
    autocor2(:,p2)=0;
    [max1,pp1]=max(autocor1);
    [max2,pp2]=max(autocor2);

    record(1,v+1)=max_autocor1/max_corr;    %��¼����1���������ֵ����ڻ���ص�����
    record(2,v+1)=max_autocor2/max_corr;    %��¼����2���������ֵ����ڻ���ص�����
    record(3,v+1)=max_autocor1/max1;        %��¼����1����������棨��ֵ����ڵڶ���ֵ��
    record(4,v+1)=max_autocor2/max2;        %��¼����2����������棨��ֵ����ڵڶ���ֵ��
    record(5,v+1)=mean(autocor1);           %��¼����1������ؾ�ֵ�����弤λ�ô���
    record(6,v+1)=mean(autocor2);           %��¼����2������ؾ�ֵ�����弤λ�ô���
    record(7,v+1)=mean(corr);               %��¼����ؾ�ֵ
    record(8,v+1)=corr(:,N); %��¼����о��㴦�Ļ����ֵ
end

%������رȻ�������ֵ
max_auto1_cc=max(max(record(1,:)));
max_auto2_cc=max(max(record(2,:)));
%��������������ֵ
max_auto1_G=max(max(record(3,:)));
max_auto2_G=max(max(record(4,:)));
%������о��㴦�������Сֵ
min_corr=min(min(record(8,:)));

mean=0;
for v=0:2^N-1
    if record(1,v+1)==max_auto1_cc && record(2,v+1)==max_auto2_cc ...
            && record(3,v+1)==max_auto1_G && record(4,v+1)==max_auto2_G ...
            && record(8,v+1)==min_corr
        if mean>=(record(5,v+1)+record(6,v+1)+record(7,v+1))/3
            mean=(record(5,v+1)+record(6,v+1)+record(7,v+1))/3;
            disp(v);
        end
    end
end


seq1=bitget(31432,N:-1:1);
seq2=double(~seq1);
seq1(seq1==0)=-1;
seq2(seq2==0)=-1;
rep_seq1=repmat(seq1,1,3);
rep_seq2=repmat(seq2,1,3);
for i=2:2*N
    autocor1(:,i-1)=sum(rep_seq1(:,1:N).*rep_seq1(:,i:i+N-1));
    autocor2(:,i-1)=sum(rep_seq2(:,1:N).*rep_seq2(:,i:i+N-1));
    corr(:,i-1)=sum(rep_seq2(:,1:N).*rep_seq1(:,i:i+N-1));
end

figure1=stem(-(N-1):(N-1),autocor1);
hold on
figure2=stem(-(N-1):(N-1),autocor2);
hold on
figure3=stem(-(N-1):(N-1),corr);
set(figure1,'color','r','LineStyle','-.',...
 'LineWidth',0.5,'Marker','o',...
'MarkerFaceColor','r','MarkerEdgeColor','r')
set(figure2,'color','b','LineStyle','-',...
  'LineWidth',0.5,'Marker','s',...
'MarkerFaceColor','b','MarkerEdgeColor','b')
set(figure3,'color','g','LineStyle','-',...
  'LineWidth',0.5,'Marker','*',...
'MarkerFaceColor','g','MarkerEdgeColor','g')
% axis([-N,N,-N,N]);
% set(gca,'XTick',-N:N,'YTick',-N:N)
xlabel('��λ');ylabel('���ֵ')
legend('����1�������','����2�������','�����')
