% Read from a text file which contains image names which were 
% choose from  the SUNRGBD/images directory
%
% Args:
%    txt_path - a char array for the path to result.txt
%
% Returns:
%   name_array - a cell array for each cell contains a img name       
%
% Author: Bai
function name_array = read_img_names(txt_path)
    assert(exist(txt_path, 'dir') == 7);
    ifile = fopen(fullfile(txt_path, 'result.txt'));
    tline = fgetl(ifile);
    row_counter = numel(textscan(txt_path, '%1c%*[^\n]'));
    name_array = cell(1, row_counter);
    count = 1;
    while ischar(tline)
        name_array{count} = tline;
        count = count + 1;
        tline = fgetl(ifile);
    end
end