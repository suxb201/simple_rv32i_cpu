

module register(
           input   wire        clk,                   //

           input   wire        reg_we,                   //
           input   wire[4:0]   write_addr,            // 寄存器编��? 32 ��?
           input   wire[31:0]  write_data,            //

           input   wire[4:0]   read_addr1,            // 读地��?
           input   wire[4:0]   read_addr2,            //

           output  reg [31:0]  read_data1,            // 返回内容
           output  reg [31:0]  read_data2             //
       );


reg [31:0] reg_file [0:32];

initial reg_file[5'h0] <= 32'b0;

reg[4:0]  r1;
reg[4:0]  r2;
// write read
always @ (posedge clk) begin
    if (reg_we) begin
        reg_file[write_addr] <= write_data;
    end
    r1 <= read_addr1;
    r2 <= read_addr2;
end

always @(*) begin

    read_data1 <= reg_file[r1];
    read_data2 <= reg_file[r2];
end



endmodule
