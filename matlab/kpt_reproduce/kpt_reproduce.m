function script_ReorderSubsysSupported()
    lh = find_system(gcs,'findall','on','regexp','on','CaseSensitive','off','searchdepth',1,'Blocktype','SubSystem','name','Gear\w*');
    Default = find_system(gcs,'findall','on','regexp','on','CaseSensitive','off','searchdepth',1,'Blocktype','SubSystem','name','default');
        position = zeros(length(lh),4);
    Coast=~isempty(strfind(gcs,'PowerOff'));
    % ToDelete = {'4to2','5to1','5to2','6to1','6to3','6to4','7to2','7to3'};

    for i=1:length(lh)
        position(i,:)=get(lh(i),'position');
        names{i} = get(lh(i),'name');
        SubsLines = get(lh(i),'Linehandles');
        delete_line(SubsLines.Inport(SubsLines.Inport~=-1));
        delete_line(SubsLines.Outport(SubsLines.Outport~=-1));
    end

    [positionsSorted,idx] = sortrows(position,2);
    if size(lh,1) > 1
    yDiff= round((positionsSorted(end,2)- positionsSorted(1,2))/(length(idx)-1));
    else
        yDiff=70;
    end
    if Coast==1 % coast
       strGearNew={'12', '21', '23', '31', '32', '34', '41', '43', '45', '53', '54', '56', '62', '65', '67', '71', '74', '75', '76', '78', '86', '87', '89', '94', '95', '97', '98'};
       vecNameRep = {0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0, 1, 1, 0, 0};
       % 'Gear1to2',	'Gear2to1',	'Gear2to3',	'Gear3to1',	'Gear3to2',	'Gear3to4',	'Gear4to1',	'Gear4to3',	'Gear4to5',	'Gear5to3',	'Gear5to4',	'Gear5to6',	'Gear6to2',	'Gear6to5',	'Gear6to7',	'Gear7to1',	'Gear7to4',	'Gear7to5',	'Gear7to6',	'Gear7to8',	'Gear8to6',	'Gear8to7',	'Gear8to9',	'Gear9to4',	'Gear9to5',	'Gear9to7',	'Gear9to8';
    else % power
         strGearNew = {'12', '21', '23', '31', '32', '34', '41', '42', '43', '45', '51', '52', '53', '54', '56', '61', '62', '63', '64', '65', '67', '71', '72', '73', '74', '75', '76', '78', '81', '82', '84', '85', '86', '87', '89', '93', '94', '95', '96', '97', '98'};
         vecNameRep = {0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 0};
         ceSuported = {'42', '51', '52', '61', '63', '64', '72', '73', '81', '82', '84', '85', '93', '96'};
         
         strGearNew = strGearNew;
         AcvNameRep = AcvNameRep;
    end
    
    strSubsRep = 'Gear1to2';
    strGearRep = '12';
    strSubsRep_rev = 'Gear2to1';
    strGearRep_rev = '21';
    revRepAcv = 1;
    nameRepAcv = 1;
    strNameRep = 'TH_NTgtForExitSpdPha1';
    strNameRep_new = 'TH_NTgtForExitCnclSpdPha1';
    
    for i = 1:length(strGearNew)
        try
        strGearSub = sprintf('Gear%sto%s',strGearNew{i}(1),strGearNew{i}(2));
        strGearSub_rev = sprintf('Gear%sto%s',strGearNew{i}(2),strGearNew{i}(1));
        strGear  = strGearNew{i};
        strGear_rev  = [strGearNew{i}(2), strGearNew{i}(1)];
        h = add_block([gcs '/' strSubsRep],[gcs '/' strGearSub ]);  % create copy with new name
        set(h, 'LinkStatus', 'none');
        Blocks=find_system(h,'findall','on','Type','block');
        TlBlocks = tl_get_blocks(h,'TargetLink');
        for k=1:numel(Blocks)  % update Simulink setting 
            BlockType = get_param(Blocks(k),'BlockType');
            if strcmp(BlockType,'SubSystem')||strcmp(BlockType,'Inport')||...
                    strcmp(BlockType,'Outport')
                NameNew_ini = get_param(Blocks(k),'Name');
                if revRepAcv
                    NameNew = strrep(NameNew_ini, strGearRep_rev, strGear_rev);
                end
                isrev = strcmp(NameNew_ini, NameNew)<1;
                if ~(i==2 && isrev)
                    NameNew = strrep(NameNew, strGearRep, strGear);
                end
                if nameRepAcv && vecNameRep{i} && isrev
                    NameNew = strrep(NameNew, strNameRep, strNameRep_new);
                    NameNew = strrep(NameNew, strGear_rev, strGear);
                end
                set_param(Blocks(k), 'Name', NameNew);
            elseif strcmp(BlockType,'Goto')||strcmp(BlockType,'From')
                TagNew_ini = get_param(Blocks(k),'GotoTag');
                if revRepAcv
                    TagNew = strrep(TagNew_ini, strGearRep_rev, strGear_rev);
                end
                isrev = strcmp(TagNew_ini, TagNew)<1;
                if ~(i==2 && isrev)
                    TagNew = strrep(TagNew,strGearRep,strGear);
                end
                if nameRepAcv && vecNameRep{i} && isrev
                    TagNew = strrep(TagNew,strNameRep,strNameRep_new);
                    TagNew = strrep(TagNew, strGear_rev, strGear);
                end
                set_param(Blocks(k),'GotoTag',TagNew);
            elseif strcmp(BlockType,'Constant')
                ValueNew_ini = get_param(Blocks(k),'Value');
                if revRepAcv
                    ValueNew = strrep(ValueNew_ini,strGearRep_rev,strGear_rev);
                end
                isrev = strcmp(ValueNew_ini, ValueNew)<1
                if ~(i==2 && isrev)
                    ValueNew = strrep(ValueNew, strGearRep, strGear);
                end
                if nameRepAcv && vecNameRep{i} && isrev
                    ValueNew = strrep(ValueNew, strNameRep, strNameRep_new);
                    ValueNew = strrep(ValueNew, strGear_rev, strGear);
                end
                set_param(Blocks(k),'Value',ValueNew);
            elseif strcmp(BlockType,'Lookup')||strcmp(BlockType,'Lookup2D')||...
                    strcmp(BlockType,'Lookup_n-D')||strcmp(BlockType,'LookupNDDirect')...
                    ||strcmp(BlockType,'Interpolation_n-D')
                TableNew_ini = get_param(Blocks(k),'Table');
                if revRepAcv
                    TableNew = strrep(TableNew_ini, strGearRep_rev, strGear_rev);
                end
                isrev = strcmp(TableNew_ini, TableNew)<1;
                if ~(i==2 && isrev)
                    TableNew = strrep(TableNew,strGearRep,strGear);
                end
                if nameRepAcv && vecNameRep{i} && isrev
                    TableNew = strrep(TableNew, strNameRep, strNameRep_new);
                    TableNew = strrep(TableNew, strGear_rev, strGear);
                end
                set_param(Blocks(k),'Table',TableNew);
                Dim = str2num(get_param(Blocks(k),'NumberOfTableDimensions'));
                for j=1:Dim
                    AxisNew_ini = get_param(Blocks(k),sprintf('BreakpointsForDimension%d',j));
                    if revRepAcv
                        AxisNew = strrep(AxisNew_ini,strGearRep_rev,strGear_rev);
                    end
                    isrev = (strcmp(AxisNew_ini, AxisNew)<1);
                    if ~(i==2 && isrev)
                        AxisNew = strrep(AxisNew,strGearRep,strGear);
                    end
                    if nameRepAcv && vecNameRep{i} && isrev
                        AxisNew = strrep(AxisNew, strNameRep, strNameRep_new);
                        AxisNew = strrep(AxisNew, strGear_rev, strGear);
                    end
                    set_param(Blocks(k),sprintf('BreakpointsForDimension%d',j),AxisNew);
                end
            end
        end
        for k = 1:numel(TlBlocks)  % update TL settings
            BlockType = get_param(TlBlocks(k),'BlockType');
            Variable = tl_get(TlBlocks(k),'Output.variable');
            if strcmp(BlockType,'Lookup')||strcmp(BlockType,'Lookup2D')...
                     ||strcmp(BlockType,'Lookup_n-D')
                TableVarNew_ini = tl_get(TlBlocks(k),'table.variable');
                if revRepAcv
                    TableVarNew = strrep(TableVarNew_ini, strGearRep_rev, strGear_rev);
                end
                isrev = (strcmp(TableVarNew_ini, TableVarNew)<1);
                if ~(i==2 && isrev)
                    TableVarNew = strrep(TableVarNew,strGearRep,strGear);
                end
                if nameRepAcv && vecNameRep{i} && isrev
                    TableVarNew = strrep(TableVarNew,strNameRep,strNameRep_new);
                    TableVarNew = strrep(TableVarNew, strGear_rev, strGear);
                end
                tl_set(TlBlocks(k),'table.variable',TableVarNew);
                Dim = str2num(get_param(TlBlocks(k),'NumberOfTableDimensions'));
                if Dim==1
                    AxisVarNew_ini = tl_get(TlBlocks(k),'input.variable');
                    if revRepAcv
                        AxisVarNew = strrep(AxisVarNew_ini,strGearRep_rev,strGearNew_rev);
                    end
                    isrev = (strcmp(AxisVarNew_ini, AxisVarNew)<1);
                    if ~(i==2 && isrev)
                        AxisVarNew = strrep(AxisVarNew,strGearRep,strGearNew);
                    end
                    if nameRepAcv && vecNameRep{i} && isrev
                        AxisVarNew = strrep(AxisVarNew,strNameRep,strNameRep_new);
                        AxisVarNew = strrep(AxisVarNew, strGear_rev, strGear);
                    end
                    tl_set(TlBlocks(k),'input.variable',AxisVarNew);
                elseif Dim==2
                    Axis1VarNew_ini = tl_get(TlBlocks(k),'row.variable');
                    if revRepAcv
                        Axis1VarNew = strrep(Axis1VarNew_ini,strGearRep_rev,strGear_rev);
                    end
                    isrev = (strcmp(Axis1VarNew_ini, Axis1VarNew)<1);
                    if ~(i==2 && isrev)
                        Axis1VarNew = strrep(Axis1VarNew,strGearRep,strGear);
                    end
                    if nameRepAcv && vecNameRep{i} && isrev
                        Axis1VarNew = strrep(Axis1VarNew,strNameRep,strNameRep_new);
                        Axis1VarNew = strrep(Axis1VarNew, strGear_rev, strGear);
                    end
                    tl_set(TlBlocks(k),'row.variable',Axis1VarNew);

                    Axis2VarNew_ini = tl_get(TlBlocks(k),'col.variable');
                    if revRepAcv
                        Axis2VarNew = strrep(Axis2VarNew_ini,strGearRep_rev,strGear_rev);
                    end
                    isrev = (strcmp(Axis2VarNew_ini, Axis2VarNew)<1);
                    if ~(i==2 && isrev)
                        Axis2VarNew = strrep(Axis2VarNew,strGearRep,strGear);
                    end
                    if nameRepAcv && vecNameRep{i} && isrev
                        Axis2VarNew = strrep(Axis2VarNew,strNameRep,strNameRep_new);
                        Axis2VarNew = strrep(Axis2VarNew, strGear_rev, strGear);
                    end
                    tl_set(TlBlocks(k),'col.variable',Axis2VarNew);
                end
            elseif ~strcmp(Variable,'')
                disp('----------------------------------------------------------')
                disp(Variable)
                disp('----------------------------------------------------------')
                if revRepAcv
                    VarNew = strrep(Variable, strGearRep_rev, strGear_rev)
                end
                isrev = (strcmp(Variable, VarNew)<1)
                if ~(i==2 && isrev)
                        VarNew = strrep(VarNew, strGearRep, strGear)
                end
                if nameRepAcv && vecNameRep{i} && isrev
                	VarNew = strrep(VarNew, strNameRep, strNameRep_new)
                	VarNew = strrep(VarNew, strGear_rev, strGear)
                end
                tl_set(TlBlocks(k),'Output.variable',VarNew);
            end
        end
        catch ME
            ME.message    
        end
    end

    
    % 
    lhNew = find_system(gcs,'findall','on','regexp','on','searchdepth',1,'Blocktype','SubSystem','name','Gear\w*');
    names = get(lhNew,'name');
    [names,idxNames] = sort(names);
    positionNew = positionsSorted(1,:);
    for i = 1:length(idxNames)
        set(lhNew(idxNames(i)),'position',positionNew);
        positionNew = positionNew+[0 yDiff 0 yDiff];
    end
    set(Default,'position',positionNew);


    hSwitchCase = find_system(gcs,'findall','on','Blocktype','SwitchCase');
    if Coast == 1
        strCaseCond = '{'
        for i = 1:length(strGearNew)
            strAdd = sprintf('%s0%s ',strGearNew{i}(1),strGearNew{i}(2));
            strCaseCond = horzcat(strCaseCond, strAdd );
        end
         strCaseCond = horzcat(strCaseCond, '}' );
        MergeSize=1928;
    else
        strCaseCond = '{'
        for i = 1:length(strGearNew)
            strAdd = sprintf('%s0%s ',strGearNew{i}(1),strGearNew{i}(2));
            strCaseCond = horzcat(strCaseCond, strAdd );
        end
         strCaseCond = horzcat(strCaseCond, '}' );
        %SwitchSize=yDiff*15;
        MergeSize=length(strCaseCond)-20;
    end
    set(hSwitchCase,'CaseConditions',strCaseCond);
    PortsSwithCase = get(hSwitchCase,'PortHandles');
    NrOutPortsSwithCase = length(PortsSwithCase .Outport);
    SwitchHeight = NrOutPortsSwithCase * 70;

    SwitchCaseLineHandles = get(hSwitchCase,'LineHandles');
    delete_line(SwitchCaseLineHandles.Outport(SwitchCaseLineHandles.Outport~=-1));
    SwitchCasePosition=get(hSwitchCase,'position');
    SwitchCasePositionX1=SwitchCasePosition(1);
    SwitchCasePositionY1=positionsSorted(1,2)-47;
    SwitchCasePositionX2=SwitchCasePosition(3);
    SwitchCasePositionY2=SwitchCasePositionY1+SwitchHeight;
    posSwitch = [SwitchCasePositionX1 SwitchCasePositionY1 SwitchCasePositionX2 SwitchCasePositionY2];
    set(hSwitchCase,'position',posSwitch);
    SwitchCasePortHandles = get(hSwitchCase,'PortHandles');

    % Merge´
    lhNew = find_system(gcs,'findall','on','regexp','on','searchdepth',1,'Blocktype','SubSystem','name','Gear\w*');


    hMerge = find_system(gcs,'findall','on','Blocktype','Merge');
    set(hMerge,'Inputs',num2str(length(lhNew)+1));
    MergeLineHandles = get(hMerge,'LineHandles');
    delete_line(MergeLineHandles.Inport(MergeLineHandles.Inport~=-1));
    MergePortHandles = get(hMerge,'PortHandles');
    MergePosition=get(hMerge,'position');
    MergePositionX1=MergePosition(1);
    MergePositionY1=MergePosition(2);
    MergePositionX2=MergePosition(3);
    MergeSize = SwitchHeight;
    MergePositionY2=MergePositionY1+ MergeSize;
    set(hMerge,'position',[MergePositionX1 MergePositionY1 MergePositionX2 MergePositionY2]);

    for i=1:length(lhNew)
        ports = get(lhNew(i),'porthandles');
        ifPorts(i,1) = ports.Ifaction;
        SubsOutports(i,1) = ports.Outport;
        add_line(gcs,SwitchCasePortHandles.Outport(i),ifPorts(i),'autorouting','on');
        add_line(gcs,SubsOutports(i),MergePortHandles.Inport(i),'autorouting','on');
    end
    DefaultPortHandles = get(Default,'PortHandles');
    add_line(gcs,SwitchCasePortHandles.Outport(end),DefaultPortHandles.Ifaction,'autorouting','on');
    add_line(gcs,DefaultPortHandles.Outport,MergePortHandles.Inport(end),'autorouting','on');


    %% connect goTo's
    ports = find_system(gcs,'searchdepth','1','findall','on','type','Port')
    for i = 1 : length( ports)
        prtType = get(ports(i),'PortType')
        l = get(ports(i),'line')
        if l == -1  && strcmp(prtType,'outport') % not connected outport
            pos = get(ports(i),'Position')
            posRight = pos + [40 0];
            add_line(gcs,[pos; posRight])
        end 
    end
end  % of function