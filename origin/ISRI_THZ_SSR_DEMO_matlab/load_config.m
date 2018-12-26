

function [result] = load_config(comportCliNum)

result = 1;
fprintf('Starting UI for mmWave Demo ....\n'); 

cliCfg{1} = 'advFrameCfg';
cliCfg{2} = 'sensorStart';

spCliHandle = configureCliPort(comportCliNum);

warning off; %MATLAB:serial:fread:unsuccessfulRead
timeOut = get(spCliHandle,'Timeout');
set(spCliHandle,'Timeout',1);
tStart = tic; numTick = 0;
while 1
    numTick = numTick + 1;
    fprintf(spCliHandle, ''); cc=fread(spCliHandle,100);
    cc = strrep(strrep(cc,char(10),''),char(13),'');
    if ~isempty(cc)
            break;
    elseif numTick == 10
            fclose(spCliHandle);
            delete(spCliHandle);
            fprintf(['Cannot connect to port ' num2str(comportCliNum) '....\n']); 
            result = -1;
            return;
    end
    pause(0.1);
    toc(tStart);
end
set(spCliHandle,'Timeout', timeOut);
warning on;
%Send CLI configuration to XWR1xxx
fprintf('Sending configuration to XWR1xxx  ...\n');
for k=1:length(cliCfg)
    fprintf(spCliHandle, cliCfg{k});
    if isempty(strrep(strrep(cliCfg{k},char(9),''),char(32),''))
        continue;
    end
    if strcmp(cliCfg{k}(1),'%')
        continue;
    end
    fprintf('%s\n', cliCfg{k});
    for kk = 1:3
        cc = fgetl(spCliHandle);
        if strcmp(cc,'Done')
            fprintf('%s\n',cc);
            break;
        elseif ~isempty(strfind(cc, 'not recognized as a CLI command'))
            fprintf('%s\n',cc);
            result = 1;
            break;
        end
    end
end
fclose(spCliHandle);
delete(spCliHandle);

end


function [sphandle] = configureCliPort(comportPnum)
    comportnum_str = ['COM' num2str(comportPnum)];
    sphandle = serial(comportnum_str,'BaudRate',115200);
    set(sphandle,'Parity','none')    
    set(sphandle,'Terminator','LF')    

    
    fopen(sphandle);
return
end