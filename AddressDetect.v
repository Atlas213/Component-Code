module AddressDetect(AddrI,Enable,AddrO);
input [7:0] AddrI;
output Enable;
output [3:0] AddrO;

reg out;
assign Enable = out;
assign AddrO[3:0] = AddrI[3:0];

always @(AddrI) begin

	if(AddrI[7:4] == 4'b1111)
	begin
		out <= 1'b1;
	end
	else
	begin
		out <= 1'b0;
	end
end
endmodule