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

    global CLASS_NAMES;

    total_number = 0;
    for index = 1:length(Hin_structs);
        for obj_index = 1:length(Hin_structs(index).groundtruth3DBB)
        %source file path and data
            source_rgb_path = Hin_structs(index).rgbpath;
            source_depth_path = Hin_structs(index).depthpath;
            source_pose = get_obj_pose(Hin_structs(index).groundtruth3DBB(obj_index).centroid, ...
                                Hin_structs(index).groundtruth3DBB(obj_index).basis, ...
                                Hin_structs(index).Rtilt);
            [source_seg_path, name, ext] = fileparts(source_rgb_path);
            source_seg_path = strrep(source_seg_path, '/image', '');
            source_seg_path = fullfile(source_seg_path, 'seg.mat');
            bbox2d = Hin_structs(index).groundtruth3DBB(obj_index).bbox2d;


            % file path
            scene_path = fullfile(pwd, 'scene');
            des_depth_path = fullfile(scene_path, 'depth_noseg');
            des_pose_path = fullfile(scene_path, 'poses');
            des_rgb_path = fullfile(scene_path, 'rgb_noseg');
            des_seg_path = fullfile(scene_path, 'seg');


            %file name
            rgb_filename = sprintf('frame-%06d.color.png', total_number);
            depth_filename = sprintf('frame-%06d.depth.png', total_number);
            pose_filename = sprintf('frame-%06d.pose.txt', total_number);
            seg_filename = sprintf('frame-%06d.seg.png', total_number);
            

            %copy and write file
            if ~exist(des_rgb_path, 'dir')
                disp('rgb_noseg dir doesnt exists!');
                fprintf('make dir %s', des_rgb_path);
                mkdir(des_rgb_path);
            end

            %crop obj from image
            %and write cropped image
            original_rgb = imread(source_rgb_path);
            rgb_cropped = imcrop(original_rgb, bbox2d);
            imwrite(rgb_cropped, fullfile(des_rgb_path, rgb_filename));
            %copyfile(source_rgb_path, fullfile(des_rgb_path, rgb_filename));


            if ~exist(des_depth_path, 'dir')
                disp('depth_noseg dir doesnt exists!');
                fprintf('make dir %s', des_depth_path);
                mkdir(des_depth_path);
            end

            original_depth = imread(source_depth_path);
            depth_cropped = imcrop(original_depth, bbox2d);
            imwrite(depth_cropped, fullfile(des_depth_path, depth_filename));

            %copyfile(source_depth_path, fullfile(des_depth_path, depth_filename));


            if ~exist(des_pose_path, 'dir')
                disp('poses dir doesnt exists!');
                fprintf('make dir %s', des_pose_path);
                mkdir(des_pose_path);
            end
            dlmwrite(fullfile(des_pose_path, pose_filename), source_pose, 'delimiter', '\t');

            %crop segmentation from seg.mat
            if ~exist(des_seg_path, 'dir')
                disp('seg dir doesnt exists!');
                fprintf('make dir %s', des_seg_path);
                mkdir(des_seg_path);
            end
            seg = load(source_seg_path);
            seglabel = seg.seglabel;
            %imshow(seglabel)
            names= seg.names;
            %idx = find(ismember(names, 'chair'));
            idx = find(ismember(names, CLASS_NAMES));
            not_idx = find(~ismember(names, CLASS_NAMES));
            %disp(idx)
            seglabel(ismember(seglabel, idx)) = 255;
            seglabel(ismember(seglabel, not_idx)) = 0;
            imshow(seglabel);
            seg_cropped = imcrop(seglabel, bbox2d);
            imwrite(seg_cropped, fullfile(des_seg_path, seg_filename));









            total_number = total_number + 1;
        end
    end
end
