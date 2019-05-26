function qpadd(varargin)
    if length(varargin)==1
        % gui appears
        disp('gui appears');
    elseif isempty(varargin)
        % add path via command line
        disp('add path via command line');
    else
        % something done wrong
        disp('too many input arguments');
    end
end