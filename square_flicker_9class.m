function square_flicker_9class() 
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


freq_list = [14 15 16 17 18 19 20 21 22] ;
phase_list = [0 0 0 0 0 0 0 0 0] ;
class = 9;
frame=120 ; % Hz
stim_len = 5;
% initiate freq table

for i =1: class 
    freq{i} = generate_freq(freq_list(i), phase_list(i) , frame,stim_len);   %freq, phase ,frame   
end

% freq{1} = generate_freq(10, 0 , 120);   %freq, phase ,frame   
% freq{2} = generate_freq(12, 0 , 120);   
% freq{3} = generate_freq(15, 0 , 120); 
% freq{4} = generate_freq(11, 0 , 120); 



%%Generate display matrixes for movies
% Find LCM of freq matrix to create equal matrixes for all freqs 

% lcmFreq = 4*lcms([length(freq{1}),length(freq{2}),length(freq{3}),length(freq{4})]);
lcmFreq = length(freq{4});

%Generate full movie matrix of frequency 
for i=1:class
    freqCombine(i,:) = repmat(freq{i},[1,lcmFreq/length(freq{i})]); 
end
%Revert value because in Matlab 255 is white and 0 is black
freqCombine = 1 - freqCombine;

% maxduration = 1000;
 
 try
    [win, texture]=  Screen_init();
%     myScreen = max(Screen('Screens'));
% 
%     [win,winRect] =   Screen(1,'OpenWindow',[],[0 0 900 900]);  % window size 
%     [width, height] = RectSize(winRect);
%     
%     % Background color dark green, just to make sure
%     Screen('FillRect',win,[0 255 0]);
%     %%Make movie 
%     targetWidth = 150;
%     targetHeight = 150;
%     % make textures clipped to screen size
%     % Draw texture to screen: Draw 16 states or texture depens on the value of
%     screenMatrix = flickerTexture_9class(width, height, targetWidth, targetHeight);
%     for  i =1:2^class 
%         texture(i) = Screen('MakeTexture', win, uint8(screenMatrix{i})*255);
%     end
%     
% %     Screen('NominalFrameRate', 1 , 1 , 120);
%    
%     % Define refresh rate.
%     ifi = Screen('GetFlipInterval', win);
%     
%    %Run in this duration
%     deadline = GetSecs + maxduration;
%         
%     % Preview texture briefly before flickering
%     % n.b. here we draw to back buffer
%     Screen('DrawTexture',win,texture(512)); 
%     VBLTimestamp = Screen('Flip', win, ifi);
    WaitSecs(2);
    
    
    
    % loop swapping buffers, checking keyboard, and chsecking time
    % param 2 denotes "dont clear buffer on flip", i.e., we alternate
    % our buffers cum textures
    indexflip = 1;
    % textureValue =0;    
%     halfifi = 0.5*ifi;
    vbl =0; 
%% Start looping movie   
    Priority(1);
%     while (~KbCheck) && (GetSecs < deadline)
%     tic;


    flicker_movie(lcmFreq,freqCombine,win, texture);
%     while (1)
% 
%         % Drawing
%         %Compute texture value based on display value from freq long matrixes
%         class_vector = zeros(9,1);
%         for i =1 : class
%             class_vector(i) = 2^(i-1); 
%         end
% 
%         textureValue = freqCombine(:, indexflip) .* int16(class_vector);   
%         textureValue = sum(textureValue)+1;
%         %Draw it on the back buffer
%         Screen('DrawTexture',win,texture(textureValue)); 
%     %     Display current index
%     %     Screen('DrawText', win, num2str(indexflip),400,400, 255);
% 
%         %Tell PTB no more drawing commands will be issued until the next flip
%         Screen('DrawingFinished', win);
%         % Fliping     
%         %Screen('Flip', win, vbl + halfifi);
% 
%         %Flip ASAP
%         Screen('Flip', win);
% %         pulseAmp(:,indexflip) = 1-freqCombine(:, indexflip);
%     %     timestamp(1,indexflip)= str2num(datestr(clock,'SS')) + str2num(datestr(clock,'FFF'))*10^(-3);
%         timestamp(1,indexflip) = toc;
% 
%     %     timestemp(2,indexflip)= str2num(datestr(clock,'FFF'));
%         indexflip = indexflip+1;
% 
%         %Reset index at the end of freq matrix
%             if indexflip > lcmFreq
%                 break;
% 
%                 indexflip = 1;
%                 %disp('over');
%             end
%     end 
%     toc;
    Priority(0); 
    frame_duration = Screen('GetFlipInterval', win);
    Screen('CloseAll');
    Screen('Close');

catch
    Screen('CloseAll');
    Screen('Close');
    psychrethrow(psychlasterror);
    
%     plot(timestamp,pulseAmp(1,:))
%     xlim([0 2])
end


%%
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
