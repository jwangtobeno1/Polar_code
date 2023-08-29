module udp_rx(
    input   wire            clk         ,
    input   wire            rst_n       ,
    
    input   wire            gmii_rx_dv  , //gmii input data valid
    input   wire    [7:0]   gmii_rxd    ,
    output  reg             rec_pkt_done, //recive data done
    output  reg             rec_en      , //eth recive data enable
    output  reg     [127:0] rec_data    ,
    output  reg     [15:0]  rec_byte_num
);

parameter BOARD_MAC = 48'hff_ff_ff_ff_ff_ff;
parameter BOARD_IP = {8'd0,8'd0,8'd0,8'd0};

localparam st_idle      =   7'b000_0001;
localparam st_preamble  =   7'b000_0010;
localparam st_eth_head  =   7'b000_0100;
localparam st_ip_head   =   7'b000_1000;
localparam st_udp_head  =   7'b001_0000;
localparam st_rx_data   =   7'b010_0000;
localparam st_rx_end    =   7'b100_0000;

localparam ETH_TYPE = 16'h0800; //以太网协议类型，IP协议

reg     [6:0]   cur_state;
reg     [6:0]   next_state;

reg             sw_en; //state switch enable
reg             err_en; //error and state to idle
reg     [4:0]   cnt_byte;
reg     [47:0]  des_mac;
reg     [15:0]  eth_type;
reg     [31:0]  des_ip;
reg     [5:0]   ip_head_byte_num;
reg     [127:0] rec_data_reg;
reg     [15:0]  udp_byte_num;
reg     [15:0]  data_byte_num;
reg     [15:0]  data_cnt;
reg     [3:0]   rec_en_cnt; //8bit to 128bit; ??
/*
ila_1 udp_rx_ila (
    .clk(clk), // input wire clk


    .probe0(cur_state), // input wire [6:0]  probe0  
    .probe1(rec_data), // input wire [127:0]  probe1 
    .probe2(gmii_rxd), // input wire [7:0]  probe2 
    .probe3(data_byte_num), // input wire [15:0]  probe3 
    .probe4(data_cnt), // input wire [15:0]  probe4 
    .probe5(rec_en_cnt), // input wire [3:0]  probe5 
    .probe6(rec_en) // input wire [0:0]  probe6
);
*/
always@(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0)
        cur_state <= st_idle;
    else
        cur_state <= next_state;
end

always@(*) begin
    next_state <= st_idle;
    case(cur_state)
        st_idle :   if(sw_en)
                        next_state <= st_preamble;
                    else
                        next_state <= st_idle;
        st_preamble : if(sw_en)
                        next_state <= st_eth_head;
                    else if(err_en)
                        next_state <= st_rx_end;
                    else
                        next_state <= st_preamble;
        st_eth_head : if(sw_en)
                        next_state <= st_ip_head;
                    else if(err_en)
                        next_state <= st_rx_end;
                    else
                        next_state <= st_eth_head;
        st_ip_head :  if(sw_en)
                        next_state <= st_udp_head;
                    else if(err_en)
                        next_state <= st_rx_end;
                    else
                        next_state <= st_ip_head;
        st_udp_head : if(sw_en)
                        next_state <= st_rx_data;
                    else
                        next_state <= st_udp_head;
        st_rx_data : if(sw_en)
                        next_state <= st_rx_end;
                    else
                        next_state <= st_rx_data;
        st_rx_end : if(sw_en)
                        next_state <= st_idle;
                    else
                        next_state <= st_rx_end;
        default : next_state <= st_idle;
    endcase
end

always@(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0) begin
        sw_en <= 1'b0;
        err_en <= 1'b0;
        cnt_byte <= 5'd0;
        des_mac <= 48'd0;
        eth_type <= 16'd0;
        des_ip <= 32'd0;
        ip_head_byte_num <= 6'd0;
        udp_byte_num <= 16'd0;
        data_byte_num <= 16'd0;
        data_cnt <= 16'd0;
        rec_en_cnt <= 4'd0;
        rec_data <= 128'd0;
        rec_pkt_done <= 1'd0;
        rec_byte_num <= 16'd0;
    end
    else begin
        sw_en <= 1'b0;
        err_en <= 1'b0;
        rec_en <= 1'b0;
        rec_pkt_done <= 1'b0;
        case(next_state)
            st_idle : begin
                if((gmii_rx_dv == 1'b1) && (gmii_rxd == 8'h55))
                    sw_en <= 1'b1;
            end
            st_preamble : begin
                if(gmii_rx_dv) begin
                    cnt_byte <= cnt_byte + 1'b1;
                    if((cnt_byte < 5'd6) && (gmii_rxd != 8'h55))
                        err_en <= 1'b1;
                    else if(cnt_byte == 5'd6) begin
                        cnt_byte <= 5'd0;
                        if(gmii_rxd == 8'hd5)
                            sw_en <= 1'b1;
                        else
                            err_en <= 1'b1;
                    end
                end
            end
            st_eth_head : begin
                if(gmii_rx_dv) begin
                    cnt_byte <= cnt_byte + 1'b1;
                    if(cnt_byte < 5'd6)
                        des_mac <= {des_mac[39:0],gmii_rxd};
                    else if(cnt_byte == 5'd12)
                        eth_type[15:8] <= gmii_rxd;
                    else if(cnt_byte == 5'd13) begin
                        eth_type[7:0] <= gmii_rxd;
                        cnt_byte <= 5'd0;
                        if(((des_mac == BOARD_MAC) || (des_mac == 48'hff_ff_ff_ff_ff_ff))
                        && eth_type[15:8] == ETH_TYPE[15:8] && gmii_rxd == ETH_TYPE[7:0])
                            sw_en <= 1'b1;
                        else
                            err_en <= 1'b1;
                    end
                end
            end
            st_ip_head : begin
                if(gmii_rx_dv) begin
                    cnt_byte <= cnt_byte + 1'b1;
                    if(cnt_byte == 5'd0)
                        ip_head_byte_num <= {gmii_rxd[3:0],2'd0};
                    else if((cnt_byte >= 5'd16) && (cnt_byte <= 5'd18))
                        des_ip <= {des_ip[23:0],gmii_rxd};
                    else if(cnt_byte == 5'd19) begin
                        des_ip <= {des_ip[23:0],gmii_rxd}; //判断IP地址是否为开发板IP地址
                        if((des_ip[23:0] == BOARD_IP[31:8]) && (gmii_rxd == BOARD_IP[7:0])) begin
                            if(cnt_byte == ip_head_byte_num - 1'b1) begin
                                sw_en <= 1'b1;
                                cnt_byte <= 5'd0;
                            end
                        end
                        else begin
                            err_en <= 1'b1;
                            cnt_byte <= 5'd0;
                        end
                    end
                    else if(cnt_byte == ip_head_byte_num - 1'b1) begin
                        sw_en <= 1'b1;
                        cnt_byte <= 5'd0;
                    end
                end
            end
            st_udp_head : begin
                if(gmii_rx_dv) begin
                    cnt_byte <= cnt_byte + 1'b1;
                    if(cnt_byte == 5'd4)
                        udp_byte_num[15:8] <= gmii_rxd; //解析udp字节长度
                    else if(cnt_byte == 5'd5)
                        udp_byte_num[7:0] <= gmii_rxd;
                    else if(cnt_byte == 5'd7) begin
                        data_byte_num <= udp_byte_num -16'd8;
                        sw_en <= 1'b1;
                        cnt_byte <= 5'd0;
                    end
                end
            end
            st_rx_data : begin
                //接收数据，转换成128bit
                if(gmii_rx_dv) begin
                    data_cnt <= data_cnt + 16'd1;
                    rec_en_cnt <= rec_en_cnt + 4'd1; //4*8
                    if(data_cnt == data_byte_num - 16'd1) begin
                        sw_en <= 1'b1;
                        data_cnt <= 16'd0;
                        rec_en_cnt <= 4'd0;
                        rec_pkt_done <= 1'b1;
                        rec_en <= 1'b1;
                        rec_byte_num <= data_byte_num;
                        case(rec_en_cnt)
                            4'b0000 : rec_data[119:0] <= 120'b0;
                            4'b0001 : rec_data[111:0] <= 112'b0;
                            4'b0010 : rec_data[103:0] <= 104'b0;
                            4'b0011 : rec_data[95 :0] <= 96'b0;
                            4'b0100 : rec_data[87 :0] <= 88'b0;
                            4'b0101 : rec_data[79 :0] <= 80'b0;
                            4'b0110 : rec_data[71 :0] <= 70'b0;
                            4'b0111 : rec_data[63 :0] <= 64'b0;
                            4'b1000 : rec_data[55 :0] <= 56'b0;
                            4'b1001 : rec_data[47 :0] <= 48'b0;
                            4'b1010 : rec_data[39 :0] <= 40'b0;
                            4'b1011 : rec_data[31 :0] <= 32'b0;
                            4'b1100 : rec_data[23 :0] <= 24'b0;
                            4'b1101 : rec_data[15 :0] <= 16'b0;
                            4'b1110 : rec_data[8  :0] <= 8'b0;
                        endcase
                    end
                    case(rec_en_cnt)
                        4'b0000 : rec_data[127:120] <= gmii_rxd;
                        4'b0001 : rec_data[119:112] <= gmii_rxd;
                        4'b0010 : rec_data[111:104] <= gmii_rxd;
                        4'b0011 : rec_data[103:96 ] <= gmii_rxd;
                        4'b0100 : rec_data[95 :88 ] <= gmii_rxd;
                        4'b0101 : rec_data[87 :80 ] <= gmii_rxd;
                        4'b0110 : rec_data[79 :72 ] <= gmii_rxd;
                        4'b0111 : rec_data[71 :64 ] <= gmii_rxd;
                        4'b1000 : rec_data[63 :56 ] <= gmii_rxd;
                        4'b1001 : rec_data[55 :48 ] <= gmii_rxd;
                        4'b1010 : rec_data[47 :40 ] <= gmii_rxd;
                        4'b1011 : rec_data[39 :32 ] <= gmii_rxd;
                        4'b1100 : rec_data[31 :24 ] <= gmii_rxd;
                        4'b1101 : rec_data[23 :16 ] <= gmii_rxd;
                        4'b1110 : rec_data[15 :8  ] <= gmii_rxd;
                        4'b1111 : 
                                begin 
                                    rec_data[7:0] <= gmii_rxd;
                                    rec_en <= 1'b1;
                                end
                    endcase
                end
            end
            st_rx_end : begin
                if(gmii_rx_dv == 1'b0 && sw_en == 1'b0)
                    sw_en <= 1'b1;
            end
            default : ;
        endcase
    end
end


endmodule