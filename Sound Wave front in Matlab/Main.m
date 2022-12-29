clc;clear;close all

%% Task 1 

c = 1500;
source = [0 0 0];
point = [0.001 0.001 0];
p0 = 1;
t1 = [0:10e-9:3e-6];
[p] = comp_press_field_point_source(c,source,point,p0,t1);

figure()
plot(t1,p,'b')
xlabel('Time [s]');ylabel('Pressure [Pa]');title('Pressure VS time')
%% Task 2

sigma = 50e-9;
t2 = [-4*sigma:10e-9:4*sigma];
f0 = 10e6;
[G] = comp_Gaussian_tone_burst(f0,sigma,t2);

figure()
plot(t2,G)
xlabel('Time [s]');ylabel('Amplitude [a.u.]');title('Gaussian tone burst')
%% Task 3

s = conv(p,G);  % Convolution of p and G
t = linspace(1e-10,3e-6,length(s)); 
figure()
plot(t,s,'g')
hold on
plot(t1,p,'b')
hold off
legend('s(x,y,z,t)','p(x,y,z,t)');xlabel('Time [s]');ylabel('Pressure [Pa]');title('Pressure VS time for an acoustic source')
%% Task 4

colors = ['b' 'c' 'r' 'g' 'k' 'm' 'y'];
f0 = linspace(2e6,40e6,7);
sigma = linspace(5e-7,5e-7,7);

figure()
for i = 1:length(sigma)
   [S(:,i)] = fourier(sigma(i),f0(i),p);
   f = (0:length(S)-1)*100/length(S);
   plot(f,abs(S(:,i)),colors(i))
   xlim([0 50]); xlabel('Frequency [MHz]'); ylabel('FFT modulus');title('Amplitude spectrum of Gaussian tone burst')
   hold on
end 
%% Task 5

comp_press_field_plane(c,source,p0,1e-6)

%% Task 6
t_evaluation = 1.5e-6;

wave_front(c,t_evaluation,p0);


%% Task 7