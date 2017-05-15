%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Filename:    ps3000aChangePowerSource.m   
%
% Copyright:   Pico Technology Limited 2012
%
% Author:      HSM
%
% Description:
%   This is a MATLAB script that provides the User with the ability to 
%   change the power source of a PicoScope 340XA/B device.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ status ] = ps3000aChangePowerSource( obj, power_status )
%PS3000ACHANGEPOWERSOURCE Changes the Power Source of a PicoScope 340X A/B device.
%   
%   This function prompts the user to acknowledge if they wish to power the
%   device using the USB cable. If the user chooses not to, they will be
%   prompted to ensure that the power supply cable is attached.
%   
%   NOTE: This function only applies to PicoScope 340XA/B devices.

switch power_status
    
    case PicoStatus.PICO_POWER_SUPPLY_NOT_CONNECTED
    
        % User must acknowledge they want to power via USB
        ch = '';
        
        % While input is not 'Y' or 'N'
        while (strcmpi(ch, 'Y') == 0 && strcmpi(ch, 'N') == 0)
           
            fprintf('5V power supply not connected.\n');
            ch = input('Do you want to run using USB only? Y/N: ', 's');
            
            if (strcmpi(ch, 'Y'))
               
                fprintf('Powering the unit via USB.\n');
                
                % Inform the driver that it's ok
                status = calllib('PS3000a', 'ps3000aChangePowerSource', ...
                    get(obj, 'unithandle'), PicoStatus.PICO_POWER_SUPPLY_NOT_CONNECTED);
                
                if(status == PicoStatus.PICO_POWER_SUPPLY_UNDERVOLTAGE)
                    
                    status = ps3000aChangePowerSource(obj, power_status);
                    %status = invoke(obj, 'ChangePowerSource', power_status);
                    
                end
            end
        end
        
        if (strcmpi(ch, 'N'))
            
            ch = input('Please use the +5V power supply to power this unit - Press ''Y'' then ENTER to confirm.\n', 's');
            
            if(strcmpi(ch, 'Y'))
                
                % Inform the driver that it's ok
                status = calllib('PS3000a', 'ps3000aChangePowerSource', ...
                    get(obj, 'unithandle'), PicoStatus.PICO_POWER_SUPPLY_CONNECTED);
                
                if(status == PicoStatus.PICO_POWER_SUPPLY_UNDERVOLTAGE)
                    
                    status = ps3000aChangePowerSource(obj, power_status);
                    %status = invoke(obj, 'ChangePowerSource', power_status);
                    
                end
                
            else
                
                status = PicoStatus.PICO_POWER_SUPPLY_NOT_CONNECTED;
                
            end
            
        end
    
        
    case PicoStatus.PICO_POWER_SUPPLY_CONNECTED
        
        fprintf('Using +5V power supply voltage.\n');
        % Tell the driver we are powered from +5V supply
        status = calllib('PS3000a', 'ps3000aChangePowerSource', ...
            get(obj, 'unithandle'), PicoStatus.PICO_POWER_SUPPLY_CONNECTED);
    
    case PicoStatus.PICO_POWER_SUPPLY_UNDERVOLTAGE
        
        status = PicoStatus.PICO_POWER_SUPPLY_REQUEST_INVALID
        
        while(status == PICO_POWER_SUPPLY_REQUEST_INVALID)
           
            fprintf('USB not supplying required voltage.\n');
            fprintf('Please plug in the +5V power supply.\n');
            
            option = input('Press X and ENTER to exit, or ENTER to continue: \n', 's');
            
            if (strcmpi(option, 'X'))
               
                exit;
                
            else
                
                status = calllib('PS3000a', 'ps3000aChangePowerSource', ...
                    get(obj, 'unithandle'), PicoStatus.PICO_POWER_SUPPLY_CONNECTED);
                
            end
            
        end
        
end

end

