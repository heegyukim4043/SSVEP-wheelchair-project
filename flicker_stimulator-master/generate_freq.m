function y= generate_freq(freq , phase, frame,length)
    temp_time_vec = linspace(0, length,length*frame+1);
    time_vec = temp_time_vec(1:end-1);
    origin_sig=sin(2*pi*freq*time_vec + phase);
    square_pulse = 0.5*(sign(origin_sig)+1);
    y= int16(square_pulse);
end


