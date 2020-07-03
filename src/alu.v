module alu (
           input wire clk,
           input wire [31:0] op1,
           input wire [31:0] op2,
           input wire [4:0] op,

           output reg [31:0] alu_out
       );

always @(posedge clk) begin
    case (op)
        5'b10000: alu_out <= 32'b0; 			// jal
        5'b10001: alu_out <= 32'b0; 		    // beq
        5'b10100: alu_out <= 32'b0; 			// lw
        5'b10101: alu_out <= 32'b0; 			// sw
        5'b01100: alu_out <= op1 +  op2;  		// addi
        5'b01101: alu_out <= op1 +  op2;  		// add
        5'b01110: alu_out <= op1 -  op2;  		// sub
        5'b01000: alu_out <= op1 << op2[4:0];	// sll
        5'b00110: alu_out <= op1 ^  op2; 		// xor
        5'b01001: alu_out <= op1 >> op2[4:0];  	// srl
        5'b00101: alu_out <= op1 |  op2;  		// or
        5'b00100: alu_out <= op1 &  op2;  		// and
        default:  alu_out <= 32'b0;
    endcase
end


endmodule
