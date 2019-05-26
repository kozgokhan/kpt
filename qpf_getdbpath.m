function dbpath = qpf_getdbpath()
    fullDbPath = mfilename('fullpath');
    whereSlash = strfind(fullDbPath,'/');
    dbpath = [fullDbPath(1:whereSlash(end)-1),'/qpdatabase.pdb'];
end