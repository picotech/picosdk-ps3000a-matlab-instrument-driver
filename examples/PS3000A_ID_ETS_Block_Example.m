%% PicoScope 3000 Series Instrument Driver Oscilloscope ETS Block Data Capture Example
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
% PS3000A_ID_ETS_Block_Example, at the MATLAB command prompt.
% 
% The file, PS3000A_ID_ETS_BLOCK_EXAMPLE.M must be on your MATLAB PATH. 
% For additional information on setting your MATLAB PATH, type 
% 'help addpath' at the MATLAB command prompt.
%
% *Example:*
%     PS3000A_ID_ETS_Block_Example;
%
% *Description:*
%     Demonstrates how to call functions in order to capture a block of
%     data using Equivalent Time Sampling from a PicoScope 3000 series 
%     oscilloscope using the underlying 'A' API.   
%
% See also ICDEVICE.
%
% *Copyright:*  Pico Technology Limited 2014 - 2015
%
% *Author:* HSM

%% Suggested Input Test Signal
% This example was published using the following test signal:
%
% * Channel A: 4Vpp, 100kHz square wave

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

%% Set Channels

% Default driver settings applied to channels are listed below - 
% use ps3000aSetChannel to turn channels on or off and set voltage ranges, 
% coupling, as well as analogue offset.

% In this example, data is only collected on Channel A so default settings
% are used and Channel B (as well as Channels C and D (oscilloscopes with 4
% analogue channels only) are switched off.

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

%% Set ETS Mode Parameters
% Set Equivalent Time Sampling Parameters
% The underlying driver will return the sampling interval to be used (in
% picoseconds).

% Block data acquisition properties and functions are located in the 
% Instrument Driver's Block group.

blockGroupObj = get(ps3000aDeviceObj, 'Block');
blockGroupObj = blockGroupObj(1);

mode            = ps3000aEnuminfo.enPS3000AEtsMode.PS3000A_ETS_FAST;
etsCycles       = 20;
etsInterleave   = 4;

[status.setEts, sampleTimePicoSeconds] = invoke(blockGroupObj, 'ps3000aSetEts', mode, etsCycles, etsInterleave);

%% Verify Maximum Samples
% Driver default timebase index used for calling the ps3000aGetTimebase2
% function to query the driver as to the maximum number of samples
% available in the buffer memory. The sample time for ETS mode is returned
% in the call to ps3000aSetEts above.
%
% To use the fastest sampling interval possible, set one analogue channel
% and turn off all other channels.
%

% timebase     : 64 (default)
% segment index: 0

timebaseIndex = get(ps3000aDeviceObj, 'timebase');

[status.getTimebase2, timeIntervalNanoSeconds, maxSamples] = invoke(ps3000aDeviceObj, 'ps3000aGetTimebase2', timebaseIndex, 0);
  
%% Set Simple Trigger
% Set a trigger on Channel A - the default value for delay is used. The
% autoTriggerMs property is ignored.

% Trigger properties and functions are located in the Instrument Driver's
% Trigger group.

triggerObj = get(ps3000aDeviceObj, 'Trigger');
triggerObj = triggerObj(1);

% Channel     : 0 (ps3000aEnuminfo.enPS3000AChannel.PS3000A_CHANNEL_A)
% Threshold   : 1000 (mV)
% Direction   : 2 (ps3000aEnuminfo.enPS3000AThresholdDirection.PS3000A_RISING)

[status.setSimpleTrigger] = invoke(triggerObj, 'setSimpleTrigger', 0, 1000, 2);

%% Set Block Parameters and Capture Data
% Capture a block of data and retrieve data values for Channel A.

% Set pre-trigger and post-trigger samples as required.

set(ps3000aDeviceObj, 'numPreTriggerSamples', 5000);
set(ps3000aDeviceObj, 'numPostTriggerSamples', 5000);

% Capture a block of data:
%
% segment index: 0 (The buffer memory is not segmented in this example)

[status.runBlock] = invoke(blockGroupObj, 'runBlock', 0);

% Retrieve data values:
%
% start index       : 0
% segment index     : 0
% downsampling ratio: 1
% downsampling mode : 0 (ps3000aEnuminfo.enPS3000ARatioMode.PS3000A_RATIO_MODE_NONE)

[numSamples, overflow, etsTimes, chA, ~, ~, ~] = invoke(blockGroupObj, 'getEtsBlockData', 0, 0, 1, 0);

% Stop the device
[status.stop] = invoke(ps3000aDeviceObj, 'ps3000aStop');

%% Plot data
% Plot data values returned from the device.

figure1 = figure('Name','PicoScope 3000 Series Example - ETS Block Mode Capture', ...
    'NumberTitle', 'off');

% Channel A
plot(etsTimes, chA, 'b');
title('Channel A', 'FontWeight', 'bold');
xlabel('Time (fs)');
ylabel('Voltage (mV)');
grid on;

%% Turn off ETS Mode
% If another operation is required that does not require Equivalent Time
% Sampling of data, turn ETS mode off.

mode            = ps3000aEnuminfo.enPS3000AEtsMode.PS3000A_ETS_OFF;
etsCycles       = 20;
etsInterleave   = 4;

[status.setEts, sampleTimePicoSeconds] = invoke(blockGroupObj, 'ps3000aSetEts', mode, etsCycles, etsInterleave);

%% Disconnect
disconnect(ps3000aDeviceObj);
