%% PS3000aCONSTANTS 
% Defines PicoScope 3000 Series constants from header file ps3000aApi.h
%
% The PS3000AConstants class defines a number of constant values that
% can be used to define the properties of a PicoScope 3000 Series
% Oscilloscope or Mixed Signal Oscilloscope (MSO) device or for passing
% as parameters to function calls.
%
% The properties in this file are divided into the following
% sub-sections:
%
%%
% 
% * Equivalent Time Sampling Properties 
% * External trigger: Max/min counts & Max/min voltage
% * Function/Arbitrary Waveform Parameters
% * Waveform Frequencies
% * Digital channel definitions (MSO Models only): Max/min logic level as
% counts & Max/min logic voltage
% * PicoScope 3000 Series Models: 2-channel, 4-channel and MSO variants

classdef PS3000aConstants   
    
    properties (Constant)
        
        % Equivalent Time Sampling Properties
        
        PS3207A_MAX_ETS_CYCLES   = 500; % 500
        PS3207A_MAX_INTERLEAVE	 = 40;  % 40

        PS3206A_MAX_ETS_CYCLES	 = 500; % 500
        PS3206A_MAX_INTERLEAVE	 = 40;  % 40
        PS3206MSO_MAX_INTERLEAVE = 80;  % 80

        PS3205A_MAX_ETS_CYCLES	 = 250; % 250
        PS3205A_MAX_INTERLEAVE	 = 20;  % 20
        PS3205MSO_MAX_INTERLEAVE = 40;  % 40

        PS3204A_MAX_ETS_CYCLES	 = 125; % 125
        PS3204A_MAX_INTERLEAVE	 = 10;  % 10
        PS3204MSO_MAX_INTERLEAVE = 20;  % 20

        % External trigger max/min counts
        PS3000A_EXT_MAX_VALUE = 32767;  % 32767
        PS3000A_EXT_MIN_VALUE = -32767; % -32767
        
        % External trigger max/min voltage
        PS3000A_EXT_MAX_VOLTAGE = 5;    % 5 volts
        PS3000A_EXT_MIN_VOLTAGE = -5;   % -5 volts

        % Function/Arbitrary Waveform Parameters
        MIN_SIG_GEN_FREQ = 0.0; % 0 Hz
        MAX_SIG_GEN_FREQ = 20000000.0; % 20 MHz

        PS3207B_MAX_SIG_GEN_BUFFER_SIZE = 32768;    % 32768
        PS3206B_MAX_SIG_GEN_BUFFER_SIZE = 16384;    % 16384
        MAX_SIG_GEN_BUFFER_SIZE         = 8192;     % 8192
        MIN_SIG_GEN_BUFFER_SIZE         = 1;        % 1
        MIN_DWELL_COUNT                 = 3;        % 3
        MAX_SWEEPS_SHOTS				= pow2(30) - 1; %1073741823

        MAX_ANALOGUE_OFFSET_50MV_200MV = 0.250;     % 0.250 Volts
        MIN_ANALOGUE_OFFSET_50MV_200MV = -0.250;    % -0.250 Volts
        MAX_ANALOGUE_OFFSET_500MV_2V   = 2.500;     % 2.5 Volts
        MIN_ANALOGUE_OFFSET_500MV_2V   = -2.500;    % -2.5 Volts
        MAX_ANALOGUE_OFFSET_5V_20V     = 20;        % 20 Volts
        MIN_ANALOGUE_OFFSET_5V_20V	   = -20;       % -20 Volts

        PS3000A_SHOT_SWEEP_TRIGGER_CONTINUOUS_RUN = hex2dec('FFFFFFFF'); % 0xFFFFFFFF

        % Frequencies
        
        PS3000A_SINE_MAX_FREQUENCY		= 1000000;  
        PS3000A_SQUARE_MAX_FREQUENCY	= 1000000;
        PS3000A_TRIANGLE_MAX_FREQUENCY	= 1000000;
        PS3000A_SINC_MAX_FREQUENCY		= 1000000;
        PS3000A_RAMP_MAX_FREQUENCY		= 1000000;
        PS3000A_HALF_SINE_MAX_FREQUENCY	= 1000000;
        PS3000A_GAUSSIAN_MAX_FREQUENCY  = 1000000;
        PS3000A_PRBS_MAX_FREQUENCY		= 1000000;
        PS3000A_PRBS_MIN_FREQUENCY		= 0.03; % 0.03 Hz
        PS3000A_MIN_FREQUENCY			= 0.03; % 0.03 Hz

        % Digital channel definitions (MSO Models only)
        
        % Max/min logic level as counts
        PS3000A_MAX_LOGIC_LEVEL = 32767;    % 32767
        PS3000A_MIN_LOGIC_LEVEL = -32767;   % -32767
        
        % Max/min logic voltage
        PS3000A_MAX_LOGIC_VOLTAGE = 5.0;    % 5 Volts
        PS3000A_MIN_LOGIC_VOLTAGE = -5.0;   % -5 Volts
        
        % PicoScope 3000 Series Models
        MODEL_NONE      = 'NONE';   % NONE
        
        % 2-channel variants
        MODEL_PS3204A   = '3204A';  % 3204A
        MODEL_PS3204B   = '3204B';  % 3204B
        MODEL_PS3205A   = '3205A';  % 3205A
        MODEL_PS3205B   = '3205B';  % 3205B
        MODEL_PS3206A   = '3206A';  % 3206A
        MODEL_PS3206B   = '3206B';  % 3206B
        MODEL_PS3207A   = '3207A';  % 3207A
        MODEL_PS3207B   = '3207B';  % 3207B
        
        MODEL_PS3203D   = '3203D';  % 3203D
        MODEL_PS3204D   = '3204D';  % 3204D
        MODEL_PS3205D   = '3205D';  % 3205D
        MODEL_PS3206D   = '3206D';  % 3206D

        % 4-channel variants
        MODEL_PS3404A   = '3404A';  % 3404A
        MODEL_PS3404B   = '3404B';  % 3404B
        MODEL_PS3405A   = '3405A';  % 3405A
        MODEL_PS3405B   = '3405B';  % 3405B
        MODEL_PS3406A   = '3406A';  % 3406A
        MODEL_PS3406B   = '3406B';  % 3406B
        
        MODEL_PS3403D   = '3403D';  % 3403D
        MODEL_PS3404D   = '3404D';  % 3404D
        MODEL_PS3405D   = '3405D';  % 3405D
        MODEL_PS3406D   = '3406D';  % 3406D
        
        % MSO Products
        MODEL_PS3204MSO = '3204MSO';    % 3204MSO
        MODEL_PS3205MSO = '3205MSO';    % 3205MSO
        MODEL_PS3206MSO = '3206MSO';    % 3206MSO
        
        MODEL_PS3203DMSO = '3203DMSO';  % 3203DMSO
        MODEL_PS3204DMSO = '3204DMSO';  % 3204DMSO
        MODEL_PS3205DMSO = '3205DMSO';  % 3205DMSO
        MODEL_PS3206DMSO = '3206DMSO';  % 3206DMSO
        
        MODEL_PS3403DMSO = '3403DMSO';  % 3403DMSO
        MODEL_PS3404DMSO = '3404DMSO';  % 3404DMSO
        MODEL_PS3405DMSO = '3405DMSO';  % 3405DMSO
        MODEL_PS3406DMSO = '3406DMSO';  % 3406DMSO
        
    end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Filename:    PS3000aConstants
%
% Copyright:   Pico Technology Limited 2013 - 2015
%
% Author:      HSM
%
% Description:
%   This is a MATLAB script that contains reference information for the
%   PicoScope 3000 Instrument Control Driver - DO NOT EDIT.
%
% Ensure that the file is on the MATLAB Path.		
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

