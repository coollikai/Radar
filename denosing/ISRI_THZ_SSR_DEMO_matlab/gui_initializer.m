

function guiMonitor = gui_initializer(Params, dim, show_params)
    global MAX_NUM_CLUSTERS
    global  load_parking_assist load_point_cloud_srr load_point_cloud_usrr load_clusters load_trackers view_range use_perspective_projection; 

    if nargin < 3
        show_params = 1; 
    end
    
    mversion = version('-release'); 
    mversion = str2num(mversion(1:4)); 
    if mversion > 2015 %这里是说高于2015的matlab版本可以把显示项的框框拿出来，里面有一些功能可以使用
        show_legend = 0; 
    else
        show_legend = 1;
    end
    
    %% Setup the main figure
    guiMonitor.detectedObjects = 1; 
    guiMonitor.stats = 0;
    figHnd = figure(1);
    clf(figHnd);
    %font_set = FontProperties(fname=r"c:\windows\fonts\simsunb.ttf", size=12)
    %set(figHnd,'Name','Texas Instruments - AWR16xx Short Range Radar Demo ','NumberTitle','off')
    set(figHnd,'Name','ISRI - 77GHz雷达演示 ','NumberTitle','off')    
    warning off MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame
    jframe=get(figHnd,'javaframe');
    %jIcon=javax.swing.ImageIcon('texas_instruments.gif');
    jIcon=javax.swing.ImageIcon('ISRI.gif');
    jframe.setFigureIcon(jIcon);
    % set(figHnd, 'MenuBar', 'none');
    set(figHnd, 'Color', [0.5 0.5 0.5]);
    set(figHnd, 'KeyPressFcn', @myKeyPressFcn);
    set(figHnd, 'CloseRequestFcn', @myCloseRequestFcn);

    % set(figHnd,'ResizeFcn',@Resize_clbk);

    pause(0.00001);
    set(jframe,'Maximized',1); 
    pause(0.00001);

%     %% Display chirp params
%     if show_params == 1
%         displayChirpParams(Params);
%     end
%     guiMonitor.figHnd = figHnd;

    
    
    %% Initalize figures
    % X, Y plot    
%   import matplotlib.pyplot as plt
%   from matplotlib.font_manager import FontProperties  
%   font_set = FontProperties(r"c:\windows\fonts\simsun.ttc", size=12)  
%   fig=plt.figure()

%     guiMonitor.detectedObjectsFigHnd = subplot(3,5, [1 2 3 6 7 8 11 12 13]);
    guiMonitor.detectedObjectsFigHnd = subplot(221);
    hold on
    axis equal                    
    axis([-dim.max_dist_x dim.max_dist_x 0 dim.max_dist_y])
    %xlabel('Distance along lateral axis (meters)');                  
    %ylabel('Distance along longitudinal axis (meters)');
    %xlabel('横向距离 (米)');          
    xlabel('横向距离 (米)','FontSize',12,'FontWeight','bold','color','b','Fontname','STFangSong')
    %ylabel('纵向距离 (米)');
    ylabel('纵向距离 (米)','FontSize',12,'FontWeight','bold','color','b','Fontname','STFangSong')
    
    % Populate the plots. 这边红点为车子，蓝点为人
    guiMonitor.detectedObjectsPlotHndA = plot(inf,inf,'r.', 'Marker', 'x','MarkerSize',20); hold on;%20  redpoint SSR only
    guiMonitor.trackedObjPlotHnd           = plot(inf,inf,'r.', 'Marker', 'd','MarkerSize',13 ); %13
    %guiMonitor.detectedObjectsPlotHndB = plot(inf,inf,'c.', 'Marker', '.','MarkerSize',14);
    guiMonitor.detectedObjectsPlotHndB = plot(inf,inf,'b.', 'Marker', '.','MarkerSize',25);%14  only sport detected
    guiMonitor.clustersPlotHndA = plot(inf*ones(6*MAX_NUM_CLUSTERS,1),inf*ones(6*MAX_NUM_CLUSTERS,1),'g', 'LineWidth',2); %2
    guiMonitor.clustersPlotHndB = plot(inf*ones(6*MAX_NUM_CLUSTERS,1),inf*ones(6*MAX_NUM_CLUSTERS,1),'g', 'LineWidth',2); %2
    guiMonitor.parkingAssistRangeBinsHnd = plot(inf,inf,'g', 'LineWidth', 2, 'Color', [1 0.5 1]); 
    t = linspace(pi/6,5*pi/6,128);
    plotSemiCircularGrid(dim.max_dist_y);
    %title('X-Y Scatter Plot')
    %title('散布图')
    title('对象方位图-无消物','FontSize',12,'FontWeight','bold','color','r','Fontname','STFangSong');
    set(gca,'Color',[1 1 1]);
    
    guiMonitor.detectedObjectsFigHnd2 = subplot(222);
    hold on
    axis equal                    
    axis([-dim.max_dist_x dim.max_dist_x 0 dim.max_dist_y])
    %xlabel('Distance along lateral axis (meters)');                  
    %ylabel('Distance along longitudinal axis (meters)');
    %xlabel('横向距离 (米)');          
    xlabel('横向距离 (米)','FontSize',12,'FontWeight','bold','color','b','Fontname','STFangSong')
    %ylabel('纵向距离 (米)');
    ylabel('纵向距离 (米)','FontSize',12,'FontWeight','bold','color','b','Fontname','STFangSong')
    
    % Populate the plots. 这边红点为车子，蓝点为人
    guiMonitor.detectedObjectsPlotHndA = plot(inf,inf,'r.', 'Marker', 'x','MarkerSize',20); hold on;%20  redpoint SSR only
    guiMonitor.trackedObjPlotHnd           = plot(inf,inf,'r.', 'Marker', 'd','MarkerSize',13 ); %13
    %guiMonitor.detectedObjectsPlotHndB = plot(inf,inf,'c.', 'Marker', '.','MarkerSize',14);
    guiMonitor.detectedObjectsPlotHndB2 = plot(inf,inf,'b.', 'Marker', '.','MarkerSize',25);%14  only sport detected
    guiMonitor.clustersPlotHndA = plot(inf*ones(6*MAX_NUM_CLUSTERS,1),inf*ones(6*MAX_NUM_CLUSTERS,1),'g', 'LineWidth',2); %2
    guiMonitor.clustersPlotHndB = plot(inf*ones(6*MAX_NUM_CLUSTERS,1),inf*ones(6*MAX_NUM_CLUSTERS,1),'g', 'LineWidth',2); %2
    guiMonitor.parkingAssistRangeBinsHnd = plot(inf,inf,'g', 'LineWidth', 2, 'Color', [1 0.5 1]); 
    t = linspace(pi/6,5*pi/6,128);
    plotSemiCircularGrid(dim.max_dist_y);
    %title('X-Y Scatter Plot')
    %title('散布图')
    title('对象方位图-消除固定物体','FontSize',12,'FontWeight','bold','color','r','Fontname','STFangSong');
    set(gca,'Color',[1 1 1]);
    
    guiMonitor.detectedObjectsFigHnd3 = subplot(223);
    hold on
    axis equal                    
    axis([-dim.max_dist_x dim.max_dist_x 0 dim.max_dist_y])
    %xlabel('Distance along lateral axis (meters)');                  
    %ylabel('Distance along longitudinal axis (meters)');
    %xlabel('横向距离 (米)');          
    xlabel('横向距离 (米)','FontSize',12,'FontWeight','bold','color','b','Fontname','STFangSong')
    %ylabel('纵向距离 (米)');
    ylabel('纵向距离 (米)','FontSize',12,'FontWeight','bold','color','b','Fontname','STFangSong')
    
    % Populate the plots. 这边红点为车子，蓝点为人
    guiMonitor.detectedObjectsPlotHndA = plot(inf,inf,'r.', 'Marker', 'x','MarkerSize',20); hold on;%20  redpoint SSR only
    guiMonitor.trackedObjPlotHnd           = plot(inf,inf,'r.', 'Marker', 'd','MarkerSize',13 ); %13
    %guiMonitor.detectedObjectsPlotHndB = plot(inf,inf,'c.', 'Marker', '.','MarkerSize',14);
    guiMonitor.detectedObjectsPlotHndB3 = plot(inf,inf,'b.', 'Marker', '.','MarkerSize',25);%14  only sport detected
    guiMonitor.clustersPlotHndA = plot(inf*ones(6*MAX_NUM_CLUSTERS,1),inf*ones(6*MAX_NUM_CLUSTERS,1),'g', 'LineWidth',2); %2
    guiMonitor.clustersPlotHndB = plot(inf*ones(6*MAX_NUM_CLUSTERS,1),inf*ones(6*MAX_NUM_CLUSTERS,1),'g', 'LineWidth',2); %2
    guiMonitor.parkingAssistRangeBinsHnd = plot(inf,inf,'g', 'LineWidth', 2, 'Color', [1 0.5 1]); 
    t = linspace(pi/6,5*pi/6,128);
    plotSemiCircularGrid(dim.max_dist_y);
    %title('X-Y Scatter Plot')
    %title('散布图')
    title('对象方位图-消除物体','FontSize',12,'FontWeight','bold','color','r','Fontname','STFangSong');
    set(gca,'Color',[1 1 1]);
    
    
    
    
    
%     
% 
%     %% R, Rd plot
% %     guiMonitor.detectedObjectsRngDopFigHnd = subplot('Position',[0.618 0.625 0.375 0.3]);
%     guiMonitor.detectedObjectsRngDopFigHnd = subplot(222);
%     hold off
%     hold on
%     %set(gca,'Color',[0 0 0.5]);
%     set(gca,'Color',[1 1 1]);
%     axis([0 dim.max_dist_y -dim.max_vel dim.max_vel])
%     %xlabel('Range (meters)');
%     %ylabel('Doppler (m/s)');
%     % xlabel('距离 (米)');
%     % ylabel('速度 (米/秒)');
%     xlabel('距离 (米)','FontSize',12,'FontWeight','bold','color','b','Fontname','STFangSong')
%     ylabel('速度 (米/秒)','FontSize',12,'FontWeight','bold','color','b','Fontname','STFangSong')
%     %title('Doppler-Range Plot');
%     %title('多普勒图');
%     title('距离-速度图','FontSize',12,'FontWeight','bold','color','r','Fontname','STFangSong');
%     %set(gca,'Xcolor',[0.5 0.5 0.5]);
%     %set(gca,'Ycolor',[0.5 0.5 0.5]);
%     guiMonitor.detectedObjectsRngDopPlotHndA = plot(inf,inf,'r.', 'Marker', '.','MarkerSize',10); hold on;
%     guiMonitor.trackedObjRngDop = plot(inf,inf,'r.', 'Marker', 'd','MarkerSize',13); hold on;
%     guiMonitor.detectedObjectsRngDopPlotHndB = plot(inf,inf,'b.', 'Marker', '.','MarkerSize',10);
%     clustersPlotHnd = plot(inf*ones(6*MAX_NUM_CLUSTERS,1),inf*ones(6*MAX_NUM_CLUSTERS,1),'g', 'LineWidth',2); 
%     parkingAssistRangeBinsHnd = plot(inf,inf,'g', 'LineWidth', 2, 'Color', [1 0.5 1]); 
%     if show_legend
%         lgnd = legend('红点', '跟踪Trackers', '点图USRR', '融合Clusters', 'Location','NorthEastOutside');%'Park Assist Grid'
%         set(lgnd,'color','white');
%         %%
%         % 
%         %  PREFORMATTED
%         %  TEXT
%         % 
%     end
%     
    
    
    plotRectGrid(dim.max_dist_y, dim.max_vel);

     %% GUI filtering options
    step = 0.15; offset = 0.05; halfStep = 0.2; height = 0.075; 
    thickness = 0.3; h_thickness = 0.5; width = step; chkbxwidth = step/5;

    h_ui = uipanel('Parent',figHnd,'Title','显示项','FontSize',12, 'Units', 'normalized', 'Position',[0.618 0.10 0.274 0.1], 'BackgroundColor', [0.8 0.8 0.8]);
    uicontrol('Parent',h_ui,'Units', 'normalized', 'Style','text','Position',[offset (height+h_thickness) width thickness],'String','近场', 'BackgroundColor', [0.8 0.8 0.8]);%为远景的0.25
    uicontrol('Parent',h_ui,'Units', 'normalized','Style','checkbox','Position',[(halfStep + offset) (height+h_thickness+0.002) chkbxwidth thickness],'Value',view_range,'Callback',@select_viewRange,'BackgroundColor', [0.8 0.8 0.8]);
    %uicontrol('Parent',h_ui,'Units', 'normalized', 'Style','text','Position',[(2*step + offset) (height+h_thickness) width thickness],'String',        'Parking ', 'BackgroundColor', [0.8 0.8 0.8]);
    %uicontrol('Parent',h_ui,'Units', 'normalized','Style','checkbox','Position',[(2*step + halfStep + offset) (height+h_thickness+0.002) chkbxwidth thickness],'Value',load_parking_assist,'Callback',@select_parking_assist,'BackgroundColor', [0.8 0.8 0.8]);
    uicontrol('Parent',h_ui,'Units', 'normalized', 'Style','text','Position',[(4*step + offset) (height+h_thickness) width thickness],'String',        '点图USRR', 'BackgroundColor', [0.8 0.8 0.8]);%USRR Cloud
    uicontrol('Parent',h_ui,'Units', 'normalized','Style','checkbox','Position',[(4*step + halfStep + offset) (height+h_thickness+0.002) chkbxwidth thickness],'Value',load_point_cloud_usrr,'Callback',@select_pointcloud_usrr,'BackgroundColor', [0.8 0.8 0.8]);
    uicontrol('Parent',h_ui,'Units', 'normalized', 'Style','text','Position',[offset height width thickness],'String',        '红点SRR', 'BackgroundColor', [0.8 0.8 0.8]);%SRR Cloud
    uicontrol('Parent',h_ui,'Units', 'normalized','Style','checkbox','Position',[(halfStep + offset) (height+0.002) chkbxwidth thickness],'Value',load_point_cloud_srr,'Callback',@select_pointcloud_srr,'BackgroundColor', [0.8 0.8 0.8]);
    uicontrol('Parent',h_ui,'Units', 'normalized','Style','text','Position',[(2*step + offset) height width thickness],'String',        '融合Clusters','BackgroundColor', [0.8 0.8 0.8]);%Clusters
    uicontrol('Parent',h_ui,'Units', 'normalized','Style','checkbox','Position',[(2*step + halfStep + offset) (height+0.002) chkbxwidth thickness],'Value',load_clusters,'Callback',@select_clusters,'BackgroundColor', [0.8 0.8 0.8]);
    uicontrol('Parent',h_ui,'Units', 'normalized','Style','text','Position',[(4*step + offset) height width thickness],'String',        '追踪Trackers','BackgroundColor', [0.8 0.8 0.8]);%Trackers
    uicontrol('Parent',h_ui,'Units', 'normalized','Style','checkbox','Position',[(4*step  + halfStep + offset) (height+0.002) chkbxwidth thickness],'Value',load_trackers,'Callback',@select_trackers,'BackgroundColor', [0.8 0.8 0.8]);
    
    if (guiMonitor.stats == 1)
         guiMonitor.statsFigHnd = subplot(3,3, 6);
         guiMonitor.statsPlotHnd = plot(zeros(100,3));
         figIdx = figIdx + 1;
         hold on;
         xlabel('frames');                  
         ylabel('% CPU Load');
         axis([0 100 0 100])
         title('Active and Interframe CPU Load')
         plot([0 0 0; 0 0 0])
         legend('Interframe', 'Active frame', 'GUI')
    end
%fprintf('123');

return



function select_pointcloud_srr(popup,event)
global load_point_cloud_srr;
    load_point_cloud_srr = (popup.Value); 
return

function select_pointcloud_usrr(popup,event)
global load_point_cloud_usrr;
    load_point_cloud_usrr = (popup.Value); 
return

function select_clusters(popup,event)
global load_clusters;
    load_clusters = (popup.Value); 
return

function select_trackers(popup,event)
global load_trackers;
    load_trackers = (popup.Value); 
return

function select_viewRange(popup,event)
global view_range;
    view_range = (popup.Value); 
return

function select_parking_assist(popup,event)
global load_parking_assist;
    load_parking_assist = (popup.Value); 

return
function select_perspective(popup, event)
    global use_perspective_projection 
    use_perspective_projection = popup.Value;
return


function myKeyPressFcn(hObject, event)
    global EXIT_KEY_PRESSED PAUSE_KEY_PRESSED RECORD_KEY_PRESSED
    if lower(event.Key) == 'q'
        EXIT_KEY_PRESSED  = 1;
    elseif lower(event.Key) == 'p'
        PAUSE_KEY_PRESSED  = 1;
    elseif lower(event.Key) == 'r'
        RECORD_KEY_PRESSED == 1;
    end
return

function myCloseRequestFcn(hObject, event)
    global EXIT_KEY_PRESSED
    EXIT_KEY_PRESSED  = 1;
    
return
