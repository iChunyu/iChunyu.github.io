% A demo to test my_spafdr
% (system identification with chirp signal)

% XiaoCY 2024-04-06

%%
clear;clc

%% second-order plant with transmission delay
gain = 1.5;
omega0 = 2*pi*20;
zeta = 0.3;
tau = 0.02;

s = tf('s');
H = gain * omega0^2 / (s^2 + 2*zeta*omega0*s + omega0^2) * exp(-tau*s);

%% chirp injection
fs = 2e3;
fstart = 1;
fstop = 50;
t = (0:1/fs:200)';
u = chirp(t, fstart, t(end), fstop, 'logarithmic');
y0 = lsim(H, u, t);

% add some noise
yn = randn(size(y0)) * 0.3;
y = y0 + yn;

figure
plot(t, y)
hold on
grid on
plot(t, y0)
xlabel('Tims [s]')
ylabel('Output')

%% test 1: compare identification results with fixed resolution
fres = 0.1;
fr = (fstart:fres:fstop)';

H11 = spafdr(iddata(y, u, 1/fs), [], 2*pi*fr);
H12 = my_spafdr(y, u, fr, fs);

figure
bode(H11, H12, H, {fstart*2*pi, fstop*2*pi})

%% test 2: compare identification results with variable resolution
fr = logspace(log10(fstart), log10(fstop), 100)';

H21 = spafdr(iddata(y, u, 1/fs), [], 2*pi*fr);
H22 = my_spafdr(y, u, fr, fs);

figure
bode(H21, H22, H, {fstart*2*pi, fstop*2*pi})