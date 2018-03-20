% Read the info which Hinterstoisser data formate needs from
% SUN_2D and Sun_3D
% Args:
%   index - the corresponding img index in SUN_3D
%
% Returns:
%   Hin_struct - a struct array contains:
%                depth_path to the depth img
%                rgb_path to the rgb img
%                extents about the object's height, width, length
%                seg_path to the seg.mat file
%                rotation_matrix to the object 
% Author: Bai

function Hin_struct = extract_Hinterstoisser_data_by_index(index)

     %groundtruth3DBB is a struct array which contains these fields
     %classname
     %objid
     %extens
     %centriod
     Hin_struct = struct('depthpath', get_depth_path_by_index(index), ...
                         'rgbpath', get_rgb_path_by_index(index), ...
                         'Rtilt', get_rotation_matrix_by_index(index), ...
                         'groundtruth3DBB', get_groundtruth3DBB_by_index(index));
end

function depth_path = get_depth_path_by_index(index)
    global OLD_ROOT;
    global NEW_ROOT;
    global SUN_3D;
    depth_path = strrep(SUN_3D.SUNRGBDMeta(index).depthpath, OLD_ROOT, NEW_ROOT);
    %use depth_bfx depth_image
    depth_path = strrep(depth_path, '/depth', '/depth_bfx');
end

function rgb_path = get_rgb_path_by_index(index)
    global OLD_ROOT;
    global NEW_ROOT;
    global SUN_3D;
    rgb_path = strrep(SUN_3D.SUNRGBDMeta(index).rgbpath, OLD_ROOT, NEW_ROOT);
    rgb_path = strrep(rgb_path, '//', '/');
end

function ratation_matrix = get_rotation_matrix_by_index(index)
    global SUN_3D;
    ratation_matrix = SUN_3D.SUNRGBDMeta(index).Rtilt;
end

function groundtruth_3DBB = get_groundtruth3DBB_by_index(index)
    global SUN_3D;
    global SUN_2D;
    global CLASS_NAMES;
    groundtruth_3DBB = struct('classname', [], ...
                              'objid', [], ... 
                              'extents', [], ...
                              'orientation', [], ...
                              'centroid', [], ...
                              'basis', [], ...
                              'bbox2d', []);
    
    cnt = 1;
    
    for i = 1:length(SUN_3D.SUNRGBDMeta(index).groundtruth3DBB) 

        if ~ismember(SUN_3D.SUNRGBDMeta(index).groundtruth3DBB(i).classname, CLASS_NAMES) || ...
           ~SUN_3D.SUNRGBDMeta(index).groundtruth3DBB(i).label
            continue;
        end



        classname = SUN_3D.SUNRGBDMeta(index).groundtruth3DBB(i).classname;
        objid = i;
        [lg, wd, hg] = get_extents_by_3DBB(SUN_3D.SUNRGBDMeta(index).groundtruth3DBB(i));
        extents.length = lg;
        extents.width = wd;
        extents.height = hg;
        orientation = SUN_3D.SUNRGBDMeta(index).groundtruth3DBB(i).orientation;
        centroid = SUN_3D.SUNRGBDMeta(index).groundtruth3DBB(i).centroid;
        basis = SUN_3D.SUNRGBDMeta(index).groundtruth3DBB(i).basis;
       % disp(index);
       % disp(i);
        bbox2d = SUN_2D.SUNRGBDMeta2DBB(index).groundtruth2DBB(i).gtBb2D;

        thisbbx.classname = classname;
        thisbbx.objid = objid;
        thisbbx.extents = extents;
        thisbbx.orientation = orientation;
        thisbbx.centroid = centroid;
        thisbbx.basis = basis;
        thisbbx.bbox2d = bbox2d;


        groundtruth_3DBB(cnt) = thisbbx;
        cnt = cnt + 1;
    end

end

function  [length, width, height] = get_extents_by_3DBB(bb3d)
    corners = get_corners_of_bb3d(bb3d);


    height = abs(corners(1,3) - corners(5, 3));
    length = pdist([corners(1, 1:2); corners(2, 1:2)], 'euclidean');
    width = pdist([corners(2, 1:2); corners(3, 1:2)], 'euclidean');
end