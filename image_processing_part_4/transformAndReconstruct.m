function [fftErrors, dctErrors] = transformAndReconstruct(image)
    % Convert the image to grayscale if it is in color
    if size(image, 3) == 3
        image = rgb2gray(image);
    end
    
    % Display the original image
    figure('Name', 'Original Image');
    subplot(1, 3, 1);
    imshow(uint8(image));
    title('Original Image');
    
    % Calculate the FFT transformation
    fftImage = fft2(image);
    
    % Calculate the DCT transformation
    dctImage = dct2(image);
    
    % Display the FFT transformation
    subplot(1, 3, 2);
    imshow(log(1 + abs(fftshift(fftImage))), []);
    title('FFT Transformation');
    
    % Display the DCT transformation
    subplot(1, 3, 3);
    imshow(log(1 + abs(dctImage)), []);
    title('DCT Transformation');
    
    % Specify the desired percentages and step
    desiredPercentages = 0.1:0.1:10;
    step = 0.1;
    
    % Calculate the number of coefficients to keep for each percentage
    numCoefficients = round(numel(image) * desiredPercentages / 100);
    
    % Initialize arrays to store mean absolute errors
    fftErrors = zeros(numel(desiredPercentages), 1);
    dctErrors = zeros(numel(desiredPercentages), 1);
    
    % Iterate over each percentage
    for i = 1:numel(desiredPercentages)
        % Calculate the threshold for selecting coefficients
        threshold = prctile(abs(fftImage(:)), 100 - desiredPercentages(i));
        
        % Set coefficients below the threshold to zero
        fftImage(abs(fftImage) < threshold) = 0;
        
        % Reconstruct image using inverse FFT transform
        reconstructedFFT = ifft2(fftImage);
        
        % Calculate the mean absolute error between the original and reconstructed image
        fftErrors(i) = mean(abs(image(:) - reconstructedFFT(:)));
        
        % Calculate the threshold for selecting coefficients
        threshold = prctile(abs(dctImage(:)), 100 - desiredPercentages(i));
        
        % Set coefficients below the threshold to zero
        dctImage(abs(dctImage) < threshold) = 0;
        
        % Reconstruct image using inverse DCT transform
        reconstructedDCT = idct2(dctImage);
        
        % Calculate the mean absolute error between the original and reconstructed image
        dctErrors(i) = mean(abs(image(:) - reconstructedDCT(:)));
    end
    
    % Plot the mean absolute error curves
    figure('Name', 'Mean Absolute Error');
    plot(desiredPercentages, fftErrors, 'r-o', 'LineWidth', 2);
    hold on;
    plot(desiredPercentages, dctErrors, 'b-o', 'LineWidth', 2);
    xlabel('Percentage of Coefficients');
    ylabel('Mean Absolute Error');
    title('Mean Absolute Error for FFT and DCT');
    legend('FFT', 'DCT');
    grid on;
    hold off;
    
    % Display the mean absolute error for each transformation and percentage
    disp('Mean Absolute Error:');
    disp('---------------------');
    disp('Transformation   Percentage   Error');
    disp('----------------------------------');
    for i = 1:numel(desiredPercentages)
        disp(['FFT              ' num2str(desiredPercentages(i)) '%        ' num2str(fftErrors(i))]);
        disp(['DCT              ' num2str(desiredPercentages(i)) '%        ' num2str(dctErrors(i))]);
        disp('----------------------------------');
    end
end
