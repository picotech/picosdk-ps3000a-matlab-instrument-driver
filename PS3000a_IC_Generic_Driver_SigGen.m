%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Filename:    PS3000A_Generic_Driver_SigGen
%
% Copyright:   Pico Technology Limited 2012 - 2014
%
% Author:      HSM
%
% Description:
%   This is a MATLAB script that demonstrates how to use the
%   PicoScope 3000a series Instrument Control Toobox driver.
%
% Example:
%    Output a signal from the signal generator using either the built-in 
%    function or 
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
%       - mv2adc.m (located in the Functions directory)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Clear MATLAB Env

clear;
clc;

%% Load configuration file

PS3000aConfig;

%% Declare constants

global data;

data.TRUE = 1;
data.FALSE = 0;

% Identify type of generator on PicoScope
data.SIG_GEN_NONE = 0;
data.SIG_GEN_FUNCT_GEN = 1;
data.SIG_GEN_AWG = 2;

% External Threshold Range
data.EXT_RANGE = 5000; % milliVolts

% Signal Generator Constants

MIN_SIG_GEN_FREQ = 0.0;
MAX_SIG_GEN_FUNC_GEN_FREQ = 1000000.0;  % A and B variants Function Generator max 1MHz
MAX_SIG_GEN_AWG_FREQ = 20000000.0;      % AWG max 20MHz

MIN_SIG_GEN_BUFFER_SIZE = 1;
MAX_SIG_GEN_BUFFER_SIZE = 8192;
PS3X06B_MAX_SIG_GEN_BUFFER_SIZE = 16384;

MIN_DWELL_COUNT = 10;

%% Device Connection

% Create device
ps3000a_obj = icdevice('PS3000a_IC_drv', '');

% Connect device
connect(ps3000a_obj);

% Provide access to enumerations and structures
[methodinfo, structs, enuminfo, ThunkLibName] = PS3000aMFile;

%% Show unit information

info_status = invoke(ps3000a_obj, 'GetUnitInfo', ps3000a_obj.unithandle)

%% Obtain Maximum & Minimum values 

max_val_status = invoke(ps3000a_obj, 'ps3000aMaximumValue');

fprintf('Max ADC value: %d\n', ps3000a_obj.maxValue);

%% Signal Generator Parameters

% Common Sig Gen Parameters

pkToPk = 2000000;  %microVolts
offsetVoltage = 0; %microVolts

startFrequency = 1000.0; 
stopFrequency = 1000.0;

sweepType = enuminfo.enPS3000ASweepType.PS3000A_UP;
operation = enuminfo.enPS3000AExtraOperations.PS3000A_ES_OFF; % Applies to B variants only
shots = 0;
sweeps = 0;
triggerType = enuminfo.enPS3000ASigGenTrigType.PS3000A_SIGGEN_RISING;
triggerSource = enuminfo.enPS3000ASigGenTrigSource.PS3000A_SIGGEN_NONE;
extInThreshold = int16(mv2adc(0, data.EXT_RANGE, ps3000a_obj.maxValue));


ch = '';

while(strcmpi(ch, 'X') == data.FALSE)
    
    % Check if there is a signal generator
    
    if(ps3000a_obj.sigGenType == data.SIG_GEN_NONE)
       
        %Break out of loop
        disp('ERROR: No Signal Generator function available on this device');
        break;
    end

    fprintf('\nPlease select one from the following options: \nS - Sig Gen\n');
    
    if(ps3000a_obj.sigGenType == data.SIG_GEN_AWG)
       
        fprintf('G - AWG\n');
        
    end
    
    ch = input('X - Exit\n\nOption: ', 's');
    
    % Ensure upper case letter
    ch = upper(ch); 
    
    if(strcmp(ch, 'X') == data.FALSE && ( strcmp(ch, 'G') || strcmp(ch, 'S') ))
        
        % Indicate if AWG not available on device (if 'G' is selected).
        if(strcmp(ch, 'G') && ps3000a_obj.sigGenType ~= data.SIG_GEN_AWG)
            
            disp('ERROR: AWG Function not available on this device.');
            
            ch = '';
            
        else
       
            % Verify the DC offset level
            disp('Verifying DC offset level...');

            while(offsetVoltage < -2000000 || offsetVoltage > 2000000)

                offsetVoltage = input('Enter offset in uV (-2000000 to 2000000):');

            end

            disp('DC offset level: OK');

            fprintf('Peak to Peak voltage: %d uV\n', pkToPk);

            change_pkToPk = input('Do you wish to change the peak to peak voltage? [Y/N]: ', 's');

            if(strcmpi(change_pkToPk, 'Y') == data.TRUE)

                new_pkToPk = -1;

                while(new_pkToPk < 0 || new_pkToPk > 4000000)

                    new_pkToPk = input('Enter new peak to peak voltage (0 -> 4000000 uV): ');

                end

                pkToPk = new_pkToPk;
            
            end

            fprintf('\n');

            fprintf('Selected Start Frequency: %dHz\n', startFrequency);
            fprintf('Selected Stop Frequency: %dHz\n', stopFrequency);

            disp('Verifying Start/Stop frequencies...');
            
        end
        
    end
     
    switch (ch)
        
        case 'S'
            
            % Check stop and start frequency
            while(startFrequency < 0 || startFrequency > MAX_SIG_GEN_FUNC_GEN_FREQ)

                startFrequency = input('Enter start frequency in the range 0 -> 1000000Hz: '); 

            end

            while(stopFrequency < 0 || stopFrequency > MAX_SIG_GEN_FUNC_GEN_FREQ)

                stopFrequency = input('Enter stop frequency in the range 0 -> 1000000Hz: ');

            end
            
            fprintf('Start/Stop Frequencies: OK\n\n');
            
            % Function Generator Parameters ('A' variant specific)
            waveformType = enuminfo.enPS3000AWaveType.PS3000A_SINE;
            increment = 0;
            dwellTime = 0;
            
            % Verify waveformType is valid for variant
            if(strcmpi(ps3000a_obj.InstrumentModel(end), 'A'))
                
                while(waveformType < enuminfo.enPS3000AWaveType.PS3000A_SINE || ...
                    (waveformType > enuminfo.enPS3000AWaveType.PS3000A_TRIANGLE && waveformType ~= enuminfo.enPS3000AWaveType.PS3000A_DC_VOLTAGE) )
                   
                    fprintf('Invalid wave type - please choose one of the following wave types: \n 0 - SINE\n 1 - SQUARE\n 2 - TRIANGLE\n 8 - DC VOLTAGE\n')
                    waveformType = input('Wave type: ');
                    
                end
               
            elseif(strcmpi(ps3000a_obj.InstrumentModel(end), 'B'))
                
                while(waveformType < enuminfo.enPS3000AWaveType.PS3000A_SINE || ...
                    waveformType > enuminfo.enPS3000AWaveType.PS3000A_DC_VOLTAGE)
                   
                    fprintf('Invalid wave type - Please choose one of the following wave types:\n');
                    fprintf(' 0 - SINE\n 1 - SQUARE\n 2 - TRIANGLE\n');
                    fprintf(' 3 - RAMP UP\n 4 - RAMP DOWN\n 5 - SINC\n');
                    fprintf(' 6 - GAUSSIAN\n 7 - HALF_SINE\n 8 - DC VOLTAGE\n');
                    waveformType = input('Wave type: ');
                         
                end
                
            end
            
            % Generate built in signal generator
            sig_gen_built_in_status = invoke(ps3000a_obj, 'ps3000aSetSigGenBuiltIn', ...
                    offsetVoltage, pkToPk, waveformType, startFrequency, stopFrequency, increment, ...
                    dwellTime, sweepType, operation, shots, sweeps, triggerType, triggerSource, ...
                    extInThreshold);
            
        case 'G'
            
            if(ps3000a_obj.sigGenType == data.SIG_GEN_AWG)
                
                % AWG specific parameters
                deltaPhaseIncrement = 0;                 
                dwellCount = 0; % Time in 50ns steps
                indexMode = enuminfo.enPS3000AIndexMode.PS3000A_SINGLE;
                
                % Dwell count must be minimum value of MIN_DWELL_COUNT (10)
                % if sweeping frequency
                if(startFrequency ~= stopFrequency)
                   
                    while(dwellCount < MIN_DWELL_COUNT)
                       
                        dwellCount = ('Enter dwell count (num. 50ns steps, Min: 10): ');
                        
                    end
                    
                end        
                
                % Check stop and start frequency
                while(startFrequency < 0 || startFrequency > MAX_SIG_GEN_AWG_FREQ)
                    
                    startFrequency = input('Enter start frequency in the range 0 -> 20000000Hz: '); 
                    
                end
                
                while(stopFrequency < 0 || stopFrequency > MAX_SIG_GEN_AWG_FREQ)
                    
                    stopFrequency = input('Enter stop frequency in the range 0 -> 20000000Hz: ');
                    
                end
                
                disp('Start/Stop Frequencies: OK');
                
                % Define file
                awg_filename = 'ramp_8192.txt';       % Normal file
                
                %awg_filename = 'sine_wave_4096.csv' % PicoScope 6 generated
                
                fprintf('Currently selected AWG file: %s\n', awg_filename);
                
                change_awg_file = input('Do you wish to change the AWG file? [Y/N]: ', 's');
                
                if(strcmpi(change_awg_file, 'Y') == data.TRUE)
                
                    awg_filename = input('Please enter file name: ', 's');
                    
                end
                
                fprintf('Has file %s been generated using PicoScope 6? ', awg_filename);
                
                % Variable to indicate if AWG file has been generated by
                % PicoScope (outputs in range -1.0 to +1.0)
                is_picoscope_generated_awg_file = input('[Y/N]: ', 's');
                
                % Load file
                awg_fid = fopen(awg_filename, 'r');
                
                if(strcmpi(is_picoscope_generated_awg_file, 'Y'))
                    
                    % Check if file is CSV
                    if(strfind(awg_filename, '.csv') ~= [])
                        
                        waveform = csvread(awg_filename);
                        waveform_size = length(waveform);
                        
                    else
                        
                        [waveform, waveform_size] = fscanf(awg_fid, '%f'); % PicoScope csv files are -1.0 to +1.0
                    
                    end
                                 
                    % Ensure waveform size is not greater than buffer size

                    if(waveform_size > ps3000a_obj.awgBufferSize)
                           
                        fprintf('Waveform size greater than buffer size - truncating length to %d.\n', ps3000a_obj.awgBufferSize);
                        waveform_size = ps3000a_obj.awgBufferSize;
                            
                    end
                    
                    awg_waveform = zeros(waveform_size, 1);
                    
                    % Scale values accordingly between -32767 and 32768
                    for n = 1:waveform_size
                       
                        awg_waveform(n, 1) = int16(32768 * waveform(n));
                       
                        if(awg_waveform(n, 1) == -32768)
                           
                            awg_waveform(n, 1) = -32767;
                            
                        end
                        
                    end
                    
                else 
                    
                    [awg_waveform, waveform_size] = fscanf(awg_fid, '%d'); % Values -32767 -> 32768
                    
                end
                
                % Close file and check for error
                st = fclose(awg_fid);
                
                if(st == -1)
                   
                    fprintf('ERROR: Unable to close file %s\n', awg_filename);
                else
                    
                    fprintf('File successfully loaded.\n');
                    
                end
                
                if (waveform_size > 0)
                
                    % Calculate delta values
                    start_delta = ((1.0 * startFrequency * waveform_size) / ps3000a_obj.awgBufferSize) * power(2,32) * (5 * power(10,-8));
                    
                    stop_delta = ((1.0 * stopFrequency * waveform_size) / ps3000a_obj.awgBufferSize) * power(2,32) * (5 * power(10,-8));
                    
                    % Create libpointer for waveform
                    %awg_waveform_lptr = libpointer('int16ptr', awg_waveform);
                    
                    % Output waveform
                    status_set_siggen_arb = invoke(ps3000a_obj, 'ps3000aSetSigGenArbitrary', offsetVoltage, pkToPk, ...
                        start_delta, stop_delta, deltaPhaseIncrement, dwellCount, awg_waveform, waveform_size, sweepType, ...
                        operation, indexMode, shots, sweeps, triggerType, triggerSource, extInThreshold);
                
                else
                    
                    disp('No waveform data found - please ensure file contains data.');
                    
                end
               
            else
               
                disp('AWG function not available on this device.');
                
            end
            
        case 'X'
            
            disp('Turning Signal generator off');
            
            pkToPk = 0;
            waveformType = enuminfo.enPS3000AWaveType.PS3000A_DC_VOLTAGE;
            increment = 0;
            dwellTime = 0;
            
            sig_gen_built_in_status = invoke(ps3000a_obj, 'ps3000aSetSigGenBuiltIn', ...
                    offsetVoltage, pkToPk, waveformType, startFrequency, stopFrequency, increment, ...
                    dwellTime, sweepType, operation, shots, sweeps, triggerType, triggerSource, ...
                    extInThreshold);
            
            %Exit
            break;
            
        otherwise
        
            % Do nothing - loop will prompt user to choose an option.
    end

end

%% Disconnect device

disconnect(ps3000a_obj);