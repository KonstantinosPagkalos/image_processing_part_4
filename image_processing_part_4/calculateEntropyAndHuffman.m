function [avgCodewordLength, efficiency, compressionRatio, redundancy] = calculateEntropyAndHuffman(image)
    % Convert the image to grayscale if it's a color image
    if size(image, 3) > 1
        image = rgb2gray(image);
    end
    
    % Adjust the data type and range of the image
    image = im2double(image);
    image = mat2gray(image);
    
    % Calculate the entropy of the image
    entropyValue = entropy(image);
    disp(['Image Entropy: ' num2str(entropyValue)]);
    
    % Reshape the image into a 1D vector
    imageVector = image(:);
    
    % Perform Huffman encoding
    [symbols, ~, ic] = unique(imageVector);  % Find unique symbols and their indices in the image
    counts = accumarray(ic, 1);  % Calculate symbol frequencies
    probabilities = counts / sum(counts);  % Calculate symbol probabilities
    
    % Create Huffman dictionary
    huffDict = huffmandict(symbols, probabilities);
    
    % Calculate the average codeword length
    avgCodewordLength = sum(probabilities .* cellfun('length', huffDict(:, 2)));
    disp(['Average Codeword Length: ' num2str(avgCodewordLength) ' bits/pixel']);
    
    % Calculate the efficiency
    efficiency = entropyValue / avgCodewordLength;
    disp(['Efficiency: ' num2str(efficiency)]);
    
    % Calculate the compression ratio
    originalBits = numel(imageVector) * 8;  % Number of bits in the original image
    compressedBits = sum(counts .* cellfun('length', huffDict(:, 2)));  % Number of bits in the compressed image
    compressionRatio = originalBits / compressedBits;
    disp(['Compression Ratio: ' num2str(compressionRatio)]);
    
    % Calculate the redundancy
    redundancy = 1 - efficiency;
    disp(['Redundancy: ' num2str(redundancy)]);
    
    % Display the input image
    figure;
    imshow(image);
    title('Input Image');
end
