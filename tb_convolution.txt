module tb_convolution;

    // Declare inputs as regs and outputs as wires
    reg clk_tb;
    reg [71:0] pixel_data_in_tb;
    reg pixel_data_valid_in_tb;
    wire [7:0] convolved_data_out_tb;
    wire convolved_data_valid_out_tb;

    // Instantiate the unit under test (UUT)
    convolution uut (
        .clk(clk_tb),
        .pixel_data_in(pixel_data_in_tb),
        .pixel_data_valid_in(pixel_data_valid_in_tb),
        .convolved_data_out(convolved_data_out_tb),
        .convolved_data_valid_out(convolved_data_valid_out_tb)
    );

    // Clock generation
    always begin
        #5 clk_tb = ~clk_tb;  // Generate a clock with a period of 10 time units
    end

    // Test vector input and output file
    integer input_file_tb, output_file_tb;
    reg [71:0] input_data_tb;
    integer processed_lines_tb = 0;   // Count of processed lines
    integer output_lines_tb = 0;     // Count of output lines written

    // Target line count
    integer target_lines_tb = 65536;

    initial begin
        // Initialize signals
        clk_tb = 0;
        pixel_data_in_tb = 0;
        pixel_data_valid_in_tb = 0;
        
        // Open the input and output files
        input_file_tb = $fopen("D:/IC Design/convolution/input_image72.txt", "r");  // Input file path
        output_file_tb = $fopen("output_image72.txt", "w");  // Output file path
        
        if (input_file_tb == 0) begin
            $display("Error opening input file.");
            $finish;
        end
        if (output_file_tb == 0) begin
            $display("Error opening output file.");
            $finish;
        end

        // Read and process data
        while (output_lines_tb < target_lines_tb) begin
            // If input file ends, rewind to the start
            if ($feof(input_file_tb)) begin
                $fclose(input_file_tb);
                input_file_tb = $fopen("D:/IC Design/vid/image72.txt", "r");
                if (input_file_tb == 0) begin
                    $display("Error reopening input file.");
                    $finish;
                end
            end

            // Read 72-bit pixel data from the input file
            if (!$feof(input_file_tb)) begin
                $fscanf(input_file_tb, "%b\n", input_data_tb);  // Input format: 72-bit binary data
                pixel_data_in_tb = input_data_tb;
                pixel_data_valid_in_tb = 1;  // Assert valid signal
                
                // Wait for the module to process the input
                #10;
                processed_lines_tb = processed_lines_tb + 1;

                // Write output data to the file when valid
                if (convolved_data_valid_out_tb) begin
                    $fwrite(output_file_tb, "%b\n", convolved_data_out_tb);  // Write 8-bit output
                    output_lines_tb = output_lines_tb + 1;
                end
            end
        end

        // Close files
        $fclose(input_file_tb);
        $fclose(output_file_tb);

        // Display summary
        $display("Simulation completed.");
        $display("Processed lines: %0d", processed_lines_tb);
        $display("Output lines written: %0d", output_lines_tb);
        $finish;
    end

    // Debugging output
    always @(posedge clk_tb) begin
        $display("Time: %0t | Processed: %0d | Output Written: %0d | pixel_data_in_tb: %b | convolved_data_out_tb: %b | Valid: %b",
                 $time, processed_lines_tb, output_lines_tb, pixel_data_in_tb, convolved_data_out_tb, convolved_data_valid_out_tb);
    end

endmodule
