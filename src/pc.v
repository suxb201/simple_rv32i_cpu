module pc (
           input wire clk,
           input wire[31:0] pc,
           input wire jump,
           input wire [31:0] jump_addr,

           output reg [31:0] next_pc,
           output reg [31:0] o_pc

       );

initial begin
    o_pc    <= 32'h0-4;
    next_pc <= 32'h0;
end

always @(*) begin
    if(jump)
        next_pc <= jump_addr;
    else
        next_pc <= pc+4;
end

always @ (posedge clk) begin
    o_pc <= next_pc;
end

endmodule
