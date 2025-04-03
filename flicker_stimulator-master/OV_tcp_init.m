function [t ,s]= OV_tcp_init ()
t = tcpip('localhost',15361);
fopen(t);
s = tcpclient('localhost',5678);
tcp_dat =read(s,128,'double');

disp(tcp_dat);
end