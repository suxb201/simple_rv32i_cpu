module ram_inst(
           input	wire		clk,    // 使能
           input	wire[31:0]	pc,
           output 	reg [31:0]	inst
       );

reg[31:0]  data[0:1023]; // len: 1024 word: 32
initial $readmemb ("D:\\01_projects\\suxb201.github.io\\simple_rv32i_cpu\\test\\machinecode.txt", data);	// read test assembly code file

always @ (posedge clk) begin
    inst <= data[pc[31:2]]; // pc+4
end

endmodule
