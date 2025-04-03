eeglab;
ft_defaults;
clc;
clear;
close all;
%%
eeg = pop_biosig('./9_speller/test_tcp_300_1sec.gdf');

srate = eeg.srate;
temp_type = [eeg.event.type];
temp_latency = [eeg.event.latency];

for i = 1:2
    tcp_type(i,:) = find(temp_type == 30+i);
end

for j= 1:2
    tcp_latency(j,:) = temp_latency(tcp_type(j,:));
end
for k =1: 45
    sample_len(k) = tcp_latency(2,k)-tcp_latency(1,k);
end
len_sample=srate;
avg_ep = mean(sample_len);