
 %参数的配置显示
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function displayChirpParams(Params)
global hndChirpParamTable
global StatsInfo
global guiProcTime
    if hndChirpParamTable ~= 0
        delete(hndChirpParamTable);
        hndChirpParamTable = 0;
    end

    dat =  { '<HTML><b> 第1子帧号  ', 1; ...
            '          扫频最小频率    (Ghz)',        Params(1).profileCfg.startFreq;...
            '          带宽           (GHz)',              Params(1).profileCfg.freqSlopeConst * Params(1).profileCfg.numAdcSamples/Params(1).profileCfg.digOutSampleRate;...
            '          距离精度         (m)',         Params(1).dataPath.rangeResolutionMeters;...
            '          速度精度       (m/s)',    Params(1).dataPath.dopplerResolutionMps;...
            '          发天线号(MIMO)',          Params(1).dataPath.numTxAnt;...
            '<HTML><b> 第2子帧号   ',      2; ...
            '          扫频最小频率    (Ghz)',        Params(2).profileCfg.startFreq;...
            '          带宽           (GHz)',              Params(2).profileCfg.freqSlopeConst * Params(2).profileCfg.numAdcSamples/Params(2).profileCfg.digOutSampleRate;...
            '          距离精度         (m)',         Params(2).dataPath.rangeResolutionMeters;...
            '          速度精度       (m/s)',    Params(2).dataPath.dopplerResolutionMps;...
            '          发天线号      (MIMO)',          Params(2).dataPath.numTxAnt;...
            '          帧周期 (ms)',  Params(2).frameCfg.framePeriodicity;...
            };
        
    columnname =   {'__________________参数 __________(单位)_________', '___________数值__________'};
    columnformat = {'char', 'numeric'};
    
    t = uitable('Units','normalized','Position',...
                [0.618 0.22 0.274 0.34], 'Data', dat,... 
                'ColumnName', columnname,...
                'ColumnFormat', columnformat,...
                'ColumnWidth', 'auto',...
                'RowName',[]); 
            
    hndChirpParamTable = t;
return
