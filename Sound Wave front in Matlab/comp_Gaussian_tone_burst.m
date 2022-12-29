function [G] = comp_Gaussian_tone_burst(f0,sigma,t)
    G = exp(-t.^2/(2*sigma^2)).*sin(2*pi*f0*t);
end