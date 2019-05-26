function qpdb = qpf_dbread
    fileID = fopen(qpf_getdbpath);
    qpdb = textscan(fileID, '%s %s', 'Delimiter', ',');
    fclose(fileID);
end