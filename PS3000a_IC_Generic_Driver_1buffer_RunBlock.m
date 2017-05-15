%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Filename:    PS3000A_IC_Generic_Driver_1buffer_RunBlock
%
% Copyright:   Pico Technology Limited 2012 - 2014
%
% Author:      HSM
%
% Description:
%   This is a MATLAB script that demonstrates how to use the
%   PicoScope 3000a series Instrument Control Toobox driver to collect a 
%   block of samples immediately with 1 data buffer per channel.
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
%addpath('C:\Pico SDK\PS3000asdk_r10_5_0_32') %- Path to dlls
addpath('..\');
addpath('..\Functions');

%% Load in PicoStatus values

PicoStatus;

%% Declare variables

global data;

data.TRUE = 1;
data.FALSE = 0;

data.BUFFER_SIZE = 1024;

% Data Buffers

pBufferChA = libpointer('int16Ptr',zeros(1024,1));
pBufferChB = libpointer('int16Ptr',zeros(1024,1));

data.timebase = 12502;  % 5kS/s for 320XA/B, 10kS/s for 340XA/B
data.oversample = 1;

data.scaleVoltages = data.TRUE;
data.inputRangesmV = [10, 20, 50, 100, 200, 500, 1000, 2000, 5000, 10000, 20000];

plotData = data.TRUE;

%% Device Connection

% Create device
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
channelSettings(2).enabled = data.TRUE;
channelSettings(2).DCCoupled = data.TRUE;
channelSettings(2).range = enuminfo.enPS3000ARange.PS3000A_1V;

if (ps3000a_obj.channelCount == 4)
    
    % Channel C
    channelSettings(3).enabled = data.FALSE;
    channelSettings(3).DCCoupled = data.TRUE;
    channelSettings(3).range = enuminfo.enPS3000ARange.PS3000A_1V;

    % Channel D
    channelSettings(4).enabled = data.FALSE;
    channelSettings(4).DCCoupled = data.TRUE;
    channelSettings(4).range = enuminfo.enPS3000ARange.PS3000A_1V;

end

%% Set Defaults for Channels

status_set_defaults = invoke(ps3000a_obj, 'setDefaults', channelSettings);

%% Set Simple Trigger

enable = data.TRUE;
source = enuminfo.enPS3000AChannel.PS3000A_CHANNEL_A;
threshold = mv2adc(500, data.inputRangesmV(channelSettings(1).range + 1), ps3000a_obj.maxValue);
direction = enuminfo.enPS3000AThresholdDirection.PS3000A_RISING;
delay = 0;              
autoTrigger_ms = 0; % Wait indefinitely

trigger_status = invoke(ps3000a_obj, 'ps3000aSetSimpleTrigger', ...
    enable, source, threshold, direction, delay, autoTrigger_ms)

%% Set Data Buffers

channelA = enuminfo.enPS3000AChannel.PS3000A_CHANNEL_A;

status = invoke(ps3000a_obj, 'ps3000aSetDataBuffer', ... 
    channelA, pBufferChA, data.BUFFER_SIZE, 0, 0);

disp('SetDataBuffer: Ch. A')
status

channelB = enuminfo.enPS3000AChannel.PS3000A_CHANNEL_B;

status = invoke(ps3000a_obj, 'ps3000aSetDataBuffer', ... 
    channelB, pBufferChB, data.BUFFER_SIZE, 0, 0);

disp('SetDataBuffer: Ch. B')
status

%% Set Timebase

timeIndisposed = 0;
maxSamples = data.BUFFER_SIZE;
timeIntNs = 0;
segmentIndex = 0;

[get_timebase2_status, timeIntNs1, maxSamples1] = invoke(ps3000a_obj, 'ps3000aGetTimebase2', ...
        data.timebase, data.BUFFER_SIZE, ...
        timeIntNs, data.oversample, maxSamples, segmentIndex);
    
disp('Timebase')
data.timebase

get_timebase2_status
timeIntNs1
maxSamples

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
[ready_status, ready] = invoke(ps3000a_obj, 'ps3000aIsReady')

while(ready == 0)
   
    [ready_status, ready] = invoke(ps3000a_obj, 'ps3000aIsReady');
    pause(1);
end

fprintf('Ready: %d\n', ready);
disp('Data collected');


%% Get Values

startIndex = 0;
downSampleRatio = 1;
downSampleRatioMode = enuminfo.enPS3000ARatioMode.PS3000A_RATIO_MODE_NONE;
segmentIndex = 0;
overflow_ptr = 0;

[get_values_status, numSamples, overflow] = invoke(ps3000a_obj, 'ps3000aGetValues', ...
    startIndex, data.BUFFER_SIZE, downSampleRatio, downSampleRatioMode, ...
    segmentIndex, overflow_ptr)

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

%% Stop the device

stop_status = invoke(ps3000a_obj, 'ps3000aStop');

%% Convert data values to milliVolt values

disp('Converting data to milliVolts...')

voltage_range_chA = data.inputRangesmV(channelSettings(1).range + 1);
voltage_range_chB = data.inputRangesmV(channelSettings(2).range + 1);

% Buffers to hold data values

buffer_a = get(pBufferChA, 'Value');
buffer_b = get(pBufferChB, 'Value');

% Convert to milliVolts
buffer_a_mv = adc2mv(buffer_a(1:numSamples), voltage_range_chA, ps3000a_obj.maxValue);
buffer_b_mv = adc2mv(buffer_b(1:numSamples), voltage_range_chB, ps3000a_obj.maxValue);

%% Plot data

if(plotData == data.TRUE)

    disp('Plotting data...')
    figure;

    % Time axis
    t_ns = double(timeIntNs1) * double([0:numSamples - 1]);
    t = t_ns / 1000000;

    plot_a_axes = subplot(2,1,1); 
    plot(t, buffer_a_mv);
    title('Channel A');
    xlabel('Time (ms)');
    ylabel(plot_a_axes, 'Voltage (mV)');

    plot_b_axes = subplot(2,1,2); 
    plot(t, buffer_b_mv, 'r-');
    title('Channel B');
    xlabel('Time (ms)');
    ylabel(plot_b_axes, 'Voltage (mV)');

end

%% Disconnect device

disconnect(ps3000a_obj);