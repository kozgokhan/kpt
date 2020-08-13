% https://en.wikipedia.org/wiki/Low-pass_filter

function y = kpt_lowpass(signal, alpha)
    y = zeros(size(signal));
    y(1) = signal(1);
    for i=2:length(signal)
        y(i) = y(i-1) + alpha*(signal(i) - y(i-1));
    end
end