function qp(command)
    qpdb = qpf_dbread();
    if strcmp(command, 'qplist')
        fprintf('+%81s+\n',repmat('-',1,81));
        fprintf('| %3s | %-20s | %-50s |\n','#', 'name', 'path');
        fprintf('+%81s+\n',repmat('-',1,81));
        for i=1:length(qpdb{1,1})
            fprintf('| %3d | <a href="matlab: cd %s">%s</a>%s | %-50s |\n',i, qpdb{1,2}{i},qpdb{1,1}{i},fillBlank(qpdb{1,1}{i},20), qpdb{1,2}{i});
        end
        fprintf('+%81s+\n',repmat('-',1,81));
    elseif strcmp(command, 'qpstats')
        disp('stats are shown')
        length(qpdb{1,1})
    else
        [isFound, ~, desiredPath] = qpf_searchName(qpdb, command);

        if isFound
            cd(desiredPath);
        else
            disp('there is no such path.');
        end
    end
end

function fb = fillBlank(text, textSpace)
    fb = blanks(textSpace - length(text));
end