

 %Read relevant CLI parameters and store into P structure
function [P] = generate_params_for_SRR()

global TOTAL_PAYLOAD_SIZE_BYTES
global MAX_NUM_OBJECTS
global OBJ_STRUCT_SIZE_BYTES
global platformType
global STATS_SIZE_BYTES

max_vel_enh = 1; 
P(1) = first_subframe_parameters(max_vel_enh);
P(2) = second_subframe_parameters(); 

return

function [P] = first_subframe_parameters(is_max_vel_enh_enabled)

    if is_max_vel_enh_enabled
        P.channelCfg.txChannelEn = 1;
        P.dataPath.numTxAzimAnt = 1;
        P.dataPath.numTxElevAnt = 0;
        P.channelCfg.rxChannelEn = 15;
        P.dataPath.numRxAnt = 4;
        P.dataPath.numTxAnt = P.dataPath.numTxElevAnt + P.dataPath.numTxAzimAnt;
        P.profileCfg.startFreq = 76.0;
        P.profileCfg.idleTime =  3.00;
        P.profileCfg.rampEndTime = 56.00;
        P.profileCfg.freqSlopeConst = 8.0;
        P.profileCfg.numAdcSamples = 256;
        P.profileCfg.digOutSampleRate = 5000; %uints: ksps
        P.frameCfg.chirpStartIdx = 0;
        P.frameCfg.chirpEndIdx = 63;
        P.frameCfg.numLoops = 1;
        P.frameCfg.numFrames = 0;
        P.frameCfg.framePeriodicity = 30;
    else
        P.channelCfg.txChannelEn = 3;
        P.dataPath.numTxAzimAnt = 2;
        P.dataPath.numTxElevAnt = 0;
        P.channelCfg.rxChannelEn = 15;
        P.dataPath.numRxAnt = 4;
        P.dataPath.numTxAnt = P.dataPath.numTxElevAnt + P.dataPath.numTxAzimAnt;
        P.profileCfg.startFreq = 76.0;
        P.profileCfg.idleTime =  3.00;
        P.profileCfg.rampEndTime = 56.00;
        P.profileCfg.freqSlopeConst = 8.0;
        P.profileCfg.numAdcSamples = 256;
        P.profileCfg.digOutSampleRate = 5000; %uints: ksps
        P.frameCfg.chirpStartIdx = 0;
        P.frameCfg.chirpEndIdx = 1;
        P.frameCfg.numLoops = 64;
        P.frameCfg.numFrames = 0;
        P.frameCfg.framePeriodicity = 30;
    end
    P = compute_secondary_params(P);
    
return;




function P = second_subframe_parameters()

    P.channelCfg.txChannelEn = 3;
    P.dataPath.numTxAzimAnt = 2;
    P.dataPath.numTxElevAnt = 0;
    P.channelCfg.rxChannelEn = 15;
    P.dataPath.numRxAnt = 4;
    P.dataPath.numTxAnt = P.dataPath.numTxElevAnt + P.dataPath.numTxAzimAnt;
    P.profileCfg.startFreq = 77.0;
    P.profileCfg.idleTime =  7.00;
    P.profileCfg.rampEndTime = 87.28;
    P.profileCfg.freqSlopeConst = 42.0;
    P.profileCfg.numAdcSamples = 512;
    P.profileCfg.digOutSampleRate = 6222; %uints: ksps
    P.frameCfg.chirpStartIdx = 0;
    P.frameCfg.chirpEndIdx = 1;
    P.frameCfg.numLoops = 32;
    P.frameCfg.numFrames = 0;
    P.frameCfg.framePeriodicity = 30;

    P = compute_secondary_params(P);
    
return;

function P = compute_secondary_params(P)
global TOTAL_PAYLOAD_SIZE_BYTES
global MAX_NUM_OBJECTS
global OBJ_STRUCT_SIZE_BYTES
global platformType
global STATS_SIZE_BYTES
P.guiMonitor.stats = 1;

    P.dataPath.numChirpsPerFrame = (P.frameCfg.chirpEndIdx -...
                                            P.frameCfg.chirpStartIdx + 1) *...
                                            P.frameCfg.numLoops;
    P.dataPath.numDopplerBins = P.dataPath.numChirpsPerFrame / P.dataPath.numTxAnt;
    P.dataPath.numRangeBins = pow2roundup(P.profileCfg.numAdcSamples);
    P.dataPath.rangeResolutionMeters = 3e8 * P.profileCfg.digOutSampleRate * 1e3 /...
                     (2 * P.profileCfg.freqSlopeConst * 1e12 * P.profileCfg.numAdcSamples);
    P.dataPath.rangeIdxToMeters = 3e8 * P.profileCfg.digOutSampleRate * 1e3 /...
                     (2 * P.profileCfg.freqSlopeConst * 1e12 * P.dataPath.numRangeBins);
    P.dataPath.dopplerResolutionMps = 3e8 / (2*P.profileCfg.startFreq*1e9 *...
                                        (P.profileCfg.idleTime + P.profileCfg.rampEndTime) *...
                                        1e-6 * P.dataPath.numDopplerBins * P.dataPath.numTxAnt);
    %Calculate monitoring packet size
    tlSize = 8; %TL size 8 bytes
    TOTAL_PAYLOAD_SIZE_BYTES = 32; % size of header
    P.guiMonitor.numFigures = 1; %One figure for numerical parameers
    TOTAL_PAYLOAD_SIZE_BYTES = TOTAL_PAYLOAD_SIZE_BYTES +...
        OBJ_STRUCT_SIZE_BYTES*MAX_NUM_OBJECTS + tlSize;

    if P.guiMonitor.stats == 1
        TOTAL_PAYLOAD_SIZE_BYTES = TOTAL_PAYLOAD_SIZE_BYTES +...
            STATS_SIZE_BYTES + tlSize;
        P.guiMonitor.numFigures = P.guiMonitor.numFigures + 1;
    end
    TOTAL_PAYLOAD_SIZE_BYTES = 32 * floor((TOTAL_PAYLOAD_SIZE_BYTES+31)/32);
    P.guiMonitor.numFigRow = 2;
    P.guiMonitor.numFigCol = ceil(P.guiMonitor.numFigures/P.guiMonitor.numFigRow);
return;

function [y] = pow2roundup (x)
    y = 1;
    while x > y
        y = y * 2;
    end
return
