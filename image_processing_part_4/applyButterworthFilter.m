function filteredImage = applyButterworthFilter(image, cutoffFrequencies, filterOrders)
    % Convert the image to double, if necessary
    image = im2double(image);
    
    % Get the dimensions of the image
    [M, N, ~] = size(image);
    
    % Zero-padding the image
    P = 2 * M;
    Q = 2 * N;
    fp = padarray(image, [P - M, Q - N], 0, 'post');
    
    % Calculate the product of padded image with (-1)^(x+y)
    [X, Y] = meshgrid(0:Q-1, 0:P-1);
    fp = fp .* (-1).^(X+Y);
    
    % Fourier transform of the padded image
    Fp = fft2(fp);
    
    % Create a figure to display the results
    figure;
    
    % Display the original image
    subplot(3, 3, 1);
    imshow(image, []);
    title('Original Image');
    
    % Display the padded image
    subplot(3, 3, 2);
    imshow(fp, []);
    title('Padded Image');
    
    % Display the result of multiplying fp by (-1)^(x+y)
    subplot(3, 3, 3);
    imshow((-1).^(X+Y), []);
    title('Product of fp and (-1)^(x+y)');
    
    % Display the spectrum of Fp
    subplot(3, 3, 4);
    imshow(log(1 + abs(fftshift(Fp))), []);
    title('Spectrum of Fp');
    
    % Loop through different cutoff frequencies
    for i = 1:length(cutoffFrequencies)
        cutoffFrequency = cutoffFrequencies(i);
        
        % Loop through different filter orders
        for j = 1:length(filterOrders)
            filterOrder = filterOrders(j);
            
            % Construct the Butterworth filter
            H = butterworthFilter([P, Q], cutoffFrequency, filterOrder);
            
            % Filtering in the frequency domain
            HFp = Fp .* H;
            
            % Inverse Fourier transform
            gp = ifft2(HFp);
            
            % Multiply with (-1)^(x+y)
            gp = gp .* (-1).^(X+Y);
            
            % Keep the MxN part of the filtered image
            g = real(gp(1:M, 1:N));
            
            % Assign the filtered image to the output variable
            filteredImage = g;
            
            % Display the centered Gaussian lowpass filter H
            subplot(3, 3, 5);
            imshow(abs(H), []);
            title('Centered Gaussian Lowpass Filter (H)');
            
            % Display the spectrum of the product HFp
            subplot(3, 3, 6);
            imshow(log(1 + abs(fftshift(HFp))), []);
            title('Spectrum of the product HFp');
            
            % Display gp, the product of (-1)^(x+y) and the real part of the IDFT of HFp
            subplot(3, 3, 7);
            imshow(real(gp), []);
            title('Product of (-1)^(x+y) and IDFT of HFp (gp)');
            
            % Display the final result g obtained by cropping the first M rows and N columns of gp
            subplot(3, 3, 8);
            imshow(g, []);
            title('Final Result (g)');
            
            % Display the filtered image
            subplot(3, 3, 9);
            imshow(g, []);
            title(sprintf('Cutoff: %d, Order: %d', cutoffFrequency, filterOrder));
        end
    end
end

function H = butterworthFilter(size, cutoffFrequency, order)
    % Get the center coordinates
    centerX = floor(size(2) / 2) + 1;
    centerY = floor(size(1) / 2) + 1;
    
    % Create a meshgrid of frequencies
    [X, Y] = meshgrid(1:size(2), 1:size(1));
    
    % Calculate the distances from the center
    distances = sqrt((X - centerX).^2 + (Y - centerY).^2);
    
    % Calculate the Butterworth filter
    H = 1 ./ (1 + (distances ./ cutoffFrequency).^(2 * order));
end
