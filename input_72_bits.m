clc;
clear all;
close all;

% MATLAB code to convert 8 bit 65536 lines data from Verilog Convolved txt file to display image 

clk=rgb2gray(imread("D:\IC Design\convolution\KDOT_jp.jpg"));
b = reshape(cellstr(dec2bin(clk,72)),size(clk));
vec3=fopen('input_image72.txt','wt');
fprintf(vec3,'%s\n',b{:});
fclose(vec3)