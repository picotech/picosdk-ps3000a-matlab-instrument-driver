%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Filename:    PS3000aConfig.m
%
% Copyright:   Pico Technology Limited 2013 - 2014
%
% Author:      HSM
%
% Description:
%   
%   Contains configuration data for setting parameters for a PicoScope 3000
%   Oscilloscope device.
%
%   Run this script in the MATLAB environment prior to connecting to the 
%   device.
%
%   This file can be edited to suit the application requirements.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% SETUP PATH
% Set paths according to the operating system and architecture.
% For Windows versions of MATLAB, it is recommended to copy 
% the driver, prototype and thunk files into the same directory as the
% instrument driver file.
% For Linux versions of MATLAB, please follow the instructions to install
% the libps3000a and libpswrappers packages from http://www.picotech.com/linux.html


% Set path to the Functions folder, PicoStatus.m and PicoConstants.m files
% Path to drivers on Linux operating systems will also be set.

% Ensure path to drivers and supporting files are set correctly
if(isunix)
    
    addpath('../Functions');	% Common functions
	    
    if(~ismac) % Linux
        
        addpath('/opt/picoscope/lib/'); %Edit to specify location of .so files or place .so files in same directory
        
    end
    
else
    
    % Microsoft Windows operating system
    addpath(''); % Edit to specify location of dll files or place dlls in the same directory
    addpath('..\Functions');
    
end

addpath('..');              % PicoStatus.m & PicoConstants.m

%% LOAD ENUMS AND STRUCTURES

% Load in enumerations and structure information - DO NOT EDIT THIS SECTION
[methodinfo, structs, enuminfo, ThunkLibName] = PS3000aMFile;

%% PICOSCOPE SETTINGS
% Define Settings for PicoScope 3000 series.