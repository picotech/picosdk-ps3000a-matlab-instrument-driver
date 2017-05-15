%% PicoScope 3000 Series Instrument Driver Mixed Signal Oscilloscope Streaming Data Capture Example
% This is a MATLAB script that demonstrates how to use the PicoScope 3000 Series (A API) Instrument Driver to collect data in 
% streaming mode for 2 analogue channels and 1 digital port without aggregation or use of a trigger.
%
% To run the instrument control session, type the name of the file, PS3000A_ID_Streaming_MSO_Example, at the MATLAB command prompt.
%
% *Example:*
%     PS3000A_ID_Streaming_MSO_Example;
%
% *To run this example script:*
% Ensure that the following files/folders are located either in the same directory or define the path in the PS3000aConfig.m file 
% (Drivers (including 64-bit thunk libraries) can be copied to the corresponding architecture folder e.g. win32):
%
% * picotech_ps3000a_generic.mdd
% * ps3000a.dll, picoipp.dll & ps3000aWrap.dll
% * ps3000aMFile.m & ps3000aWrapMFile.m (located in the corresponding architecture folder e.g. win32)
% * PicoConstants.m
% * PicoStatus.m
% * Functions   
%
% See also ICDEVICE.
%
% *Copyright:*   Pico Technology Limited 2014 - 2015
%
% *Author:*      KPV

%% Suggested Input Test Signals
% This example was published using the following test signals:
%
% * Channel A: 4Vpp, 1Hz sine wave
% * Channel B: 2Vpp, 2Hz square wave   
% * Digital Channels D0 - D7: Test pattern output with base frequency of 10Hz   
%

%% Clear Command Window

clc;

%% Load Configuration Information

PS3000aConfig;

%% Parameter Definitions
% Define any parameters that might be required throughout the script.

channelA = ps3000aEnuminfo.enPS3000AChannel.PS3000A_CHANNEL_A;
channelB = ps3000aEnuminfo.enPS3000AChannel.PS3000A_CHANNEL_B;
portD0 = ps3000aEnuminfo.enPS3000ADigitalPort.PS3000A_DIGITAL_PORT0;

% Digital Port 0 definition for the wrapper
wrapperPortD0 = ps3000aWrapEnuminfo.enPS3000AWrapDigitalPortIndex.PS3000A_WRAP_DIGITAL_PORT0;

plotLiveData = PicoConstants.FALSE;

%% Device Connection

% Create device -  specify serial number if required
% Specify serial number as 2nd argument if required.
ps3000aDeviceObj = icdevice('picotech_ps3000a_generic', '');

% Connect device
connect(ps3000aDeviceObj);

%% Display Unit Information

[infoStatus, unitInfo] = invoke(ps3000aDeviceObj, 'getUnitInfo');

unitInfo

%% Set Analogue Channels and Digital Ports
% Default driver settings applied to analogue and digital channels are listed below - 
% use ps3000aSetChannel to turn analogue channels on or off and set voltage ranges, 
% coupling, as well as analogue offset.

% Channels       : 0 - 1 (ps3000aEnuminfo.enPS3000AChannel.PS3000A_CHANNEL_A - PS3000A_CHANNEL_B)
% Enabled        : 1
% Type           : 1 (ps3000aEnuminfo.enPS3000ACoupling.PS3000A_DC)
% Range          : 7 (ps3000aEnuminfo.enPS3000ARange.PS3000A_2V)
% Analogue Offset: 0.0

% Channel A
channelSettings(1).enabled 			= PicoConstants.TRUE;
channelSettings(1).coupling 		= ps3000aEnuminfo.enPS3000ACoupling.PS3000A_DC;
channelSettings(1).range 			= ps3000aEnuminfo.enPS3000ARange.PS3000A_2V;
channelSettings(1).analogueOffset 	= 0.0;

% Obtain the range value for Channel A in millivolts
channelARangeMV = PicoConstants.SCOPE_INPUT_RANGES(channelSettings(1).range + 1);

% Channel B
channelSettings(2).enabled          = PicoConstants.TRUE;
channelSettings(2).coupling         = ps3000aEnuminfo.enPS3000ACoupling.PS3000A_DC;
channelSettings(2).range            = ps3000aEnuminfo.enPS3000ARange.PS3000A_2V;
channelSettings(2).analogueOffset   = 0.0;

% Obtain the range value for Channel B in millivolts
channelBRangeMV = PicoConstants.SCOPE_INPUT_RANGES(channelSettings(2).range + 1);

% Turn off Channels C and D
if(ps3000aDeviceObj.channelCount == PicoConstants.QUAD_SCOPE)
    
    % Channel C
    channelSettings(3).enabled 			= PicoConstants.FALSE;
    channelSettings(3).coupling 		= ps3000aEnuminfo.enPS3000ACoupling.PS3000A_DC;
    channelSettings(3).range 			= ps3000aEnuminfo.enPS3000ARange.PS3000A_2V;
    channelSettings(3).analogueOffset 	= 0.0;
    
    % Channel D
    channelSettings(4).enabled 			= PicoConstants.FALSE;
    channelSettings(4).coupling 		= ps3000aEnuminfo.enPS3000ACoupling.PS3000A_DC;
    channelSettings(4).range 			= ps3000aEnuminfo.enPS3000ARange.PS3000A_2V;
    channelSettings(4).analogueOffset 	= 0.0;
    
end

% Retrieve the number of analogue channels on the device
numChannels = get(ps3000aDeviceObj, 'channelCount');

for ch = 1:numChannels
    
    status.setChannelStatus(ch) = invoke(ps3000aDeviceObj, 'ps3000aSetChannel', ...
        (ch - 1), channelSettings(ch).enabled, ...
        channelSettings(ch).coupling, channelSettings(ch).range, ...
        channelSettings(ch).analogueOffset);
    
end

% Use ps3000aSetDigitalPort to set enable/disable digital ports and set the 
% logic level threshold. This function is located in the Instrument
% Driver's Digital Group. Enabling a digital port will enable all channels
% on that port.

digitalGroupObj = get(ps3000aDeviceObj, 'Digital');
digitalGroupObj = digitalGroupObj(1);

% Digital Port  : 128 (ps3000aEnuminfo.enPS3000ADigitalPort.PS3000A_DIGITAL_PORT0)
% Enabled       : 1 (On)
% Logic Level   : 2.5V
invoke(digitalGroupObj, 'ps3000aSetDigitalPort', evalin('base', 'ps3000aEnuminfo.enPS3000ADigitalPort.PS3000A_DIGITAL_PORT0'), 1, 1.5);

% Digital Port  : 129 (ps3000aEnuminfo.enPS3000ADigitalPort.PS3000A_DIGITAL_PORT1)
% Enabled       : 0 (Off)
% Logic Level   : 0V
invoke(digitalGroupObj, 'ps3000aSetDigitalPort', evalin('base', 'ps3000aEnuminfo.enPS3000ADigitalPort.PS3000A_DIGITAL_PORT1'), 0, 0);

% Obtain the maximum ADC Count from the driver
maxADCCount = double(get(ps3000aDeviceObj, 'maxADCValue'));

%% Trigger Setup
% Turn off the trigger.
% If a trigger is set and the autoStop property in the driver is set to
% '1', the device will stop collecting data once the number of post trigger
% samples have been collected.

% Trigger properties and functions are located in the Instrument Driver's Trigger group.

triggerGroupObj = get(ps3000aDeviceObj, 'Trigger');
triggerGroupObj = triggerGroupObj(1);

[status.setTriggerOff] = invoke(triggerGroupObj, 'setTriggerOff');

%% Set Data Buffers
% Data buffers for Channels A, B and Digital Port 0 - buffers should be set
% with the driver, and these MUST be passed with application buffers to the
% wrapper driver in order to ensure data is correctly copied.

overviewBufferSize  = 250000; % Size of the temporary buffers used to collect data from the device.
segmentIndex        = 0;

ratioMode = ps3000aEnuminfo.enPS3000ARatioMode.PS3000A_RATIO_MODE_NONE;

% Buffers to be passed to the driver
pDriverBufferChA 	= libpointer('int16Ptr', zeros(overviewBufferSize, 1, 'int16'));
pDriverBufferChB 	= libpointer('int16Ptr', zeros(overviewBufferSize, 1, 'int16'));
pDriverBufferPortD0 = libpointer('int16Ptr', zeros(overviewBufferSize, 1, 'int16'));

status.setDataBufferChA = invoke(ps3000aDeviceObj, 'ps3000aSetDataBuffer', ...
    channelA, pDriverBufferChA, overviewBufferSize, segmentIndex, ratioMode);

status.setDataBufferChB = invoke(ps3000aDeviceObj, 'ps3000aSetDataBuffer', ...
    channelB, pDriverBufferChB, overviewBufferSize, segmentIndex, ratioMode);

status.setDataBufferPortD0 = invoke(ps3000aDeviceObj, 'ps3000aSetDataBuffer', ...
    portD0, pDriverBufferPortD0, overviewBufferSize, segmentIndex, ratioMode);

% Application Buffers - these are for copying from the driver into temporarily.
pAppBufferChA 		= libpointer('int16Ptr', zeros(overviewBufferSize, 1));
pAppBufferChB 		= libpointer('int16Ptr', zeros(overviewBufferSize, 1));
pAppBufferPortD0 	= libpointer('int16Ptr', zeros(overviewBufferSize, 1));

% Streaming properties and functions are located in the Instrument
% Driver's Streaming group.

streamingGroupObj = get(ps3000aDeviceObj, 'Streaming');
streamingGroupObj = streamingGroupObj(1);

% Register application buffer and driver buffers (with the wrapper driver).

status.setAppAndDriverBuffersA = invoke(streamingGroupObj, 'setAppAndDriverBuffers', channelA, ...
    pAppBufferChA, pDriverBufferChA, overviewBufferSize);

status.setAppAndDriverBuffersB = invoke(streamingGroupObj, 'setAppAndDriverBuffers', channelB, ...
    pAppBufferChB, pDriverBufferChB, overviewBufferSize);

status.setAppAndDriverPortD0 = invoke(streamingGroupObj, 'setAppAndDriverDigiBuffers', wrapperPortD0, ...
    pAppBufferPortD0, pDriverBufferPortD0, overviewBufferSize);

%% Configure Streaming Data Collection Parameters and Collect Data
% Use default value for streaming interval which is 1e-6 for 1MS/s. 
% Collect data for 1 second with auto stop - maximum array size will 
% depend on PC's resources - type 'memory' at MATLAB command prompt 
% for further information.

% To change the sample interval set the streamingInterval property of the
% Streaming group. The call to ps3000aRunStreaming will output the actual
% sampling interval used by the driver.

% For 200kS/s, specify 5us
% set(streamingGroupObj, 'streamingInterval', 5e-6);

% For 10MS/s, specify 100ns
% set(streamingGroupObj, 'streamingInterval', 100e-9);

% Set the number of pre- and post-trigger samples.
% If no trigger is set 'numPreTriggerSamples' is ignored.
set(ps3000aDeviceObj, 'numPreTriggerSamples', 0);
set(ps3000aDeviceObj, 'numPostTriggerSamples', 2000000);

% autoStop parameter can be set to false (0)
%set(streamingGroupObj, 'autoStop', PicoConstants.FALSE);

% Set other streaming parameters
downSampleRatio     = 1;
downSampleRatioMode = ps3000aEnuminfo.enPS3000ARatioMode.PS3000A_RATIO_MODE_NONE;

% Defined buffers to store data collected from channels. If capturing data
% without using the autoStop flag, or if using a trigger with the autoStop
% flag, allocate sufficient space (1.5 times the size is shown below) to
% allow for pre-trigger data. Pre-allocating the array is more efficient
% than using vertcat to combine data.

maxSamples = get(ps3000aDeviceObj, 'numPreTriggerSamples') + ...
    get(ps3000aDeviceObj, 'numPostTriggerSamples');

% Take into account the downSamplesRatioMode - required if collecting data
% without a trigger and using the autoStop flag.
% finalBufferLength = round(1.5 * maxSamples / downSampleRatio);

pBufferChAFinal = libpointer('int16Ptr', zeros(maxSamples, 1, 'int16'));
pBufferChBFinal = libpointer('int16Ptr', zeros(maxSamples, 1, 'int16'));
pBufferPortD0Final = libpointer('int16Ptr', zeros(maxSamples, 1, 'int16'));

% Prompt User to indicate if they wish to plot live streaming data.
choice = questdlg('Plot live streaming data?', ...
	'Streaming Data Plot', ...
	'Yes','No','Yes');

% Handle response
switch choice
    
    case 'Yes'
        disp('Live streaming data collection with second plot on completion.');
        plotLiveData = PicoConstants.TRUE;
    
    case 'No'
        disp('Streaming data plot on completion.');
        plotLiveData = PicoConstants.FALSE;
    
end

% Start the device collecting streaming data.
[status.runStreaming, actualSampleInterval, sampleIntervalTimeUnitsStr] = ...
    invoke(streamingGroupObj, 'ps3000aRunStreaming', downSampleRatio, ...
    downSampleRatioMode, overviewBufferSize);

disp('Streaming data collection...');
fprintf('Click the STOP button to stop capture or wait for auto stop if enabled.\n\n')

% Variables to be used when collecting the data
hasAutoStopped      = PicoConstants.FALSE;
newSamples          = 0; % Number of new samples returned from the driver.
previousTotal       = 0; % The previous total number of samples.
totalSamples        = 0; % Total samples captured by the device.
startIndex          = 0; % Start index of data in the buffer returned.
hasTriggered        = 0; % To indicate if trigger has occurred.
triggeredAtIndex    = 0; % The index in the overall buffer where the trigger occurred.

status.getStreamingLatestValues = PicoStatus.PICO_OK; % OK

% Display stop button
[stopFig.f, stopFig.h] = stopButton();

flag = 1; % Use flag variable to indicate if stop button has been clicked (0)
setappdata(gcf, 'run', flag);

% Plot Properties - these are for displaying data as it is collected.

if(plotLiveData == PicoConstants.TRUE)
    
    % Plot on a single figure
    figure1 = figure('Name', 'PicoScope 3000 Series - Streaming Mode Capture', 'NumberTitle', 'off');
    analogueAxis = subplot(2,1,1);
    digitalAxis = subplot(2,1,2);

    % Estimate x-axis limit to try and avoid using too much CPU resources
    % when drawing - use max of multiple channels if plotting on same
    % graph.
    
    xlim(analogueAxis, [0 (actualSampleInterval * maxSamples)]);
    xlim(digitalAxis, [0 (actualSampleInterval * maxSamples)]);

    yRange = channelARangeMV + 0.5;
    ylim(analogueAxis,[(-1 * yRange) yRange]);

    hold(analogueAxis,'on');
    hold (digitalAxis, 'on');

    grid(analogueAxis, 'on');
    grid(digitalAxis, 'on');

    title(analogueAxis,'Analogue Channels (Live)');
    title(digitalAxis, 'Digital Channels (Live)');
    xLabelStr = strcat('Time (', sampleIntervalTimeUnitsStr, ')');
    xlabel(xLabelStr);
    ylabel('Voltage (mV)');

end

% Get data values as long as power status has not changed (check for STOP
% button push inside loop).
while(hasAutoStopped == PicoConstants.FALSE && status.getStreamingLatestValues == PicoStatus.PICO_OK)
    
    ready = PicoConstants.FALSE;
    
    while(ready == PicoConstants.FALSE)
        
        status.getStreamingLatestValues = invoke(streamingGroupObj, 'getStreamingLatestValues');
        
        ready = invoke(streamingGroupObj, 'isReady');
        
        % Give option to abort from here
        flag = getappdata(gcf, 'run');
        drawnow;
        
        if(flag == 0)
            
            disp('STOP button clicked - aborting data collection.')
            break;
            
        end
        
        if(plotLiveData == PicoConstants.TRUE)

            drawnow;

        end
        
    end
    
    % Check for data
    [newSamples, startIndex] = invoke(streamingGroupObj, 'availableData');
    
    if (newSamples > 0)
        
        % Check if the scope has triggered
        [triggered, triggeredAt] = invoke(streamingGroupObj, 'isTriggerReady');
        
        if (triggered == PicoConstants.TRUE)
            
            % Adjust trigger position as MATLAB does not use zero-based
            % indexing.
            bufferTriggerPosition = triggeredAt + 1;
            
            fprintf('Triggered - index in buffer: %d\n', bufferTriggerPosition);
            
            hasTriggered = triggered;
            
            % Adjust by 1 due to driver using zero indexing
            triggeredAtIndex = totalSamples + bufferTriggerPosition;
            
        end
        
        previousTotal = totalSamples;
        totalSamples = totalSamples + newSamples;
        
        % Printing to console can slow down acquisition - use for
        % demonstration.
        fprintf('Collected %d samples, startIndex: %d total: %d.\n', newSamples, startIndex, totalSamples);
        
        % Position indices of data in buffer
        firstValuePosn = startIndex + 1;
        lastValuePosn = startIndex + newSamples;
        
        % Convert data values to milliVolts from the application buffers
        bufferChAmV     = adc2mv(pAppBufferChA.Value(firstValuePosn:lastValuePosn), channelARangeMV, maxADCCount);
        bufferChBmV     = adc2mv(pAppBufferChB.Value(firstValuePosn:lastValuePosn), channelBRangeMV, maxADCCount);
        
        % Retrieve digital values as integers
        bufferPortD0    = pAppBufferPortD0.Value(firstValuePosn:lastValuePosn);
        
        % Process collected data further if required - this example plots
        % the data if the User has selected 'Yes' at the prompt.
        
        % Copy data into final buffers
        pBufferChAFinal.Value(previousTotal + 1:totalSamples)       = bufferChAmV;
        pBufferChBFinal.Value(previousTotal + 1:totalSamples)       = bufferChBmV;
        
        pBufferPortD0Final.Value(previousTotal + 1:totalSamples)    = bufferPortD0;
        
        if(plotLiveData == PicoConstants.TRUE)
            
            % Time axis
            % Multiply by ratio mode as samples get reduced 
            time = (double(actualSampleInterval) * double(downSampleRatio)) * (previousTotal:(totalSamples - 1));

            % Plot Channel A and D0 only
            plot(analogueAxis, time, bufferChAmV);
            plot(digitalAxis, time, bufferPortD0);
        
        end
        
        % Clear variables for use again
        clear bufferChAMV;
        clear bufferChBMV;
        clear bufferPortD0;
        clear firstValuePosn;
        clear lastValuePosn;
        clear startIndex;
        clear triggered;
        clear triggerAt;
        
    end
    
    % Check if auto stop has occurred
    hasAutoStopped = invoke(streamingGroupObj, 'autoStopped');
    
    if(hasAutoStopped == PicoConstants.TRUE)
        
        disp('AutoStop: TRUE - exiting loop.');
        break;
        
    end
    
    % Check if 'STOP' button pressed
    flag = getappdata(gcf, 'run');
    
    if(plotLiveData == PicoConstants.TRUE)
        
        drawnow;
        
    end
    
    if(flag == 0)
        
        disp('STOP button clicked - aborting data collection.')
        break;
        
    end
    
end

% Close the STOP button window
if(exist('stopFig', 'var'))
    
    close('Stop Button');
    clear stopFig;
    
end

if(plotLiveData == PicoConstants.TRUE)
    
    drawnow;
    
end

if(hasTriggered == PicoConstants.TRUE)
    
    fprintf('Triggered at overall index: %d\n', triggeredAtIndex);
    
end

if(plotLiveData == PicoConstants.TRUE)
    
    % Take hold off the current figure
    hold off;
    
end

fprintf('\n');

%% Stop the Device
% This function should be called regardless of whether auto stop is enabled
% or not.

status.stop = invoke(ps3000aDeviceObj, 'ps3000aStop');

%% Find the Number of Samples
% This is the number of samples held in the driver itself. The actual
% number of samples collected when using a trigger is likely to be greater.
[status.noOfStreamingValues, numStreamingValues] = invoke(streamingGroupObj, 'ps3000aNoOfStreamingValues');

fprintf('Number of samples available from the driver: %u.\n\n', numStreamingValues);

%% Process Data
% Process all data if required

% Reduce size of arrays if required
if(totalSamples < maxSamples)
    
    pBufferChAFinal.Value(totalSamples + 1:end) = [];
    pBufferChBFinal.Value(totalSamples + 1:end) = [];
    
end

channelAFinal   = pBufferChAFinal.Value();
channelBFinal   = pBufferChBFinal.Value();
portD0Final     = pBufferPortD0Final.Value();

% Convert Digital Data to Binary Format
% Each sample value for a digital port is returned as a 16-bit integer with
% the data in the lower 8-bits of the 16-bit value. The values are Most
% Significant Bit (MSB) ordered. This process may take a little while if a
% large number of samples have been collected.

disp('Converting digital data into binary array...');

% Allocate memory for Digital Port D0 Binary data
portD0BinaryData = zeros(length(portD0Final), 8);

for sample = 1:length(portD0Final)
    
    portD0BinaryData(sample,:)= bitget(portD0Final(sample), 8:-1:1, 'int16');
    
end

disp('Digital data conversion complete.');

% Plot Analogue Channel Data
analogueFinalFigure = figure('Name', 'PicoScope 3000 Series Streaming Data Capture - Analogue Channels', 'NumberTitle', 'off');
analogueFinalFigureAxes = axes('Parent', analogueFinalFigure);
hold on;

time = (double(actualSampleInterval) * double(downSampleRatio)) * (0:length(channelAFinal) - 1);
plot(analogueFinalFigureAxes, time, channelAFinal, time, channelBFinal);

title(analogueFinalFigureAxes, 'Analogue Channel Data', 'FontWeight', 'bold');
xLabelStr = strcat('Time (', sampleIntervalTimeUnitsStr, ')');
xlabel(analogueFinalFigureAxes, xLabelStr);
ylabel(analogueFinalFigureAxes, 'Voltage (mV)');

% Find the maximum voltage range
maxYRange = max(channelARangeMV, channelBRangeMV);
ylim(analogueFinalFigureAxes,[(-1 * maxYRange) maxYRange]);

grid(analogueFinalFigureAxes, 'on');
legend('Channel A', 'Channel B');

hold off;

movegui(analogueFinalFigure, 'northwest');
drawnow;

% Plot Digital Data - only data for digital channels D0 and D1 are plotted here.
digitalFinalFigure  = figure('Name','PicoScope 3000 Series Streaming Data Capture - Digital Channels', ...
    'NumberTitle','off');

digitalFinalFigureAxes = axes('Parent', digitalFinalFigure);

% Change the last value to 7 in order to plot all digital channel data for
% Digital Port 0
for i = 0:1
    
    subplot(2, 1, i + 1);
    % Uncomment the line below to plot all 8 digital channels for the port
    % subplot(4, 2, i + 1);
    
    plot(digitalFinalFigureAxes, time, portD0BinaryData(:, (8 - i)));
    title(digitalFinalFigureAxes, strcat('Digital Channel D', num2str(i)), 'FontWeight', 'bold');
    xlabel(digitalFinalFigureAxes, strcat('Time (', sampleIntervalTimeUnitsStr, ')'));
    ylabel(digitalFinalFigureAxes, 'Logic Level');
    axis(digitalFinalFigureAxes, [-inf, inf, -0.5, 1.5])
    
end

movegui(digitalFinalFigure, 'northeast');

%% Disconnect Device

disconnect(ps3000aDeviceObj);