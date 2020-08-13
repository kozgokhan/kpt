signal = [9.5 10 11 10.3 9.7 11.3 9.6 9.3 9.1 8.3 8.1 9 9.1 10 10.1 10.2 9.9 8 10 10.1 9.9 10.2 9.9 10 11 10 9.9 10.1];

plot(signal)
hold on
plot(kpt_lowpass(signal, 0.3))