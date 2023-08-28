function EncodeRes = PolarEncode(msg)

n = 8; 
N = 2^n; %码长

%% 生成信源
% eg:67AB947CFC6176112BE2361A0653E8AE
Source = sendmsg(msg);
fprintf('Source is  %s\n',Source);
u = hexToBinaryVector(Source,128);

% FileData = load('./u_b.txt');
% u = FileData(:,1);

%% 信道可靠性检测
pw = zeros(1,N);
beta = 2^(0.25);
for i= 1 : 1 : N 
    i_B_char = dec2base(i-1,2,n);
    i_B_7 = str2double(i_B_char(1));
    i_B_6 = str2double(i_B_char(2));
    i_B_5 = str2double(i_B_char(3));
    i_B_4 = str2double(i_B_char(4));
    i_B_3 = str2double(i_B_char(5));
    i_B_2 = str2double(i_B_char(6));
    i_B_1 = str2double(i_B_char(7));
    i_B_0 = str2double(i_B_char(8));
    pw(i) = i_B_0*beta^(0)+i_B_1*beta^(1)+i_B_2*beta^(2)+i_B_3*beta^(3)+i_B_4*beta^(4)+...
        i_B_5*beta^(5)+i_B_6*beta^(6)+i_B_7*beta^(7);
end
mix_data = zeros(1,N);
[~,id] = sort(pw);
id_128 = id(129:1:end);
for i = 1 : 1 : 128
   mix_data(id_128(i)) = 1;
end
%result_128 = sort(id_128);
j=1;
for i = 1 : 1 : N
   if(mix_data(i) == 1)
       mix_data(i) = u(j);
       j = j + 1;
   end
end
%% 编码
F = [1 0; 1 1];
f_kronecker_2 = kron(F,F);
f_kronecker_3 = kron(f_kronecker_2, F);
f_kronecker_4 = kron(f_kronecker_3, F);
f_kronecker_5 = kron(f_kronecker_4, F);
f_kronecker_6 = kron(f_kronecker_5, F);
f_kronecker_7 = kron(f_kronecker_6, F);
f_kronecker_8 = kron(f_kronecker_7, F);
EncodeRes_Bit = mod(mix_data*f_kronecker_8,2); %编码后结果

%% 比特翻转 
% 由于译码器端进行了比特翻转，那么这里就不用了
s=(1:1:N);
s=(s-1).';
w=dec2bin(s);
w=w(:,8:-1:1);
s=bin2dec(w)+1;
s=s.';
EncodeRes_reg = zeros(1,256);
for i = 1 : 1 : 256
    EncodeRes_reg(i) = EncodeRes_Bit(s(i));
end

%% 编码结果转换
%如果要比特翻转的话，这里的EncodeRes_Bit需要改成EncodeRes_reg
EncodeRes_Bit_8_32 = reshape(EncodeRes_Bit,[8,32]).';                            
EncodeRes_Dec = binaryVectorToDecimal(EncodeRes_Bit_8_32);
EncodeRes = uint8(EncodeRes_Dec);
%% 编码结果转为16进制
%如果有进行比特翻转的话，这里的EncodeRes_Bit需要改成EncodeRes_reg
EncodeRes_hex = binaryVectorToHex(EncodeRes_Bit);                           
fprintf('Encode Result is  %s\n',EncodeRes_hex);
