clear all;clc;close all;warning off;
Pathr = '.\data\';
Pathw = '.\result\';

% 如果输出文件夹不存在则自动创建，防止报错
if ~exist(Pathw, 'dir')
    mkdir(Pathw);
end

Files_png = dir(strcat(Pathr, '*.png'));
Files_jpg = dir(strcat(Pathr, '*.jpg')); 
Files = [Files_png; Files_jpg];
LengthFiles = length(Files);

% 去除了 parfor 不支持的 global 声明
factor = 4;

tic;
% 将 for 替换为 parfor
parfor ii = 1:LengthFiles
    current_file = Files(ii).name;
    image = double(imread(strcat(Pathr, current_file)));
    
    outimg1 = image(:,:,1);
    outimg2 = image(:,:,2);
    outimg3 = image(:,:,3);
    
    %% using Metropolis theorem to get H1
    H1_outimg1 = BSA_MT_Enhanced(outimg1);            
    H1_outimg2 = BSA_MT_Enhanced(outimg2); 
    H1_outimg3 = BSA_MT_Enhanced(outimg3);
    
    %% get details
    [h, w] = size(outimg1);
    det1 = imresize(H1_outimg1, [h, w], 'bilinear');
    det2 = imresize(H1_outimg2, [h, w], 'bilinear');
    det3 = imresize(H1_outimg3, [h, w], 'bilinear');
    
    %% add details to the original images
    res1 = outimg1 + det1 * factor;
    res2 = outimg2 + det2 * factor;
    res3 = outimg3 + det3 * factor;
    
    % 在 parfor 中使用 cat 合并通道是最安全的做法
    outimg = cat(3, res1, res2, res3);
    
    imwrite(uint8(outimg), strcat('./result/', current_file(1:end-4), '_BSA_MT_Enhanced.png'));
end
toc;

[mean_ssim, mean_psnr, valid_count, all_results] = calculate_dataset_y_metrics_mixed(Pathr, Pathw);
fprintf('成功处理图像数: %d\n', valid_count);
fprintf('平均 Y-PSNR: %.2f dB\n', mean_psnr);
fprintf('平均 Y-SSIM: %.4f\n', mean_ssim);