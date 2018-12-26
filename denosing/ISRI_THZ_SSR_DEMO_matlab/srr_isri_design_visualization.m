

 %
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function srr_isri_design_visualization(user_port, data_port, loadCfg, max_dist_y, max_dist_x, max_vel,record, filename_rec)
global maxX;
global maxX;
if nargin == 8
    user_port = if_string_convert_to_num(user_port);
    data_port = if_string_convert_to_num(data_port);
    loadCfg   = if_string_convert_to_num(loadCfg);
    dimensions.max_dist_y = if_string_convert_to_num(max_dist_y); 
    dimensions.max_dist_x = if_string_convert_to_num(max_dist_x); 
    dimensions.max_vel = if_string_convert_to_num(max_vel); 
    record_options.record = if_string_convert_to_num(record);
    record_options.replay = if_string_convert_to_num(replay);
    
    if record_options.record == 1
        record_options.filename_rec = (filename_rec); 
        record_options.replay = 0;
    elseif record_options.record == 2
        record_options.record = 0;
        record_options.replay = 1;
        record_options.filename_rep = (filename_rep); 
    else
        record_options.record = 0;
        record_options.replay = 1;
    end
    
    %grid_mapping_options.perfom_grid_mapping = 0; 

else
    if nargin >= 3
        user_port = if_string_convert_to_num(user_port);
        data_port = if_string_convert_to_num(data_port);
        loadCfg   = if_string_convert_to_num(loadCfg);

    else
        user_port = 6; 
        data_port = 5;
        loadCfg   = 1;
    end
    [user_port, data_port, loadCfg, dimensions, record_options, grid_mapping_options] = choose_ports_dialog(user_port, data_port, loadCfg);
end
    
if loadCfg
     try
        result = load_config(user_port);
     catch 
        result = -1;
     end
else
    result = 1;
end
grid_mapping_options.read_lvds_file_instead_of_serial_port  = 0;
grid_mapping_options.perfom_grid_mapping_using_serial_obd = 1;
%检查端口是否有问题
if result ~= 1
    if result == -1
       errordlg([{['端口错误:COM ' num2str(user_port) '. 请确认'], '是否为DATA口',  ' '}]);
    elseif result == -2%稍微找了一下，哪里变成-2??
       errordlg('Incorrect demo. Make sure you have flashed the SRR TI Design demo on the AWR16XX Device.', 'Invalid Command');
    end
    return;
end

%检查记录文件是否有问题
if record_options.replay == 0
    if grid_mapping_options.perfom_grid_mapping 
        error('invalid option.');
        %read_serial_port_and_plot_object_location_with_serial_obd(data_port, dimensions, record_options, grid_mapping_options);
    elseif grid_mapping_options.read_lvds_file_instead_of_serial_port 
        %read_lvds_out_file_and_plot_object_location('D:\Radar_capture_card\GUI_FILES\DCA1001EVM_GUI_20NOV2017_V2\DCA1001EVM_GUI\RawAlpha3_4_Raw_0.bin', dimensions, record_options);
    else
        read_serial_port_and_plot_object_location(data_port, dimensions, record_options);
    end
else
    if grid_mapping_options.perfom_grid_mapping == 1
        if grid_mapping_options.perfom_grid_mapping_with_serial_obd == 1
            read_serial_port_and_plot_object_location_with_serial_obd(dimensions, record_options, grid_mapping_options);
        else
            %read_file_and_plot_object_location_with_persistance(dimensions, record_options, grid_mapping_options);
        end
    else
        grid_mapping_options.plot_movie  =  0;
        if grid_mapping_options.plot_movie == 0
            read_file_and_plot_object_location(dimensions, record_options);
        else
            %movie_options.fname = '' ; % D:\RADAR\SRR_TI_Design\movies\IMG_0224.MOV';
            %movie_options.play_movie = 0; 
            
            %movie_options.offset_sec = -0.5;
            %movie_options.frame_rate = 29.97;
            %movie_options.record_movie = 0;
            %movie_options.record_movie_fname = 'D:\RADAR\SRR_TI_Design\movies\DallasTestDrive.avi';
            
            %read_file_and_plot_object_location_and_show_movie(dimensions, record_options, movie_options);
        end
    end
end

end


function out = if_string_convert_to_num(in)

if ischar(in)
    out = str2num(in);
else
    out = in;
end

end

function [user_port, data_port, load_cfg, dimensions, record_options, grid_mapping_options] = choose_ports_dialog(user_port, data_port, load_cfg)

    dimensions.max_dist_y = 8; % meters 纵向宽度
    dimensions.max_dist_x = 5; % meters 横向宽度
    dimensions.max_vel = 10; % meters/sec  最大速度
    
    record_options.replay = 0; 
    record_options.filename_rec = '';
    record_options.filename_rep = '';
    record_options.record = 0; 
    
    grid_mapping_options.perfom_grid_mapping = 0; 
    grid_mapping_options.file = ''; 
    grid_mapping_options.offset = 0; 
    grid_mapping_options.orientation = 0; 
    grid_mapping_options.perfom_grid_mapping_using_serial_obd = 0;
    grid_mapping_options.read_lvds_file_instead_of_serial_port = 1;
    
    

    
    ba = 0.1;
    of = 0.02;
    dx = (1-ba - of*5)/4;
    %clear
    %d = dialog('Units', 'normalized','Position',[0.2 0.2 0.28 0.70],'Name','SRR TI Design Config.');
    d = dialog('Units', 'normalized','Position',[0.2 0.2 0.28 0.70],'Name','ISRI 雷达配置');
    warning off MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame
    jframe=get(d,'javaframe');
    jIcon=javax.swing.ImageIcon('ISRI.gif');
    jframe.setFigureIcon(jIcon);

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %h_merge = uipanel('Parent',d,'Title','Grid Mapping options.','FontSize',12, 'Units', 'normalized', 'Position',[.05 (ba + of) .9 dx]);
    %txt_grid_mapping = uicontrol('Parent',h_merge,'Units', 'normalized','Style','text','Position',[0.1 0.7 0.5 0.15],'String',   'Perform Grid Mapping.                       ');
    %txt_filename_rec = uicontrol('Parent',h_merge,'Units', 'normalized','Style','text','Position',[0.1 0.5 0.5 0.15],'String',   'OBD sensor data source file.              ');
    %txt_offset       = uicontrol('Parent',h_merge,'Units', 'normalized','Style','text','Position',[0.1 0.3 0.5 0.15],'String',   'Offset w.r.t sensor (sec).                    ');
    %txt_orientation  = uicontrol('Parent',h_merge,'Units', 'normalized','Style','text','Position',[0.1 0.1 0.5 0.15],'String',   'Radar orientation (deg) w.r.t to car.     ');
    
    %in_grid_mapping = uicontrol('Parent',h_merge,'Units', 'normalized','Style','checkbox','Position', [0.6 0.7 0.3 0.15],'Value',grid_mapping_options.perfom_grid_mapping,'Callback',@populate_grid_mapping);
    %in_grid_mapping_browse = uicontrol('Parent',h_merge,'Units', 'normalized','Position', [0.65 0.7 0.25 0.15],'String','浏览','Callback',@populate_grid_mapping_filename_picker);
    %in_grid_mapping_file_rec  = uicontrol('Parent',h_merge,'Units', 'normalized','Style','edit','Position',     [0.6 0.5 0.3 0.15],'String',(grid_mapping_options.file),'Callback',@populate_grid_mapping_filename_rec);
    %in_offset        = uicontrol('Parent',h_merge,'Units', 'normalized','Style','edit','Position', [0.6 0.3 0.3 0.15],'String',num2str(grid_mapping_options.offset),'Callback',@populate_grid_mapping_offset);
   %in_orientation   = uicontrol('Parent',h_merge,'Units', 'normalized','Style','edit','Position',     [0.6 0.1 0.3 0.15],'String',num2str(grid_mapping_options.orientation),'Callback',@populate_grid_mapping_orientation);
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %position 参数是一个四元素向量，用于指定组件的位置和大小：[距离左侧的像素数, 距离底部的像素数, 宽度所占像素数, 高度所占像素数]
    h_record_or_replay = uipanel('Parent',d,'Title','记录与回放','FontSize',12,...
        'Units', 'normalized', 'Position',[.05 (ba + dx + 2*of) .9 dx]);
    txt_record       = uicontrol('Parent',h_record_or_replay,'Units', 'normalized','Style','text','Position',[0.1 0.7 0.5 0.15],'String',   '记录当前任务   ');
    txt_filename_rec = uicontrol('Parent',h_record_or_replay,'Units', 'normalized','Style','text','Position',[0.1 0.5 0.5 0.15],'String',   '记录文件名     ');
    txt_replay       = uicontrol('Parent',h_record_or_replay,'Units', 'normalized','Style','text','Position',[0.1 0.3 0.5 0.15],'String',   '回放历史任务   ');
    txt_filename_rep = uicontrol('Parent',h_record_or_replay,'Units', 'normalized','Style','text','Position',[0.1 0.1 0.5 0.15],'String',   '回放文件名     ');
    
    in_record        = uicontrol('Parent',h_record_or_replay,'Units', 'normalized','Style','checkbox','Position', [0.6 0.7 0.3 0.15],'Value',record_options.replay,'Callback',@populate_record);
    in_filename_rec_browse = uicontrol('Parent',h_record_or_replay,'Units', 'normalized','Position', [0.65 0.7 0.25 0.15],'String','浏览','Callback',@populate_record_filename_picker);
    in_filename_rec  = uicontrol('Parent',h_record_or_replay,'Units', 'normalized','Style','edit','Position',     [0.6 0.5 0.3 0.15],'String',(record_options.filename_rec),'Callback',@populate_filename_rec);
    in_replay        = uicontrol('Parent',h_record_or_replay,'Units', 'normalized','Style','checkbox','Position', [0.6 0.3 0.3 0.15],'Value',record_options.record,'Callback',@populate_replay);
    in_filename_rep_browse = uicontrol('Parent',h_record_or_replay,'Units', 'normalized','Position', [0.65 0.3 0.25 0.15],'String','浏览','Callback',@populate_replay_filename_picker);
    in_filename_rep  = uicontrol('Parent',h_record_or_replay,'Units', 'normalized','Style','edit','Position',     [0.6 0.1 0.3 0.15],'String',(record_options.filename_rep),'Callback',@populate_filename_rep);
    
    
    h_gui_options   = uipanel('Parent',d,'Title',' 测试参数范围.','FontSize',12, 'Units', 'normalized', 'Position',[.05 (ba +2*dx + 3*of) .9 dx]);          
    
    txt_max_vel     = uicontrol('Parent',h_gui_options,'Units', 'normalized','Style','text','Position',[0.1 0.7 0.5 0.15], 'String',  '最大速度 (m/s)        ');
    txt_max_range_x = uicontrol('Parent',h_gui_options,'Units', 'normalized','Style','text','Position',[0.1 0.5 0.5 0.15],'String',  '最大横向宽度 (m)         ');
    txt_max_range_y = uicontrol('Parent',h_gui_options,'Units', 'normalized','Style','text','Position',[0.1 0.3 0.5 0.15],'String',  '最大纵向深度 (m)         ');
    
    in_max_vel      = uicontrol('Parent',h_gui_options,'Units', 'normalized','Style','edit','Position',[0.6 0.7 0.3 0.15],'String',num2str(dimensions.max_vel),'Callback',@populate_max_vel);
    in_max_range_x  = uicontrol('Parent',h_gui_options,'Units', 'normalized','Style','edit','Position',[0.6 0.5 0.3 0.15],'String',num2str(dimensions.max_dist_x),'Callback',@populate_max_range_x);
    in_max_range_y  = uicontrol('Parent',h_gui_options,'Units', 'normalized','Style','edit','Position',[0.6 0.3 0.3 0.15],'String',num2str(dimensions.max_dist_y),'Callback',@populate_max_range_y);
    
    
    h_port_options  = uipanel('Parent',d,'Title',' 串口配置','FontSize',12,'Units', 'normalized','Position',[.05 (ba +3*dx + 4*of) .9 dx]);          
    txt_user        = uicontrol('Parent',h_port_options,'Units', 'normalized','Style','text','Position',[0.1 0.7 0.5 0.15],'String', '下载');%XDS110 Class Application/User UART
    txt_data        = uicontrol('Parent',h_port_options,'Units', 'normalized','Style','text','Position',[0.1 0.5 0.5 0.15],'String',  '数据 ');
    txt_reload      = uicontrol('Parent',h_port_options,'Units', 'normalized','Style','text','Position',[0.1 0.3 0.5 0.15],'String',        '重载配置');
    
    in_user         = uicontrol('Parent',h_port_options,'Units', 'normalized','Style','edit','Position',[0.6 0.7 0.3 0.15],'String',num2str(user_port),'Callback',@populate_user_port);
    in_port         = uicontrol('Parent',h_port_options,'Units', 'normalized','Style','edit','Position',[0.6 0.5 0.3 0.15],'String',num2str(data_port),'Callback',@populate_data_port);
    in_reload       = uicontrol('Parent',h_port_options,'Units', 'normalized','Style','checkbox','Position',[0.6 0.3 0.3 0.15],'Value',load_cfg,'Callback',@populate_reload);
       
    btn = uicontrol('Parent',d,'Units', 'normalized','Position',[.05 (0.05+1*of) .9 dx],'String','确认','Callback','delete(gcf)');%[0.425 0.02 0.15 0.07]
    %uicontrol：position 参数是一个四元素向量，用于指定组件的位置和大小：[距离左侧的像素数, 距离底部的像素数, 宽度所占像素数, 高度所占像素数]   
    % Wait for d to close before running to completion  [.05 (ba +2*dx + 3*of) .9 dx]
    uiwait(d);
   
    function populate_user_port(popup,event)
      try 
          user_port = str2num(popup.String); 
      catch
          popup.Value = user_port; 
      end
    end

    function populate_data_port(popup,event)
      try 
          data_port = str2num(popup.String); 
      catch
          popup.Value = data_port; 
      end
    end


    function populate_max_vel(popup,event)
      try 
          dimensions.max_vel = str2num(popup.String); 
      catch
          popup.Value = dimensions.max_vel; 
      end
    end

    function populate_max_range_x(popup,event)
      try 
          dimensions.max_dist_x = str2num(popup.String); 
      catch
          popup.Value = dimensions.max_dist_x; 
      end
    end
    function populate_max_range_y(popup,event)
      try 
          dimensions.max_dist_y = str2num(popup.String); 
      catch
          popup.Value = dimensions.max_dist_y; 
      end
    end

    function populate_reload(popup,event)
      load_cfg = (popup.Value); 
    end

  
    function populate_replay(popup, event)
        if ~(record_options.record == 1 ||  load_cfg == 1) 
            record_options.replay  =  popup.Value; 
        else
            popup.Value = 0; 
        end
    end


    function populate_record(popup, event)
        if record_options.replay  == 0; 
            record_options.record =  popup.Value; 
        else
            popup.Value = 0; 
        end
    end

   function populate_filename_rec(popup,event)
        temp  = (popup.String); 
        if isValidFile(temp)
            record_options.filename_rec = temp;
        else
            popup.String = 'Invalid file';
        end
   end

    function populate_record_filename_picker(popup,event)

        [FileName,PathName] = uiputfile('*.*','选择要记录的文件.');
        if FileName == 0
            return;
        end

        temp = [PathName '\' FileName ];
        record_options.filename_rec = temp;
        in_filename_rec.String = temp;
    end

   function populate_filename_rep(popup,event)
        temp  = (popup.String); 
        if isValidFile(temp) && exist(temp, 'file')
            record_options.filename_rep = temp;
        else
             popup.String = 'NonExistant File';
        end
   end

    function populate_replay_filename_picker(popup,event)
        
        [FileName,PathName] = uigetfile('*.*','选择要回放的文件.');
        if FileName == 0
            return;
        end
        
        temp = [PathName '\' FileName ];
        record_options.filename_rep = temp;
        in_filename_rep.String = temp;
    end

    function populate_grid_mapping(popup, evt)
        grid_mapping_options.perfom_grid_mapping =  popup.Value; 
    end
   
    function populate_grid_mapping_filename_rec(popup,event) %#ok<*INUSD>
        temp  = (popup.String); 
        if isValidFile(temp) && exist(temp, 'file')
            grid_mapping_options.file = temp;
        else
             popup.String = '文件不存在';
        end
    end

    function populate_grid_mapping_filename_picker(popup,event)
        
        [FileName,PathName] = uigetfile('*.*','选择 OBD 文件');
        if FileName == 0
            return;
        end
        
        temp = [PathName '\' FileName ];
        grid_mapping_options.file = temp;
        in_grid_mapping_file_rec.String = temp;
    end

    function populate_grid_mapping_offset(popup,event)
      try 
          grid_mapping_options.offset = str2double(popup.String); 
      catch
          popup.Value = grid_mapping_options.offset; 
      end
    end

    function populate_grid_mapping_orientation(popup,event)
      try 
          grid_mapping_options.orientation = str2double(popup.String); 
      catch
          popup.Value = grid_mapping_options.orientation; 
      end
    end
end


function result = isValidFile(filename)

    result = 0; 
    if ~isempty(filename)
    if ~isempty(regexp(filename, '[/\*:?"<>|]', 'once'))
        result = 1;
    else
        
    end
    end
end
