%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Filename:    PS3000A_IC_Generic_Driver_1buffer_RunBlock_Adv_Trig
%
% Copyright:   Pico Technology Limited 2012 - 2014
%
% Author:      HSM
%
% Description:
%   This is a MATLAB script that demonstrates how to use the
%   PicoScope 3000a series Instrument Control Toobox driver to collect a 
%   block of samples immediately with 1 data buffer per channel 
%   with Advanced Trigger.
%
%	To run this application:
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

%% Load config file

PS3000aConfig;

%% Declare variables

global data;

data.TRUE = 1;
data.FALSE = 0;

data.BUFFER_SIZE = 1024;

%data.timebase = 627; % 100kS/s for 320XA/B
data.timebase = 1252; % 100kS/s for 340XA/B
data.oversample = 1;

data.scaleVoltages = data.TRUE;
data.inputRangesmV = [10, 20, 50, 100, 200, 500, 1000, 2000, 5000, 10000, 20000];

% Data Buffers

pBufferChA = libpointer('int16Ptr',zeros(1024,1));
pBufferChB = libpointer('int16Ptr',zeros(1024,1));

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

channelA = enuminfo.enPS3000AChannel.PS3000A_CHANNEL_A;
voltage_range_chA = data.inputRangesmV(channelSettings(1).range + 1);

% Channel B
channelSettings(2).enabled = data.TRUE;
channelSettings(2).DCCoupled = data.TRUE;
channelSettings(2).range = enuminfo.enPS3000ARange.PS3000A_1V;

channelB = enuminfo.enPS3000AChannel.PS3000A_CHANNEL_B;
voltage_range_chB = data.inputRangesmV(channelSettings(2).range + 1);

if (ps3000a_obj.channelCount == 4)
    
    % Channel C
    channelSettings(3).enabled = data.FALSE;
    channelSettings(3).DCCoupled = data.TRUE;
    channelSettings(3).range = enuminfo.enPS3000ARange.PS3000A_1V;

    voltage_range_chC = data.inputRangesmV(channelSettings(3).range + 1);

    % Channel D
    channelSettings(4).enabled = data.FALSE;
    channelSettings(4).DCCoupled = data.TRUE;
    channelSettings(4).range = enuminfo.enPS3000ARange.PS3000A_1V;

    voltage_range_chD = data.inputRangesmV(channelSettings(4).range + 1);

end

%% Set Defaults for Channels

invoke(ps3000a_obj, 'setDefaults', channelSettings);

%% Set Advanced Trigger

% This example shows a trigger on Channel A OR Channel B
triggerDelay = 0;
auxOutputEnabled = 0;
autoTrigger_ms = 10000; 

% Trigger Channel Properties
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Channel A
trig_ch_a_properties =  structs.tPS3000ATriggerChannelProperties.members;

trig_ch_a_properties.thresholdUpper = mv2adc(500, voltage_range_chA, ps3000a_obj.maxValue);
trig_ch_a_properties.thresholdUpperHysteresis = 32;
trig_ch_a_properties.thresholdLower = mv2adc(480, voltage_range_chA, ps3000a_obj.maxValue);
trig_ch_a_properties.thresholdLowerHysteresis = 32;
trig_ch_a_properties.channel = channelA;
trig_ch_a_properties.thresholdMode = enuminfo.enPS3000A_ThresholdMode.PS3000A_LEVEL;

% Channel B
trig_ch_b_properties =  structs.tPS3000ATriggerChannelProperties.members;

trig_ch_b_properties.thresholdUpper = mv2adc(750, voltage_range_chB, ps3000a_obj.maxValue);
trig_ch_b_properties.thresholdUpperHysteresis = 32;
trig_ch_b_properties.thresholdLower = mv2adc(730, voltage_range_chB, ps3000a_obj.maxValue);
trig_ch_b_properties.thresholdLowerHysteresis = 32;
trig_ch_b_properties.channel = channelB;
trig_ch_b_properties.thresholdMode = enuminfo.enPS3000A_ThresholdMode.PS3000A_LEVEL;

% Combine into struct
triggerChannelProperties(1) = trig_ch_a_properties;
triggerChannelProperties(2) = trig_ch_b_properties;

% Trigger Channel Conditions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

trig_conditions1 =  structs.tPS3000ATriggerConditions.members;

trig_conditions1.channelA = enuminfo.enPS3000ATriggerState.PS3000A_CONDITION_TRUE;
trig_conditions1.channelB = enuminfo.enPS3000ATriggerState.PS3000A_CONDITION_DONT_CARE;
trig_conditions1.channelC = enuminfo.enPS3000ATriggerState.PS3000A_CONDITION_DONT_CARE;
trig_conditions1.channelD = enuminfo.enPS3000ATriggerState.PS3000A_CONDITION_DONT_CARE;
trig_conditions1.external = enuminfo.enPS3000ATriggerState.PS3000A_CONDITION_DONT_CARE;
trig_conditions1.aux = enuminfo.enPS3000ATriggerState.PS3000A_CONDITION_DONT_CARE;
trig_conditions1.pulseWidthQualifier = enuminfo.enPS3000ATriggerState.PS3000A_CONDITION_DONT_CARE;

trig_conditions2 =  structs.tPS3000ATriggerConditions.members;

trig_conditions2.channelA = enuminfo.enPS3000ATriggerState.PS3000A_CONDITION_DONT_CARE;
trig_conditions2.channelB = enuminfo.enPS3000ATriggerState.PS3000A_CONDITION_TRUE;
trig_conditions2.channelC = enuminfo.enPS3000ATriggerState.PS3000A_CONDITION_DONT_CARE;
trig_conditions2.channelD = enuminfo.enPS3000ATriggerState.PS3000A_CONDITION_DONT_CARE;
trig_conditions2.external = enuminfo.enPS3000ATriggerState.PS3000A_CONDITION_DONT_CARE;
trig_conditions2.aux = enuminfo.enPS3000ATriggerState.PS3000A_CONDITION_DONT_CARE;
trig_conditions2.pulseWidthQualifier = enuminfo.enPS3000ATriggerState.PS3000A_CONDITION_DONT_CARE;

% Combine trigger conditions into struct - in this case Channel A OR
% Channel B
triggerConditions(1) = trig_conditions1;
triggerConditions(2) = trig_conditions2;

% Pulse Width Qualifer
%%%%%%%%%%%%%%%%%%%%%%

pulseWidth = structs.tPS3000APwqConditions.members;

pulseWidth.channelA = enuminfo.enPS3000ATriggerState.PS3000A_CONDITION_DONT_CARE;
pulseWidth.channelB = enuminfo.enPS3000ATriggerState.PS3000A_CONDITION_DONT_CARE;
pulseWidth.channelC = enuminfo.enPS3000ATriggerState.PS3000A_CONDITION_DONT_CARE;
pulseWidth.channelD = enuminfo.enPS3000ATriggerState.PS3000A_CONDITION_DONT_CARE;
pulseWidth.external = enuminfo.enPS3000ATriggerState.PS3000A_CONDITION_DONT_CARE;
pulseWidth.aux = enuminfo.enPS3000ATriggerState.PS3000A_CONDITION_DONT_CARE;

% Directions
%%%%%%%%%%%%

directions.channelA = enuminfo.enPS3000AThresholdDirection.PS3000A_RISING;
directions.channelB = enuminfo.enPS3000AThresholdDirection.PS3000A_RISING;
directions.channelC = enuminfo.enPS3000AThresholdDirection.PS3000A_NONE;
directions.channelD = enuminfo.enPS3000AThresholdDirection.PS3000A_NONE;
directions.external = enuminfo.enPS3000AThresholdDirection.PS3000A_NONE;
directions.aux = enuminfo.enPS3000AThresholdDirection.PS3000A_NONE;

disp('Setting advanced trigger parameters...')

% Set the advanced trigger settings

advancedTriggerStatus = invoke(ps3000a_obj, 'setAdvancedTrigger', ...
    triggerChannelProperties, triggerConditions, ...
    directions, triggerDelay, auxOutputEnabled, autoTrigger_ms);

%% Set Data Buffers

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

preTriggerSamples = 10;
postTriggerSamples = data.BUFFER_SIZE - preTriggerSamples;
segmentIndex = 0;

% Prompt to press ENTER key to begin capture

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
            
            fprintf('ps3000aRunBlock status: 0x%X', run_block_status);
            
        end
        
    else
        
        retry = 0;
        
    end
    
end

% Confirm if device is ready
[ready_status, ready] = invoke(ps3000a_obj, 'ps3000aIsReady')

while ready == 0
   
    [ready_status, ready] = invoke(ps3000a_obj, 'ps3000aIsReady');
    pause(1);
    
end

fprintf('Ready: %d\n', ready);
disp('Data collected.');

%% Stop the device

stop_status = invoke(ps3000a_obj, 'ps3000aStop');

%% Get Values

startIndex = 0;
downSampleRatio = 1;
downSampleRatioMode = enuminfo.enPS3000ARatioMode.PS3000A_RATIO_MODE_NONE;
segmentIndex = 0;
overflow_ptr = 0

[get_values_status, numSamples, overflow] = invoke(ps3000a_obj, 'ps3000aGetValues', ...
    startIndex, data.BUFFER_SIZE, downSampleRatio, downSampleRatioMode, segmentIndex, overflow_ptr)

if(get_values_status ~= PicoStatus.PICO_OK)
    
    % Check if Power Status issue
    if(get_values_status == PicoStatus.PICO_POWER_SUPPLY_CONNECTED || ...
        get_values_status == PicoStatus.PICO_POWER_SUPPLY_NOT_CONNECTED || ...
            get_values_status == PicoStatus.PICO_POWER_SUPPLY_UNDERVOLTAGE)

        if(get_values_status == PicoStatus.PICO_POWER_SUPPLY_UNDERVOLTAGE)

            %pwr_status = invoke(ps3000a_obj, 'ChangePowerSource', get_values_status);
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

% Buffers to hold data values

buffer_a = get(pBufferChA, 'Value');
buffer_b = get(pBufferChB, 'Value');

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
    plot(t, buffer_b_mv);
    title('Channel B');
    xlabel('Time (ms)');
    ylabel(plot_b_axes, 'Voltage (mV)');

end

%% Disconnect device

disconnect(ps3000a_obj);