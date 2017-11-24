%% PicoScope 3000 Series Instrument Driver Oscilloscope Rapid Block Data Capture Example
% This is an example of an instrument control session using a device 
% object. The instrument control session comprises  all the steps you 
% are likely to take when communicating with your instrument. 
%
% These steps are:
%       
% # Create a device object   
% # Connect to the instrument 
% # Configure properties 
% # Invoke functions 
% # Disconnect from the instrument 
%  
% To run the instrument control session, type the name of the file,
% PS3000A_ID_Rapid_Block_Plot3D_Example, at the MATLAB command
% prompt.
% 
% The file, PS3000A_IC_GENERIC_DRIVER_BLOCK_PLOT3D.M must be on your MATLAB
% PATH. For additional information on setting your MATLAB PATH, type 'help
% addpath' at the MATLAB command prompt.
%
% *Example:*
%     PS3000A_ID_Rapid_Block_Plot3D_Example;
%
% *Description:*
%     Demonstrates how to call functions in order to capture data in Rapid
%     Block Mode from a PicoScope 3000 Series Oscilloscope using the
%     underlying 'A' API.
%
% See also ICDEVICE.
%
% *Copyright:*  Pico Technology Limited 2014 - 2015
%
% *Author:* HSM

%% Suggested Input Test Signal
% This example was published using the following test signal:
%
% * 4Vpp, Swept sine wave on Channel A (Start: 200Hz, Stop: 1kHz, Sweep type: Up, Increment: 50Hz, Increment Time: 5ms)

%% Clear Command Window

clc;

%% Load Configuration Information

PS3000aConfig;

%% Device Connection

% Create a device object. 
% The serial number can be specified as a second input parameter.
ps3000aDeviceObj = icdevice('picotech_ps3000a_generic.mdd', '');

% Connect device object to hardware.
connect(ps3000aDeviceObj);

%% Set Channels
% Default driver settings applied to channels are listed below - use
% ps3000aSetChannel to turn channels on or off and set voltage ranges,
% coupling, as well as analogue offset.

% In this example, data is only collected on Channel A so default settings
% are used and channels B (and C to D for 4-channel devices) are switched
% off.

% Channels       : 1 - 3 (ps3000aEnuminfo.enPS3000AChannel.PS3000A_CHANNEL_B - PS3000A_CHANNEL_D)
% Enabled        : 0
% Type           : 1 (ps3000aEnuminfo.enPS3000ACoupling.PS3000A_DC)
% Range          : 8 (ps3000aEnuminfo.enPS3000ARange.PS3000A_5V)
% Analogue Offset: 0.0

[status.setChB] = invoke(ps3000aDeviceObj, 'ps3000aSetChannel', 1, 0, 1, 8, 0.0);

if(ps3000aDeviceObj.channelCount == PicoConstants.QUAD_SCOPE)
    
    [status.setChC] = invoke(ps3000aDeviceObj, 'ps3000aSetChannel', 2, 0, 1, 8, 0.0);
    [status.setChD] = invoke(ps3000aDeviceObj, 'ps3000aSetChannel', 3, 0, 1, 8, 0.0);
    
end

%% Set Memory Segments
% Configure number of memory segments and query ps3000aGetMaxSegments to
% find the maximum number of samples for each segment.

% nSegments : 128

[status.memorySegments, nMaxSamples] = invoke(ps3000aDeviceObj, 'ps3000aMemorySegments', 128);

% Set number of pre- and post-trigger samples to collect. Ensure that the
% total does not exceeed nMaxSamples above.

set(ps3000aDeviceObj, 'numPreTriggerSamples', 2500);
set(ps3000aDeviceObj, 'numPostTriggerSamples', 7500);

%% Verify Timebase Index and Maximum Number of Samples
% Use ps3000aGetTimebase2 to query the driver as to suitability of using a
% particular timebase index then set the 'timebase' property if required.

% timebase      : 42
% segment index : 0

status.getTimebase2 = PicoStatus.PICO_INVALID_TIMEBASE;
timebaseIndex = 42;

while(status.getTimebase2 == PicoStatus.PICO_INVALID_TIMEBASE)
    
    [status.getTimebase2, timeIntNs, maxSamples] = invoke(ps3000aDeviceObj, 'ps3000aGetTimebase2', timebaseIndex, 0);
    
    if(status.getTimebase2 == PicoStatus.PICO_OK)
       
        break;
        
    else
        
        timebaseIndex = timebaseIndex + 1;
        
    end

end

set(ps3000aDeviceObj, 'timebase', timebaseIndex);

%% Set Simple Trigger 
% Set a trigger on Channel A with an auto timeout - the default value for
% delay is used.

% Trigger properties and functions are located in the Instrument
% Driver's Trigger group.

triggerGroupObj = get(ps3000aDeviceObj, 'Trigger');
triggerGroupObj = triggerGroupObj(1);

% Set the autoTriggerMs property in order to automatically trigger the
% oscilloscope after 1 second if a trigger event has not occurred. Set to 0
% to wait indefinitely for a trigger event.

set(triggerGroupObj, 'autoTriggerMs', 1000);

% Channel     : 0 (ps3000aEnuminfo.enPS3000AChannel.PS3000A_CHANNEL_A)
% Threshold   : 500 (mV)
% Direction   : 2 (ps3000aEnuminfo.enPS3000AThresholdDirection.PS3000A_RISING)

[status.setSimpleTrigger] = invoke(triggerGroupObj, 'setSimpleTrigger', 0, 500, 2);

%% Setup Rapid Block Parameters and Capture Data

% Rapid Block specific properties and functions are located in the Instrument
% Driver's Rapidblock group.

rapidBlockGroupObj = get(ps3000aDeviceObj, 'Rapidblock');
rapidBlockGroupObj = rapidBlockGroupObj(1);

% Set the number of waveforms to captures

% nCaptures : 16

[status.setNoOfCaptures] = invoke(rapidBlockGroupObj, 'ps3000aSetNoOfCaptures', 16);

% Block specific properties and functions are located in the Instrument
% Driver's Block group.

blockGroupObj = get(ps3000aDeviceObj, 'Block');
blockGroupObj = blockGroupObj(1);

% Capture the blocks of data

% segmentIndex : 0 

[status.runBlock, timeIndisposedMs] = invoke(blockGroupObj, 'runBlock', 0);

% Retrieve Rapid Block Data - only data for Channel A is required

% numCaptures : 16
% ratio       : 1
% ratioMode   : 0 (ps3000aEnuminfo.enPS3000ARatioMode.PS3000A_RATIO_MODE_NONE)

[numSamples, overflow, chA, ~, ~, ~] = invoke(rapidBlockGroupObj, 'getRapidBlockData', 16, 1, 0);

% Stop the Device
[status.stop] = invoke(ps3000aDeviceObj, 'ps3000aStop');

%% Process data
% Plot data values in 3D showing history of the waveforms collected.

% Calculate time (nanoseconds) and convert to milliseconds. 
% Use timeIntervalNanoSeconds output from ps3000aGetTimebase2 or calculate
% using the PicoScope 3000 Series A (API) PC Oscilloscopes and MSOs
% Programmer's Guide.

timeNs = double(timeIntNs) * double(0:numSamples - 1);

% Channel A
figure1 = figure('Name','PicoScope 3000 Series Example - Rapid Block Mode Capture', ...
    'NumberTitle','off');

axes1 = axes('Parent', figure1);
view(axes1,[-15 24]);
grid(axes1,'on');
hold(axes1,'all');

for i = 1:16
    
    plot3(timeNs, i * (ones(numSamples, 1)), chA(:, i));
    
end

title('Rapid Block Data Acquisition - Channel A');
xlabel('Time (ns)');
ylabel('Capture');
zlabel('Voltage (mV)');

hold off;

%% Disconnect Device

% Disconnect device object from hardware.
disconnect(ps3000aDeviceObj);
