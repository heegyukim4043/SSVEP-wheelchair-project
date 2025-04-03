function [cueTexture]=cueTexture_all_class_fixed(winWidth,winHeight,targetWidth,targetHeight,class_x,class_y,Color,baseimage,margin_x,margin_y)


class = class_x*class_y;
for ind_c=1:class
    targetMatrix{ind_c} = uint8(baseimage); 
    tempMatrix{ind_c} = uint8(baseimage); 
end

for ind_c=1:class
%     for ind_h =1:winHeight
%         for ind_w=1:winWidth
%             if tempMatrix{ind_c}(ind_h,ind_w) == 1
%                 for color_ind = 1:3
%                     targetMatrix{ind_c}(ind_h,ind_w,color_ind) = 255;
%                 end
%             end
%         end
%         
%     end
    for color_ind = 1:3
        targetMatrix{ind_c}(:,:,color_ind) =255*tempMatrix{ind_c};
    end
end
% R = Color(1);
% G = Color(2);
% B = Color(3);

init_Height = 180;  % text area
init_Width = 60;    % interval width

len_W = winWidth - 2*init_Width;
len_H = winHeight - init_Height;
% 
% targetWidth = targetWidth + 10;
% targetHeight = targetHeight +10;

K_x = targetWidth*class_x + margin_x*(class_x-1); % RVS 부분의 총 길이
K_y = targetHeight*class_y + margin_y*(class_y-1);

init_x = (1800-K_x)/2 + 60;
init_y = (840-K_y)/2 + 180;

%  1~9: 1flicker box , 10: empty
%conver maxtrix from zero to target
%     00100 Top
%     10001 Left/Right
%     00100 Down


for ind_h =1:winHeight
    for ind_w=1:winWidth
%         %Target0 : index1
%         if (ind_w>= winWidth/4)&&( ind_w <= winWidth*3/4)&&( ind_h <= init_Height*4/9)  &&(ind_h >=init_Height*1/9)
%             targetMatrix{1+class  }(ind_h,ind_w)=1; %match target coordinate
%             %disp('got it');
%         end
%         if (ind_w>= winWidth/4)&&( ind_w <= winWidth*3/4)&&( ind_h <= init_Height*8/9)  &&(ind_h >=init_Height*5/9)
%             targetMatrix{1+class  }(ind_h,ind_w)=1; %match target coordinate
%             %disp('got it');
%         end
        
        for ind_Height = 1:class_y
            for ind_Width = 1: class_x
                if (ind_w >= init_x + (targetWidth + margin_x)*(ind_Width -1) )&&...
                    (ind_w <= init_x + (targetWidth + margin_x)*(ind_Width -1) + targetWidth )&&...
                    (ind_h >= init_y + (targetHeight + margin_y)*(ind_Height -1)) && ...
                    (ind_h <= init_y + (targetHeight + margin_y)*(ind_Height -1) + targetHeight)
                    
                    targetMatrix{(ind_Height-1)*class_x +ind_Width}(ind_h,ind_w)=1; %match target coordinate
                    for color_ind = 1:3
                        targetMatrix{(ind_Height-1)*class_x +ind_Width}(ind_h,ind_w,color_ind) = Color(color_ind);
                    end
                    %disp('got it');
                 
                end
            end
        end
    end
end


%%Draw texture to screen: Draw 16 states depens on the value of

% 
% for targetStage_class =0: 2^class -1
%     ind_str = dec2bin(targetStage_class);
%     if length(ind_str) <= class
%         for add_zero = 1: class-length(ind_str)
%             ind_str = strcat('0',ind_str);
%         end
%     elseif length(ind_str) > class
%         ind_str =[];
%         for add_zero = 1: class
%             ind_str = strcat('0',ind_str);
%         end
%     end
%     
%     %         textureNumber = 0;
%     %         for target_class = 1 : class
%     %             textureNumber = textureNumber+(str2num(ind_str(class-target_class+1)))*2^(target_class-1) ;
%     %         end
%     screenMatrix{targetStage_class+1} = targetMatrix{class+1};
%     for screen_ind = 1: class
%         screenMatrix{targetStage_class+1} = screenMatrix{targetStage_class+1} | targetMatrix{screen_ind}*(str2num(ind_str(class-screen_ind+1)));
%     end
%     
% end



%     for targetState1=1:2
%     for targetState2=1:2
%     for targetState3=1:2
%     for targetState4=1:2
%     for targetState5=1:2
%     for targetState6=1:2
%     for targetState7=1:2
%     for targetState8=1:2
%     for targetState9=1:2
%
%     textureNumber = (targetState9-1)*2^8 + (targetState8-1)*2^7+(targetState7-1)*2^6 +(targetState6-1)*2^5 ...
%     + (targetState5-1)*2^4+(targetState4-1)*8 +(targetState3-1)*4 +(targetState2-1)*2 +(targetState1-1)*1 +1;
%
%     screenMatrix{textureNumber}=targetMatrix{10} | targetMatrix{1}*uint8(targetState1-1) |...
%     targetMatrix{2}*uint8(targetState2-1) | targetMatrix{3}*uint8(targetState3-1) |...
%     targetMatrix{4}*uint8(targetState4-1) | targetMatrix{5}*uint8(targetState5-1) | targetMatrix{6}*uint8(targetState6-1)| ...
%     targetMatrix{7}*uint8(targetState7-1) | targetMatrix{8}*uint8(targetState8-1) | targetMatrix{9}*uint8(targetState9-1);
%
%     end
%     end
%     end
%     end
%     end
%     end
%     end
%     end
%     end
cueTexture =targetMatrix;
end