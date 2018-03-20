% Transform image names to  sequences 
%
% Args:
%    names - a cell array for the names in result.txt
%
% Returns:
%   sequence_names - a cell array transformed sequence names for the input
%
% Author: Bai
function sequence_names = transform_name_to_sequence(names)
    for i = 1:length(names)
        name_splits = strsplit(names{i}, '_');
        switch name_splits{1}
            %case strcmp(names{1}, 'kinect2data') || strcmp(names{1}, 'align')
            case {'kinect2data', 'align'}
                sequence_names = transform_name_to_kv2_sequence(names);
            %imply other conditions





        end
    end
end

% Transform image names to  sequences 
%
% Args:
%    names - a cell array for the names  to  kv2 sequence 
%
% Returns:
%   kv2_sequence_names - transformed sequence names for the input
%
% Author: Bai

function kv2_sequence_names = transform_name_to_kv2_sequence(names)
    prefix = 'SUNRGBD';
    kv2_path = fullfile(prefix, 'kv2');
    kv2_sequence_names = cell(1, length(names));
    for i = 1:length(names)
        img_name_array = strsplit(names{i}, '_');
        if (strcmp(img_name_array{1}, 'align'))
            kv2_align_path = fullfile(kv2_path, 'align_kv2');
            middel_part = strrep(names{i}, 'align_kv2_', '');
            middel_part = strrep(middel_part, ['_', img_name_array{end}], '');
            kv2_sequence_names{i} = fullfile(kv2_align_path, middel_part);
        else
            kv2_kinect2data_path = fullfile(kv2_path, 'kinect2data');
            middel_part = strrep(names{i}, 'kinect2data_', '');
            middel_part = strrep(middel_part, ['_', img_name_array{end}], '');
            kv2_sequence_names{i} = fullfile(kv2_kinect2data_path, middel_part);
        end
    end
endtransform_name_to_kv2_sequence