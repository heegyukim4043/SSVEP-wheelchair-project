function box_out = Process(box_in)

for i = 1: OV_getNbPendingInputChunk(box_in,1)
    if(~box_in.user_data.is_headerset)
        box_in.outputs{1}.header = box_in.inputs{1}.header;
        box_in.outputs{1}.header.nb_channels = 1;
        box_in.outputs{1}.header.channel_names = {'P1'};
        box_in.user_data.is_headerset = 1;
    end

    freq = box_in.user_data.freq;  % Setup in initialize function
    fs = box_in.inputs{1}.header.sampling_rate;    %CNT.EEG_SSVEP_test.fs;
    time = box_in.inputs{1}.header.nb_samples_per_buffer /fs;


    % disp(freq)
    % disp(fs)
    % disp(time)

    %%%  prep_segmentation set

    dat_x = box_in.inputs{1}.buffer{1}.matrix_data;
    dat_1 = box_in.inputs{1};
    for subband_idx = 1: 4
        dat_ch(:,:,subband_idx) = dat_x(1+5*(subband_idx-1): size(dat_x,1)/4 + 5*(subband_idx-1) , :) ;      % ch X time X sub-band
    end

    % dat_int = linspace(1000*dat_1.buffer{1}.start_time ,1000*dat_1.buffer{1}.end_time, size(dat_x,2));
    %          pop 4 input
    for i = 1
        [box_in, ~, ~, ~] = OV_popInputBuffer(box_in,i);
    end
    %
    %
    box_in.outputs{1}.header = box_in.inputs{1}.header;
    box_in.outputs{1}.header.nb_channels = 1;
    box_in.outputs{1}.header.channel_names = {'index_num'};
    box_in.user_data.is_headerset = 1;

    box_in.user_data.m_cnt = box_in.user_data.m_cnt + 1;

    Freq = freq;
    nClasses = length(Freq);

    %
    t= 0: 1/ fs : (time);
    t = t(1:end-1);
    Y = cell(1,nClasses);
    r = cell(1,nClasses);
    %
    for i = 1:nClasses
        ref = 2*pi*Freq(i)*t;
        Y{i} = [sin(ref);cos(ref);sin(ref*2);cos(ref*2);...
            sin(ref*3);cos(ref*3);sin(ref*4);cos(ref*4)];
    end

    a= 1; b=0;
    for class_idx = 1 : nClasses
        for subband_idx = 1: 4
            wn(subband_idx) = subband_idx^(-a)+b;

            [~,~,r]=canoncorr(dat_ch(:,:,subband_idx)', Y{class_idx}');
            results(subband_idx)=max(r);
        end
        weight_r(class_idx)= sum((wn.*results).^2);
    end

    % degree_vec = pi * ([0.5: 1:39.5]./40) ;
    % [~,y] = sort(weight_r,'descend');
    % 
    % for class_idx =1 : 40
    %     radius = (2*class_idx)^(-a)+b;
    %     check_val(1,class_idx) = radius * cos(degree_vec(y(class_idx)));
    %     check_val(2,class_idx) = radius * sin(degree_vec(y(class_idx)));
    % end
    % 
    % tan_val= mean(check_val,2);
    % 
    % target_degree = atan(tan_val(2)/tan_val(1));
    % if target_degree < 0
    %     target_degree = target_degree + pi;
    % end
    % 
    % temp_target = find(degree_vec >= target_degree );
    % 
    % if temp_target == 1
    %     find_target = 1;
    % 
    % elseif (target_degree- degree_vec(temp_target(1))) > (target_degree- degree_vec(temp_target(1)-1))
    %     find_target = temp_target(1);
    % 
    % else
    %     find_target = temp_target(1) - 1 ;
    % 
    % end
    [~, detect_f] = max(weight_r);
    % detect_f = find_target;

    disp(detect_f);

    box_in = OV_addOutputBuffer(box_in, 1, dat_1.buffer{1}.start_time,  dat_1.buffer{1}.start_time + fs*time -1, detect_f*ones(1,fs*time ));

end
box_out = box_in;

end
