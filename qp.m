function qp(whereToGo)

    qpdb = qpf_dbread();
    [isFound, ~, desiredPath] = qpf_searchName(qpdb, whereToGo);
    
    if isFound
        cd(desiredPath);
    else
        disp('there is no such path.');
    end

end