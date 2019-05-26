function qpf_dbappend(pathName, path)
    fid = fopen(qpf_getdbpath,'at');
    fprintf(fid,'%s,%s\n',pathName, path);
    fclose(fid);
end