% this file extract the 

addpath(genpath('.'));
current_path = pwd;

global SUN_2D; 
global SUN_3D; 
global OLD_ROOT;
global NEW_ROOT;
global CLASS_NAMES;
global SUNRGBD_ROOT;

SUN_2D = load('./MetaData/SUNRGBDMeta2DBB_v2.mat');
SUN_3D = load('./MetaData/SUNRGBDMeta3DBB_v2.mat');


%remove the lamp object's groundtruth3DBB, since the SUNRGBD
%has an error in the SUNRGBDMeta2DBB's mat file

%delete lamp from SUN_2D

%preprocess
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for img_index = 1:length(SUN_2D.SUNRGBDMeta2DBB)

    if isempty(SUN_2D.SUNRGBDMeta2DBB(img_index).groundtruth2DBB)
        continue;
    end

    %delete classname not equal to 'chair'
    %we only need chair now
    classnames = {SUN_2D.SUNRGBDMeta2DBB(img_index).groundtruth2DBB.classname};
    idx = ~cellfun(@(classname) strcmp(classname, 'chair'), classnames);
    idx = find(idx == 1);
    SUN_2D.SUNRGBDMeta2DBB(img_index).groundtruth2DBB(idx) = [];


end

%delete anything which is not chair from SUN_3D
for img_index = 1:length(SUN_3D.SUNRGBDMeta)
    if isempty(SUN_3D.SUNRGBDMeta(img_index).groundtruth3DBB)
        continue;
    end

    classnames = {SUN_3D.SUNRGBDMeta(img_index).groundtruth3DBB.classname};
    idx = ~cellfun(@(classname) strcmp(classname, 'chair'), classnames);
    idx = find(idx == 1);
    SUN_3D.SUNRGBDMeta(img_index).groundtruth3DBB(idx) = [];

end


%delete has3dbox equal to 0
for img_index = 1:length(SUN_2D.SUNRGBDMeta2DBB)
    %assert(length(SUN_2D.SUNRGBDMeta2DBB) == length(SUN_3D.SUNRGBDMeta(img_index))
    %for obj_index = 1:length(SUN_2D.SUNRGBDMeta2DBB(img_index).groundtruth2DBB)
    %    assert(length(SUN_2D.SUNRGBDMeta2DBB(img_index).groundtruth2DBB(obj_index).classname) == ...
    %           length(SUN_3D.SUNRGBDMeta(img_index).groundtruth3DBB(obj_index).classname))
    if isempty(SUN_2D.SUNRGBDMeta2DBB(img_index).groundtruth2DBB)
        SUN_3D.SUNRGBDMeta(img_index).groundtruth3DBB = [];
        continue;
    end
   % SUN_2D.SUNRGBDMeta2DBB(img_index);
   % SUN_2D.SUNRGBDMeta2DBB(img_index).groundtruth2DBB;
   % SUN_2D.SUNRGBDMeta2DBB(img_index).groundtruth2DBB.has3dbox;
    has3dboxs = [SUN_2D.SUNRGBDMeta2DBB(img_index).groundtruth2DBB.has3dbox];
    has3dboxs = find(has3dboxs == 0);
    SUN_2D.SUNRGBDMeta2DBB(img_index).groundtruth2DBB(has3dboxs) = [];
    %    SUN_3D.SUNRGBDMeta(img_index).groundtruth3DBB(has3dboxs) = [];
    %assert(length(SUN_2D.SUNRGBDMeta2DBB(img_index).groundtruth2DBB(obj_index)) == length(SUN_3D.SUNRGBDMeta(img_index).groundtruth3DBB))
    if length(SUN_2D.SUNRGBDMeta2DBB(img_index).groundtruth2DBB) ~= length(SUN_3D.SUNRGBDMeta(img_index).groundtruth3DBB)
        %disp(img_index);
        SUN_2D.SUNRGBDMeta2DBB(img_index).groundtruth2DBB =[];
        SUN_3D.SUNRGBDMeta(img_index).groundtruth3DBB = [];
      %  if img_index == 93
      %      SUN_3D.SUNRGBDMeta(img_index).groundtruth3DBB
      %      SUN_3D.SUNRGBDMeta(img_index).rgbpath
      %      SUN_2D.SUNRGBDMeta2DBB(img_index).rgbpath
      %  end
    end
end


%test those two has the same size
disp(length(SUN_2D.SUNRGBDMeta2DBB))
disp(length(SUN_3D.SUNRGBDMeta))
assert(length(SUN_2D.SUNRGBDMeta2DBB) == length(SUN_3D.SUNRGBDMeta));
for i = 1:length(SUN_2D.SUNRGBDMeta2DBB)
   % if i == 93
   %     SUN_3D.SUNRGBDMeta(img_index).groundtruth3DBB
   %     SUN_3D.SUNRGBDMeta(img_index).rgbpath
   %     SUN_2D.SUNRGBDMeta2DBB(img_index).rgbpath
   % end

    assert(length(SUN_2D.SUNRGBDMeta2DBB(i).groundtruth2DBB) == length(SUN_3D.SUNRGBDMeta(i).groundtruth3DBB));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
OLD_ROOT = '/n/fs/sun3d/data';
%NEW_ROOT = '/media/baiyu/428210F38210ED63'; % you need to change here
NEW_ROOT = '/home/admin-bai/Downloads';
CLASS_NAMES = {'chair'};

SUNRGBD_ROOT = '/home/admin-bai/Downloads/SUNRGBD';
if ~exist(SUNRGBD_ROOT, 'dir')
    disp('root directory doesnt exists');
    return;
end


result_path = fullfile(current_path, 'ImageNames');
write_img_names('kv2', result_path);


disp('reading image names....');
name_array = read_img_names(result_path);
%rf = fopen(result_file, 'r');
%tline = fgetl(rf);
%row_counter = numel(textscan('result.txt', '%1c%*[^\n]'));
%nameArray = cell(1, row_counter);
%count = 1;
%while ischar(tline)
%    nameArray{count} = tline;
%    count = count + 1;
%    tline = fgetl(rf);
%end



% get seg, img, depth
%img_pathes = cell(1, length(nameArray));
%seg_pathes = cell(1, length(nameArray));
%sequence_names = cell(1, length(nameArray));
%%depth_pathes = cell(1, length(nameArray));
%img_index = cell(1, length(nameArray));
%SUN = load('SUNRGBDMeta3DBB_v2.mat');
%all_names = {SUN.SUNRGBDMeta.sequenceName}; 
%for i = 1:length(nameArray) 
%    sequence_names{i} = get_sequencename(nameArray{i});
%    img_index{i} = find(ismember(all_names, sequence_names{i}));
%    disp(sequence_names{i});
%end

sequence_names = transform_name_to_sequence(name_array);
image_indexes = get_image_index(sequence_names);
Hin_struct = struct('depthpath', [], ...
                         'rgbpath', [], ...
                         'Rtilt', [], ...
                         'groundtruth3DBB', []);
            

disp('extracting data by index.....');
index = 1;
for i = 1:length(image_indexes)
    Hin_struct_temp =  extract_Hinterstoisser_data_by_index(image_indexes{i});

    %check if we have a I was 
    for obj_index = 1:length(Hin_struct_temp.groundtruth3DBB)
        if any(structfun(@isempty, Hin_struct_temp.groundtruth3DBB(obj_index)))
            Hin_struct_temp = [];
            break;
        end
    end

    if isempty(Hin_struct_temp)
        continue;
    end

    Hin_struct(index) = Hin_struct_temp;
    index = index + 1;
end

disp('write result....');
write_results(Hin_struct);
%depth_pathes = cell(1, length(img_index));
%jpg_pathes = cell(1, length(img_index));
%rotation_matrixes = cell(1, length(img_index));
%extents = cell(1, length(img_index)); % cell array, each cell contains a struct array. struct array have object height , width, length
%seg_pathes = cell(1, length(img_index));
%
%for i = 1:length(img_index)
%
%    %get depth_path from  SUN.SUNRGBDMeta
%    depth_pathes{i} = strrep(SUN.SUNRGBDMeta(img_index{i}).depthpath, old_root, new_root);
%    %use depth_bfx depth_image
%    depth_pathes{i} = strrep(depth_pathes{i}, '/depth', 'depth_bfx');
%
%
%    %get jpg_path  from SUN.SUNRGBDMeta
%    jpg_pathes{i} = strrep(SUN.SUNRGBDMeta(img_index{i}).rgbpath, old_root, new_root);
%
%    %get rotation_matrixes from SUN.SUNRGBDMeta
%    rotation_matrixes{i} = SUN.SUNRGBDMeta(img_index{i}).Rtilt;
%
%    %get seg_pathes from SUN.SUNRGBDMeta
%    temp = strsplit(jpg_pathes{i}, '//'); 
%    seg_pathes{i} [temp{1}, '/seg.mat'];
%
%    %find the chai= r index
%    object_index = find(strcmp({SUN.SUNRGBDMeta(img_index{i}).groundtruth3DBB.classname}, 'chair'));
%    for index = 1:numel(object_index);
%        %get corners of chair object
%        corners = get_corners_of_bb3d(SUN.SUNRGBDMeta(img_index{i}).groundtruth3DBB(object_index(index)));
%        extents{i}(index).height = abs(corners(1, 3) - corners(5, 3)); % get height
%        extents{i}(index).width = pdist([corners(1, 1:2); corners(2, 1:2)], 'euclidean');
%        extents{i}(index).length = pdist([corners(2, 1:2); corners(3, 1:2)], 'euclidean');
%    end
%    disp(extents{i});
%
%    %hold on;
%    
%end



%dummy_root = fullfile(pwd, 'my_dummy');
%
%% check if dummy_root exists
%if ~exist(dummy_root, 'dir')
%    mkdir(dummy_root);
%end
%
%%create sub folder 
%create_sub_folder(dummy_root);
%
%training_root = fullfile(dummy_root, 'training', 'SUNRGBD_chair');
%
%%training_root_sub = get_sub_dir(training_root);
%
%%if ~isempty(find(training_root_sub, ismember(training_root_sub, 'rgb_noseg')))
%%    training_rgb_noseg = fullfile(training_root, 'rgb_noseg');
%%else
%%    disp('there is no rgb_noseg folder');
%%    return;
%%end
%training_depth_noseg = fullfile(training_root, 'depth_noseg');
%training_rgb_noseg = fullfile(training_root, 'rgb_noseg');
%training_obj = fullfile(training_root, 'obj');
%training_seg = fullfile(training_root, 'seg');
%training_info = fullfile(training_root, 'info');
%%for i = 1:length(training_root_sub) 
%%    switch training_root_sub{i}
%%    case 'rgb_noseg'
%%        training_rgb_noseg = fullfile(training_root, training_root_sub{i});       
%%    case 'depth_noseg'
%%        training_depth_noseg = fullfile(training_root, training_root_sub{i});
%%    case 'obj'
%%        training_obj = fullfile(training_root, training_root_sub{i});
%%    case 'info'
%%        training_info = fullfile(training_root, training_root_sub{i});
%%    case 'seg'
%%        training_seg = fullfile(training_seg, training_root_sub{i});
%%    end
%%end
%
%
%total_img = 0;
%for i = 1:length(extents)
%    total_img = total_img + length(extents{i});
%end
%disp(total_img);
%
%dummy_data = struct([]);
%