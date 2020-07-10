%% PicoScope 3000 Series Instrument Driver Mixed Signal Oscilloscope Block Data Capture Example
% This is an example of an instrument control session using a device 
% object. The instrument control session comprises  all the steps you 
% are likely to take when communicating with your instrument. 
%
% These steps are:
%
%
% # Create a device object   
% # Connect to the instrument 
% # Configure properties 
% # Invoke functions 
% # Disconnect from the instrument 
%  
% To run the instrument control session, type the name of the file,
% PS3000A_ID_Block_MSO_Example, at the MATLAB command prompt.
% 
% The file, PS3000A_ID_BLOCK_MSO_EXAMPLE.M must be on your MATLAB PATH. For
% additional information on setting your MATLAB PATH, type 'help addpath'
% at the MATLAB command prompt.
%
% *Example:*
%     PS3000A_ID_Block_MSO_Example;
%
% *Description:* 
%   Demonstrates how to call functions in order to capture a
%   block of data from a PicoScope 3000 Series Mixed Signal Oscilloscope
%   using the underlying 'A' API.
%
% See also ICDEVICE.
%
% *Copyright:*  Pico Technology Limited 2014 - 2015
%
% *Author: KPV*

%% Suggested Test Input Signals
% This example was published using the following test signals:
%
% * Channels A and B: 2Vpp, 200Hz sine wave
% * Channels C and D: 4Vpp, 200Hz square wave (4-channel oscilloscope/MSO models only)
% * Digital Channels D0 - D7: Test pattern output with base frequency of 2kHz

%% Clear Command Window

clc;

%% Load Configuration Information

PS3000aConfig;

%% Device Connection

% Create a device object. 
% The serial number can be specified as a second input parameter.
ps3000aDeviceObj = icdevice('picotech_ps3000a_generic.mdd', '');

% Connect device object to hardware.
connect(ps3000aDeviceObj)

%% Set Analogue Channels and Digital Ports
% Default driver settings applied to analogue and digital channels are
% listed below - use ps3000aSetChannel to turn analogue channels on or off
% and set voltage ranges, coupling, as well as analogue offset.

% In this example, data is collected on all Analogue Channels using 
% default settings and also on the Digital Port 0 channels (D0 - D7)
% while Digital Port 1 (D8 - D15) is switched off.

% Channels       : 0 - 3 (ps3000aEnuminfo.enPS3000AChannel.PS3000A_CHANNEL_A - PS3000A_CHANNEL_D)
% Enabled        : 1
% Type           : 1 (ps3000aEnuminfo.enPS3000ACoupling.PS3000A_DC)
% Range          : 8 (ps3000aEnuminfo.enPS3000ARange.PS3000A_5V)
% Analogue Offset: 0.0

% Use ps3000aSetDigitalPort to enable/disable digital ports and set the 
% logic level threshold. This function is located in the Instrument
% Driver's Digital Group. Enabling a digital port will enable all channels
% on that port.

digitalGroupObj = get(ps3000aDeviceObj,'Digital');

% Digital Port  : 128 (ps3000aEnuminfo.enPS3000ADigitalPort.PS3000A_DIGITAL_PORT0)
% Enabled       : 1 (On)
% Logic Level   : 2.5V

status.setD0 = invoke(digitalGroupObj, 'ps3000aSetDigitalPort', evalin('base', 'ps3000aEnuminfo.enPS3000ADigitalPort.PS3000A_DIGITAL_PORT0'), 1, 2.5);

% Digital Port  : 129 (ps3000aEnuminfo.enPS3000ADigitalPort.PS3000A_DIGITAL_PORT1)
% Enabled       : 0 (Off)
% Logic Level   : 0V

status.setD1 = invoke(digitalGroupObj, 'ps3000aSetDigitalPort', evalin('base', 'ps3000aEnuminfo.enPS3000ADigitalPort.PS3000A_DIGITAL_PORT1'), 0, 0);

%% Verify Timebase Index and Maximum Number of Samples
% Driver default timebase index used - use ps3000aGetTimebase2 to query the
% driver as to suitability of using a particular timebase index and the
% maximum number of samples available in the buffer memory then set the
% 'timebase' property if required.
%
% The fastest sampling interval possible will depend on the number of
% analogue channels and digital ports in use.
%
% Use a while loop to query the function until the status indicates that a
% valid timebase index has been selected. In this example, the timebase 
% index of 3 is valid. 

% timebase     : 3
% segment index: 0

status.getTimebase2 = PicoStatus.PICO_INVALID_TIMEBASE;
timebaseIndex = 3;

while(status.getTimebase2 == PicoStatus.PICO_INVALID_TIMEBASE)
    
    [status.getTimebase2, timeIntervalNanoSeconds, maxSamples] = invoke(ps3000aDeviceObj, 'ps3000aGetTimebase2', timebaseIndex, 0);
    
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

%% Set Block Parameters and Capture Data
% Capture a block of data and retrieve data values for all enabled analogue
% channels and digital channels.

% Block data acquisition properties and functions are located in the 
% Instrument Driver's Block group.

blockObj = get(ps3000aDeviceObj, 'Block');
blockObj = blockObj(1);

% Set pre-trigger and post-trigger samples as required
% The default of 0 pre-trigger and 1 million post-trigger samples is used
% in this example.

% set(ps3000aDeviceObj, 'numPreTriggerSamples', 0);
% set(ps3000aDeviceObj, 'numPostTriggerSamples', 2e6);

% Capture a block of data:
%
% segment index: 0 (The buffer memory is not segmented in this example)

[status.runBlock] = invoke(blockObj, 'runBlock', 0);

% Retrieve data values:
%
% start index       : 0
% segment index     : 0
% downsampling ratio: 1
% downsampling mode : 0 (ps3000aEnuminfo.enPS3000ARatioMode.PS3000A_RATIO_MODE_NONE)

[numSamples, overflow, chA, chB, chC, chD, portD0, portD1] = invoke(blockObj, 'getBlockData', 0, 0, 1, 0);

% Stop the device

[status.stop] = invoke(ps3000aDeviceObj, 'ps3000aStop');

%% Convert Digital Data to Binary Format
% Each sample value for a digital port is returned as a 16-bit integer 
% with the data in the lower 8-bits of the 16-bit value. The values are 
% Most Significant Bit (MSB) ordered.

% Allocate memory for the digital channels for Digital Port 0.
D0 = zeros(numSamples, 8);

disp('Converting digital data into binary array...');

% Use the bitget function to retrieve the bit value corresponding to the
% channel. This process may take a little while depending on the number of
% samples collected.
for sample = 1:numSamples

    D0(sample,:)= bitget(portD0(sample), 8:-1:1, 'int16');
    
end

disp('Digital data conversion complete.');

%% Plot data
% Plot data values returned from the device.

% Calculate time (nanoseconds) and convert to milliseconds. 
% Use timeIntervalNanoSeconds output from ps3000aGetTimebase2 or calculate
% using the PicoScope 3000 Series A (API) PC Oscilloscopes and MSOs
% Programmer's Guide.

timeNs = double(timeIntervalNanoSeconds) * double(0:numSamples - 1);
timeMs = timeNs / 1e6;

% Plot Analogue Data

figure1 = figure('Name','PicoScope 3000 Series Block Mode Capture - Analogue Channels', ...
    'NumberTitle','off');

movegui(figure1, 'northwest');

% Find the number of analogue channels on the device
numAnalogueChannels = get(ps3000aDeviceObj, 'channelCount');
numColumns = numAnalogueChannels / 2;

% Channel A
axisHandleChA = subplot(2, numColumns, 1); 
plot(axisHandleChA, timeMs, chA, 'b');
title(axisHandleChA, 'Channel A', 'FontWeight', 'bold');
xlabel(axisHandleChA, 'Time (ms)');
ylabel(axisHandleChA, 'Voltage (mV)');
grid(axisHandleChA);

% Channel B
axisHandleChB = subplot(2, numColumns, 2); 
plot(axisHandleChB, timeMs, chB, 'r');
title(axisHandleChB, 'Channel B', 'FontWeight', 'bold');
xlabel(axisHandleChB, 'Time (ms)');
ylabel(axisHandleChB, 'Voltage (mV)');
grid(axisHandleChB);

if(numAnalogueChannels == PicoConstants.QUAD_SCOPE)
    
    % Channel C
    axisHandleChC = subplot(2, numColumns, 3); 
    plot(axisHandleChC, timeMs, chC, 'g');
    title(axisHandleChC, 'Channel C', 'FontWeight', 'bold');
    xlabel(axisHandleChC, 'Time (ms)');
    ylabel(axisHandleChC, 'Voltage (mV)');
    grid(axisHandleChC);

    % Channel D
    axisHandleChD = subplot(2, numColumns, 4); 
    plot(axisHandleChD, timeMs, chD, 'y');
    title(axisHandleChD, 'Channel D', 'FontWeight', 'bold');
    xlabel(axisHandleChD, 'Time (ms)');
    ylabel(axisHandleChD, 'Voltage (mV)');
    grid(axisHandleChD);

end

% Plot Digital Data

figure2 = figure('Name','PicoScope 3000 Series Block Mode Capture - Digital Channel Data', ...
    'NumberTitle','off');

movegui(figure2, 'northeast');

for i = 0:7
    
    subplot(4, 2, i+1); 
    plot(timeMs, D0(:,(8 - i)));
    title(strcat('Digital Channel D', num2str(i)), 'FontWeight', 'bold');
    xlabel('Time (ms)');
    ylabel('Logic Level');
    axis([-inf, inf, -0.5, 1.5])
    
end

%% Disconnect
disconnect(ps3000aDeviceObj);
