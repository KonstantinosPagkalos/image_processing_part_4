function process_image(input_image, normalization_matrix)

    
    % Resize normalization matrix to match the size of the input image
    normalization_matrix_resized = imresize(normalization_matrix, size(input_image));
    
    % Perform processing steps
    input_image = input_image - 128;
    transformed_image = dct2(input_image);
    normalized_image = round(transformed_image ./ normalization_matrix_resized);
    quantized_image = normalized_image .* normalization_matrix_resized;
    reconstructed_image = idct2(quantized_image);
    reconstructed_image = reconstructed_image + 128;
    
    % Reverse Quantization
    dequantized_image = quantized_image ./ normalization_matrix_resized;
    
    % Reverse DCT
    reversed_transformed_image = idct2(dequantized_image);
    reversed_transformed_image = reversed_transformed_image + 128;
    
    % Display the intermediate results
    figure;
    
    % Original Image
    subplot(2, 4, 1);
    imshow(input_image, []);
    title('Original Image');
    
    % Transformed Image (DCT)
    subplot(2, 4, 2);
    imshow(log(abs(transformed_image) + 1), []);
    title('Transformed Image (DCT)');
    
    % Normalized Image (Quantized)
    subplot(2, 4, 3);
    imshow(normalized_image, []);
    title('Normalized Image (Quantized)');
    
    % Quantized Image
    subplot(2, 4, 4);
    bar3(quantized_image);
    title('Quantized Image');
    
    % Reconstructed Image
    subplot(2, 4, 5);
    imshow(uint8(reconstructed_image));
    title('Reconstructed Image');
    
    % Reverse Quantization Image
    subplot(2, 4, 6);
    imshow(dequantized_image, []);
    title('Reverse Quantization Image');
    
    % Reverse Transformed Image (Reverse DCT)
    subplot(2, 4, 7);
    imshow(uint8(reversed_transformed_image));
    title('Reverse Transformed Image (Reverse DCT)');
    
    % Adjust the figure layout
    sgtitle('Image Processing Steps');
end
