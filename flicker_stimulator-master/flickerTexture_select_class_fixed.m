function [flickerTexture]=flickerTexture_select_class_fixed(winWidth,winHeight,targetWidth,targetHeight,class_x,class_y, margin_x, margin_y,unique_arrays,mask_matrix)

%% Generate matrix for N target

% check stim number

if ~(sum(mask_matrix,'all') == size(unique_arrays,2))
    disp('please check the # of mask and stimuli');
    flickerTexture = [];s
else
    
    reshape_mask = reshape(mask_matrix,1,[]);
    list_mask = find(reshape_mask == 1);
    
    
    class = class_x* class_y;
    for ind_h=1:1+class
        targetMatrix{ind_h} = zeros(winHeight,winWidth,'uint8');
    end
    
    
    init_Height = 180;  % text area
    init_Width = 60;    % interval width
    
    len_W = winWidth - 2*init_Width;
    len_H = winHeight - init_Height;
    
    K_x = targetWidth*class_x + margin_x*(class_x-1); % RVS 부분의 총 길이
    K_y = targetHeight*class_y + margin_y*(class_y-1);
    
    init_x = (1800-K_x)/2 + 60;
    init_y = (840-K_y)/2 + 180;
    
    
    % Set initial texture matrix
    for ind_h =1:winHeight  %y
        for ind_w=1:winWidth  %x
            
            % 지시문 뜨는 부분
            %Target0 : index1
            if (ind_w>= winWidth/4)&&( ind_w <= winWidth*3/4)&&( ind_h <= init_Height*3/9)  &&(ind_h >=init_Height*0/9)
                targetMatrix{1+class  }(ind_h,ind_w)=1; %match target coordinate
                %disp('got it');
            end
            if (ind_w>= winWidth/4)&&( ind_w <= winWidth*3/4)&&( ind_h <= init_Height*7/9)  &&(ind_h >=init_Height*4/9)
                targetMatrix{1+class  }(ind_h,ind_w)=1; %match target coordinate
                %disp('got it');
            end
            
            %여기부터 RVS
            for ind_Height = 1:class_y % 1부터 3까지 (RVS 3x3일 때)
                for ind_Width = 1: class_x % 1부터 3까지 (RVS 3x3일 때)
                    if (ind_w >= init_x + (targetWidth + margin_x)*(ind_Width -1) )&&...
                            (ind_w <= init_x + (targetWidth + margin_x)*(ind_Width -1) + targetWidth )&&...
                            (ind_h >= init_y + (targetHeight + margin_y)*(ind_Height -1)) && ...
                            (ind_h <= init_y + (targetHeight + margin_y)*(ind_Height -1) + targetHeight &&...
                            mask_matrix(ind_Width,ind_Height)==1)
                        
                        targetMatrix{(ind_Height-1)*class_x + ind_Width}(ind_h,ind_w)=1; %match target coordinate 
                    else
                        targetMatrix{(ind_Height-1)*class_x + ind_Width}(ind_h,ind_w)=0; %match target coordinate 
                    end
                    
                    
                end
            end
        end
    end
    
    for i = 1 : length(list_mask)
        re_targetMatrix{i} = targetMatrix{list_mask(i)};
    end
    re_targetMatrix{end+1} = targetMatrix{end};
    
%     for i = 1 : length(re_targetMatrix)
%         figure
%         spy(re_targetMatrix{i})
%     end
    %%Draw texture to screen: Draw 16 states depens on the value of
    
    
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
    
    screenMatrix = cell(0);
    for targetStage_class =1:size(unique_arrays,1)%2^class -1
        %     ind_str = dec2bin(targetStage_class, class);
        ind_str = sprintf('%d', unique_arrays(targetStage_class,:));
        screenMatrix{targetStage_class} = re_targetMatrix{length(list_mask)+1}; % user-answer area
        % Adding user-answer area and whole cases
        for screen_ind = find(ind_str=='1')
            screenMatrix{targetStage_class} = screenMatrix{targetStage_class} + re_targetMatrix{screen_ind};
        end
        
    end
    
    screenMatrix{size(unique_arrays,1)+1} = re_targetMatrix{end};
    for i = 1 : size(re_targetMatrix,2)
        screenMatrix{size(unique_arrays,1)+1} = double(screenMatrix{size(unique_arrays,1)+1}) + double(re_targetMatrix{i});
    end
    
%     for i = 1 : length(screenMatrix)
%         figure
%         spy(screenMatrix{i})
%         
%     end
   
   
    flickerTexture = screenMatrix;
    
end

end

% for i=1 :13
%     figure,
%     spy(test_temp{1, i})
% end
