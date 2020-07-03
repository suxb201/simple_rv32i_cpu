module id (
           input wire clk,

           input wire[31:0] pc,
           input wire[31:0] inst,

           output reg[4:0] opcode,  // for micro inst
           output wire[31:0] reg_addr1, // for reg
           output wire[31:0] reg_addr2, // for reg

           input wire[31:0] reg_data1,
           input wire[31:0] reg_data2,

           input wire[31:0] last_data,
           input wire[4:0] last_rd,


           output reg o_jump,
           output reg[4:0] rd,
           output reg[31:0] jump_addr,
           output reg[31:0] op1,
           output reg[31:0] op2,
           output reg[4:0] o_opcode
       );

assign reg_addr1 = inst[19:15];
assign reg_addr2 = inst[24:20];

always @(*) begin

    casex(inst)
        32'bxxxxxxxxxxxxxxxxxxxxxxxxx1101111: opcode <= 5'b10000;  // jal   J
        32'bxxxxxxxxxxxxxxxxx000xxxxx1100011: opcode <= 5'b10001;  // beq    B
        // 32'bxxxxxxxxxxxxxxxxx100xxxxx1100011: opcode <= 5'b10010;  // blt
        32'bxxxxxxxxxxxxxxxxx010xxxxx0000011: opcode <= 5'b10100;  // lw     I
        32'bxxxxxxxxxxxxxxxxx010xxxxx0100011: opcode <= 5'b10101;  // sw     S
        32'bxxxxxxxxxxxxxxxxx000xxxxx0010011: opcode <= 5'b01100;  // addi   I
        32'b0000000xxxxxxxxxx000xxxxx0110011: opcode <= 5'b01101;  // add
        32'b0100000xxxxxxxxxx000xxxxx0110011: opcode <= 5'b01110;  // sub
        32'b0000000xxxxxxxxxx001xxxxx0110011: opcode <= 5'b01000;  // sll
        32'b0000000xxxxxxxxxx100xxxxx0110011: opcode <= 5'b00110;  // xor
        32'b0000000xxxxxxxxxx101xxxxx0110011: opcode <= 5'b01001;  // srl
        32'b0000000xxxxxxxxxx110xxxxx0110011: opcode <= 5'b00101;  // or
        32'b0000000xxxxxxxxxx111xxxxx0110011: opcode <= 5'b00100;  // and
        default:  opcode <= 5'b11111;  // not legal
    endcase

end


// -------------------------- before tick -----------------------------
reg[31:0] tmp_pc;
reg[4:0] tmp_reg1;
reg[4:0] tmp_reg2;
reg[31:0] imm_I;
reg[31:0] imm_B;
reg[31:0] imm_S;
reg[31:0] imm_J;



always @(posedge clk) begin
    tmp_pc   <= pc;
    tmp_reg1 <= reg_addr1;
    tmp_reg2 <= reg_addr2;
    imm_I <= {{21{inst[31:31]}}, inst[30:20]};
    imm_B <= {{20{inst[31:31]}}, inst[ 7: 7], inst[30:25], inst[11:8], 1'b0};
    imm_S <= {{20{inst[31:31]}}, inst[ 7: 7], inst[30:25], inst[11:8], 1'b0};
    imm_J <= {{12{inst[31:31]}}, inst[19:12], inst[20:20], inst[30:25], inst[24:21], 1'b0};
    // output
    o_opcode <= opcode;
    rd       <= inst[11:7];
end

// ------------------- after tick ----------------------

reg[31:0] r1;
reg[31:0] r2;
//assign r1 = tmp_reg1==last_rd? last_data: reg_data1;
//assign r2 = tmp_reg2==last_rd? last_data: reg_data2;
always @(*) begin
    if(tmp_reg1==last_rd) begin
        r1 <= last_data;
    end
    else
        r1 <= reg_data1;
    if(tmp_reg2==last_rd) begin
        r2 <= last_data;
    end
    else
        r2 <= reg_data2;
end

always @(*) begin


    // jump op1 op2
    if (o_opcode == 5'b10000) begin      // J jal
        o_jump    <= 1;
        jump_addr <= tmp_pc + imm_J;
        op1       <= 0;
        op2       <= 0;
    end
    else if (o_opcode == 5'b10001) begin //  B beq
        if (r1==r2)
            o_jump    <= 1;
        else
            o_jump    <= 0;
        jump_addr <= tmp_pc + imm_B;
        op1       <= 0;
        op2       <= 0;
        $display("tmp_pc:%h, imm_B:%d",tmp_pc,imm_B);
    end
    else if (o_opcode == 5'b10101) begin // S sw
        o_jump    <= 0;
        jump_addr <= 0;
        op1       <= r1+imm_S;
        op2       <= r2;       // op2 -> M[op1]

    end
    else if (o_opcode == 5'b10101) begin // I lw
        o_jump    <= 0;
        jump_addr <= 0;
        op1       <= r1+imm_I;     // M[op1] -> x rd
        op2       <= 0;
    end
    else if (o_opcode==5'b01100 ) begin // I: addi
        o_jump    <= 0;
        jump_addr <= 0;
        op1       <= r1;
        op2       <= imm_I;
    end
    else begin // R
        o_jump    <= 0;
        jump_addr <= 0;
        op1       <= r1;
        op2       <= r2;
    end
end


endmodule
