%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Filename:    PS3000A_IC_Generic_Driver_2buffers_RunBlock
%
% Copyright:   Pico Technology Limited 2012 - 2014
%
% Author:      HSM
%
% Description:
%   This is a MATLAB script that demonstrates how to use the
%   PicoScope 3000a series Instrument Control Toobox driver to collect a 
%   block of samples immediately with 2 data buffers per channel and 
%   aggregation.
%
% To run this application:
%		Ensure that the following files are located either in the same 
%       directory or define the path:
%       
%       - PS3000a_IC_drv.mdd
%       - PS3000a.dll & ps3000aWrap.dll (Windows version of MATLAB only)
%       - PS3000aMFile & ps3000aWrapMFile
%       - PicoStatus.m
%       - ps3000aChangePowerSource.m
%       - adc2mv.m & mv2adc.m (located in the Functions directory)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Clear MATLAB Env

clear;
clc;

%% Load Config File

PS3000aConfig;

%% Declare variables

global data;

data.TRUE = 1;
data.FALSE = 0;

data.BUFFER_SIZE = 1024;

% Max and Min data buffers for Channel A
data.pBufferMaxA = libpointer('int16Ptr',zeros(data.BUFFER_SIZE,1));
data.pBufferMinA = libpointer('int16Ptr',zeros(data.BUFFER_SIZE,1));

% Max and Min data buffers for Channel B
%data.pBufferMaxB = libpointer('int16Ptr',zeros(1024,1));
%data.pBufferMinB = libpointer('int16Ptr',zeros(1024,1));

%data.timebase = 627; % 10KS/s for 320XA/B 
data.timebase = 1252; % 10KS/s for 340XA/B
data.oversample = 1;

data.scaleVoltages = data.TRUE;
data.inputRangesmV = [10, 20, 50, 100, 200, 500, 1000, 2000, 5000, 10000, 20000];

plotData = data.TRUE;

%% Device Connection

% Create device
ps3000a_obj = icdevice('PS3000a_IC_drv', ''); % Specify serial number as 2nd argument if required.

% Connect device
connect(ps3000a_obj);

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

channelA = enuminfo.enPS3000ARange.PS3000A_1V;
analogueOffset = 0;

set_ch_a_status = invoke(ps3000a_obj, 'ps3000aSetChannel', enuminfo.enPS3000AChannel.PS3000A_CHANNEL_A, ...
    channelSettings(1).enabled, channelSettings(1).DCCoupled, channelSettings(1).range, analogueOffset);

%% Set Simple Trigger

enable = data.TRUE;
source = enuminfo.enPS3000AChannel.PS3000A_CHANNEL_A;
threshold = 100;
direction = enuminfo.enPS3000AThresholdDirection.PS3000A_RISING;
delay = 0;
autoTrigger_ms = 0;

trigger_status = invoke(ps3000a_obj, 'ps3000aSetSimpleTrigger', ...
    enable, source, threshold, direction, ...
    delay, autoTrigger_ms)

%% Set Timebase

timeIndisposed = 0;
maxSamples = data.BUFFER_SIZE;
timeIntNs = 0;
segmentIndex = 0;

[get_timebase2_status, timeIntNs1, maxSamples1] = invoke(ps3000a_obj, 'ps3000aGetTimebase', ...
        data.timebase, data.BUFFER_SIZE, ...
        timeIntNs, data.oversample, maxSamples, segmentIndex);
    
disp('Timebase')
data.timebase

get_timebase2_status
timeIntNs1
maxSamples

%% Run Block

preTriggerSamples = 0;
postTriggerSamples = data.BUFFER_SIZE;
segmentIndex = 0;

% Prompt to press a key to begin capture
input_str = input('Press ENTER to begin data collection.', 's');

% Run block and retry if power source not set correctly
retry = 1;

while(retry == 1)

    [run_block_status, timeIndisposedMs] = invoke(ps3000a_obj, 'ps3000aRunBlock', ...
        preTriggerSamples, postTriggerSamples, data.timebase, ...
        data.oversample, segmentIndex)

    % Check power status
    if run_block_status ~= PicoStatus.PICO_OK
        
        if (run_block_status == PicoStatus.PICO_POWER_SUPPLY_CONNECTED || ...
                run_block_status == PicoStatus.PICO_POWER_SUPPLY_NOT_CONNECTED || ...
                run_block_status == PicoStatus.PICO_POWER_SUPPLY_UNDERVOLTAGE)
            
            %change_power_src_status = invoke(ps3000a_obj, 'ChangePowerSource', run_block_status)
            change_power_src_status = ps3000aChangePowerSource(ps3000a_obj, run_block_status)
            
        else
            
            % Display error code in Hexadecimal
            fprintf('ps3000aRunBlock status: 0x%X', run_block_status);
            
        end
        
    else
        
        retry = 0;
        
    end

end

% Confirm if device is ready
[status_ready, ready] = invoke(ps3000a_obj, 'ps3000aIsReady')

while ready == 0
   
    [status_ready, ready] = invoke(ps3000a_obj, 'ps3000aIsReady');
    pause(1);
end

fprintf('Ready: %d\n', ready);
disp('Data collected.');

%% Stop the device

stop_status = invoke(ps3000a_obj, 'ps3000aStop')

%% Set Data Buffers

segmentIndex = 0;
ratio_mode = enuminfo.enPS3000ARatioMode.PS3000A_RATIO_MODE_AGGREGATE;

set_data_buffers_chA_status = invoke(ps3000a_obj, 'ps3000aSetDataBuffers', ...
    0, data.pBufferMaxA, data.pBufferMinA, ...
    data.BUFFER_SIZE, segmentIndex, ratio_mode);

disp('SetDataBuffers: Ch. A')
set_data_buffers_chA_status

%% Get Values

startIndex = 0;
numSamples = data.BUFFER_SIZE;
downSampleRatio = 2;
downSampleRatioMode = enuminfo.enPS3000ARatioMode.PS3000A_RATIO_MODE_AGGREGATE;
segmentIndex = 0;
overflow_ptr = 0;

[get_values_status, numSamples, overflow] = invoke(ps3000a_obj, 'ps3000aGetValues', ...
    startIndex, numSamples, downSampleRatio, downSampleRatioMode, segmentIndex, overflow_ptr);

if(get_values_status ~= PicoStatus.PICO_OK)
    
    % Check if Power Status issue
    if(get_values_status == PicoStatus.PICO_POWER_SUPPLY_CONNECTED || ...
        get_values_status == PicoStatus.PICO_POWER_SUPPLY_NOT_CONNECTED || ...
            get_values_status == PicoStatus.PICO_POWER_SUPPLY_UNDERVOLTAGE)

        if(get_values_status == PicoStatus.PICO_POWER_SUPPLY_UNDERVOLTAGE)

            pwr_status = ps3000aChangePowerSource(ps3000a_obj, get_values_status)
        
        else

            fprintf('Power Source Changed. Data collection aborted.\n');
            plotData = data.FALSE;
            
        end

    else

        fprintf('ps3000aGetValues status: 0x%X', get_values_status);
        plotData = data.FALSE;

    end

end



%% Convert data values to milliVolt values

disp('Converting data to milliVolts...')

voltage_range_chA = data.inputRangesmV(channelSettings(1).range + 1);

% Buffers to hold data values

buffer_a_max = get(data.pBufferMaxA, 'Value');
buffer_a_min = get(data.pBufferMinA, 'Value');

buffer_a_max_mv = adc2mv(buffer_a_max(1:numSamples), voltage_range_chA, ps3000a_obj.maxValue);
buffer_a_min_mv = adc2mv(buffer_a_min(1:numSamples), voltage_range_chA, ps3000a_obj.maxValue);

%% Plot data

if(plotData == data.TRUE)
    
    disp('Plotting data...')
    figure;

    % Time axis
    % Samples get reduced, so plot against every nth step in tim interval
    % where n is the ratio
    t_ns = (double(timeIntNs1) * [0:downSampleRatio:(data.BUFFER_SIZE - 1)]);
    % Convert to milliseconds
    t = t_ns / 1000000;

    % Plot Channel A Max
    plot_a_max_axes = subplot(2,1,1); 
    plot(t, buffer_a_max_mv);
    title('Channel A Max');
    xlabel('Time (ms)');
    ylabel(plot_a_max_axes, 'Voltage (mV)');

    % Plot Channel A Min (only for aggregate mode)
    plot_a_min_axes = subplot(2,1,2); 
    plot(t, buffer_a_min_mv);
    title('Channel A Min');
    xlabel('Time (ms)');
    ylabel(plot_a_min_axes, 'Voltage (mV)');

end

%% Disconnect device

disconnect(ps3000a_obj);