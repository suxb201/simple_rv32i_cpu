module pre_wb (
           input   wire         clk,
           input   wire         mem_re,
           input   wire         reg_we,
           input   wire[31:0]   alu_out,
           input   wire[31:0]   mem_data_out,
           input   wire[4:0]    reg_addr,

           output  reg[4:0]    o_reg_addr,
           output  reg[31:0]    mem_out,
           output  reg[31:0]    o_reg_we
       );


always @(*) begin
    if (mem_re) begin
        mem_out <= mem_data_out;
    end else begin
        mem_out <= alu_out;
    end
end

always @(posedge clk) begin
    o_reg_addr <= reg_addr;
    o_reg_we   <= reg_we;
end


endmodule
