filename = 'signal-nikpe353.wav';
[data, fs] = audioread(filename);
DATA = fft(data);                       %DTF for data
absDATA = abs(DATA);
l = length(data);
fAxis=((0:fs/l:(fs)-(fs/l)));     %skalar x-axeln efter sampell?ngd
figure(1);                              %skapar figur 1
plot(fAxis(1:length(fAxis)/2), absDATA(1:length(absDATA)/2));                   %plotta DTF f?r signalen i figur 1
xlabel('Frekvens (Hz)','fontsize',24);
ylabel('Amplitud','fontsize',24);

cut1_left = 72000;
cut1_right = 80000;
cut2_left = 110000;
cut2_right = 118000;
cut3_left = 148000;
cut3_right = 156000;
fc_1 = 76000; %utl?sta i figuren
fc_2 = 114000;
fc_3 = 152000;

t_axis = linspace(0, 19.5, l);
[B,A] = butter(2,[cut1_left/(fs/2), cut1_right/(fs/2)]);
[D,C] = butter(2,[cut2_left/(fs/2), cut2_right/(fs/2)]);
[F,E] = butter(2,[cut3_left/(fs/2), cut3_right/(fs/2)]);
s_1 = filter(B,A,data);
s_2 = filter(D,C,data);
s_3 = filter(F,E,data);
figure(2);
subplot(3,1,1);
plot(t_axis, s_1);
xlabel('Tid(s) (fc = 76000 Hz)','fontsize',24);
subplot(3,1,2);
plot(t_axis, s_2);
xlabel('Tid(s) (fc = 114000 Hz)','fontsize',24);
subplot(3,1,3);
plot(t_axis, s_3);
xlabel('Tid(s) (fc = 152000 Hz)','fontsize',24);

[acorr, lagg] = xcorr(s_2);
figure(3);
plot(lagg/fs, acorr);
xlabel('Tid (s)','fontsize',24);

tau = 0.41; % l?st fr?n figuren, tau ?r 0.41s
difference = tau * fs; % sampel differens
bw = 18000; % bandbredd utl?st fr?n signal

y = zeros(size(s_1));
echo_samples = (fs * tau);
y(1:echo_samples) = s_1(1:echo_samples);
for n = (echo_samples+1:l)
    y(n) = s_1(n) - 0.9*y(n - echo_samples);
end

[B, A] = butter(10, bw/(fs/2), 'low');
i_c = cos(2*pi*fc_1*t_axis + 0.8)';
q_c = sin(2*pi*fc_1*t_axis + 0.8)';
yi = filter(B,A, 2*y.*i_c);
yq = -filter(B,A, 2*y.*q_c);
i = decimate(yi, 4);
q = decimate(yq, 4);
