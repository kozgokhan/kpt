function kpt_extract_a2l(a2l_name)

fid=fopen(a2l_name);
text_to_be_searched = '/begin MEASUREMENT';
search_len = length(text_to_be_searched);

k=1;
n=1;
while 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end
    %tline(strfind(tline,' '))='';
    if length(tline)>search_len
        searched_text_position = strfind(tline, text_to_be_searched);
        if length(tline)>search_len & searched_text_position>0
            res{k} = tline;
            quote_pos = strfind(tline,'"');
            sig_name = tline(searched_text_position+search_len+1:quote_pos(1)-2);
            sig_description = tline(quote_pos(1)+1:quote_pos(2)-1);
            
            if not(isempty(strfind(sig_name,'_InputData.'))) || not(isempty(strfind(sig_name,'_OutputData.')))
                inout{n,1} = sig_name;
                inout{n,2} = sig_description;
                n = n+1;
            end
            
            if not(isempty(strfind(sig_name,'_CalibParam.')))
                calibParam{p,1} = sig_name;
                calibParam{p,2} = sig_description;
                p = p+1;
            end
            
            k = k+1;
        end
    end   
end
fclose(fid);

xlswrite([a2l_name,'.xls'], inout);