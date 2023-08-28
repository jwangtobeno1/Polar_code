function bit_reverse_res = bit_reversed(s)

    N = length(s);
    bit_reverse_res = zeros(1,N);
    x = (1 : N)';
    v = bitrevorder(x);
    for i = 1 : N
        bit_reverse_res(i) = s(v(i));
    end