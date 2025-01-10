clear all;
close all;
clc;

% MATLAB code to display image from 8 bit 65536 lines data from Verilog Convolved txt file 

input_filename = "D:\IC Design\convolution\simulation\modelsim\output_image72.txt";  % Replace with your file path
fid_in = fopen(input_filename, 'r');
if fid_in == -1
    error('Unable to open input file: %s', input_filename);
end
pixel_data = fscanf(fid_in, '%d', [1, 65536]);  
fclose(fid_in);  
pixel_data = uint8(pixel_data);
image_data = reshape(pixel_data, [256, 256]);
figure;
imshow(image_data, []);  
title('Verilog Convolved Image');
