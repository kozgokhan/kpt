constants = find_system(gcs, 'BlockType', 'Constant');

for i = 1:numel(constants)
    underscores = [];
    val = get_param(constants{i}, 'Value');
    underscores = strfind(val, '_');
    before_suffix = val(1:underscores(end)-1);
    suffix = val(underscores(end):end);
    new_val = [before_suffix, 'ForAdap', suffix];
    set_param(constants{i}, 'Value', new_val)
end