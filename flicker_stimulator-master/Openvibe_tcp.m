function Openvibe_tcp (t,input_marker)

OV_flags =4;
val64as32_flag = swapbytes(typecast(uint64(OV_flags), 'uint32'));
% Matlab fwrite does not support uint64, then split uint64 into uint32s
fwrite(t, (val64as32_flag), 'uint32');


OV_marker =input_marker;
val64as32_marker = swapbytes(typecast(uint64(OV_marker), 'uint32'));
% Matlab fwrite does not support uint64, then split uint64 into uint32s
fwrite(t, (val64as32_marker), 'uint32');


OV_timestamp =0;
val64as32_stamp = swapbytes(typecast(uint64(OV_timestamp), 'uint32'));
% Matlab fwrite does not support uint64, then split uint64 into uint32s
fwrite(t, (val64as32_stamp), 'uint32');


end