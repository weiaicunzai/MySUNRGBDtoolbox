% find through the SUNRGBDMeta3DBB_v2.mat file, and return
% the indexes of which sequence names were found.
% Args:
%   sequence-names - the sequence names we want to query
%
% Returns:
%   indexs - the found sequence names' indexes  in SUNRGBDMeta2DBB_v2.mat
%
% Author: Bai
function indexes = get_image_index(sequence_names) 
    global SUN_3D;
    indexes = cell(1, length(sequence_names));
    for i = 1:length(sequence_names)
        indexes{i} = find(ismember({SUN_3D.SUNRGBDMeta.sequenceName}, sequence_names{i}));
    end
end