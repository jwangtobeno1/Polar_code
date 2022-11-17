times=1e4;
BER=zeros(times,21);

for i=1:times
    BER(i,:)=test_m_sequence;
end

BERwhole=sum(BER,1)./times;

% BER_demod1_dseq=cell2mat(struct2cell(load('C:\Users\Administrator\Desktop\新型脉冲调制法\解码性能\demod1(directcode).mat')));
% BER_demod1_seq1=cell2mat(struct2cell(load('C:\Users\Administrator\Desktop\新型脉冲调制法\解码性能\demod1(seq2).mat')));
% BER_demod1_seq2=cell2mat(struct2cell(load('C:\Users\Administrator\Desktop\新型脉冲调制法\解码性能\demod1(seq3(corrvalue_-1)).mat')));
% BER_demod2_dseq=cell2mat(struct2cell(load('C:\Users\Administrator\Desktop\新型脉冲调制法\解码性能\demod2(directcode).mat')));
% BER_demod2_seq1=cell2mat(struct2cell(load('C:\Users\Administrator\Desktop\新型脉冲调制法\解码性能\demod2(seq2).mat')));
% BER_demod2_seq2=cell2mat(struct2cell(load('C:\Users\Administrator\Desktop\新型脉冲调制法\解码性能\demod2(seq3(corrvalue_-1)).mat')));
% 
% BER_demod1_orthoseq=cell2mat(struct2cell(load('C:\Users\Administrator\Desktop\新型脉冲调制法\解码性能\demod1(ortho_code).mat')));
% BER_demod2_orthoseq=cell2mat(struct2cell(load('C:\Users\Administrator\Desktop\新型脉冲调制法\解码性能\demod2(ortho_code).mat')));

SNR=-25:-5;
figure(3)
semilogy(SNR,BERwhole)
% semilogy(SNR,BER_demod1_dseq,'-ro',SNR,BER_demod1_seq1,'-rs',SNR,BER_demod1_seq2,'-r*',...
%     SNR,BER_demod2_dseq,'-bo',SNR,BER_demod2_seq1,'-bs',SNR,BER_demod2_seq2,'-b*',...
%     SNR,BER_demod1_orthoseq,'-kx',SNR,BER_demod2_orthoseq,'-k+')
% legend('解调方法1(直接码)','解调方法1(Gold序列1(互相关值-9)）','解调方法1(Gold序列2(互相关值-1))',...
%     '解调方法2(直接码)','解调方法2(Gold序列1(互相关值-9))','解调方法2(Gold序列2(互相关值-1))',...
%     '解调方法1(正交码)','解调方法2(正交码)')
grid on;
xlabel('SNR')
ylabel('BER')
xlim([-25 -10]);
ylim([1e-5 1]);
