%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Filename:    PS3000A_IC_Generic_Driver_1buffer_RapidBlock
%
% Copyright:   Pico Technology Limited 2012
%
% Author:      HSM
%
% Description:
%   This is a MATLAB script that demonstrates how to use the
%   PicoScope 3000a series Instrument Control Toobox driver to collect a 
%   rapid block of samples immediately with 1 data buffer on 1 channel.
%
%	To run this application:
%		Ensure that the following files are located either in the same 
%       directory or define the path:
%       
%       - ps3000a.mdd
%       - PS3000a.dll & ps3000aWrap.dll (Windows version of MATLAB only)
%       - PS3000aMFile & ps3000aWrapMFile
%       - PicoStatus.m
%       - ps3000aChangePowerSource.m  
%       - adc2mv.m & mv2adc.m (located in the Functions directory)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Clear MATLAB Env

clc;
clear;

%% Load Config File

PS3000aConfig;

%% Declare variables

global data;

data.TRUE = 1;
data.FALSE = 0;

data.BUFFER_SIZE = 1024;

data.timebase = 64;     % ~1 MS/s (320XA/B)
%data.timebase = 127       % 1 MS/s (340XA/B)
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

channelA = enuminfo.enPS3000AChannel.PS3000A_CHANNEL_A;
channelA_range = enuminfo.enPS3000ARange.PS3000A_1V;
analogueOffset = 0;

% Channel settings - create a struct

% Channel A
channelSettings(1).enabled = data.TRUE;
channelSettings(1).DCCoupled = data.TRUE;
channelSettings(1).range = channelA_range;

% Channel B
% channelSettings(2).enabled = data.TRUE;
% channelSettings(2).DCCoupled = data.TRUE;
% channelSettings(2).range = enuminfo.enPS3000ARange.PS3000A_1V;

% invoke(ps3000a_obj, 'setDefaults', ps3000a_obj.unithandle, channelSettings);

set_ch_a_status = invoke(ps3000a_obj, 'ps3000aSetChannel', channelA, ...
    channelSettings(1).enabled, channelSettings(1).DCCoupled, ...
    channelSettings(1).range, analogueOffset);

%% Set Simple Trigger

enable = data.FALSE;
source = enuminfo.enPS3000AChannel.PS3000A_CHANNEL_A;
threshold = mv2adc(500, data.inputRangesmV(channelA_range + 1), ps3000a_obj.maxValue);
direction = enuminfo.enPS3000AThresholdDirection.PS3000A_RISING;
delay = 0;              
autoTrigger_ms = 10000; % 10 seconds

trigger_status = invoke(ps3000a_obj, 'ps3000aSetSimpleTrigger', ...
    enable, source, threshold, direction, delay, autoTrigger_ms)

%% Get Timebase

timeIndisposed = 0;
maxSamples = data.BUFFER_SIZE;
timeIntNs = 0;
segmentIndex = 0;

[get_timebase_status, timeIntNs1, maxSamples1] = invoke(ps3000a_obj, 'ps3000aGetTimebase', ...
        data.timebase, data.BUFFER_SIZE, ...
        timeIntNs, data.oversample, maxSamples, segmentIndex);

%% Setup Number of Captures and Memory Segments

nCaptures = 10;

% Segment the memory
[mem_segments_status, maxSamples] = invoke(ps3000a_obj, 'ps3000aMemorySegments', ...
    nCaptures);

% Set the number of captures
num_captures_status = invoke(ps3000a_obj, 'ps3000aSetNoOfCaptures', nCaptures);

%% Run Block

preTriggerSamples = 0;
postTriggerSamples = data.BUFFER_SIZE - preTriggerSamples;
segmentIndex = 0;

% Prompt to press a key to begin capture
input_str = input('Press ENTER to begin data collection.', 's');

% Run block and retry if power source not set correctly
retry = 1;

while retry == 1
    
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
[status, ready] = invoke(ps3000a_obj, 'ps3000aIsReady')

while ready == 0
   
    [status, ready] = invoke(ps3000a_obj, 'ps3000aIsReady');
    pause(1);
end

fprintf('Ready: %d\n', ready);
disp('Capture complete.');

%% Stop the device

stop_status = invoke(ps3000a_obj, 'ps3000aStop');

%% Get Number of Captures

[num_captures_status, nCompleteCaptures] = invoke(ps3000a_obj, 'ps3000aGetNoOfCaptures');

% Only show blocks that were captured

nCaptures = nCompleteCaptures;

%% Set Data Buffer and Get Values

channelA_range = enuminfo.enPS3000AChannel.PS3000A_CHANNEL_A;
buffer_length = preTriggerSamples + postTriggerSamples;
buffer_ratio_mode = enuminfo.enPS3000ARatioMode.PS3000A_RATIO_MODE_NONE;

pBufferChA = libpointer('int16Ptr', zeros(buffer_length, nCompleteCaptures));

% Obtain data values for each capture, setting the data buffer in turn.
for i = 1 : nCaptures
    
    fprintf('Capture %d:\n', i);
    
    temp_buffer = libpointer('int16Ptr', zeros(buffer_length, 1));
    
    status_set_db = invoke(ps3000a_obj, 'ps3000aSetDataBuffer', ... 
        channelA_range, temp_buffer, ...
        buffer_length, i - 1, buffer_ratio_mode);

    %channelA_range, pBufferChA.value(:, i), ...
    disp('SetDataBuffer: Ch. A')
    status
    
    % channelB = enuminfo.enPS3000AChannel.PS3000A_CHANNEL_B;
    % 
    % status = invoke(ps3000a_obj, 'ps3000aSetDataBuffer', ... 
    %     ps3000a_obj.unithandle, channelB, pBufferChB, data.BUFFER_SIZE, 0, 0);
    % 
    % disp('SetDataBuffer: Ch. B')
    % status

    startIndex = 0;
    downSampleRatio = 1;
    downSampleRatioMode = enuminfo.enPS3000ARatioMode.PS3000A_RATIO_MODE_NONE;
    overflow = 0;

    % Get Values
    
    [get_values_status, numSamples, overflow] = invoke(ps3000a_obj, ...
        'ps3000aGetValues', startIndex, ...
        buffer_length, downSampleRatio, downSampleRatioMode, ...
        i - 1, overflow)
    
    if(get_values_status ~= PicoStatus.PICO_OK)
    
        % Check if Power Status issue
        if(get_values_status == PicoStatus.PICO_POWER_SUPPLY_CONNECTED || ...
            get_values_status == PicoStatus.PICO_POWER_SUPPLY_NOT_CONNECTED || ...
                get_values_status == PicoStatus.PICO_POWER_SUPPLY_UNDERVOLTAGE)

            if(get_values_status == PicoStatus.PICO_POWER_SUPPLY_UNDERVOLTAGE)

                pwr_status = ps3000aChangePowerSource(ps3000a_obj, get_values_status)
                %pwr_status = invoke(ps3000a_obj, 'ChangePowerSource', get_values_status);

            else

                fprintf('Power Source Changed. Data collection aborted.\n');
                plotData = data.FALSE;

            end

        else

            fprintf('ps3000aGetValues status: 0x%X', get_values_status);
            plotData = data.FALSE;

        end
        
    else
        
        fprintf('Assigning data to buffer.\n\n')
        pBufferChA.value(:, i) = temp_buffer.value(:, 1);

    end

end

%% Convert data values to milliVolt values

disp('Converting data to milliVolts...')

voltage_range_chA = data.inputRangesmV(channelSettings(1).range + 1);
%voltage_range_chB = data.inputRangesmV(channelSettings(2).range + 1);

% Buffers to hold data values

buffer_a = get(pBufferChA, 'Value');
%buffer_b = get(pBufferChB, 'Value');

buffer_a_mv = zeros(numSamples, nCaptures);
%buffer_b_mv = zeros(numSamples, nCaptures);

for m = 1 : nCaptures
    
    buffer_a_mv(:, m) = adc2mv(buffer_a(:, m), voltage_range_chA, ps3000a_obj.maxValue);

    %buffer_b_mv(:, m) = adc2mv(buffer_b(:, m), voltage_range_chB, ps3000a_obj.maxValue);
    
end

pause(2.0);
%% Plot data
% This plots the 10 waveforms on a 5 x 2 grid - if nCaptures is set to 
% another value this may require adjustment such as separating graphs onto
% other figures.
disp('Plotting data...')
figure;

% Time axis
t_ns = double(timeIntNs1) * double([0: downSampleRatio : numSamples - 1]);
t = t_ns / 1000000;

% Number of columns in plot
numColumns = 2;

% Calculate number of rows for the grid
if(mod(nCaptures, numColumns) == 0)
    
    numRows = double(nCaptures / numColumns);
    
else 
    
    numRows = double((nCaptures + 1) / numColumns);
    
end

for i = 1 : nCaptures
        
    plot_a_axes = subplot(numRows, numColumns, double(i)); 
    
    plot(t, buffer_a_mv(:, i));
    title(strcat(['Channel A - Waveform ', num2str(i)]));
    xlabel('Time (ms)');
    
    if(data.scaleVoltages == data.TRUE)
        
        ylabel(plot_a_axes, 'Voltage (mV)');
        
    else
       
        ylabel(plot_a_axes, 'ADC Counts');
        
    end

    % plot_b_axes = subplot(2,1,2); 
    % plot(t, buffer_b_mv);
    % title('Channel B');
    % xlabel('Time (ms)');
    % if(data.scaleVoltages == data.TRUE)
    %             
    %     ylabel(plot_b_axes, 'Voltage (mV)');
    %         
    % else
    %        
    %     ylabel(plot_b_axes, 'ADC Counts');
    %         
    % end
    
end

%% Disconnect device

disconnect(ps3000a_obj);