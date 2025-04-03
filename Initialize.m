function box_out = Initialize(box_in)
% Initialization

    % box_in.user_data.time = 5;
    box_in.user_data.freq = [8:0.2:15.8] ; 
    % box_in.user_data.interval = [0 1000];  % ms
    box_in.user_data.m_cnt = 0;


     disp('Loading DSI chanlocs..');
   
    box_in.user_data.is_headerset = false;
	
	% We also add some statistics
	box_in.user_data.nb_matrix_processed = 0;
	box_in.user_data.mean_fft_matrix = 0; 
    
    box_out = box_in;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
