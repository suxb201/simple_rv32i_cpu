module mem(
           input	wire		clk,
           input	wire		mem_re,
           input	wire		mem_we,
           input	wire[31:0]	mem_addr,
           input	wire[31:0]	mem_data_in,

           output	reg [31:0]	mem_data_out,
           output	reg		    o_mem_re
       );

reg[7:0]  data[0:32'hffffffff]; // 4g ram

initial $readmemh ( "D:\\01_projects\\suxb201.github.io\\simple_rv32i_cpu\\test\\momory.txt", data );

always @ (posedge clk) begin
    o_mem_re <= mem_re;
    if (mem_we) begin
        data[mem_addr]     <= mem_data_in[7:0];
        data[mem_addr + 1] <= mem_data_in[15:8];
        data[mem_addr + 2] <= mem_data_in[23:16];
        data[mem_addr + 3] <= mem_data_in[31:24];
        // $display("MEM write, addr: %h, data: %h", addr, data_in);
    end
    else if (mem_re) begin
        mem_data_out = {
                         data[mem_addr + 3],
                         data[mem_addr + 2],
                         data[mem_addr + 1],
                         data[mem_addr]
                     };
        // $display("MEM read, addr: %h, data: %h", addr, data_out);
    end

end

endmodule
