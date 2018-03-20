% Write rgb image, depth image, rotation matrix and tranlation matrix
% to file(now have only tested for chairs)
% Args:
%    Hin_structs a struct array contains the information we need
%
% Returns:
%   sequence_names - a cell array transformed sequence names for the input
%
% Author: Bai

function write_results(Hin_structs)

    total_number = 0;
    for index = 1:length(Hin_structs);
        for obj_index = 1:length(Hin_structs(index).groundtruth3DBB)
        %source file path and data
            source_rgb_path = Hin_structs(index).rgbpath;
            source_depth_path = Hin_structs(index).depthpath;
            source_pose = get_obj_pose(Hin_structs(index).groundtruth3DBB(obj_index).centroid, ...
                                Hin_structs(index).groundtruth3DBB(obj_index).basis, ...
                                Hin_structs(index).Rtilt);
            bbox2d = Hin_structs(index).groundtruth3DBB(obj_index).bbox2d;

            % file path
            scene_path = fullfile(pwd, 'scene');
            des_depth_path = fullfile(scene_path, 'depth_noseg');
            des_pose_path = fullfile(scene_path, 'poses');
            des_rgb_path = fullfile(scene_path, 'rgb_noseg');

            %file name
            rgb_filename = sprintf('frame-%06d.color.png', total_number);
            depth_filename = sprintf('frame-%06d.depth.png', total_number);
            pose_filename = sprintf('frame-%06d.pose.txt', total_number);
            

            %copy and write file
            if ~exist(des_rgb_path, 'dir')
                disp('rgb_noseg dir doesnt exists!');
                return;
            end

            %crop obj from image
            %and write cropped image
            original_rgb = imread(source_rgb_path);
            rgb_cropped = imcrop(original_rgb, bbox2d);
            imwrite(rgb_cropped, fullfile(des_rgb_path, rgb_filename));
            %copyfile(source_rgb_path, fullfile(des_rgb_path, rgb_filename));


            if ~exist(des_depth_path, 'dir')
                disp('depth_noseg dir doesnt exists!');
                return;
            end

            original_depth = imread(source_depth_path);
            depth_cropped = imcrop(original_depth, bbox2d);
            imwrite(depth_cropped, fullfile(des_depth_path, depth_filename));

            %copyfile(source_depth_path, fullfile(des_depth_path, depth_filename));


            if ~exist(des_pose_path, 'dir')
                disp('poses dir doesnt exists!');
            end
            dlmwrite(fullfile(des_pose_path, pose_filename), source_pose, 'delimiter', '\t');


            total_number = total_number + 1;
        end
    end
end
