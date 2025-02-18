function [Ihmf] = filtering(I)
FT_img = fft2(double(I));
I = im2double(I);
I = log(1 + I);
M = 2*size(I,1) + 1;
N = 2*size(I,2) + 1;
% Assign Cut-off Frequency
sigma = 10;

% Designing Ideal High-pass filter 
u = 0:(M-1); 
idx = find(u>M/2); 
u(idx) = u(idx)-M; 
v = 0:(N-1); 
idy = find(v>N/2); 
v(idy) = v(idy)-N; 

[X, Y] = meshgrid(v,u); % meshgrid to return 2d values 
centerX = ceil(N/2);
centerY = ceil(M/2);

% Calculating Euclidean Distance 
D = sqrt((X - centerX).^2+(Y - centerY).^2); 
H = exp(-D./(2*sigma.^2));
H = 1 - H;
H = fftshift(H);
If = fft2(I, M, N);
Iout = real(ifft2(H.*If));
Iout = Iout(1:size(I,1),1:size(I,2));
Ihmf = exp(Iout) - 1;

end