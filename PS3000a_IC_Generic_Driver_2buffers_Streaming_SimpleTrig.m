%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Filename:    PS3000A_IC_Generic_Driver_2buffers_Streaming_SimpleTrig
%
% Copyright:   Pico Technology Limited 2012
%
% Author:      HSM
%
% Description:
%   This is a MATLAB script that demonstrates how to use the
%   PicoScope 3000a series Instrument Control Toobox driver to collect data
%   in streaming mode for 1 channel with aggregation and simple trigger.
%
%	To run this application:
%		Ensure that the following files are located either in the same 
%       directory or define the path:
%       
%       - PS3000a_IC_drv.mdd
%       - PS3000a.dll & ps3000aWrap.dll 
%       - PS3000aMFile & ps3000aWrapMFile
%       - PicoStatus.m
%       - ps3000aChangePowerSource.m
%       - adc2mv.m & mv2adc.m (located in the Functions directory)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Clear MATLAB Env

clear;
clc;
%% Set Path

% Edit as required
addpath('C:\Pico SDK\PS3000asdk_r10_4_3_1');
addpath('..\');
addpath('..\Functions');

%% Load in PicoStatus values

PicoStatus;
%% Declare variables

global data;

data.TRUE = 1;
data.FALSE = 0;

data.BUFFER_SIZE = 1024;

data.oversample = 1;

data.scaleVoltages = data.TRUE;
data.inputRangesmV = [10, 20, 50, 100, 200, 500, 1000, 2000, 5000, 10000, 20000];

plotData = data.TRUE;

%% Device Connection

% Create device -  specify serial number if required
ps3000a_obj = icdevice('PS3000a_IC_drv', ''); % Specify serial number as 2nd argument if required.

% Connect device
connect(ps3000a_obj);

% Provide access to enumerations and structures
[methodinfo, structs, enuminfo, ThunkLibName] = PS3000aMFile;

%% Show unit information

info_status = invoke(ps3000a_obj, 'GetUnitInfo')

%% Obtain Maximum & Minimum values 

max_val_status = invoke(ps3000a_obj, 'ps3000aMaximumValue')

disp('Max ADC value:');
ps3000a_obj.maxValue

min_val_status= invoke(ps3000a_obj, 'ps3000aMinimumValue')

disp('Min ADC value:');
ps3000a_obj.minValue

%% Channel settings

% Channel settings - create a struct

% Channel A
channelSettings(1).enabled = data.TRUE;
channelSettings(1).DCCoupled = data.TRUE;
channelSettings(1).range = enuminfo.enPS3000ARange.PS3000A_1V;

% Channel B
%channelSettings(2).enabled = data.TRUE;
%channelSettings(2).DCCoupled = data.TRUE;
%channelSettings(2).range = enuminfo.enPS3000ARange.PS3000A_1V;

%% Set Channel A

channelA_Range = enuminfo.enPS3000ARange.PS3000A_1V;
analogueOffset = 0;

set_ch_a_status = invoke(ps3000a_obj, 'ps3000aSetChannel', enuminfo.enPS3000AChannel.PS3000A_CHANNEL_A, ...
    channelSettings(1).enabled, channelSettings(1).DCCoupled, channelSettings(1).range, analogueOffset)

%% Set Simple Trigger

enable = data.TRUE;
source = enuminfo.enPS3000AChannel.PS3000A_CHANNEL_A;
threshold = mv2adc(500, data.inputRangesmV(channelA_Range + 1), ps3000a_obj.maxValue);
direction = enuminfo.enPS3000AThresholdDirection.PS3000A_RISING;
delay = 0;              
autoTrigger_ms = 10000; % 10 seconds

trigger_status = invoke(ps3000a_obj, 'ps3000aSetSimpleTrigger', ...
    enable, source, threshold, direction, ...
    delay, autoTrigger_ms)

%% Set Data Buffers

segmentIndex = 0;   
sampleCount =  10 * data.BUFFER_SIZE; % x10 to make sure buffer is large enough
ratio_mode = enuminfo.enPS3000ARatioMode.PS3000A_RATIO_MODE_AGGREGATE;

% Max and Min data buffers for Channel A
data.pBufferMaxA = libpointer('int16Ptr', zeros(sampleCount, 1));
data.pBufferMinA = libpointer('int16Ptr', zeros(sampleCount, 1));

disp('SetDataBuffers: Ch. A')

set_data_buffers_chA_status = invoke(ps3000a_obj, 'ps3000aSetDataBuffers', ...
    0, data.pBufferMaxA, data.pBufferMinA, ...
    sampleCount, segmentIndex, ratio_mode)


%% Run Streaming and Get Values

sampleInterval = 5; % 200KS/s
sampleIntervalTimeUnits = enuminfo.enPS3000ATimeUnits.PS3000A_US;
maxPreTriggerSamples = 1000;
maxPostTriggerSamples = 100000 - maxPreTriggerSamples;
autoStop = data.TRUE;
downSampleRatio = 1;
downSampleRatioMode = enuminfo.enPS3000ARatioMode.PS3000A_RATIO_MODE_AGGREGATE;
overviewBufferSize = sampleCount;

% Prompt to press a key to begin capture
input_str = input('Press ENTER to begin data collection.', 's');

repeat = data.TRUE;

% Repeat until Power source is correct
while(repeat == data.TRUE)

    % Start Streaming
    streaming_status = invoke(ps3000a_obj, 'ps3000aRunStreaming', ...
        sampleInterval, sampleIntervalTimeUnits, maxPreTriggerSamples, ...
        maxPostTriggerSamples, autoStop, downSampleRatio, ...
        downSampleRatioMode, overviewBufferSize);
    
    fprintf('Sample interval: %d', sampleInterval);
    
    switch(sampleIntervalTimeUnits)
       
        case enuminfo.enPS3000ATimeUnits.PS3000A_FS
            
            fprintf('fs\n');
            
        case enuminfo.enPS3000ATimeUnits.PS3000A_PS
            
            fprintf('ps\n');
            
        case enuminfo.enPS3000ATimeUnits.PS3000A_NS
            
            fprintf('ns\n');
            
        case enuminfo.enPS3000ATimeUnits.PS3000A_US
            
            fprintf('us\n');
            
        case enuminfo.enPS3000ATimeUnits.PS3000A_MS
            
            fprintf('ms\n');
            
        case enuminfo.enPS3000ATimeUnits.PS3000A_S
            
            fprintf('s\n');
        
    end
    
    % Check power status
    if(streaming_status ~= PicoStatus.PICO_OK)

        if(streaming_status == PicoStatus.PICO_POWER_SUPPLY_CONNECTED || ...
                streaming_status == PicoStatus.PICO_POWER_SUPPLY_NOT_CONNECTED || ...
                streaming_status == PicoStatus.PICO_POWER_SUPPLY_UNDERVOLTAGE)

            %change_power_src_status = invoke(ps3000a_obj, 'ChangePowerSource', run_block_status)
            change_power_src_status = ps3000aChangePowerSource(ps3000a_obj, streaming_status)

        else

            % Display error code in Hexadecimal
            fprintf('ps3000aRunStreaming status: 0x%X', streaming_status);

        end

    else

        repeat = data.FALSE;

    end

end

disp('Streaming data...');

% Variables to be used when collecting the data
hasAutoStopped = data.FALSE;
powerChange = data.FALSE;
 
newSamples = 0;         % Number of new samples returned from the driver.
totalSamples = 0;       % Total samples captured by the device.
startIndex = 0;         % Start index of data in the buffer returned.

hasTriggered = 0;       % To indicate if trigger has occurred.
triggeredAtIndex = 0;   % The index in the overall buffer where the trigger occurred.

originalPowerSource = invoke(ps3000a_obj, 'ps3000aCurrentPowerSource');

get_str_latest_values_status = PicoStatus.PICO_OK; % OK

% Use for
%expectedTotalSamples = int32((maxPreTriggerSamples + maxPostTriggerSamples) / ratio_mode);

% Buffers to hold all data
bufferMaxChA = [];
bufferMinChA = [];

% Stop button to check abort data collection - based on Mathworks solution 1-15JIQ 
% and MATLAB Central forum.

stop_fig.f = figure('menubar','none',...
              'units','pix',...
              'pos',[400 400 100 50]);
          
stop_fig.h = uicontrol('string', 'STOP', ...
'callback', 'setappdata(gcf, ''run'', 0)', 'units','pixels',...
                 'position',[10 10 80 30]);

flag = 1; % Use flag variable to indicate if stop button has been clicked (0)
setappdata(gcf, 'run', flag);

% Get data values as long as power status has not changed (check for STOP button push inside loop)
while(hasAutoStopped == data.FALSE && get_str_latest_values_status == PicoStatus.PICO_OK)
    
   ready = data.FALSE;
   
   while(ready == data.FALSE)
   
       get_str_latest_values_status = invoke(ps3000a_obj, 'GetStreamingLatestValues');
       pause(0.1); 
       ready = invoke(ps3000a_obj, 'IsReady');
       fprintf('Ready: %d\n', ready);
       
       % Give option to abort from here
       flag = getappdata(gcf, 'run');
       drawnow;
       
       if(flag == 0)
      
            disp('STOP button clicked - aborting data collection.')
            break;
            
       end
       
       drawnow;
       
   end
   
   fprintf('\n');
   
   
   % Check if the scope has triggered
   [triggered, triggeredAt] = invoke(ps3000a_obj, 'IsTriggerReady');
       
   % Check for data
   [newSamples, startIndex] = invoke(ps3000a_obj, 'AvailableData');
   
   if (newSamples > 0)
   
       if (triggered == data.TRUE)

          % Adjust trigger position as MATLAB does not use zero-based
          % indexing
          fprintf('Triggered - index in buffer: %d\n', (triggeredAt + 1));

          hasTriggered = triggered;

          % Adjust by 1 due to driver using zero indexing
          triggeredAtIndex = totalSamples + triggeredAt + 1;
       
       end
   
       totalSamples = totalSamples + newSamples;
       
       fprintf('Collected %d samples, total: %d.\n\n', newSamples, totalSamples);
   
       % Position indices of data in buffer
       firstValuePosn = startIndex + 1;
       lastValuePosn = firstValuePosn + newSamples - 1;
   
       % Extract data
       valuesMaxChA = get(data.pBufferMaxA, 'Value');
       valuesMinChA = get(data.pBufferMinA, 'Value');
       
       bufferMaxChA = vertcat(bufferMaxChA, valuesMaxChA(firstValuePosn:lastValuePosn, 1));
       bufferMinChA = vertcat(bufferMinChA, valuesMinChA(firstValuePosn:lastValuePosn, 1));
       
       % Process Data further if required
              
   end
   
   % Check if auto stop has occurred
   hasAutoStopped = invoke(ps3000a_obj, 'AutoStopped');
   
   fprintf('AutoStopped: %d\n', hasAutoStopped);
   
   if(hasAutoStopped == data.TRUE)
      
       disp('AutoStop: TRUE - exiting loop.');
       break;
       
   end
   
   fprintf('Click the STOP button to stop capture.\n') 
   
   % Check if 'STOP' button pressed
   
   flag = getappdata(gcf, 'run');
   drawnow;
   
   if(flag == 0)
      
       disp('STOP button clicked - aborting data collection.')
       break;
   end
   
%    % Check if power source has changed
%    currentPowerSource = invoke(ps3000a_obj, 'ps3000aCurrentPowerSource');
%    
%    if(currentPowerSource ~= originalPowerSource)
%    
%        powerChange = data.TRUE;
%        
%    end
%    
    
end

% Close the STOP button window
delete(stop_fig.f);
drawnow;

if(hasTriggered == data.TRUE)
   
    fprintf('Triggered at overall index: %d\n\n', triggeredAtIndex);
    
end


%% Stop the device

stop_status = invoke(ps3000a_obj, 'ps3000aStop')

%% Convert data values to milliVolt values

disp('Converting data to milliVolts...')

voltage_range_chA = data.inputRangesmV(channelSettings(1).range + 1);

% Buffers to hold data values

% buffer_a_max = get(data.pBufferMaxA, 'Value');
% buffer_a_min = get(data.pBufferMinA, 'Value');

buffer_a_max_mv = zeros(totalSamples, 1);
buffer_a_min_mv = zeros(totalSamples, 1);

for n = 1 : totalSamples

    buffer_a_max_mv(n, 1) = adc2mv(data.TRUE, bufferMaxChA(n, 1), voltage_range_chA, ps3000a_obj.maxValue);
    
    buffer_a_min_mv(n, 1) = adc2mv(data.TRUE, bufferMinChA(n, 1), voltage_range_chA, ps3000a_obj.maxValue);
    
end

%% Plot data

disp('Plotting data...')
figure;

% Time axis
% Multiply by ratio mode as samples get reduced
t_ns = (double(sampleInterval) * double(downSampleRatio)) * [0:(totalSamples - 1)];
% Convert to milliseconds
t = t_ns / 1000000;

% Plot Channel A Max and trigger point
plot_a_max_axes = subplot(2,1,1);

if(hasTriggered)
   
    plot(t, buffer_a_max_mv, 'b', t(triggeredAtIndex), buffer_a_max_mv(triggeredAtIndex), 'ro')
    
else
    
    plot(t, buffer_a_max_mv);
    
end

title('Channel A Max');
xlabel('Time (ms)');
ylabel(plot_a_max_axes, 'Voltage (mV)');

% Plot Channel A Min (only for aggregate mode)
plot_a_min_axes = subplot(2,1,2); 
plot(t, buffer_a_min_mv);
title('Channel A Min');
xlabel('Time (ms)');
ylabel(plot_a_min_axes, 'Voltage (mV)');

%% Disconnect device

disconnect(ps3000a_obj);