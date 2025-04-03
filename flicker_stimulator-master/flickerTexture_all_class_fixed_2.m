function [flickerTexture]=flickerTexture_all_class_fixed(winWidth,winHeight,targetWidth,targetHeight,class_x,class_y, unique_arrays)

%% Generate matrix for 9 target

class = class_x*class_y;
targetMatrix = cell(0);
for ind_h=1:1+class
    targetMatrix{ind_h} = zeros(winHeight,winWidth,'uint8');
end

init_Height = 180;  % text area
init_Width = 60;    % interval width

len_W = winWidth - 2*init_Width;
len_H = winHeight - init_Height;

%  1~9: 1flicker box , 10: empty
%conver maxtrix from zero to target
%     00100 Top
%     10001 Left/Right
%     00100 Down
for ind_h =1:winHeight
    for ind_w=1:winWidth
        %Target0 : index1
        if (ind_w>= winWidth/4)&&( ind_w <= winWidth*3/4)&&( ind_h <= init_Height*4/9)  &&(ind_h >=init_Height*1/9)
            targetMatrix{1+class}(ind_h,ind_w)=1; %match target coordinate
        end
        
        if (ind_w>= winWidth/4)&&( ind_w <= winWidth*3/4)&&( ind_h <= init_Height*8/9)  &&(ind_h >=init_Height*5/9)
            targetMatrix{1+class}(ind_h,ind_w)=1; %match target coordinate
        end
        
        for ind_Height = 1:class_y
            for ind_Width = 1: class_x
                if (ind_w >= init_Width + (ind_Width)*len_W/(class_x+1) - targetWidth/2 )&&...
                    (ind_w <= targetWidth + init_Width +(ind_Width)*len_W/(class_x+1) - targetWidth/2 )&&...
                    (ind_h >= init_Height + (ind_Height-1)*len_H/(class_y)) && ...
                    (ind_h <= targetHeight+init_Height + (ind_Height-1)*len_H/(class_y))
                    
                    targetMatrix{(ind_Height-1)*class_x +ind_Width}(ind_h,ind_w)=1; %match target coordinate
                end
            end
        end
    end
end
%%Draw texture to screen: Draw 16 states depens on the value of

% Major time consume
screenMatrix = cell(0);
for targetStage_class =1:size(unique_arrays,1)%2^class -1
%     ind_str = dec2bin(targetStage_class, class);
    ind_str = sprintf('%d', unique_arrays(targetStage_class,:));
    screenMatrix{targetStage_class} = targetMatrix{class+1}; % user-answer area
    % Adding user-answer area and whole cases
    for screen_ind = find(ind_str=='1')
        screenMatrix{targetStage_class} = screenMatrix{targetStage_class} + targetMatrix{screen_ind};
    end
    
end
flickerTexture = screenMatrix;
end

