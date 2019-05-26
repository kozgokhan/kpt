function qpadd(varargin)
    if length(varargin)==1
        % gui appears
        % in case this function is called by another gui
        disp('gui appears');
    elseif isempty(varargin)
        % add path via command line
        pathName = input('enter a name for the path: ','s');
        disp(pathName)
    else
        % something done wrong
        disp('too many input arguments');
    end
end