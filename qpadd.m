function qpadd(varargin)
    if length(varargin)==1
        % gui appears
        % in case this function is called by another gui
        disp('gui appears');
    elseif isempty(varargin)
        % add path via command line
        pathName = input('enter a name for the path: ','s');
        
        qpdb = qpf_dbread;
        
        if qpf_searchName(qpdb, pathName) == 0
            qpf_dbappend(pathName, pwd);
            disp('new path successfully added.')
        else
            disp(['there is already a path named as ', pathName]);
        end
    else
        % something done wrong
        disp('too many input arguments');
    end
end