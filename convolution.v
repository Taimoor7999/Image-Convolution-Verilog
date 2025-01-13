module convolution(
input        clk,
input [71:0] pixel_data_in,
input        pixel_data_valid_in,
output reg [7:0] convolved_data_out,
output reg   convolved_data_valid_out
);
    
reg [7:0] kernel_horizontal [8:0];
reg [7:0] kernel_vertical [8:0];
reg [10:0] mult_result_horizontal[8:0];
reg [10:0] mult_result_vertical[8:0];
reg [10:0] sum_horizontal;
reg [10:0] sum_vertical;
reg [10:0] sum_horizontal_reg;
reg [10:0] sum_vertical_reg;
reg mult_result_valid;
reg sum_result_valid;
reg convolved_data_valid_reg;
reg [20:0] convolved_data_intermediate1;
reg [20:0] convolved_data_intermediate2;
wire [21:0] convolved_data_combined;
reg convolved_data_intermediate_valid;

initial begin
    kernel_horizontal[0] =  1;
    kernel_horizontal[1] =  0;
    kernel_horizontal[2] = -1;
    kernel_horizontal[3] =  2;
    kernel_horizontal[4] =  0;
    kernel_horizontal[5] = -2;
    kernel_horizontal[6] =  1;
    kernel_horizontal[7] =  0;
    kernel_horizontal[8] = -1;

    kernel_vertical[0] =  1;
    kernel_vertical[1] =  2;
    kernel_vertical[2] =  1;
    kernel_vertical[3] =  0;
    kernel_vertical[4] =  0;
    kernel_vertical[5] =  0;
    kernel_vertical[6] = -1;
    kernel_vertical[7] = -2;
    kernel_vertical[8] = -1;
end    

always @(posedge clk) begin
    mult_result_horizontal[0] <= $signed(kernel_horizontal[0]) * $signed({1'b0, pixel_data_in[7:0]});
    mult_result_horizontal[1] <= $signed(kernel_horizontal[1]) * $signed({1'b0, pixel_data_in[15:8]});
    mult_result_horizontal[2] <= $signed(kernel_horizontal[2]) * $signed({1'b0, pixel_data_in[23:16]});
    mult_result_horizontal[3] <= $signed(kernel_horizontal[3]) * $signed({1'b0, pixel_data_in[31:24]});
    mult_result_horizontal[4] <= $signed(kernel_horizontal[4]) * $signed({1'b0, pixel_data_in[39:32]});
    mult_result_horizontal[5] <= $signed(kernel_horizontal[5]) * $signed({1'b0, pixel_data_in[47:40]});
    mult_result_horizontal[6] <= $signed(kernel_horizontal[6]) * $signed({1'b0, pixel_data_in[55:48]});
    mult_result_horizontal[7] <= $signed(kernel_horizontal[7]) * $signed({1'b0, pixel_data_in[63:56]});
    mult_result_horizontal[8] <= $signed(kernel_horizontal[8]) * $signed({1'b0, pixel_data_in[71:64]});

    mult_result_vertical[0] <= $signed(kernel_vertical[0]) * $signed({1'b0, pixel_data_in[7:0]});
    mult_result_vertical[1] <= $signed(kernel_vertical[1]) * $signed({1'b0, pixel_data_in[15:8]});
    mult_result_vertical[2] <= $signed(kernel_vertical[2]) * $signed({1'b0, pixel_data_in[23:16]});
    mult_result_vertical[3] <= $signed(kernel_vertical[3]) * $signed({1'b0, pixel_data_in[31:24]});
    mult_result_vertical[4] <= $signed(kernel_vertical[4]) * $signed({1'b0, pixel_data_in[39:32]});
    mult_result_vertical[5] <= $signed(kernel_vertical[5]) * $signed({1'b0, pixel_data_in[47:40]});
    mult_result_vertical[6] <= $signed(kernel_vertical[6]) * $signed({1'b0, pixel_data_in[55:48]});
    mult_result_vertical[7] <= $signed(kernel_vertical[7]) * $signed({1'b0, pixel_data_in[63:56]});
    mult_result_vertical[8] <= $signed(kernel_vertical[8]) * $signed({1'b0, pixel_data_in[71:64]});

    mult_result_valid <= pixel_data_valid_in;
end

always @(*) begin
    sum_horizontal = $signed(mult_result_horizontal[0]) + $signed(mult_result_horizontal[1]) + $signed(mult_result_horizontal[2]) +
                      $signed(mult_result_horizontal[3]) + $signed(mult_result_horizontal[4]) + $signed(mult_result_horizontal[5]) +
                      $signed(mult_result_horizontal[6]) + $signed(mult_result_horizontal[7]) + $signed(mult_result_horizontal[8]);

    sum_vertical = $signed(mult_result_vertical[0]) + $signed(mult_result_vertical[1]) + $signed(mult_result_vertical[2]) +
                   $signed(mult_result_vertical[3]) + $signed(mult_result_vertical[4]) + $signed(mult_result_vertical[5]) +
                   $signed(mult_result_vertical[6]) + $signed(mult_result_vertical[7]) + $signed(mult_result_vertical[8]);
end

always @(posedge clk) begin
    sum_horizontal_reg <= sum_horizontal;
    sum_vertical_reg <= sum_vertical;
    sum_result_valid <= mult_result_valid;
end

always @(posedge clk) begin
    convolved_data_intermediate1 <= $signed(sum_horizontal_reg) * $signed(sum_horizontal_reg);
    convolved_data_intermediate2 <= $signed(sum_vertical_reg) * $signed(sum_vertical_reg);
    convolved_data_intermediate_valid <= sum_result_valid;
end

assign convolved_data_combined = convolved_data_intermediate1 + convolved_data_intermediate2;

always @(posedge clk) begin
    if (convolved_data_combined > 4000)
        convolved_data_out <= 8'hFF;
    else
        convolved_data_out <= 8'h00;

    convolved_data_valid_out <= convolved_data_intermediate_valid;
end

endmodule

