function square_flicker_4class_joint_phase_fixed_feedback(preload)
% square_flicker_40class_joint_phase_fixed_feedback(flicker_images)

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

freq_set = 14:17;
% for i =1 : 5
%     freq_list = cat(2,freq_list,freq_set + 0.2*(i-1));
% end

freq_list = freq_set;
phase_list =[] ;
phase_set=zeros(1,length(freq_set));
% for i = 1 :5
%     phase_list=cat(2,phase_list,phase_set(i:i+7));
% end
phase_list = phase_set;



% speller size
targetWidth = 250; 
targetHeight = 250; 
margin_x = 150; % interval
margin_y = 50; 

textarea_fontspace = 50;
true_pos = [500 30]; % x, y
ans_pos = [500 105]; % x, y


class = length(freq_list);
trial_num = 1;
stimul_size = 5;
% frame = 60; % 120 ; % Hz
frame =60 ; % refresh rate
stimul_len = 5; % sec
srate = 300; % sampling rate, Hz

feedback_time = 10; %sec


class_x = 3;
class_y = 3;

mask_matrix = zeros(class_x,class_y);

mask_matrix(1,2) = 1 ;
mask_matrix(2,1) = 1 ;
mask_matrix(2,3) = 1 ;
mask_matrix(3,2) = 1 ;

if ~(sum(mask_matrix,'all') == length(freq_list))
    disp('Please check the Stimuli param and Num of Mask');
    
end

% class_x = 8;
% class_y = 5;

% init tcp
global t
t = tcpip('localhost',15361, 'NetworkRole', 'client');
fopen(t);
Openvibe_tcp(t, 5);

echotcpip('on',5678);
echotcpip('off');
s = tcpclient('localhost',5678);
% for i = 1: 10
%    Openvibe_tcp(t, 3);
%    Openvibe_tcp(t, 4);
%    WaitSecs(2);
% end
while (1)
    Openvibe_tcp(t, 5); %% start stm based epoch: 3
    
    WaitSecs(stimul_len + 0.25);
    % tcp_dat =read(s,srate*2,'double');
    tcp_dat =read(s,srate*stimul_len,'double');

    try
        dummy=read(s); % remove extra sample
        dummy =[];
    end
    
    if length(unique(tcp_dat))==1
        disp('tcp init done...');
        break;
    end
end

stimul_list = [];
for ind_class = 1: class
    stimul_list = [stimul_list  ind_class*ones(1,trial_num)];
end
% for ind_class = 1: class_y
%     stimul_list = cat(2, stimul_list,(8*(ind_class-1)+1)*ones(1,trial_num) );
% end
%
% for i =1 : 4
% stimul_list = shuffle_vec(stimul_list);
% end

% stimul_list = shuffle_vec(stimul_list);

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

len_Freq = length(freq{1});

%Generate full movie matrix of frequency
for i=1:class
    freqCombine(i,:) = repmat(freq{i},[1,len_Freq/length(freq{i})]);
end
%Revert value because in Matlab 255 is white and 0 is black
freqCombine = 1 - freqCombine;

% maxduration = 1000;

try
    %[win, texture]=  Screen_init();
    Screen('Preference', 'SkipSyncTests', 0);
    Screen('Preference', 'VisualDebuglevel', 1);
    Screen('Preference', 'VBLTimestampingMode', 2);
    Screen('Preference', 'Enable3DGraphics', 1);
    Screen('Preference', 'OverrideMultimediaEngine',1);
    Screen('Preference', 'FrameRectCorrection', 1);
    Screen('Preference', 'TextRenderer', 1);
    Screen('Preference','TextEncodingLocale','UTF-8');
    

%     PsychDefaultSetup(2);    
    %     VBLSyncTest(10000, 0, 0.1, 0, 0,1, 0,0,0,1) ;
    
    myScreen = max(Screen('Screens'));
    [win,winRect] =   Screen('OpenWindow',myScreen, [],[0 0 1920 1080],[],[]);  % window size
    % [windowPtr,rect]=Screen(‘OpenWindow’,windowPtrOrScreenNumber [,color] [,rect][,pixelSize][,numberOfBuffers][,stereomode][,multisample][,imagingmode][,specialFlags][,clientRect][,fbOverrideRect][,vrrParams=[]]);
    %     [win,winRect] =   Screen(myScreen,'OpenWindow',[],[0 0 1920 1080]);  % window size
    [width, height] = RectSize(winRect);
    %     Screen('Preference', 'SkipSyncTests', 1);
    %     Screen('Preference', 'SynchronizeDisplays', syncMethod [,screenId]);
    %     Screen('Preference', 'Process');
    
    %     Screen('Preference','FrameRectCorrection', 1);
    %     Screen('AsyncFlipBegin',1)
    %     Screen('GetFlipInfo', 1,'infoType',1);
    % Background color dark green, just to make sure
    Screen('FillRect',win,[0 0 0]);
    

    
    % make textures clipped to screen size
    % Draw texture to screen: Draw 16 states or texture depens on the value of
%     screenMatrix = flickerTexture_all_class_fixed(width, height, targetWidth, targetHeight,class_x,class_y,margin_x,margin_y, unique_nb');
    screenMatrix = flickerTexture_select_class_fixed(width, height, targetWidth, targetHeight,class_x,class_y,margin_x,margin_y, unique_nb',mask_matrix);
    
    anscueMatrix = cueTexture_select_class_fixed(width,height,targetWidth,targetHeight,class_x,class_y,[255 0 0],screenMatrix{end},margin_x,margin_y,mask_matrix);   %color: RGB
    stimcueMatrix = cueTexture_select_class_fixed(width,height,targetWidth,targetHeight,class_x,class_y,[0 0 255],screenMatrix{end},margin_x,margin_y,mask_matrix);   %color: RGB
    
    
    if (isempty(preload))
        flicker_images = [];
        for  i =1:length(screenMatrix)
            
            texture(i) = Screen('MakeTexture', win, uint8(screenMatrix{i})*255);
            
            Screen('DrawTexture', win, texture(i));
            win = Text_all_class_fixed(width,height,targetWidth,targetHeight,class_x,class_y,margin_x,margin_y,win);
            Screen('Flip', win);
            
            imageArray = Screen('GetImage', win);
            flicker_texture(i) = Screen('MakeTexture', win, imageArray);
            flicker_images = cat(4, flicker_images, imageArray);
        end
        texture = flicker_texture;
        texture_name = sprintf('pre_texture_%d-%d.mat',freq_set(1),freq_set(end));
        save(texture_name, '-v7.3', 'flicker_images');
    else
        for j=1:size(preload, 4)
            texture(j) = Screen('MakeTexture', win, preload(:, :, :, j));
        end
    end
    
    for  i =1:length(anscueMatrix)
        anscuetexture(i) = Screen('MakeTexture',win,anscueMatrix{i});
    end
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
    
    wait_key = 0; % for waiting..
    %     imshow(img_ready, cmap_ready);
    while(wait_key ~= 1)
        ifi = Screen('GetFlipInterval', win);
        
        
        % Preview texture briefly before flickering
        if wait_key == 2
            Screen('DrawTexture',win,texture(end));
            
            Screen('TextSize',win,30);
            Screen('DrawText', win,'>>', true_pos(1),true_pos(2), 0);
            
            win = Text_all_class_fixed(width,height,targetWidth,targetHeight,class_x,class_y,margin_x,margin_y,win);
            VBLTimestamp = Screen('Flip', win, ifi);
        elseif wait_key == 3
            Screen('CloseAll');
        end
        wait_key = input('Start - 1, Draw visual stim - 2, Escape - 3 : ');
        
    end
    %     ifi = Screen('GetFlipInterval', win);
    
    
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
    
    
    for trial_2 = 1: ceil(class/stimul_size)
        clear stimul_set;
        clear results;
        if length(stimul_list(1+ (trial_2-1)*stimul_size :end))>= stimul_size
            stimul_set = stimul_list(1+ (trial_2-1)*stimul_size : 5+ (trial_2-1)*stimul_size);
        else
            stimul_set = stimul_list(1+ (trial_2-1)*stimul_size :end);
        end
        
        for trial_1  =1: length(stimul_set)
            Openvibe_tcp(t, 1);
            tic;
            %          Screen('DrawTexture',win,stimcuetexture(stimul_set(trial_1)));
            Screen('DrawTexture',win,stimcuetexture(stimul_set(trial_1)));  % N class stop frame
            
            Screen('TextSize',win,30);
            Screen('DrawText', win,'>>', true_pos(1),true_pos(2), 0);
            Screen('DrawText', win,'>>', ans_pos(1),ans_pos(2), 0);
            
            % Display list
            Screen('TextSize',win,30);
            for dist_list = 1: length(stimul_set)
                Screen('DrawText', win,num2str(stimul_set(dist_list)), true_pos(1) + 10 + textarea_fontspace*dist_list,true_pos(2), 0);
            end
            
            % results
            %         Screen('TextSize',win,30);
            if  trial_1 > 1
                for index_results= 1: trial_1-1
                    
                    Screen('DrawText', win,num2str(results(index_results)), ans_pos(1) + 10 + textarea_fontspace*index_results, ans_pos(2), 0);
                end
            end
            
            
            win = Text_all_class_fixed(width,height,targetWidth,targetHeight,class_x,class_y,margin_x,margin_y,win);
            Screen('Flip', win);
            
            imageArray = Screen('GetImage', win, [0 0 1920 140]);
            textureIndex = Screen('MakeTexture', win, imageArray);
            
            temp_int = toc;
            if temp_int <= 0.5
                WaitSecs(0.5-toc);
            end
            Openvibe_tcp(t, 2);
            % marker, stm type
            Openvibe_tcp(t, 5);
            %                     Openvibe_tcp(t, 3); %% start stm based epoch: 3
            Openvibe_tcp(t, 10+stimul_set(trial_1)); %%  stm based epoch
            %         Openvibe_tcp(t, 31); %% test tcp comm.
            %         tic;
%             tic;
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
                Screen('DrawTexture',win,texture((decimal_unique==bin2dec(sprintf('%d',freqCombine(:,indexflip)')))));
                %Display current index
                %             Screen('TextSize',win,30);
                %             Screen('DrawText', win,'>>', true_pos(1),true_pos(2), 0);
                %
                %             % Display true list
                %             Screen('TextSize',win,30);
                %             for dist_list = 1: length(stimul_set)
                %                 Screen('DrawText', win,num2str(stimul_set(dist_list)), true_pos(1)+ 10 + textarea_fontspace*dist_list,true_pos(2), 0);
                %             end
                
                % results
                %             Screen('TextSize',win,30);
                %             if  trial_1 > 1
                %                 for index_results= 1: trial_1-1
                %                     Screen('DrawText', win,num2str(results(index_results)), ans_pos(1)+ 10 + textarea_fontspace*index_results, ans_pos(2), 0);
                %                 end
                %             end
                %             win = Text_all_class_fixed(width,height,targetWidth,targetHeight,class_x,class_y,margin_x,margin_y,win);
                
                Screen('DrawTexture',win,textureIndex, [0 0 1920 140], [0 0 1920 140]); % copy upper line
                Screen('DrawingFinished', win);
                stp=Screen('Flip', win);
                list_amp(indexflip,:,trial_2,trial_1) = freqCombine(:,indexflip);
                list_stp(indexflip,trial_2,trial_1) = stp;
            end
%             toc;
            Openvibe_tcp(t, 3);
            
            Screen('DrawTexture',win,stimcuetexture(stimul_set(trial_1)));  % N class stop frame
            
            Screen('TextSize',win,30);
            Screen('DrawText', win,'>>', true_pos(1),true_pos(2), 0);
            Screen('DrawText', win,'>>', ans_pos(1),ans_pos(2), 0);
            
            % Display list
            Screen('TextSize',win,30);
            for dist_list = 1: length(stimul_set)
                Screen('DrawText', win,num2str(stimul_set(dist_list)), true_pos(1) + 10 + textarea_fontspace*dist_list,true_pos(2), 0);
            end
            
            % results
            %         Screen('TextSize',win,30);
            if  trial_1 > 1
                for index_results= 1: trial_1-1
                    
                    Screen('DrawText', win,num2str(results(index_results)), ans_pos(1) + 10 + textarea_fontspace*index_results, ans_pos(2), 0);
                end
            end
            
           
            Screen('DrawTexture',win,texture(end), [0 140 1920 1080], [0 140 1920 1080]);
%             win = Text_all_class_fixed(width,height,targetWidth,targetHeight,class_x,class_y,margin_x,margin_y,win);
            Screen('Flip', win);
            
            tic;                    
            WaitSecs(0.2);
            tcp_dat =read(s,srate*stimul_len,'double');
            try
                dummy=read(s); % remove extra sample
                dummy =[];
            end
            if length(unique(tcp_dat))==1
                results(trial_1)=unique(tcp_dat);
            else
                results(trial_1)=mode(tcp_dat);
            end
            tcp_dat=[];
            Openvibe_tcp(t, 50+results(trial_1)); %% start stm based epoch: 3
            
            
            Screen('DrawTexture',win,anscuetexture(results(trial_1)));
            Screen('TextSize',win,30);
            for dist_list = 1: length(stimul_set)
                Screen('DrawText', win,num2str(stimul_set(dist_list)), true_pos(1)+10 + textarea_fontspace*dist_list,true_pos(2), 0);
            end
            for index_results= 1: trial_1
                Screen('DrawText', win,num2str(results(index_results)), ans_pos(1)+ 10 + textarea_fontspace*index_results, ans_pos(2), 0);
            end 
            
            Screen('DrawText', win,'>>', true_pos(1),true_pos(2), 0);
            Screen('DrawText', win,'>>', ans_pos(1),ans_pos(2), 0);
            win = Text_all_class_fixed(width,height,targetWidth,targetHeight,class_x,class_y,margin_x,margin_y,win);
            Screen('Flip', win,ifi);
            
            temp_int = toc;
            if temp_int <= feedback_time
                WaitSecs(feedback_time- temp_int);
            end
            Openvibe_tcp(t, 4);
            tic ;
            Screen('DrawTexture',win,stimcuetexture(stimul_set(trial_1)));  % N class stop frame
            
            Screen('TextSize',win,30);
            Screen('DrawText', win,'>>', true_pos(1),true_pos(2), 0);
            Screen('DrawText', win,'>>', ans_pos(1),ans_pos(2), 0);
            
            % Display list
            Screen('TextSize',win,30);
            for dist_list = 1: length(stimul_set)
                Screen('DrawText', win,num2str(stimul_set(dist_list)), true_pos(1) + 10 + textarea_fontspace*dist_list,true_pos(2), 0);
            end
            
            % results
            %         Screen('TextSize',win,30);
           for index_results= 1: trial_1
                Screen('DrawText', win,num2str(results(index_results)), ans_pos(1)+ 10 + textarea_fontspace*index_results, ans_pos(2), 0);
            end 
           
            Screen('DrawTexture',win,texture(end), [0 140 1920 1080], [0 140 1920 1080]);
%             win = Text_all_class_fixed(width,height,targetWidth,targetHeight,class_x,class_y,margin_x,margin_y,win);
            Screen('Flip', win);
            temp_int = toc;
            if temp_int <= 0.3
                WaitSecs(0.3-toc);
            end
            
            %         dummy=read(s); % remove extra sample
            %         dummy =[];
        end
        WaitSecs(2);
    end
    WaitSecs(2);
    %     toc;
    Priority(0);
    %     Openvibe_tcp(t, 5); %% end
    frame_duration = Screen('GetFlipInterval', win);
    Screen('CloseAll');
    Screen('Close');
    echotcpip("off")
    
    
catch
    WaitSecs(2);
    Screen('CloseAll');
    Screen('Close');
    psychrethrow(psychlasterror);
    %     penvibe_tcp(t, 4); %% end
    echotcpip('off');
    
    %     plot(timestamp,pulseAmp(1,:))
    %     xlim([0 2])
end

%%
%
% % list_amp , 600    32     7     5
% % list_stp , 600     7     5
% set_stp=[];
% for i = 1:6
%     for j =1 :4
%         temp = list_stp(2:end,i,j)-list_stp(1:end-1,i,j);
%         set_stp = cat(1,set_stp,temp);
%
%     end
% end
% time = 0: 1/120 :5;
% time = time(1:end-1);
% for i =1
%     for j = 1
%
%         for ch = 1:32
% %            subplot(4,8 ,ch)
%             figure,
%             plot(list_stp(:,i,j)-list_stp(1,i,j),list_amp(:,ch,i,j));
%             hold on;
%             plot(time,1- freq{ch}(:));
%         end
%     end
% end

