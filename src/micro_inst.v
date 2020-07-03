module micro_inst (
           input  wire          clk,
           input  wire[4:0]     opcode,
           input wire jump,
           output reg          mem_re,
           output reg          mem_we,
           output reg          reg_we
       );

always @(posedge clk) begin
    if (jump) begin
        mem_re <= 0;
        mem_we <= 0;
        reg_we <= 0;
    end
    else begin
        // mem_re
        if (opcode == 5'b10100)  // I lw
            mem_re <= 1;
        else
            mem_re <= 0;

        // mem_we
        if (opcode == 5'b10101)  // S sw
            mem_we <= 1;
        else
            mem_we <= 0;

        // reg_we
        case (opcode)
            5'b10000: reg_we <= 0; 			// jal
            5'b10001: reg_we <= 0; 		    // beq
            5'b10100: reg_we <= 0; 			// lw
            5'b10101: reg_we <= 0; 			// sw
            5'b01100: reg_we <= 1;  		// addi
            5'b01101: reg_we <= 1;  		// add
            5'b01110: reg_we <= 1;  		// sub
            5'b01000: reg_we <= 1;	        // sll
            5'b00110: reg_we <= 1; 		    // xor
            5'b01001: reg_we <= 1;  	    // srl
            5'b00101: reg_we <= 1;  		// or
            5'b00100: reg_we <= 1;  		// and
            default:  reg_we <= 0;
        endcase

    end
end
endmodule
