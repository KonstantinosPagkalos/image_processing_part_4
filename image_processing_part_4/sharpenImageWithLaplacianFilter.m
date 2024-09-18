function [sharpenedImg] = sharpenImageWithLaplacianFilter(img)

% Define the Laplacian filter
laplacianFilter = [0 1 0; 1 -4 1; 0 1 0];

% Perform convolution with the filter
filteredImg = conv2(double(img), laplacianFilter, 'same');

% Add or subtract the filtered image from the original, depending on the filter
if max(laplacianFilter(:)) == 1
    sharpenedImg = img - filteredImg;
else
    sharpenedImg = img + filteredImg;
end

% Display the original and sharpened images side by side
figure;
subplot(1, 2, 1);
imshow(uint8(img));
title('Original Image');
subplot(1, 2, 2);
imshow(uint8(sharpenedImg));
title('Sharpened Image');

end
