function flicker_movie (len,freqCombine, win, texture)
    
    
    
    for indexflip = 1: len
        % Drawing
        %Compute texture value based on display value from freq long matrixes
        class_vector = zeros(9,1);
        for i =1 : 9
            class_vector(i) = 2^(i-1); 
        end

        textureValue = freqCombine(:, indexflip) .* int16(class_vector);   
        textureValue = sum(textureValue)+1;
        %Draw it on the back buffer
        Screen('DrawTexture',win,texture(textureValue)); 
    %     Display current index
    %     Screen('DrawText', win, num2str(indexflip),400,400, 255);

        %Tell PTB no more drawing commands will be issued until the next flip
        Screen('DrawingFinished', win);
        % Fliping     
        %Screen('Flip', win, vbl + halfifi);

        %Flip ASAP
        Screen('Flip', win);
        pulseAmp(:,indexflip) = 1-freqCombine(:, indexflip);
    %     timestamp(1,indexflip)= str2num(datestr(clock,'SS')) + str2num(datestr(clock,'FFF'))*10^(-3);
        timestamp(1,indexflip) = toc;


    end


end