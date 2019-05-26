function qp(whereToGo)

    fileID = fopen('qpdatabase.pdb');
    qpdb = textscan(fileID, '%s %s', 'Delimiter', ',');
    fclose(fileID);
    
    itemNum = length(qpdb{1,1});
    for i=1:itemNum
        isFound = strcmp(qpdb{1,1}{i}, whereToGo);
        if isFound
           desiredPath = qpdb{1,2}{i};
           break;
        end
    end
    
    if isFound
        cd(desiredPath);
    else
        disp('there is no such path.');
    end

end