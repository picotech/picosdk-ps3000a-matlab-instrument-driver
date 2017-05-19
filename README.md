# PicoScope 3000 Series - MATLAB Generic Instrument Driver

This MATLAB® Generic Instrument Driver allows you to acquire data from the PicoScope® 3000 Series High-Performance Oscilloscopes and 
control signal generator functionality. The data could be processed in MATLAB using functions from Toolboxes such as [Signal Processing Toolbox](https://www.mathworks.com/products/signal.html). 

The driver was initially created using Instrument Control Toolbox v3.1.

This Instrument Driver package includes the following: 

* The MATLAB Generic Instrument Driver 
* Example scripts that demonstrate how to call functions in order to capture data in various collection modes, as well as using the signal generator.

* The driver can be used with the Test and Measurement Tool to carry out the following: 

  * Acquire data in Block mode 
  * Acquire data in Rapid Block mode 
  * Use the Built-in Function/Arbitrary Waveform Generator (model-dependent)

## Supported Models

The driver will work with the following PicoScope models:

* PicoScope 3204A/B/D  
* PicoScope 3205A/B/D   
* PicoScope 3206A/B/D
* PicoScope 3207A/B
* PicoScope 3204MSO/D MSO 
* PicoScope 3205MSO/D MSO   
* PicoScope 3206MSO/D MSO
* PicoScope 3404A/B/D  
* PicoScope 3405A/B/D   
* PicoScope 3406A/B/D
* PicoScope 3404D MSO 
* PicoScope 3405D MSO   
* PicoScope 3406D MSO

## Getting started

### Prerequisites

* [MATLAB](https://uk.mathworks.com/products/matlab.html) for Microsoft Windows (32- or 64-bit) or Linux operating systems (64-bit).
* [Instrument Control Toolbox](http://www.mathworks.co.uk/products/instrument/)
* The [PicoScope Support Toolbox](http://uk.mathworks.com/matlabcentral/fileexchange/53681-picoscope-support-toolbox)

**Notes:**

* MATLAB 2015b is recommended for 32-bit versions of MATLAB on Microsoft Windows operating systems.

### Installing drivers

Drivers are available for the following platforms. Refer to the subsections below for further information.

#### Windows

* Download the PicoSDK (32-bit or 64-bit) driver package installer from our [Downloads page](https://www.picotech.com/downloads).

#### Linux

* Follow the instructions from our [Linux Software & Drivers for Oscilloscopes and Data Loggers page](https://www.picotech.com/downloads/linux) to install the required `libps3000a` and `libpswrappers` driver packages.

### Programmer's Guides

You can download the [Programmer's Guide](https://www.picotech.com/download/manuals/picoscope-3000-series-a-api-programmers-guide.pdf) providing a description of the API functions for the ps3000a shared library used by this Instrument Driver.

## Further information

To view Pico Technology's Hardware Support page, please visit:

http://www.mathworks.co.uk/hardware-support/picoscope.html

## Obtaining support

Please visit our [Support page](https://www.picotech.com/tech-support) to contact us directly or visit our [Test and Measurement Forum](https://www.picotech.com/support/forum71.html) to post questions.

Issues can be reported via the [Issues tab](https://github.com/picotech/picosdk-ps3000a-matlab-instrument-driver/issues).

Please leave a comment and rating for this submission on our [MATLAB Central File Exchange page](https://uk.mathworks.com/matlabcentral/fileexchange/38952-picoscope-3000-series-matlab-generic-instrument-driver).

## Copyright and licensing

picosdk-ps3000a-matlab-instrument-driver is Copyright (C) 2012 - 2017 Pico Technology Ltd. All rights reserved. See [LICENSE.md](LICENSE.md) for license terms. 

*PicoScope* is a registered trademark of Pico Technology Ltd. 

*MATLAB* is a registered trademark of The Mathworks, Inc. *Signal Processing Toolbox*
is a trademark of The Mathworks, Inc.

*Windows* is a registered trademark of Microsoft Corporation. 

*Linux* is the registered trademark of Linus Torvalds in the U.S. and other countries.

## Contributing

Contributions to examples are welcome. Please refer to our [guidelines for contributing](.github/CONTRIBUTING.md) for further information.

