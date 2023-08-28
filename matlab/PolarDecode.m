function DecRes = PolarDecode(llr_arr)
    addpath('decoder_function/');
    llr = bit_reversed(llr_arr);
    l128l = func_f(llr);
    l64l = func_f(l128l);
    l32r = func_g(l64l,zeros(1,32));
    l16r = func_g(l32r,zeros(1,16));
    l8l = func_f(l16r);
    b8l = func_rep(l8l);
    l8r = func_g(l16r, b8l);
    l4l = func_f(l8r);
    b4l = func_rep(l4l);
    l4r = func_g(l8r, b4l);  % 10
    b4r = func_spc(l4r);
    b8r = bit_combine(b4l, b4r);
    b16r = bit_combine(b8l, b8r);
    b32r = bit_combine(zeros(1,16),b16r);
    b64l = bit_combine(zeros(1,32),b32r);
    % print(f"b8l:\t{b8l}\nb4r:\t{b4r}\nb8r:\t{b8r}\nb16r:\t{b16r}\nb32r:\t{b32r}\nb64l:\t{b64l}\n")
    l64r = func_g(l128l, b64l); %16
    l32l = func_f(l64r);
    l16l = func_f(l32l);
    b16l = func_rep(l16l);
    l16r = func_g(l32l, b16l);
    l8l = func_f(l16r);
    b8l = func_rep(l8l);
    l8r = func_g(l16r, b8l);  %23
    l4l = func_f(l8r);
    b4l = func_rep(l4l);
    l4r = func_g(l8r, b4l);
    b4r = func_spc(l4r);
    b8r = bit_combine(b4l, b4r);
    b16r = bit_combine(b8l, b8r);
    b32l = bit_combine(b16l, b16r);
    % print(f"b16l:\t{b16l}\nb8l:\t{b8l}\nb4l:\t{b4l}\nb4r:\t{b4r}\nb8r:\t{b8r}\nb16r:\t{b16r}\nb32l:\t{b32l}\n")
    l32r = func_g(l64r, b32l);
    l16l = func_f(l32r);  % 32
    l8l = func_f(l16l);
    b8l = func_rep(l8l);
    l8r = func_g(l16l, b8l);
    b8r = func_type3(l8r);
    b16l = bit_combine(b8l, b8r);
    l16r = func_g(l32r, b16l);
    b16r = func_spc(l16r);
    b32r = bit_combine(b16l, b16r);
    b64r = bit_combine(b32l, b32r);
    b128l = bit_combine(b64l, b64r);  % 42
    % print(f"b8l:\t{b8l}\nb8r:\t{b8r}\nb16l:\t{b16l}\nb16r:\t{b16r}\nb32r:\t{b32r}\nb64r:\t{b64r}\n")

    l128r = func_g(llr, b128l);
    l64l = func_f(l128r);
    l32l = func_f(l64l);
    l16l = func_f(l32l);
    b16l = func_rep(l16l);
    l16r = func_g(l32l, b16l);
    l8l = func_f(l16r);
    b8l = func_type1(l8l);
    l8r = func_g(l16r, b8l);
    b8r = func_spc(l8r);
    b16r = bit_combine(b8l, b8r);
    b32l = bit_combine(b16l, b16r);  % 54
    % print(f"b16l:\t{b16l}\nb8l:\t{b8l}\nb8r:\t{b8r}\nb16r:\t{b16r}\nb32l:\t{b32l}\n")
    l32r = func_g(l64l, b32l);
    l16l = func_f(l32r);
    l8l = func_f(l16l);
    l4l = func_f(l8l);
    b4l = func_rep(l4l);
    l4r = func_g(l8l, b4l);
    b4r = func_spc(l4r);
    b8l = bit_combine(b4l, b4r);
    l8r = func_g(l16l, b8l);
    b8r = func_spc(l8r);
    b16l = bit_combine(b8l, b8r);
    l16r = func_g(l32r, b16l);
    b16r = func_spc(l16r);
    b32r = bit_combine(b16l, b16r);
    b64l = bit_combine(b32l, b32r);  % 69
    % print(f"b4l:\t{b4l}\nb4r:\t{b4r}\nb8l:\t{b8l}\nb8r:\t{b8r}\nb16l:\t{b16l}\nb16r:\t{b16r}\nb32r:\t{b32r}\nb64l:\t{b64l}\n")
    l64r = func_g(l128r, b64l);
    l32l = func_f(l64r);
    l16l = func_f(l32l);
    l8l = func_f(l16l);
    l4l = func_f(l8l);
    b4l = func_rep(l4l);
    l4r = func_g(l8l, b4l);
    b4r = func_spc(l4r);
    b8l = bit_combine(b4l, b4r);
    l8r = func_g(l16l, b8l);
    b8r = func_spc(l8r);
    b16l = bit_combine(b8l, b8r);
    l16r = func_g(l32l, b16l);
    b16r = func_rate1(l16r);
    b32l = bit_combine(b16l, b16r);
    % print(f"b4l:\t{b4l}\nb4r:\t{b4r}\nb8l:\t{b8l}\nb8r:\t{b8r}\nb16l:\t{b16l}\nb16r:\t{b16r}\nb32l:\t{b32l}\n")
    l32r = func_g(l64r, b32l);
    b32r = func_rate1(l32r);
    b64r = bit_combine(b32l, b32r);
    b128r = bit_combine(b64l, b64r);
    b256 = bit_combine(b128l, b128r);
    %% Kron
    F = [1 0; 1 1];
    f_kronecker_2 = kron(F,F);
    f_kronecker_3 = kron(f_kronecker_2, F);
    f_kronecker_4 = kron(f_kronecker_3, F);
    f_kronecker_5 = kron(f_kronecker_4, F);
    f_kronecker_6 = kron(f_kronecker_5, F);
    f_kronecker_7 = kron(f_kronecker_6, F);
    f_kronecker_8 = kron(f_kronecker_7, F);
    KronRes = mod(b256*f_kronecker_8,2);
    
    %% Extract
    DecRes = zeros(1,128);
    infoPos = get_infopos(128,256);
    for i = 1 : 1 : 128
        DecRes(i) = KronRes(infoPos(i));
    end
    %DecRes_hex = binaryVectorToHex(DecRes);
    