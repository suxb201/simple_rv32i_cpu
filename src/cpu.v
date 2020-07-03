module cpu();

reg	clk;
wire jump;
wire mem_re, o_mem_re, mem_we, reg_we, o_reg_we;
wire[31:0] pc, next_pc; // IF - pc
wire[31:0] jump_addr, inst;
wire[31:0] reg_data1, reg_data2, reg_addr1, reg_addr2;
wire[31:0] op1, op2, alu_out, mem_data_out, mem_out;
wire[4:0] opcode, o_opcode;
wire[4:0] rd, o_rd;


initial begin
    clk = 1'b0;
    forever #50 clk = ~clk;
end

initial begin
    // rst = 1'b0;
    // #200    rst = 1'b0;
    #10000 $stop;
end

// ------------------------- IF ----------------------------------

pc the_pc(
       .clk(clk), .pc(pc), .jump(jump), .jump_addr(jump_addr),
       .next_pc(next_pc),
       .o_pc(pc) // poedge
   );

ram_inst the_ram_inst(
             .clk(clk), .pc(next_pc),
             .inst(inst) // poedge
         );

// ------------------------- ID ----------------------------------

id the_id(
       .clk(clk), .pc(pc), .inst(inst), .reg_data1(reg_data1), .reg_data2(reg_data2), .last_rd(o_rd), .last_data(alu_out),
       .opcode(opcode),.reg_addr1(reg_addr1), .reg_addr2(reg_addr2),
       .o_jump(jump), .jump_addr(jump_addr), .rd(rd), .op1(op1), .op2(op2), .o_opcode(o_opcode)// poedge
   );

micro_inst the_micro_inst(
               .clk(clk), .opcode(opcode),.jump(jump),
               .mem_re(mem_re), .mem_we(mem_we), .reg_we(reg_we) // poedge
           );


register the_register(
             .clk(clk), .read_addr1(reg_addr1), .read_addr2(reg_addr2), .reg_we(o_reg_we), .write_addr(o_rd), .write_data(mem_out),
             .read_data1(reg_data1), .read_data2(reg_data2) // poedge
         );



// ------------------------- EX ----------------------------------

alu the_alu(
        .clk(clk), .op1(op1), .op2(op2), .op(o_opcode),
        .alu_out(alu_out) // posedge
    );

mem the_mem(
        .clk(clk), .mem_re(mem_re), .mem_we(mem_we), .mem_addr(op1), .mem_data_in(op2),
        .mem_data_out(mem_data_out), .o_mem_re(o_mem_re)// poedge
    );
pre_wb the_pre_wb(
           .clk(clk), .alu_out(alu_out), .mem_re(o_mem_re), .mem_data_out(mem_data_out), .reg_addr(rd), .reg_we(reg_we),
           .mem_out(mem_out), // *
           .o_reg_addr(o_rd), .o_reg_we(o_reg_we)  // posedge
       );

// ------------------------- WB ----------------------------------


endmodule
