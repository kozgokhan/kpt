function quickpath()

    bg_color = [0.9 0.9 0.9]; mainWindowWidth = 500; mainWindowHeight = 350; winMargin = 50;
    f_qp = figure('Visible','off','Position',[500,300,mainWindowWidth,mainWindowHeight],'MenuBar','None','Name', 'QuickPath 1.0','NumberTitle','off', 'color', bg_color);
    
    funAreaWidth = 75; editAreaHeight = 80; itemMargin = 15; buttonHeight = 20;
    
    listHeigh = 180; listWidth = mainWindowWidth - 2*winMargin-funAreaWidth;
    qpdb = qpf_dbread();
    listItems = qpdb{1,1}
    list = uicontrol('Style','listbox', 'Position',[winMargin,mainWindowHeight-winMargin-listHeigh, listWidth, listHeigh], 'String',listItems, 'FontSize',12);
    
    uicontrol('Style','pushbutton', 'String','Add', 'Position',[winMargin+itemMargin+listWidth,mainWindowHeight-winMargin-buttonHeight, funAreaWidth, 20]);
    uicontrol('Style','pushbutton', 'String','Remove', 'Position',[winMargin+itemMargin+listWidth,mainWindowHeight-winMargin-2*buttonHeight-0.5*buttonHeight, funAreaWidth, 20]);
    
    nameLabel = uicontrol('Style','text', 'Position',[winMargin, winMargin + 30, 50, 20], 'String','Name:', 'BackgroundColor',bg_color);
    pathLabel = uicontrol('Style','text', 'Position',[winMargin, winMargin, 50, 20], 'String','Path:', 'BackgroundColor',bg_color);
    
    copyrightText = uicontrol('Style','text','String','Copyright (c) 2019 - Kaan Ozgokhan','Enable','off','Position',[0,5,mainWindowWidth,20],'BackgroundColor',bg_color);
    set(f_qp,'Visible','on');
end