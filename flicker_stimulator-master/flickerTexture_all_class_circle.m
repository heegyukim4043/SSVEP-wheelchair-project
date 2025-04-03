function [flickerTexture]=flickerTexture_all_class_circle(winWidth,winHeight,targetWidth,targetHeight,class, margin_x, margin_y,unique_arrays,r_max,r_min)

%% Generate matrix for 9 target

% class

% r_max  r_min <= r_max <= min(width,height)/2
% r_min  0 <= r_max <= r_max 

for ind_h=1:1+class
    targetMatrix{ind_h} = zeros(winHeight,winWidth,'uint8');
end


% init_Height = 180;  % text area
% init_Width = 60;    % interval width

% len_W = winWidth - 2*init_Width;
% len_H = winHeight - init_Height;

% K_x = targetWidth*class_x + margin_x*(class_x-1); % RVS 부분의 총 길이
% K_y = targetHeight*class_y + margin_y*(class_y-1);
% 
% init_x = (1800-K_x)/2 + 60;
% init_y = (840-K_y)/2 + 180;


% center_point = [winHeight,winWidth]./2;
center_point = [winHeight*6/7, winWidth/2];

r_stim_max = r_max;
r_stim_min = r_min;


for class_idx = 1 : class
    check_template = zeros(winHeight,winWidth);

    for radious_idx =r_stim_min : r_stim_max
        
        angle_diff = (pi/class)*(class_idx-1) + pi;

        angles = linspace(0 + angle_diff, pi/class + angle_diff, max(center_point*2) );
        x = radious_idx * cos(angles) + center_point(2);
        y = radious_idx * sin(angles) + center_point(1);

        x_r = round(x);
        y_r = round(y);
        for j = 1 : length(x_r)
            check_template(y_r(j),x_r(j)) = 1;
        end

    end
    targetMatrix{class_idx} = check_template;
end

check_template = zeros(winHeight,winWidth);
targetMatrix{class + 1} = check_template;


% for radious_idx = 1 : 41
%     figure
%     spy(targetMatrix{radious_idx});
% end



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

screenMatrix{size(unique_arrays,1)+1} = targetMatrix{end};

for radious_idx = 1 : size(targetMatrix,2)
    screenMatrix{size(unique_arrays,1)+1} = screenMatrix{size(unique_arrays,1)+1} + targetMatrix{radious_idx};
end

% spy(screenMatrix{end})

flickerTexture = screenMatrix;
end

