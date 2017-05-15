%%  PicoScope 3000 Series Instrument Driver Signal Generator Example
% Code for communicating with an instrument in order to control the
% signal generator.
%
% This is a modified version machine generated representation of an 
% instrument control session using a device object. The instrument 
% control session comprises  all the steps you are likely to take when 
% communicating with your instrument. 
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
% PS3000A_ID_Sig_Gen_Example, at the MATLAB command prompt.
% 
% The file, PS3000A_ID_SIG_GEN_EXAMPLE.M must be on your MATLAB PATH. For
% additional information on setting your MATLAB PATH, type 'help addpath'
% at the MATLAB command prompt.
%
% *Example:*
%   PS3000A_ID_Sig_Gen_Example;
%
% See also ICDEVICE.
%
% *Copyright:*  Pico Technology Limited 2015

%% Test Setup
% For this example the 'Gen' output of the oscilloscope was connected to
% Channel A on another PicoScope oscilloscope running the PicoScope 6
% software application. Images, where shown, depict output, or part of the
% output in the PicoScope 6 display.

%% Load Configuration Information

PS3000aConfig;

%% Device Connection

% Create a device object. 
ps3000aDeviceObj = icdevice('picotech_ps3000a_generic.mdd');

% Connect device object to hardware.
connect(ps3000aDeviceObj);

%% Obtain Signal Generator Group Object
% Signal Generator properties and functions are located in the Instrument
% Driver's signalGenerator group.

sigGenGroupObj = get(ps3000aDeviceObj, 'Signalgenerator');
sigGenGroupObj = sigGenGroupObj(1);

%% Function Generator - Simple
% Output a Sine wave, 2000mVpp, 0mV offset, 1000Hz (uses preset values for 
% offset, peak to peak voltage and frequency)

[status.setSigGenBuiltInSimple] = invoke(sigGenGroupObj, 'setSigGenBuiltInSimple', 0);

%%
% 
% <<sine_wave_1kHz.PNG>>
%

%% Function Generator - Sweep Frequency

% Configure property value(s).
set(ps3000aDeviceObj.Signalgenerator(1), 'startFrequency', 50.0);
set(ps3000aDeviceObj.Signalgenerator(1), 'stopFrequency', 500.0);
set(ps3000aDeviceObj.Signalgenerator(1), 'offsetVoltage', 500.0);
set(ps3000aDeviceObj.Signalgenerator(1), 'peakToPeakVoltage', 2500.0);

% Execute device object function(s).

% Wavetype       : 1 (ps3000aEnuminfo.enPS3000AWaveType.PS3000A_SQUARE) 
% Increment      : 50.0 (Hz)
% Dwell Time     : 1 (s)
% Sweep Type     : 1 (ps3000aEnuminfo.enPS3000ASweepType.PS3000A_DOWN)
% Operation      : 0 (ps3000aEnuminfo.enPS3000AExtraOperations.PS3000A_ES_OFF)
% Shots          : 0 
% Sweeps         : 0
% Trigger Type   : 0 (ps3000aEnuminfo.enPS3000ASigGenTrigType.PS3000A_SIGGEN_RISING)
% Trigger Source : 0 (ps3000aEnuminfo.enPS3000ASigGenTrigSource.PS3000A_SIGGEN_NONE)
% Ext. Threshold : 0

invoke(sigGenGroupObj, 'setSigGenBuiltIn', 1, 50.0, 1, 1, 0, 0, 0, 0, 0, 0);

%%
% 
% <<square_wave_sweep1.PNG>>

%% 
%
% <<square_wave_sweep2.PNG>>
%


%% Turn Off Signal Generator
% Sets the output to 0V DC

[status.setSigGenOff] = invoke(sigGenGroupObj, 'setSigGenOff');

%%
%
% <<sig_gen_off_0V_DC.PNG>>
%

%% Arbitrary Waveform Generator - Set Parameters

% Configure property value(s).
set(ps3000aDeviceObj.Signalgenerator(1), 'startFrequency', 2000.0);
set(ps3000aDeviceObj.Signalgenerator(1), 'stopFrequency', 2000.0);
set(ps3000aDeviceObj.Signalgenerator(1), 'offsetVoltage', 0.0);
set(ps3000aDeviceObj.Signalgenerator(1), 'peakToPeakVoltage', 2000.0);

% Define Arbitrary Waveform - must be in range -1 to +1
% Arbitrary waveforms can also be read in from text and csv files using
% dlmread and csvread respectively.
% AWG Files created using PicoScope 6 can be read using the above method.

awgBufferSize = get(sigGenGroupObj, 'awgBufferSize');
x = linspace(0, 360, awgBufferSize);
y = normalise(sind(x) + sind(2*x + 90) + sind(4*x + 45));

%% Arbitrary Waveform Generator - Simple
% Output an arbitrary waveform with constant frequency

% Arb. Waveform : y (defined above)
[status.setSigGenArbitrarySimple] = invoke(sigGenGroupObj, 'setSigGenArbitrarySimple', y);

%%
%
% <<arbitrary_waveform.PNG>>
%

%% Turn Off Signal Generator
% Sets the output to 0V DC
[status.setSigGenOff] = invoke(sigGenGroupObj, 'setSigGenOff');

%% Arbitrary Waveform Generator - Output Shots

% Increment      : 0 (Hz)
% Dwell Time     : 1 (s)
% Arb. Waveform  : y (defined above)
% Sweep Type     : 0 (ps3000aEnuminfo.enPS3000ASweepType.PS3000A_UP)
% Operation      : 0 (ps3000aEnuminfo.enPS3000AExtraOperations.PS3000A_ES_OFF)
% Shots          : 2 
% Sweeps         : 0
% Trigger Type   : 0 (ps3000aEnuminfo.enPS3000ASigGenTrigType.PS3000A_SIGGEN_RISING)
% Trigger Source : 4 (ps3000aEnuminfo.enPS3000ASigGenTrigSource.PS3000A_SIGGEN_SOFT_TRIG)
% Ext. Threshold : 0
[status.setSigGenArbitrary] = invoke(sigGenGroupObj, 'setSigGenArbitrary', 0, 1, y, 0, 0, 0, 2, 0, 0, 4, 0);

% Trigger the AWG

% State : 1
[status.sigGenSoftwareControl] = invoke(sigGenGroupObj, 'ps3000aSigGenSoftwareControl', 1);

%%
%
% <<awg_shots.PNG>>
%

%% Turn Off Signal Generator
% Sets the output to 0V DC

[status.setSigGenOff] = invoke(sigGenGroupObj, 'setSigGenOff');

%% Disconnect
% Disconnect device object from hardware.
disconnect(ps3000aDeviceObj);
