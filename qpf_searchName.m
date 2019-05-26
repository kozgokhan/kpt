function [isFound,i,desiredPath] = qpf_searchName(qpdb, name)
    itemNum = length(qpdb{1,1}); 
    isFound = 0; desiredPath = '';
    for i=1:itemNum
        isFound = strcmp(qpdb{1,1}{i}, name);
        if isFound
           desiredPath = qpdb{1,2}{i};
           break;
        end
    end
end