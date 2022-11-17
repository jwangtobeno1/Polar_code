clc;
clear;
%测试同步

m=load(".\tek0000RF1.csv");  % 读入示波器采集的数据文件
%time=m(:,1);                  % 示波器记录第一列：采样时间 
MagH=m(:,2);                  % 示波器记录第二列：电流强度
% time=resample(time,1,20);     % 为了提高运算速度，重采/降采样率
MagH=resample(MagH,1,10);     %（不牺牲信号形貌条件下尽可能降采样率）
dt=1e-3;
time=0:dt:1-dt;
tt=0:dt:0.068-dt;

partemp1=MagH(0.454/dt:(0.454+0.068)/dt-1,:);
partemp0=MagH((0.454+0.068)/dt:(0.454+2*0.068)/dt-1,:);

% figure(2)
% plot(tt,partemp0,'r',tt,partemp1,'b')
% legend('0','1')

N=15;%Gold码长
seq1=bitget(31432,N:-1:1);
seq2=double(~seq1);
seq1(seq1==0)=-1;
seq2(seq2==0)=-1;
% seq1=[-1,1,-1,-1,1,-1,-1,-1,-1,1,1,1,1,-1,1];
% seq2=[1,-1,1,1,-1,1,1,-1,-1,1,-1,-1,-1,1,-1];
symbol1=zeros(0.068/dt*N,1);
symbol0=zeros(0.068/dt*N,1);
for i=1:N
    if seq1(:,i)==1                    %序列1映射到符号1
        symbol1((i-1)*0.068/dt+1:i*0.068/dt,:)=partemp1;
    else
        symbol1((i-1)*0.068/dt+1:i*0.068/dt,:)=partemp0;
    end
    
    if seq2(:,i)==1                    %序列2映射到符号0
        symbol0((i-1)*0.068/dt+1:i*0.068/dt,:)=partemp1;
    else
        symbol0((i-1)*0.068/dt+1:i*0.068/dt,:)=partemp0;
    end
end

num=3;%传输比特数
info=randi([0 1],num,1);
trans_sig=zeros(num*length(symbol1),1);
for i=1:num
    if info(i,:)==1
        trans_sig((i-1)*1020+1:i*1020,:)=symbol1;
    else
        trans_sig((i-1)*1020+1:i*1020,:)=symbol0;
    end
end

%%
%同步
%假设时隙同步到了第13个时隙，离下一码元的开头还差2时隙
delay=8;
rec_sig=trans_sig(delay*0.068/dt+1:end,:);
rec_sig=awgn(rec_sig,-15,'measured'); %给rec添加噪声，信噪比为-15
window=length(rec_sig)-15*68+1;
sync_cor=zeros((window-1)/68+1,1);
for i=1:68:window
    i_cor=(i-1)/68+1;
    sync_cor(i_cor,:)=abs(sum((symbol1-symbol0).*rec_sig(i:i+length(symbol1)-1,:)));
end

win_sear=repmat([1;zeros(N-1,1)],floor(length(sync_cor)/N)-1,1); %峰值搜寻窗
deci_p=zeros(15,1);
for i=1:N
    deci_p(i,:)=sum(win_sear.*sync_cor(i:length(win_sear)+i-1,:));
end
[max_deci_p,sync_slot_res]=max(deci_p);
sync_slot_res=sync_slot_res-1;

figure(3)
plot(sync_cor,'r')
% hold on
% plot(deci_p,'b')
