%% PS3000ACONFIG Configure path and parameter information
% Configures paths according to platforms and loads information from
% prototype files for PicoScope 3000 Series (A API) Oscilloscopes. The folder 
% that this file is located in must be added to the MATLAB path.
%
% Platform Specific Information:-
%
% Microsoft Windows: Download the Software Development Kit installer from
% the <a href="matlab: web('https://www.picotech.com/downloads')">Pico Technology Download software and manuals for oscilloscopes and data loggers</a> page.
% 
% Linux: Follow the instructions to install the libps3000a and libpswrappers
% packages from the <a href="matlab:
% web('https://www.picotech.com/downloads/linux')">Pico Technology Linux Software & Drivers for Oscilloscopes and Data Loggers</a> page.
%
% Apple Mac OS X: Follow the instructions to install the PicoScope 6
% application from the <a href="matlab: web('https://www.picotech.com/downloads')">Pico Technology Download software and manuals for oscilloscopes and data loggers</a> page.
% Optionally, create a 'maci64' folder in the same directory as this file
% and copy the following files into it:
% 
% * libps3000a.dylib and any other libps3000a library files
% * libps3000aWrap.dylib and any other libps3000aWrap library files
% * libpicoipp.dylib and any other libpicoipp library files
% * libiomp5.dylib
%
% Contact our Technical Support team via the <a href="matlab: web('https://www.picotech.com/tech-support/')">Technical Enquiries form</a> for further assistance.
%
% Run this script in the MATLAB environment prior to connecting to the 
% device.
%
% This file can be edited to suit application requirements.

%% Set Path to Shared Libraries
% Set paths to shared library files according to the operating system and
% architecture.

% Identify architecture e.g. 'win64'

archStr = computer('arch');

% Identify working directory
ps3000aConfigInfo.workingDir = pwd;

% Find file name
ps3000aConfigInfo.configFileName = mfilename('fullpath');

% Only require the path to the config file
[ps3000aConfigInfo.pathStr] = fileparts(ps3000aConfigInfo.configFileName);

% Identify architecture e.g. 'win64'
ps3000aConfigInfo.archStr = computer('arch');

try

    addpath(fullfile(ps3000aConfigInfo.pathStr, ps3000aConfigInfo.archStr));
    
catch err
    
    error('PS3000aConfig:OperatingSystemNotSupported', 'Operating system not supported - please contact support@picotech.com');
    
end

% Set the path according to operating system.

if(ismac())
    
    % Libraries (including wrapper libraries) are stored in the PicoScope
    % 6 App folder. Add locations of library files to environment variable.
    
    setenv('DYLD_LIBRARY_PATH', '/Applications/PicoScope6.app/Contents/Resources/lib');
    
    if(strfind(getenv('DYLD_LIBRARY_PATH'), '/Applications/PicoScope6.app/Contents/Resources/lib'))
       
        addpath('/Applications/PicoScope6.app/Contents/Resources/lib');
        
    else
        
        warning('PS3000aConfig:LibraryPathNotFound','Locations of libraries not found in DYLD_LIBRARY_PATH');
        
    end
    
elseif(isunix())
	    
    % Edit to specify location of .so files or place .so files in same directory
    addpath('/opt/picoscope/lib/'); 
		
elseif(ispc())
    
    % Microsoft Windows operating systems
    
    % Set path to dll files if the Pico Technology SDK Installer has been
    % used or place dll files in the folder corresponding to the
    % architecture. Detect if 32-bit version of MATLAB on 64-bit Microsoft
    % Windows.
    
    ps3000aConfigInfo.winSDKInstallPath = '';
    
    if(strcmp(ps3000aConfigInfo.archStr, 'win32') && exist('C:\Program Files (x86)\', 'dir') == 7)
       
        try 
            
            addpath('C:\Program Files (x86)\Pico Technology\SDK\lib\');
            ps3000aConfigInfo.winSDKInstallPath = 'C:\Program Files (x86)\Pico Technology\SDK';
            
        catch err
           
            warning('PS3000aConfig:DirectoryNotFound', ['Folder C:\Program Files (x86)\Pico Technology\SDK\lib\ not found. '...
                'Please ensure that the location of the library files are on the MATLAB path.']);
            
        end
        
    else
        
        % 32-bit MATLAB on 32-bit Windows or 64-bit MATLAB on 64-bit
        % Windows operating systems
        try 
        
            addpath('C:\Program Files\Pico Technology\SDK\lib\');
            ps3000aConfigInfo.winSDKInstallPath = 'C:\Program Files\Pico Technology\SDK';
            
        catch err
           
            warning('PS3000aConfig:DirectoryNotFound', ['Folder C:\Program Files\Pico Technology\SDK\lib\ not found. '...
                'Please ensure that the location of the library files are on the MATLAB path.']);
            
        end
        
    end
    
else
    
    error('PS3000aConfig:OperatingSystemNotSupported', 'Operating system not supported - please contact support@picotech.com');
    
end

%% Set Path for PicoScope Support Toolbox Files if Not Installed
% Set MATLAB Path to include location of PicoScope Support Toolbox
% Functions and Classes if the Toolbox has not been installed. Installation
% of the toolbox is only supported in MATLAB 2014b and later versions.

% Check if PicoScope Support Toolbox is installed - using code based on
% <http://stackoverflow.com/questions/6926021/how-to-check-if-matlab-toolbox-installed-in-matlab How to check if matlab toolbox installed in matlab>

ps3000aConfigInfo.psTbxName = 'PicoScope Support Toolbox';
ps3000aConfigInfo.v = ver; % Find installed toolbox information

if(~any(strcmp(ps3000aConfigInfo.psTbxName, {ps3000aConfigInfo.v.Name})))
   
    warning('PS3000aConfig:PSTbxNotFound', 'PicoScope Support Toolbox not found, searching for folder.');
    
    % If the PicoScope Support Toolbox has not been installed, check to see
    % if the folder is on the MATLAB path, having been downloaded via zip
    % file or copied from the Microsoft Windows Pico SDK installer
    % directory.
    
    ps3000aConfigInfo.psTbxFound = strfind(path, ps3000aConfigInfo.psTbxName);
    
    if(isempty(ps3000aConfigInfo.psTbxFound) && ispc())
        
        % Check if the folder is present in the relevant SDK installation
        % directory on Windows platforms (if the SDK installer has been
        % used).
        
        % Obtain the folder name
        ps3000aConfigInfo.psTbxFolderName = fullfile(ps3000aConfigInfo.winSDKInstallPath, 'MATLAB' , ps3000aConfigInfo.psTbxName);

        % If it is present in the SDK directory, add the PicoScope Support
        % Toolbox folder and sub-folders to the MATLAB path.
        if(exist(ps3000aConfigInfo.psTbxFolderName, 'dir') == 7)

            addpath(genpath(ps3000aConfigInfo.psTbxFolderName));

        end
            
    else
        
        warning('PS3000aConfig:PSTbxDirNotFound', 'PicoScope Support Toolbox directory not found.');
            
    end
    
end

% Change back to the folder where the script was called from.
cd(ps3000aConfigInfo.workingDir);

%% Load Enumerations and Structure Information
% Enumerations and structures are used by certain Intrument Driver functions.

% PLEASE DO NOT EDIT THE LINES BELOW
[ps3000aMethodinfo, ps3000aStructs, ps3000aEnuminfo, ps3000aThunkLibName] = ps3000aMFile; 

[ps3000aWrapMethodinfo, ps3000aWrapStructs, ps3000aWrapEnuminfo, ps3000aWrapThunkLibName] = ps3000aWrapMFile;