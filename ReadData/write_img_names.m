% Read files from SUNRGBD/images according to 
% the sensor type (only support kv2 right now)
% 
%
% Args:
%   sensor_type: kv2, kv1 ....
%   result_path: file path for result.txt
% Returns:
%   name_array - a cell array for each cell contains a img name       
%
% Author: Bai

function write_img_names(sensor_type, result_path)
    global SUNRGBD_ROOT;
    assert(strcmp(sensor_type, 'kv2'));

    image_path = fullfile(SUNRGBD_ROOT, 'images', sensor_type);
    if ~exist(image_path, 'dir')
        disp('image path doesnt exists');
        return;
    end
    image_names = dir(image_path);

    %write to files
    results = fopen(fullfile(result_path, 'result.txt'), 'w');
    %for index = 3:length(image_names)
    for index = 3:100
        fprintf(results, strcat(image_names(index).name, '\n'));
    end
    fclose(results);
end


