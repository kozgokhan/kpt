constants = find_system(gcs, 'BlockType', 'Constant');

for i = 1:numel(constants)
    val = get_param(constants{i}, 'Value');
    tl_set(constants{i},'Output.Variable', val);
end