function square_flicker_4class_fixed()
%%Initiate frequency
% Frames Period Freq. Simulated signal. 0 light. 1 dark
% [#] [ms] [Hz] [-]
% 3.0 50 .00 20.00 011
% 4.0 66.67 15.00 0011
% 5.0 83.33 12.00 00111
% 6.0 100.00 10.00 000111
% 7.0 116.67 8.57 0001111
% 8.0 133.33 7.50 00001111
% 9.0 150.00 6.66 0000 11111

%According to the paper 1 is blackbox, 0 is white
% seven_five =        [0 0 0 0 1 1 1 1];
% ten =               [0 0 0 0 0 0 1 1 1 1 1 1];
% six_six =           [0 0 0 0 1 1 1 1 1];            %[0 0 1 1 1];
% eight_fiveseven =   [0 0 0 1 1 1 1];%l

% initiate freq table
freq_list = [];
single_freq= 10;
freq_set = single_freq:2:single_freq+8 ;
freq_set = freq_set(1:end-1);
for i =1 :4
    freq_list = cat(2,freq_list,freq_set(i));
end
% freq_list = 8:0.25:16;
% freq_list(end) =[] ;
% 
% phase_list =[] ;
% for i = 1 : 4
%    phase_list=cat(2,phase_list, ((i-1)*pi/2)*zeros(1,8));
% end
phase_list =[] ;
for i = 1 :4
   phase_list=cat(2,phase_list, ((i-1)*pi/2)*ones(1,1));
end



class = length(freq_list);
trial_num = 5;  % 
stimul_size = 5; 
frame = 120 ; % Hz
stimul_len = 3; % sec
srate = 500; % sampling rate, Hz


class_x =2;
class_y = 2;

% init tcp 
global t
t = tcpip('localhost',15361, 'NetworkRole', 'client');
fopen(t);
% s = tcpclient('localhost',5678);
% for i =1 :10
%     Openvibe_tcp(t, 3);
%     Openvibe_tcp(t, 4);
%     WaitSecs(2);
% end
% while (1)
%     
%     Openvibe_tcp(t, 3); %% start stm based epoch: 3
% 
%     WaitSecs(stimul_len +0.5);
%     tcp_dat =read(s,srate*stimul_len,'double');
%     
%     try
%         dummy=read(s); % remove extra sample
%         dummy =[];
%     end
%     
%     if length(unique(tcp_dat))==1
%         disp('tcp init done...');
%         break;
%     end
%     
% end



stimul_list = [];
for ind_class = 1: class
    stimul_list = [stimul_list  ind_class*ones(1,trial_num)];
end
stimul_list = shuffle_vec(stimul_list);


freq = cell(0);
tmp_freqs = [];
for i =1: class
    freq{i} = generate_freq(freq_list(i), phase_list(i) , frame,stimul_len);   %freq, phase ,frame 
    tmp_freqs = cat(1, tmp_freqs, 1-freq{i});
end
unique_nb = unique(tmp_freqs(:,:)', 'rows')'; % nb_class x nb_samples
decimal_unique = zeros(size(unique_nb,2),1);
for i=1:length(decimal_unique)
    decimal_unique(i) = bin2dec((sprintf('%d',unique_nb(:,i)')));
end

len_Freq = stimul_len*length(freq{1});

%Generate full movie matrix of frequency
for i=1:class
    freqCombine(i,:) = repmat(freq{i},[1,len_Freq/length(freq{i})]);
end
%Revert value because in Matlab 255 is white and 0 is black
freqCombine = 1 - freqCombine;

% maxduration = 1000;

try
    %[win, texture]=  Screen_init();
    myScreen = max(Screen('Screens'));
%     Screen('Preference', 'SkipSyncTests', 1);
    [win,winRect] =   Screen(1,'OpenWindow',[],[0 0 1920 1080]);  % window size
    [width, height] = RectSize(winRect);
    Screen('Preference', 'VBLTimestampingMode', 3); 
    
    % Background color dark green, just to make sure
    Screen('FillRect',win,[0 0 0]);
    %%Make movie
    targetWidth = 140;
    targetHeight = 140;
    margin_x = 50;
    margin_y = 50;
    
    textarea_fontspace = 50;
    true_pos = [500 30]; % x, y
    ans_pos = [500 110]; % x, y
    
    % make textures clipped to screen size
    % Draw texture to screen: Draw 16 states or texture depens on the value of
    screenMatrix = flickerTexture_all_class_fixed(width, height, targetWidth, targetHeight,class_x,class_y,margin_x,margin_y, unique_nb');
%     anscueMatrix = cueTexture_all_class_fixed(width,height,targetWidth,targetHeight,class_x,class_y,[255 0 0],screenMatrix{end},margin_x,margin_y);   %color: RGB
    stimcueMatrix = cueTexture_all_class_fixed(width,height,targetWidth,targetHeight,class_x,class_y,[0 0 255],screenMatrix{end},margin_x,margin_y);   %color: RGB

    for  i =1:length(screenMatrix)
        texture(i) = Screen('MakeTexture', win, uint8(screenMatrix{i})*255);
    end
%     for  i =1:length(anscueMatrix)
%         anscuetexture(i) = Screen('MakeTexture',win,anscueMatrix{i});
%     end
    for  i =1:length(stimcueMatrix)
        stimcuetexture(i) = Screen('MakeTexture', win,stimcueMatrix{i});
    end
     
%     temp_texture = Screen('MakeTexture', win,temp);
    
    % Define refresh rate.
    ifi = Screen('GetFlipInterval', win);
    
    
    % Preview texture briefly before flickering
    % n.b. here we draw to back buffer
    Screen('DrawTexture',win,texture(end));
%     for i = 1 : 120
%         figure,
%         spy(screenMatrix{1, i});
%     end
%     
%     Screen('DrawTexture',win,anscuetexture(3));
    Screen('TextSize',win,30);
    Screen('DrawText', win,'>>', true_pos(1),true_pos(2), 0);
%     Screen('TextSize',win,20)
%     Screen('DrawText', win,'>>', 500,120, 0);
    
    win = Text_all_class_fixed(width,height,targetWidth,targetHeight,class_x,class_y,margin_x,margin_y,win);
    VBLTimestamp = Screen('Flip', win, ifi);
%     WaitSecs(2);

    % loop swapping buffers, checking keyboard, and chsecking time
    % param 2 denotes "dont clear buffer on flip", i.e., we alternate
    % our buffers cum textures
    indexflip = 1;
    % textureValue =0;
    %     halfifi = 0.5*ifi;
    vbl =0;
    
%     wait_key = 0; % for waiting..
% %     imshow(img_ready, cmap_ready);
%     while(wait_key ~= 1)
    ifi = Screen('GetFlipInterval', win);
    
    
    % Preview texture briefly before flickering
    % n.b. here we draw to back buffer
    Screen('DrawTexture',win,texture(end));
%     for i = 1 : 120
%         figure,
%         spy(screenMatrix{1, i});
%     end
%     
%     Screen('DrawTexture',win,anscuetexture(3));
    Screen('TextSize',win,30);
    Screen('DrawText', win,'>>', true_pos(1),true_pos(2), 0);
%     Screen('TextSize',win,20)
%     Screen('DrawText', win,'>>', 500,120, 0);
    
    win = Text_all_class_fixed(width,height,targetWidth,targetHeight,class_x,class_y,margin_x,margin_y,win);
    VBLTimestamp = Screen('Flip', win, ifi);
        wait_key = input('Start - 1, Otherwise - 0 : ');
        pause(0.01); 
    end
    ifi = Screen('GetFlipInterval', win);
    
    
    % Preview texture briefly before flickering
    % n.b. here we draw to back buffer
    Screen('DrawTexture',win,texture(end));
%     for i = 1 : 120
%         figure,
%         spy(screenMatrix{1, i});
%     end
%     
%     Screen('DrawTexture',win,anscuetexture(3));
    Screen('TextSize',win,30);
    Screen('DrawText', win,'>>', true_pos(1),true_pos(2), 0);
%     Screen('TextSize',win,20)
%     Screen('DrawText', win,'>>', 500,120, 0);
    
    win = Text_all_class_fixed(width,height,targetWidth,targetHeight,class_x,class_y,margin_x,margin_y,win);
    VBLTimestamp = Screen('Flip', win, ifi);
    WaitSecs(3);
    
%% Start looping movie
    Priority(1);
    %     while (~KbCheck) && (GetSecs < deadline)
    %     tic;
%     stimul_list


 for trial_2 = 1: ceil(class*trial_num/stimul_size)
        clear stimul_set;
        clear results;
        if length(stimul_list(1+ (trial_2-1)*stimul_size :end))>= stimul_size
            stimul_set = stimul_list(1+ (trial_2-1)*stimul_size : 5+ (trial_2-1)*stimul_size);
        else
            stimul_set = stimul_list(1+ (trial_2-1)*stimul_size :end);
        end
        
    for trial_1  =1: length(stimul_set)

        tic;
%          Screen('DrawTexture',win,stimcuetexture(stimul_set(trial_1)));
        Screen('DrawTexture',win,stimcuetexture(stimul_set(trial_1)));  % N class stop frame
       
        Screen('TextSize',win,30);
        Screen('DrawText', win,'>>', true_pos(1),true_pos(2), 0);
%         Screen('DrawText', win,'>>', ans_pos(1),ans_pos(2), 0);
       
       % Display list 
        Screen('TextSize',win,30);
        for dist_list = 1: length(stimul_set)
            Screen('DrawText', win,num2str(stimul_set(dist_list)), true_pos(1) + 10 + textarea_fontspace*dist_list,true_pos (2), 0);
        end

        % results
%         Screen('TextSize',win,30);
%         if  trial_1 > 1 
%             for index_results= 1: trial_1-1
% 
%                 Screen('DrawText', win,num2str(results(index_results)), ans_pos(1) + 10 + textarea_fontspace*index_results, ans_pos(2), 0);
%             end
%         end
        
        win = Text_all_class_fixed(width,height,targetWidth,targetHeight,class_x,class_y,margin_x,margin_y,win);
        VBLTimestamp = Screen('Flip', win, ifi);
        WaitSecs(0.5-toc);
        % marker, stm type
        Openvibe_tcp(t, 3); %% start stm based epoch: 3
        Openvibe_tcp(t, 10+stimul_set(trial_1)); %%  stm based epoch
%         Openvibe_tcp(t, 31); %% test tcp comm.
        tic;
        for indexflip = 1: len_Freq  % 1 trial 
            % Drawing
            %Compute texture value based on display value from freq long matrixes
            class_vector = zeros(class,1);
            for i =1 : class
                class_vector(i) = 2^(i-1);
            end
            
            textureValue = freqCombine(:, indexflip) .* int16(class_vector);
            textureValue = sum(textureValue)+1;
            %Draw it on the back buffer
%             Screen('DrawTexture',win,texture(textureValue));
            Screen('DrawTexture',win,texture(find(decimal_unique==bin2dec(sprintf('%d',freqCombine(:,indexflip)')))));
            %Display current index
            Screen('TextSize',win,30);
            Screen('DrawText', win,'>>', true_pos(1),true_pos(2), 0);
%             Screen('DrawText', win,'>>', ans_pos(1),ans_pos(2), 0);
            
            % Display true list 
            Screen('TextSize',win,30);
            for dist_list = 1: length(stimul_set)     
                Screen('DrawText', win,num2str(stimul_set(dist_list)), true_pos(1)+ 10 + textarea_fontspace*dist_list,true_pos(2), 0);
            end
            
            % results
%             Screen('TextSize',win,30);
%             if  trial_1 > 1 
%                 for index_results= 1: trial_1-1        
%                     Screen('DrawText', win,num2str(results(index_results)), ans_pos(1)+ 10 + textarea_fontspace*index_results, ans_pos(2), 0);
%                 end
%             end
            win = Text_all_class_fixed(width,height,targetWidth,targetHeight,class_x,class_y,margin_x,margin_y,win);
            %Tell PTB no more drawing commands will be issued until the next flip
            Screen('DrawingFinished', win);
            % Fliping
            %Screen('Flip', win, vbl + halfifi);
            
            %Flip ASAP
            Screen('Flip', win);
            pulseAmp(:,indexflip) = 1-freqCombine(:, indexflip);
            
            timestamp(1,indexflip) = toc;
            
            %     timestemp(2,indexflip)= str2num(datestr(clock,'FFF'));
%             indexflip = indexflip+1;
            
        end
%         Openvibe_tcp(t, 32); %% test tcp comm.
        % dddd
%         for dist_list = 1: trial_num
%             Screen('DrawText', win,num2str(stimul_set(dist_list)), 510 + 20*dist_list,50, 0);
%         end
%         for index_results= 1: trial_1-1
%             Screen('DrawText', win,num2str(results(index_results)), 510+20*index_results, 130, 0);
%         end
%         Screen('DrawTexture',win,texture(end));
%         Screen('DrawText', win,'>>', 500,50, 0);
%         Screen('DrawText', win,'>>', 500,130, 0);
%         Screen('Flip', win);
        
        tic;        
%         WaitSecs(0.2);
         
%         tcp_dat =read(s,srate*stimul_len,'double');
%         try
%             dummy=read(s); % remove extra sample
%             dummy =[];
%         end
%         if length(unique(tcp_dat))==1
%             results(trial_1)=unique(tcp_dat);
%         else
%             results(trial_1)=mode(tcp_dat);
%         end
%         Openvibe_tcp(t, 20+results(trial_1)); %% results
        
%         Screen('DrawTexture',win,anscuetexture(results(trial_1)));
%         Screen('TextSize',win,30);
%         for index_results= 1: trial_1
%             Screen('DrawText', win,num2str(results(index_results)), ans_pos(1)+ 10 + textarea_fontspace*index_results, ans_pos(2), 0);
%         end 
        
%         Screen('TextSize',win,30);
%         for dist_list = 1: stimul_size
%             Screen('DrawText', win,num2str(stimul_set(dist_list)), true_pos(1)+10 + textarea_fontspace*dist_list, true_pos(2), 0);
%         end
%         Screen('DrawText', win,'>>', true_pos(1),true_pos(2), 0);
% %         Screen('DrawText', win,'>>', ans_pos(1),ans_pos(2), 0);
%         win = Text_all_class_fixed(width,height,targetWidth,targetHeight,class_x,class_y,margin_x,margin_y,win);
%         Screen('Flip', win);
%         
%         WaitSecs(0.5);
                
        Screen('DrawTexture',win,texture(end));
%         Screen('TextSize',win,30);
%         for index_results= 1: trial_1
%             Screen('DrawText', win,num2str(results(index_results)), ans_pos(1)+10+textarea_fontspace*index_results, ans_pos(2), 0);
%         end
        
        Screen('TextSize',win,30);
        for dist_list = 1: length(stimul_set)
            Screen('DrawText', win,num2str(stimul_set(dist_list)), true_pos(1)+10 + textarea_fontspace*dist_list,true_pos(2), 0);
        end
        Screen('DrawText', win,'>>', true_pos(1),true_pos(2), 0);
%         Screen('DrawText', win,'>>', ans_pos(1),ans_pos(2), 0);
        win = Text_all_class_fixed(width,height,targetWidth,targetHeight,class_x,class_y,margin_x,margin_y,win);
        Screen('Flip', win);
        temp_int = toc;
        if temp_int <= 0.5
            WaitSecs(0.5-toc);
        end
%         dummy=read(s); % remove extra sample
%         dummy =[];
    end
    WaitSecs(2);
 end
    WaitSecs(2);
    %     toc;
    Priority(0);
    Openvibe_tcp(t, 4); %% end 
    frame_duration = Screen('GetFlipInterval', win);
    Screen('CloseAll');
    Screen('Close');
    echotcpip("off")
    
    
catch
    WaitSecs(2);
    Screen('CloseAll');
    Screen('Close');
    psychrethrow(psychlasterror);
    penvibe_tcp(t, 4); %% end 
    echotcpip("off");
    
    %     plot(timestamp,pulseAmp(1,:))
    %     xlim([0 2])
end


%%
% figure,
% for i = (0:3)*8+2
%      subplot(4,1,floor(i/8)+1);
%      plot(timestamp-timestamp(1),pulseAmp(i,:));
%      xlim([0 1])
% end
% figure,
% plot(timestamp-timestamp(1),pulseAmp(1,:))
% ylim([0 1.1])
% xlim([0 2])
% title('10Hz', 'Fontsize',12);
% xlabel('time (sec)')
%
% figure,
% for i=1: length(timestamp)-1
%     interval_vec(i) = timestamp(i+1)-timestamp(i);
% end
% histogram(interval_vec,'BinWidth',0.1*10^-3);
%  title(sprintf('Avg: %0.4f std: %0.4f (ms)',mean(interval_vec)*1000, std(interval_vec)*1000));
