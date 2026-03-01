function [mean_ssim, mean_psnr, valid_count, all_results] = calculate_dataset_y_metrics_mixed(reference_path, processed_path)
% 计算数据集Y通道SSIM和PSNR - 支持PNG和JPG混合格式
% 输出:
%   mean_ssim - 平均SSIM
%   mean_psnr - 平均PSNR
%   valid_count - 有效图像数量
%   all_results - 所有图像的结果表格

    % 同时获取PNG和JPG文件
    ref_files_png = dir(fullfile(reference_path, '*.png'));
    ref_files_jpg = dir(fullfile(reference_path, '*.jpg'));
    ref_files = [ref_files_png; ref_files_jpg];
    
    ssim_values = [];
    psnr_values = [];
    image_names = {};
    
    fprintf('\n=== 开始计算Y通道质量指标 (支持PNG/JPG) ===\n');
    fprintf('找到 %d 个参考图像 (%d PNG, %d JPG)\n', ...
        length(ref_files), length(ref_files_png), length(ref_files_jpg));
    
    for i = 1:length(ref_files)
        ref_name = ref_files(i).name;
        ref_img = imread(fullfile(reference_path, ref_name));
        
        % 处理后的图像统一保存为PNG格式
        [~, name, ~] = fileparts(ref_name);  % 去掉扩展名
        proc_name = [name '_BSA_MT_Enhanced.png'];
        proc_path = fullfile(processed_path, proc_name);
        
        if exist(proc_path, 'file')
            proc_img = imread(proc_path);
            
            % 检查图像尺寸是否一致
            if ~isequal(size(ref_img), size(proc_img))
                fprintf('调整图像尺寸: %s\n', ref_name);
                proc_img = imresize(proc_img, [size(ref_img,1), size(ref_img,2)]);
            end
            
            % 转换为YCbCr并提取Y通道
            ref_y = rgb2ycbcr(ref_img);
            proc_y = rgb2ycbcr(proc_img);
            
            % 计算SSIM和PSNR
            current_ssim = ssim(proc_y(:,:,1), ref_y(:,:,1));
            current_psnr = psnr(proc_y(:,:,1), ref_y(:,:,1));
            
            % 存储结果
            ssim_values(end+1) = current_ssim;
            psnr_values(end+1) = current_psnr;
            image_names{end+1} = ref_name;
            
            % 显示每张图像的结果
            fprintf('图像 %d: %s - SSIM: %.4f, PSNR: %.2f dB\n', i, ref_name, current_ssim, current_psnr);
        else
            fprintf('图像 %d: %s - 未找到处理后的图像: %s\n', i, ref_name, proc_name);
        end
    end
    
    % 计算统计结果
    valid_count = length(ssim_values);
    
    if valid_count > 0
        mean_ssim = mean(ssim_values);
        mean_psnr = mean(psnr_values);
        
        % 创建结果表格
        all_results = table(image_names', ssim_values', psnr_values', ...
            'VariableNames', {'ImageName', 'Y_SSIM', 'Y_PSNR'});
    else
        mean_ssim = NaN;
        mean_psnr = NaN;
        all_results = table();
        fprintf('错误: 没有找到有效的图像对\n');
    end
    
    fprintf('\n=== 计算完成 ===\n');
    fprintf('有效图像数量: %d/%d\n', valid_count, length(ref_files));
end