function infoPos = get_infopos(K,N)

    n = log2(N);
    beta = 2^(0.25);
    pw = zeros(1,N);
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
    [~,id] = sort(pw);
    infoPos = sort(id(K+1:1:end));
    