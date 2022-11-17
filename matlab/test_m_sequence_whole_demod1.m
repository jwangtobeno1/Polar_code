times=1e4;
BER=zeros(times,21);

for i=1:times
    BER(i,:)=test_m_sequence;
end

BERwhole=sum(BER,1)./times;

% BER_demod1_dseq=cell2mat(struct2cell(load('C:\Users\Administrator\Desktop\����������Ʒ�\��������\demod1(directcode).mat')));
% BER_demod1_seq1=cell2mat(struct2cell(load('C:\Users\Administrator\Desktop\����������Ʒ�\��������\demod1(seq2).mat')));
% BER_demod1_seq2=cell2mat(struct2cell(load('C:\Users\Administrator\Desktop\����������Ʒ�\��������\demod1(seq3(corrvalue_-1)).mat')));
% BER_demod2_dseq=cell2mat(struct2cell(load('C:\Users\Administrator\Desktop\����������Ʒ�\��������\demod2(directcode).mat')));
% BER_demod2_seq1=cell2mat(struct2cell(load('C:\Users\Administrator\Desktop\����������Ʒ�\��������\demod2(seq2).mat')));
% BER_demod2_seq2=cell2mat(struct2cell(load('C:\Users\Administrator\Desktop\����������Ʒ�\��������\demod2(seq3(corrvalue_-1)).mat')));
% 
% BER_demod1_orthoseq=cell2mat(struct2cell(load('C:\Users\Administrator\Desktop\����������Ʒ�\��������\demod1(ortho_code).mat')));
% BER_demod2_orthoseq=cell2mat(struct2cell(load('C:\Users\Administrator\Desktop\����������Ʒ�\��������\demod2(ortho_code).mat')));

SNR=-25:-5;
figure(3)
semilogy(SNR,BERwhole)
% semilogy(SNR,BER_demod1_dseq,'-ro',SNR,BER_demod1_seq1,'-rs',SNR,BER_demod1_seq2,'-r*',...
%     SNR,BER_demod2_dseq,'-bo',SNR,BER_demod2_seq1,'-bs',SNR,BER_demod2_seq2,'-b*',...
%     SNR,BER_demod1_orthoseq,'-kx',SNR,BER_demod2_orthoseq,'-k+')
% legend('�������1(ֱ����)','�������1(Gold����1(�����ֵ-9)��','�������1(Gold����2(�����ֵ-1))',...
%     '�������2(ֱ����)','�������2(Gold����1(�����ֵ-9))','�������2(Gold����2(�����ֵ-1))',...
%     '�������1(������)','�������2(������)')
grid on;
xlabel('SNR')
ylabel('BER')
xlim([-25 -10]);
ylim([1e-5 1]);
