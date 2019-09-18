function found = findinws(keyword)
    allvars = evalin('base','who');
    
    n = 1;
    for i=1:numel(allvars)
       if strfind(lower(allvars{i}), lower(keyword))>0
           found(n,1) = allvars(i);
           n = n+1;
       end
    end
end