function BER=test_m_sequence
m=load(".\tek0000RF1.csv");  % 读入示波器采集的数据文件
%time=m(:,1);                  % 示波器记录第一列：采样时间 
MagH=m(:,2);                  % 示波器记录第二列：电流强度
% time=resample(time,1,20);     % 为了提高运算速度，重采/降采样率
MagH=resample(MagH,1,10);     %（不牺牲信号形貌条件下尽可能降采样率）
dt=1e-3;
time=0:dt:1-dt; %1*1000 0,0.001,0.002...0.999
tt=0:dt:0.068-dt;

% frMagH=fft(MagH);
% %orifMagH=(0:length(frMagH)-1)/(dt*length(frMagH));
% fshift=(-length(MagH)/2:length(MagH)/2-1)*(1/(dt*length(MagH)));
% yshift=fftshift(frMagH);

partemp1=MagH(0.454/dt:(0.454+0.068)/dt-1,:);
partemp0=MagH((0.454+0.068)/dt:(0.454+2*0.068)/dt-1,:);

figure(2)
plot(tt,partemp0,'r',tt,partemp1,'b')
legend('0','1')

N=15;%Gold码长
seq1=bitget(31432,N:-1:1);
seq2=double(~seq1);
seq1(seq1==0)=-1;
seq2(seq2==0)=-1;
% seq1=[1,-1,1,1,1,1,-1,-1,-1,-1,-1,1,1,1,-1];
% seq2=[-1,-1,1,1,1,-1,1,1,1,-1,-1,-1,1,-1,1];
% seq1=[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1];
% seq2=[-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1];
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

num=1e2;%传输比特数
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
%解调方案1
demtemp1=repmat(symbol1,num,1);
demtemp0=repmat(symbol0,num,1);
noisig=zeros(length(trans_sig),21);
dem_sig=zeros(length(trans_sig),21);
dem_seq=zeros(num,21);
for snr=-25:-5
    i=snr+26;
    noisig(:,i)=awgn(trans_sig,snr,'measured');
    dem_sig(:,i)=(demtemp1-demtemp0).*noisig(:,i);
    for numi=1:num
        if sum(dem_sig((numi-1)*1020+1:numi*1020,i))>0
            dem_seq(numi,i)=1;
        else
            dem_seq(numi,i)=0;
        end
    end
end

ber=zeros(1,21);
for snr=-25:-5
    i=snr+26;
    ber(:,i)=length(find((dem_seq(:,i)-info)~=0))/num;
end

BER=ber;

% frMagH=fft(trans_sig);
% %orifMagH=(0:length(frMagH)-1)/(dt*length(frMagH));
% fshift=(-length(trans_sig)/2:length(trans_sig)/2-1)*(1/(dt*length(trans_sig)));
% yshift=fftshift(frMagH);
% figure(2)
% plot(fshift,abs(yshift))
% title('波形频谱')
% 
% %%
% %解调方案2
% demtemp1=repmat(partemp1,num*N,1);
% demtemp0=repmat(partemp0,num*N,1);
% noisig=zeros(length(trans_sig),21);
% dem_sig=zeros(length(trans_sig),21);
% dem_seq=zeros(num*N,21);
% dem_bit=zeros(num,21);
% for snr=-25:-5
%     i=snr+26;
%     noisig(:,i)=awgn(trans_sig,snr,'measured');
%     dem_sig(:,i)=(demtemp1-demtemp0).*noisig(:,i);
%     for numi=1:num*N
%         if sum(dem_sig((numi-1)*68+1:numi*68,i))>0
%             dem_seq(numi,i)=1;
%         else
%             dem_seq(numi,i)=-1;
%         end
%     end
%     for numj=1:num
%         if sum((seq1'-seq2').*dem_seq((numj-1)*15+1:numj*15,i))>0
%             dem_bit(numj,i)=1;
%         else
%             dem_bit(numj,i)=0;
%         end
%     end
% end
% 
% ber=zeros(1,21);
% for snr=-25:-5
%     i=snr+26;
%     ber(:,i)=length(find((dem_bit(:,i)-info)~=0))/num;
% end
% 
% BER=ber;