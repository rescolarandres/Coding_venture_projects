function [S] = fourier(sigma,f0,p)
t = linspace(-4*sigma,4*sigma,40);
[G] = comp_Gaussian_tone_burst(f0,sigma,t);
s = conv(p,G);
S = fft(s);
end 