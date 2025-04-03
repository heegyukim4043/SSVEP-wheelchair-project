function [flickerTexture]=flickerTexture_9class(winWidth,winHeight,targetWidth,targetHeight)

%% Generate matrix for 9 target 
    for i=1:10  
        targetMatrix{i} = zeros(winHeight,winWidth,'uint8');
    end
    
   %  1~9: 1flicker box , 10: empty
    %conver maxtrix from zero to target
%     00100 Top
%     10001 Left/Right
%     00100 Down
    for i =1:winHeight
        for j=1:winWidth
        %Target1 : L-T
        if (j>= (1))&&( j <= targetWidth)&&( i <= targetHeight)
            targetMatrix{1}(i,j)=1; %match target coordinate
            %disp('got it');     
        end
        %Target2 : M-T
        if (j>= (winWidth/2-targetWidth/2))&&( j <= winWidth/2+targetWidth/2)&&( i <= targetHeight)
            targetMatrix{2}(i,j)=1; %match target coordinate
            %disp('got it');     
        end
        %Target3 : R-T
        if (j>= winWidth-targetWidth)&&( j <= winWidth)&&( i <= targetHeight)
            targetMatrix{3}(i,j)=1; %match target coordinate
            %disp('got it');     
        end
        
        %Target4 : L-M
        if (j>= (1))&&( j <= targetWidth)&&(i>= (winHeight/2-targetHeight/2))&&( i <= winHeight/2+targetHeight/2)
            targetMatrix{4}(i,j)=1; %match target coordinate
            %disp('got it');     
        end
        %Target5 : M-M
        if (j>= (winWidth/2-targetWidth/2))&&( j <= winWidth/2+targetWidth/2)&&(i>= (winHeight/2-targetHeight/2))&&( i <= winHeight/2+targetHeight/2)
            targetMatrix{5}(i,j)=1; %match target coordinate
            %disp('got it');     
        end
        %Target6 : R-M
        if (j>= winWidth-targetWidth)&&( j <= winWidth)&&(i>= (winHeight/2-targetHeight/2))&&( i <= winHeight/2+targetHeight/2)
            targetMatrix{6}(i,j)=1; %match target coordinate
            %disp('got it');     
        end

        %Target7 : L-B
         if (j>= 1)&&(j <= targetWidth)&&( i >= (winHeight-targetHeight))
            targetMatrix{7}(i,j)=1; %match target coordinate
            %disp('got it');            
         end
          %Target8 : M-B
           if (j>= (winWidth/2-targetWidth/2))&&( j <= winWidth/2+targetWidth/2)&&( i >= (winHeight-targetHeight))
           targetMatrix{8}(i,j)=1; %match target coordinate
           end
          %Target9 : R-B
           if (j>= winWidth-targetWidth)&&( j <= winWidth)&&(i >= (winHeight-targetHeight))
            targetMatrix{9}(i,j)=1; %match target coordinate
            %disp('got it');
           end
           
           
        end
    end
%%Draw texture to screen: Draw 16 states depens on the value of


    



    for targetState1=1:2
    for targetState2=1:2
    for targetState3=1:2
    for targetState4=1:2
    for targetState5=1:2
    for targetState6=1:2
    for targetState7=1:2
    for targetState8=1:2
    for targetState9=1:2
        
    textureNumber = (targetState9-1)*2^8 + (targetState8-1)*2^7+(targetState7-1)*2^6 +(targetState6-1)*2^5 ...
    + (targetState5-1)*2^4+(targetState4-1)*8 +(targetState3-1)*4 +(targetState2-1)*2 +(targetState1-1)*1 +1;

    screenMatrix{textureNumber}=targetMatrix{10} | targetMatrix{1}*uint8(targetState1-1) |...
    targetMatrix{2}*uint8(targetState2-1) | targetMatrix{3}*uint8(targetState3-1) |...
    targetMatrix{4}*uint8(targetState4-1) | targetMatrix{5}*uint8(targetState5-1) | targetMatrix{6}*uint8(targetState6-1)| ...
    targetMatrix{7}*uint8(targetState7-1) | targetMatrix{8}*uint8(targetState8-1) | targetMatrix{9}*uint8(targetState9-1);

    end
    end
    end
    end
    end
    end
    end
    end
    end
    flickerTexture = screenMatrix;
end
