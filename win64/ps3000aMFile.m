function [methodinfo,structs,enuminfo,ThunkLibName]=ps3000aMFile
%PS3000AMFILE Create structures to define interfaces found in 'ps3000aApi'.

%This function was generated by loadlibrary.m parser version  on Tue Apr 19 16:42:18 2016
%perl options:'ps3000aApi.i -outfile=ps3000aMFile.m -thunkfile=ps3000a_thunk_pcwin64.c -header=ps3000aApi.h'
ival={cell(1,0)}; % change 0 to the actual number of functions to preallocate the data.
structs=[];enuminfo=[];fcnNum=1;
fcns=struct('name',ival,'calltype',ival,'LHS',ival,'RHS',ival,'alias',ival,'thunkname', ival);
MfilePath=fileparts(mfilename('fullpath'));
ThunkLibName=fullfile(MfilePath,'ps3000a_thunk_pcwin64');
% PICO_STATUS ps3000aOpenUnit ( int16_t * handle , char * serial ); 
fcns.thunkname{fcnNum}='uint32voidPtrcstringThunk';fcns.name{fcnNum}='ps3000aOpenUnit'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16Ptr', 'cstring'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aOpenUnitAsync ( int16_t * status , char * serial ); 
fcns.thunkname{fcnNum}='uint32voidPtrcstringThunk';fcns.name{fcnNum}='ps3000aOpenUnitAsync'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16Ptr', 'cstring'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aOpenUnitProgress ( int16_t * handle , int16_t * progressPercent , int16_t * complete ); 
fcns.thunkname{fcnNum}='uint32voidPtrvoidPtrvoidPtrThunk';fcns.name{fcnNum}='ps3000aOpenUnitProgress'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16Ptr', 'int16Ptr', 'int16Ptr'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aGetUnitInfo ( int16_t handle , char * string , int16_t stringLength , int16_t * requiredSize , PICO_INFO info ); 
fcns.thunkname{fcnNum}='uint32int16cstringint16voidPtruint32Thunk';fcns.name{fcnNum}='ps3000aGetUnitInfo'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'cstring', 'int16', 'int16Ptr', 'uint32'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aFlashLed ( int16_t handle , int16_t start ); 
fcns.thunkname{fcnNum}='uint32int16int16Thunk';fcns.name{fcnNum}='ps3000aFlashLed'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'int16'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aCloseUnit ( int16_t handle ); 
fcns.thunkname{fcnNum}='uint32int16Thunk';fcns.name{fcnNum}='ps3000aCloseUnit'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aMemorySegments ( int16_t handle , uint32_t nSegments , int32_t * nMaxSamples ); 
fcns.thunkname{fcnNum}='uint32int16uint32voidPtrThunk';fcns.name{fcnNum}='ps3000aMemorySegments'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'uint32', 'int32Ptr'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aSetChannel ( int16_t handle , PS3000A_CHANNEL channel , int16_t enabled , PS3000A_COUPLING type , PS3000A_RANGE range , float analogOffset ); 
fcns.thunkname{fcnNum}='uint32int16PS3000A_CHANNELint16PS3000A_COUPLINGPS3000A_RANGEfloatThunk';fcns.name{fcnNum}='ps3000aSetChannel'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'enPS3000AChannel', 'int16', 'enPS3000ACoupling', 'enPS3000ARange', 'single'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aSetDigitalPort ( int16_t handle , PS3000A_DIGITAL_PORT port , int16_t enabled , int16_t logicLevel ); 
fcns.thunkname{fcnNum}='uint32int16PS3000A_DIGITAL_PORTint16int16Thunk';fcns.name{fcnNum}='ps3000aSetDigitalPort'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'enPS3000ADigitalPort', 'int16', 'int16'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aSetBandwidthFilter ( int16_t handle , PS3000A_CHANNEL channel , PS3000A_BANDWIDTH_LIMITER bandwidth ); 
fcns.thunkname{fcnNum}='uint32int16PS3000A_CHANNELPS3000A_BANDWIDTH_LIMITERThunk';fcns.name{fcnNum}='ps3000aSetBandwidthFilter'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'enPS3000AChannel', 'enPS3000ABandwidthLimiter'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aSetNoOfCaptures ( int16_t handle , uint32_t nCaptures ); 
fcns.thunkname{fcnNum}='uint32int16uint32Thunk';fcns.name{fcnNum}='ps3000aSetNoOfCaptures'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'uint32'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aGetTimebase ( int16_t handle , uint32_t timebase , int32_t noSamples , int32_t * timeIntervalNanoseconds , int16_t oversample , int32_t * maxSamples , uint32_t segmentIndex ); 
fcns.thunkname{fcnNum}='uint32int16uint32int32voidPtrint16voidPtruint32Thunk';fcns.name{fcnNum}='ps3000aGetTimebase'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'uint32', 'int32', 'int32Ptr', 'int16', 'int32Ptr', 'uint32'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aGetTimebase2 ( int16_t handle , uint32_t timebase , int32_t noSamples , float * timeIntervalNanoseconds , int16_t oversample , int32_t * maxSamples , uint32_t segmentIndex ); 
fcns.thunkname{fcnNum}='uint32int16uint32int32voidPtrint16voidPtruint32Thunk';fcns.name{fcnNum}='ps3000aGetTimebase2'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'uint32', 'int32', 'singlePtr', 'int16', 'int32Ptr', 'uint32'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aSetSigGenArbitrary ( int16_t handle , int32_t offsetVoltage , uint32_t pkToPk , uint32_t startDeltaPhase , uint32_t stopDeltaPhase , uint32_t deltaPhaseIncrement , uint32_t dwellCount , int16_t * arbitraryWaveform , int32_t arbitraryWaveformSize , PS3000A_SWEEP_TYPE sweepType , PS3000A_EXTRA_OPERATIONS operation , PS3000A_INDEX_MODE indexMode , uint32_t shots , uint32_t sweeps , PS3000A_SIGGEN_TRIG_TYPE triggerType , PS3000A_SIGGEN_TRIG_SOURCE triggerSource , int16_t extInThreshold ); 
fcns.thunkname{fcnNum}='uint32int16int32uint32uint32uint32uint32uint32voidPtrint32PS3000A_SWEEP_TYPEPS3000A_EXTRA_OPERATIONSPS3000A_INDEX_MODEuint32uint32PS3000A_SIGGEN_TRIG_TYPEPS3000A_SIGGEN_TRIG_SOURCEint16Thunk';fcns.name{fcnNum}='ps3000aSetSigGenArbitrary'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'int32', 'uint32', 'uint32', 'uint32', 'uint32', 'uint32', 'int16Ptr', 'int32', 'enPS3000ASweepType', 'enPS3000AExtraOperations', 'enPS3000AIndexMode', 'uint32', 'uint32', 'enPS3000ASigGenTrigType', 'enPS3000ASigGenTrigSource', 'int16'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aSetSigGenBuiltIn ( int16_t handle , int32_t offsetVoltage , uint32_t pkToPk , int16_t waveType , float startFrequency , float stopFrequency , float increment , float dwellTime , PS3000A_SWEEP_TYPE sweepType , PS3000A_EXTRA_OPERATIONS operation , uint32_t shots , uint32_t sweeps , PS3000A_SIGGEN_TRIG_TYPE triggerType , PS3000A_SIGGEN_TRIG_SOURCE triggerSource , int16_t extInThreshold ); 
fcns.thunkname{fcnNum}='uint32int16int32uint32int16floatfloatfloatfloatPS3000A_SWEEP_TYPEPS3000A_EXTRA_OPERATIONSuint32uint32PS3000A_SIGGEN_TRIG_TYPEPS3000A_SIGGEN_TRIG_SOURCEint16Thunk';fcns.name{fcnNum}='ps3000aSetSigGenBuiltIn'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'int32', 'uint32', 'int16', 'single', 'single', 'single', 'single', 'enPS3000ASweepType', 'enPS3000AExtraOperations', 'uint32', 'uint32', 'enPS3000ASigGenTrigType', 'enPS3000ASigGenTrigSource', 'int16'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aSetSigGenBuiltInV2 ( int16_t handle , int32_t offsetVoltage , uint32_t pkToPk , int16_t waveType , double startFrequency , double stopFrequency , double increment , double dwellTime , PS3000A_SWEEP_TYPE sweepType , PS3000A_EXTRA_OPERATIONS operation , uint32_t shots , uint32_t sweeps , PS3000A_SIGGEN_TRIG_TYPE triggerType , PS3000A_SIGGEN_TRIG_SOURCE triggerSource , int16_t extInThreshold ); 
fcns.thunkname{fcnNum}='uint32int16int32uint32int16doubledoubledoubledoublePS3000A_SWEEP_TYPEPS3000A_EXTRA_OPERATIONSuint32uint32PS3000A_SIGGEN_TRIG_TYPEPS3000A_SIGGEN_TRIG_SOURCEint16Thunk';fcns.name{fcnNum}='ps3000aSetSigGenBuiltInV2'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'int32', 'uint32', 'int16', 'double', 'double', 'double', 'double', 'enPS3000ASweepType', 'enPS3000AExtraOperations', 'uint32', 'uint32', 'enPS3000ASigGenTrigType', 'enPS3000ASigGenTrigSource', 'int16'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aSetSigGenPropertiesArbitrary ( int16_t handle , uint32_t startDeltaPhase , uint32_t stopDeltaPhase , uint32_t deltaPhaseIncrement , uint32_t dwellCount , PS3000A_SWEEP_TYPE sweepType , uint32_t shots , uint32_t sweeps , PS3000A_SIGGEN_TRIG_TYPE triggerType , PS3000A_SIGGEN_TRIG_SOURCE triggerSource , int16_t extInThreshold ); 
fcns.thunkname{fcnNum}='uint32int16uint32uint32uint32uint32PS3000A_SWEEP_TYPEuint32uint32PS3000A_SIGGEN_TRIG_TYPEPS3000A_SIGGEN_TRIG_SOURCEint16Thunk';fcns.name{fcnNum}='ps3000aSetSigGenPropertiesArbitrary'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'uint32', 'uint32', 'uint32', 'uint32', 'enPS3000ASweepType', 'uint32', 'uint32', 'enPS3000ASigGenTrigType', 'enPS3000ASigGenTrigSource', 'int16'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aSetSigGenPropertiesBuiltIn ( int16_t handle , double startFrequency , double stopFrequency , double increment , double dwellTime , PS3000A_SWEEP_TYPE sweepType , uint32_t shots , uint32_t sweeps , PS3000A_SIGGEN_TRIG_TYPE triggerType , PS3000A_SIGGEN_TRIG_SOURCE triggerSource , int16_t extInThreshold ); 
fcns.thunkname{fcnNum}='uint32int16doubledoubledoubledoublePS3000A_SWEEP_TYPEuint32uint32PS3000A_SIGGEN_TRIG_TYPEPS3000A_SIGGEN_TRIG_SOURCEint16Thunk';fcns.name{fcnNum}='ps3000aSetSigGenPropertiesBuiltIn'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'double', 'double', 'double', 'double', 'enPS3000ASweepType', 'uint32', 'uint32', 'enPS3000ASigGenTrigType', 'enPS3000ASigGenTrigSource', 'int16'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aSigGenFrequencyToPhase ( int16_t handle , double frequency , PS3000A_INDEX_MODE indexMode , uint32_t bufferLength , uint32_t * phase ); 
fcns.thunkname{fcnNum}='uint32int16doublePS3000A_INDEX_MODEuint32voidPtrThunk';fcns.name{fcnNum}='ps3000aSigGenFrequencyToPhase'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'double', 'enPS3000AIndexMode', 'uint32', 'uint32Ptr'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aSigGenArbitraryMinMaxValues ( int16_t handle , int16_t * minArbitraryWaveformValue , int16_t * maxArbitraryWaveformValue , uint32_t * minArbitraryWaveformSize , uint32_t * maxArbitraryWaveformSize ); 
fcns.thunkname{fcnNum}='uint32int16voidPtrvoidPtrvoidPtrvoidPtrThunk';fcns.name{fcnNum}='ps3000aSigGenArbitraryMinMaxValues'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'int16Ptr', 'int16Ptr', 'uint32Ptr', 'uint32Ptr'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aGetMaxEtsValues ( int16_t handle , int16_t * etsCycles , int16_t * etsInterleave ); 
fcns.thunkname{fcnNum}='uint32int16voidPtrvoidPtrThunk';fcns.name{fcnNum}='ps3000aGetMaxEtsValues'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'int16Ptr', 'int16Ptr'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aSigGenSoftwareControl ( int16_t handle , int16_t state ); 
fcns.thunkname{fcnNum}='uint32int16int16Thunk';fcns.name{fcnNum}='ps3000aSigGenSoftwareControl'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'int16'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aSetEts ( int16_t handle , PS3000A_ETS_MODE mode , int16_t etsCycles , int16_t etsInterleave , int32_t * sampleTimePicoseconds ); 
fcns.thunkname{fcnNum}='uint32int16PS3000A_ETS_MODEint16int16voidPtrThunk';fcns.name{fcnNum}='ps3000aSetEts'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'enPS3000AEtsMode', 'int16', 'int16', 'int32Ptr'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aSetSimpleTrigger ( int16_t handle , int16_t enable , PS3000A_CHANNEL source , int16_t threshold , PS3000A_THRESHOLD_DIRECTION direction , uint32_t delay , int16_t autoTrigger_ms ); 
fcns.thunkname{fcnNum}='uint32int16int16PS3000A_CHANNELint16PS3000A_THRESHOLD_DIRECTIONuint32int16Thunk';fcns.name{fcnNum}='ps3000aSetSimpleTrigger'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'int16', 'enPS3000AChannel', 'int16', 'enPS3000AThresholdDirection', 'uint32', 'int16'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aSetTriggerDigitalPortProperties ( int16_t handle , PS3000A_DIGITAL_CHANNEL_DIRECTIONS * directions , int16_t nDirections ); 
fcns.thunkname{fcnNum}='uint32int16voidPtrint16Thunk';fcns.name{fcnNum}='ps3000aSetTriggerDigitalPortProperties'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'tPS3000ADigitalChannelDirectionsPtr', 'int16'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aSetPulseWidthDigitalPortProperties ( int16_t handle , PS3000A_DIGITAL_CHANNEL_DIRECTIONS * directions , int16_t nDirections ); 
fcns.thunkname{fcnNum}='uint32int16voidPtrint16Thunk';fcns.name{fcnNum}='ps3000aSetPulseWidthDigitalPortProperties'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'tPS3000ADigitalChannelDirectionsPtr', 'int16'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aSetTriggerChannelProperties ( int16_t handle , PS3000A_TRIGGER_CHANNEL_PROPERTIES * channelProperties , int16_t nChannelProperties , int16_t auxOutputEnable , int32_t autoTriggerMilliseconds ); 
fcns.thunkname{fcnNum}='uint32int16voidPtrint16int16int32Thunk';fcns.name{fcnNum}='ps3000aSetTriggerChannelProperties'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'tPS3000ATriggerChannelPropertiesPtr', 'int16', 'int16', 'int32'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aSetTriggerChannelConditions ( int16_t handle , PS3000A_TRIGGER_CONDITIONS * conditions , int16_t nConditions ); 
fcns.thunkname{fcnNum}='uint32int16voidPtrint16Thunk';fcns.name{fcnNum}='ps3000aSetTriggerChannelConditions'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'tPS3000ATriggerConditionsPtr', 'int16'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aSetTriggerChannelConditionsV2 ( int16_t handle , PS3000A_TRIGGER_CONDITIONS_V2 * conditions , int16_t nConditions ); 
fcns.thunkname{fcnNum}='uint32int16voidPtrint16Thunk';fcns.name{fcnNum}='ps3000aSetTriggerChannelConditionsV2'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'tPS3000ATriggerConditionsV2Ptr', 'int16'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aSetTriggerChannelDirections ( int16_t handle , PS3000A_THRESHOLD_DIRECTION channelA , PS3000A_THRESHOLD_DIRECTION channelB , PS3000A_THRESHOLD_DIRECTION channelC , PS3000A_THRESHOLD_DIRECTION channelD , PS3000A_THRESHOLD_DIRECTION ext , PS3000A_THRESHOLD_DIRECTION aux ); 
fcns.thunkname{fcnNum}='uint32int16PS3000A_THRESHOLD_DIRECTIONPS3000A_THRESHOLD_DIRECTIONPS3000A_THRESHOLD_DIRECTIONPS3000A_THRESHOLD_DIRECTIONPS3000A_THRESHOLD_DIRECTIONPS3000A_THRESHOLD_DIRECTIONThunk';fcns.name{fcnNum}='ps3000aSetTriggerChannelDirections'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'enPS3000AThresholdDirection', 'enPS3000AThresholdDirection', 'enPS3000AThresholdDirection', 'enPS3000AThresholdDirection', 'enPS3000AThresholdDirection', 'enPS3000AThresholdDirection'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aSetTriggerDelay ( int16_t handle , uint32_t delay ); 
fcns.thunkname{fcnNum}='uint32int16uint32Thunk';fcns.name{fcnNum}='ps3000aSetTriggerDelay'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'uint32'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aSetPulseWidthQualifier ( int16_t handle , PS3000A_PWQ_CONDITIONS * conditions , int16_t nConditions , PS3000A_THRESHOLD_DIRECTION direction , uint32_t lower , uint32_t upper , PS3000A_PULSE_WIDTH_TYPE type ); 
fcns.thunkname{fcnNum}='uint32int16voidPtrint16PS3000A_THRESHOLD_DIRECTIONuint32uint32PS3000A_PULSE_WIDTH_TYPEThunk';fcns.name{fcnNum}='ps3000aSetPulseWidthQualifier'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'tPS3000APwqConditionsPtr', 'int16', 'enPS3000AThresholdDirection', 'uint32', 'uint32', 'enPS3000APulseWidthType'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aSetPulseWidthQualifierV2 ( int16_t handle , PS3000A_PWQ_CONDITIONS_V2 * conditions , int16_t nConditions , PS3000A_THRESHOLD_DIRECTION direction , uint32_t lower , uint32_t upper , PS3000A_PULSE_WIDTH_TYPE type ); 
fcns.thunkname{fcnNum}='uint32int16voidPtrint16PS3000A_THRESHOLD_DIRECTIONuint32uint32PS3000A_PULSE_WIDTH_TYPEThunk';fcns.name{fcnNum}='ps3000aSetPulseWidthQualifierV2'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'tPS3000APwqConditionsV2Ptr', 'int16', 'enPS3000AThresholdDirection', 'uint32', 'uint32', 'enPS3000APulseWidthType'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aIsTriggerOrPulseWidthQualifierEnabled ( int16_t handle , int16_t * triggerEnabled , int16_t * pulseWidthQualifierEnabled ); 
fcns.thunkname{fcnNum}='uint32int16voidPtrvoidPtrThunk';fcns.name{fcnNum}='ps3000aIsTriggerOrPulseWidthQualifierEnabled'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'int16Ptr', 'int16Ptr'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aGetTriggerTimeOffset ( int16_t handle , uint32_t * timeUpper , uint32_t * timeLower , PS3000A_TIME_UNITS * timeUnits , uint32_t segmentIndex ); 
fcns.thunkname{fcnNum}='uint32int16voidPtrvoidPtrvoidPtruint32Thunk';fcns.name{fcnNum}='ps3000aGetTriggerTimeOffset'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'uint32Ptr', 'uint32Ptr', 'enPS3000ATimeUnitsPtr', 'uint32'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aGetTriggerTimeOffset64 ( int16_t handle , int64_t * time , PS3000A_TIME_UNITS * timeUnits , uint32_t segmentIndex ); 
fcns.thunkname{fcnNum}='uint32int16voidPtrvoidPtruint32Thunk';fcns.name{fcnNum}='ps3000aGetTriggerTimeOffset64'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'int64Ptr', 'enPS3000ATimeUnitsPtr', 'uint32'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aGetValuesTriggerTimeOffsetBulk ( int16_t handle , uint32_t * timesUpper , uint32_t * timesLower , uint32_t * timeUnits , uint32_t fromSegmentIndex , uint32_t toSegmentIndex ); 
fcns.thunkname{fcnNum}='uint32int16voidPtrvoidPtrvoidPtruint32uint32Thunk';fcns.name{fcnNum}='ps3000aGetValuesTriggerTimeOffsetBulk'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'uint32Ptr', 'uint32Ptr', 'uint32Ptr', 'uint32', 'uint32'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aGetValuesTriggerTimeOffsetBulk64 ( int16_t handle , int64_t * times , uint32_t * timeUnits , uint32_t fromSegmentIndex , uint32_t toSegmentIndex ); 
fcns.thunkname{fcnNum}='uint32int16voidPtrvoidPtruint32uint32Thunk';fcns.name{fcnNum}='ps3000aGetValuesTriggerTimeOffsetBulk64'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'int64Ptr', 'uint32Ptr', 'uint32', 'uint32'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aGetNoOfCaptures ( int16_t handle , uint32_t * nCaptures ); 
fcns.thunkname{fcnNum}='uint32int16voidPtrThunk';fcns.name{fcnNum}='ps3000aGetNoOfCaptures'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'uint32Ptr'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aGetNoOfProcessedCaptures ( int16_t handle , uint32_t * nProcessedCaptures ); 
fcns.thunkname{fcnNum}='uint32int16voidPtrThunk';fcns.name{fcnNum}='ps3000aGetNoOfProcessedCaptures'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'uint32Ptr'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aSetDataBuffer ( int16_t handle , PS3000A_CHANNEL channelOrPort , int16_t * buffer , int32_t bufferLth , uint32_t segmentIndex , PS3000A_RATIO_MODE mode ); 
fcns.thunkname{fcnNum}='uint32int16PS3000A_CHANNELvoidPtrint32uint32PS3000A_RATIO_MODEThunk';fcns.name{fcnNum}='ps3000aSetDataBuffer'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'enPS3000AChannel', 'int16Ptr', 'int32', 'uint32', 'enPS3000ARatioMode'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aSetDataBuffers ( int16_t handle , PS3000A_CHANNEL channelOrPort , int16_t * bufferMax , int16_t * bufferMin , int32_t bufferLth , uint32_t segmentIndex , PS3000A_RATIO_MODE mode ); 
fcns.thunkname{fcnNum}='uint32int16PS3000A_CHANNELvoidPtrvoidPtrint32uint32PS3000A_RATIO_MODEThunk';fcns.name{fcnNum}='ps3000aSetDataBuffers'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'enPS3000AChannel', 'int16Ptr', 'int16Ptr', 'int32', 'uint32', 'enPS3000ARatioMode'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aSetEtsTimeBuffer ( int16_t handle , int64_t * buffer , int32_t bufferLth ); 
fcns.thunkname{fcnNum}='uint32int16voidPtrint32Thunk';fcns.name{fcnNum}='ps3000aSetEtsTimeBuffer'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'int64Ptr', 'int32'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aSetEtsTimeBuffers ( int16_t handle , uint32_t * timeUpper , uint32_t * timeLower , int32_t bufferLth ); 
fcns.thunkname{fcnNum}='uint32int16voidPtrvoidPtrint32Thunk';fcns.name{fcnNum}='ps3000aSetEtsTimeBuffers'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'uint32Ptr', 'uint32Ptr', 'int32'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aIsReady ( int16_t handle , int16_t * ready ); 
fcns.thunkname{fcnNum}='uint32int16voidPtrThunk';fcns.name{fcnNum}='ps3000aIsReady'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'int16Ptr'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aRunBlock ( int16_t handle , int32_t noOfPreTriggerSamples , int32_t noOfPostTriggerSamples , uint32_t timebase , int16_t oversample , int32_t * timeIndisposedMs , uint32_t segmentIndex , void * lpReady , void * pParameter ); 
fcns.thunkname{fcnNum}='uint32int16int32int32uint32int16voidPtruint32voidPtrvoidPtrThunk';fcns.name{fcnNum}='ps3000aRunBlock'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'int32', 'int32', 'uint32', 'int16', 'int32Ptr', 'uint32', 'voidPtr', 'voidPtr'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aRunStreaming ( int16_t handle , uint32_t * sampleInterval , PS3000A_TIME_UNITS sampleIntervalTimeUnits , uint32_t maxPreTriggerSamples , uint32_t maxPostPreTriggerSamples , int16_t autoStop , uint32_t downSampleRatio , PS3000A_RATIO_MODE downSampleRatioMode , uint32_t overviewBufferSize ); 
fcns.thunkname{fcnNum}='uint32int16voidPtrPS3000A_TIME_UNITSuint32uint32int16uint32PS3000A_RATIO_MODEuint32Thunk';fcns.name{fcnNum}='ps3000aRunStreaming'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'uint32Ptr', 'enPS3000ATimeUnits', 'uint32', 'uint32', 'int16', 'uint32', 'enPS3000ARatioMode', 'uint32'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aGetStreamingLatestValues ( int16_t handle , void * lpPs3000aReady , void * pParameter ); 
fcns.thunkname{fcnNum}='uint32int16voidPtrvoidPtrThunk';fcns.name{fcnNum}='ps3000aGetStreamingLatestValues'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'voidPtr', 'voidPtr'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aNoOfStreamingValues ( int16_t handle , uint32_t * noOfValues ); 
fcns.thunkname{fcnNum}='uint32int16voidPtrThunk';fcns.name{fcnNum}='ps3000aNoOfStreamingValues'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'uint32Ptr'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aGetMaxDownSampleRatio ( int16_t handle , uint32_t noOfUnaggreatedSamples , uint32_t * maxDownSampleRatio , PS3000A_RATIO_MODE downSampleRatioMode , uint32_t segmentIndex ); 
fcns.thunkname{fcnNum}='uint32int16uint32voidPtrPS3000A_RATIO_MODEuint32Thunk';fcns.name{fcnNum}='ps3000aGetMaxDownSampleRatio'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'uint32', 'uint32Ptr', 'enPS3000ARatioMode', 'uint32'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aGetValues ( int16_t handle , uint32_t startIndex , uint32_t * noOfSamples , uint32_t downSampleRatio , PS3000A_RATIO_MODE downSampleRatioMode , uint32_t segmentIndex , int16_t * overflow ); 
fcns.thunkname{fcnNum}='uint32int16uint32voidPtruint32PS3000A_RATIO_MODEuint32voidPtrThunk';fcns.name{fcnNum}='ps3000aGetValues'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'uint32', 'uint32Ptr', 'uint32', 'enPS3000ARatioMode', 'uint32', 'int16Ptr'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aGetValuesBulk ( int16_t handle , uint32_t * noOfSamples , uint32_t fromSegmentIndex , uint32_t toSegmentIndex , uint32_t downSampleRatio , PS3000A_RATIO_MODE downSampleRatioMode , int16_t * overflow ); 
fcns.thunkname{fcnNum}='uint32int16voidPtruint32uint32uint32PS3000A_RATIO_MODEvoidPtrThunk';fcns.name{fcnNum}='ps3000aGetValuesBulk'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'uint32Ptr', 'uint32', 'uint32', 'uint32', 'enPS3000ARatioMode', 'int16Ptr'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aGetValuesAsync ( int16_t handle , uint32_t startIndex , uint32_t noOfSamples , uint32_t downSampleRatio , int16_t downSampleRatioMode , uint32_t segmentIndex , void * lpDataReady , void * pParameter ); 
fcns.thunkname{fcnNum}='uint32int16uint32uint32uint32int16uint32voidPtrvoidPtrThunk';fcns.name{fcnNum}='ps3000aGetValuesAsync'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'uint32', 'uint32', 'uint32', 'int16', 'uint32', 'voidPtr', 'voidPtr'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aGetValuesOverlapped ( int16_t handle , uint32_t startIndex , uint32_t * noOfSamples , uint32_t downSampleRatio , PS3000A_RATIO_MODE downSampleRatioMode , uint32_t segmentIndex , int16_t * overflow ); 
fcns.thunkname{fcnNum}='uint32int16uint32voidPtruint32PS3000A_RATIO_MODEuint32voidPtrThunk';fcns.name{fcnNum}='ps3000aGetValuesOverlapped'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'uint32', 'uint32Ptr', 'uint32', 'enPS3000ARatioMode', 'uint32', 'int16Ptr'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aGetValuesOverlappedBulk ( int16_t handle , uint32_t startIndex , uint32_t * noOfSamples , uint32_t downSampleRatio , PS3000A_RATIO_MODE downSampleRatioMode , uint32_t fromSegmentIndex , uint32_t toSegmentIndex , int16_t * overflow ); 
fcns.thunkname{fcnNum}='uint32int16uint32voidPtruint32PS3000A_RATIO_MODEuint32uint32voidPtrThunk';fcns.name{fcnNum}='ps3000aGetValuesOverlappedBulk'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'uint32', 'uint32Ptr', 'uint32', 'enPS3000ARatioMode', 'uint32', 'uint32', 'int16Ptr'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aGetTriggerInfoBulk ( int16_t handle , PS3000A_TRIGGER_INFO * triggerInfo , uint32_t fromSegmentIndex , uint32_t toSegmentIndex ); 
fcns.thunkname{fcnNum}='uint32int16voidPtruint32uint32Thunk';fcns.name{fcnNum}='ps3000aGetTriggerInfoBulk'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'tPS3000ATriggerInfoPtr', 'uint32', 'uint32'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aStop ( int16_t handle ); 
fcns.thunkname{fcnNum}='uint32int16Thunk';fcns.name{fcnNum}='ps3000aStop'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aHoldOff ( int16_t handle , uint64_t holdoff , PS3000A_HOLDOFF_TYPE type ); 
fcns.thunkname{fcnNum}='uint32int16uint64PS3000A_HOLDOFF_TYPEThunk';fcns.name{fcnNum}='ps3000aHoldOff'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'uint64', 'enPS3000AHoldOffType'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aGetChannelInformation ( int16_t handle , PS3000A_CHANNEL_INFO info , int32_t probe , int32_t * ranges , int32_t * length , int32_t channels ); 
fcns.thunkname{fcnNum}='uint32int16PS3000A_CHANNEL_INFOint32voidPtrvoidPtrint32Thunk';fcns.name{fcnNum}='ps3000aGetChannelInformation'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'enPS3000AChannelInfo', 'int32', 'int32Ptr', 'int32Ptr', 'int32'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aEnumerateUnits ( int16_t * count , char * serials , int16_t * serialLth ); 
fcns.thunkname{fcnNum}='uint32voidPtrcstringvoidPtrThunk';fcns.name{fcnNum}='ps3000aEnumerateUnits'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16Ptr', 'cstring', 'int16Ptr'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aPingUnit ( int16_t handle ); 
fcns.thunkname{fcnNum}='uint32int16Thunk';fcns.name{fcnNum}='ps3000aPingUnit'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aMaximumValue ( int16_t handle , int16_t * value ); 
fcns.thunkname{fcnNum}='uint32int16voidPtrThunk';fcns.name{fcnNum}='ps3000aMaximumValue'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'int16Ptr'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aMinimumValue ( int16_t handle , int16_t * value ); 
fcns.thunkname{fcnNum}='uint32int16voidPtrThunk';fcns.name{fcnNum}='ps3000aMinimumValue'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'int16Ptr'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aGetAnalogueOffset ( int16_t handle , PS3000A_RANGE range , PS3000A_COUPLING coupling , float * maximumVoltage , float * minimumVoltage ); 
fcns.thunkname{fcnNum}='uint32int16PS3000A_RANGEPS3000A_COUPLINGvoidPtrvoidPtrThunk';fcns.name{fcnNum}='ps3000aGetAnalogueOffset'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'enPS3000ARange', 'enPS3000ACoupling', 'singlePtr', 'singlePtr'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aGetMaxSegments ( int16_t handle , uint32_t * maxSegments ); 
fcns.thunkname{fcnNum}='uint32int16voidPtrThunk';fcns.name{fcnNum}='ps3000aGetMaxSegments'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'uint32Ptr'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aChangePowerSource ( int16_t handle , PICO_STATUS powerState ); 
fcns.thunkname{fcnNum}='uint32int16uint32Thunk';fcns.name{fcnNum}='ps3000aChangePowerSource'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16', 'uint32'};fcnNum=fcnNum+1;
% PICO_STATUS ps3000aCurrentPowerSource ( int16_t handle ); 
fcns.thunkname{fcnNum}='uint32int16Thunk';fcns.name{fcnNum}='ps3000aCurrentPowerSource'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint32'; fcns.RHS{fcnNum}={'int16'};fcnNum=fcnNum+1;
structs.tPS3000ATriggerConditions.packing=1;
structs.tPS3000ATriggerConditions.members=struct('channelA', 'enPS3000ATriggerState', 'channelB', 'enPS3000ATriggerState', 'channelC', 'enPS3000ATriggerState', 'channelD', 'enPS3000ATriggerState', 'external', 'enPS3000ATriggerState', 'aux', 'enPS3000ATriggerState', 'pulseWidthQualifier', 'enPS3000ATriggerState');
structs.tPS3000ATriggerConditionsV2.packing=1;
structs.tPS3000ATriggerConditionsV2.members=struct('channelA', 'enPS3000ATriggerState', 'channelB', 'enPS3000ATriggerState', 'channelC', 'enPS3000ATriggerState', 'channelD', 'enPS3000ATriggerState', 'external', 'enPS3000ATriggerState', 'aux', 'enPS3000ATriggerState', 'pulseWidthQualifier', 'enPS3000ATriggerState', 'digital', 'enPS3000ATriggerState');
structs.tPS3000APwqConditions.packing=1;
structs.tPS3000APwqConditions.members=struct('channelA', 'enPS3000ATriggerState', 'channelB', 'enPS3000ATriggerState', 'channelC', 'enPS3000ATriggerState', 'channelD', 'enPS3000ATriggerState', 'external', 'enPS3000ATriggerState', 'aux', 'enPS3000ATriggerState');
structs.tPS3000APwqConditionsV2.packing=1;
structs.tPS3000APwqConditionsV2.members=struct('channelA', 'enPS3000ATriggerState', 'channelB', 'enPS3000ATriggerState', 'channelC', 'enPS3000ATriggerState', 'channelD', 'enPS3000ATriggerState', 'external', 'enPS3000ATriggerState', 'aux', 'enPS3000ATriggerState', 'digital', 'enPS3000ATriggerState');
structs.tPS3000ADigitalChannelDirections.packing=1;
structs.tPS3000ADigitalChannelDirections.members=struct('channel', 'enPS3000ADigitalChannel', 'direction', 'enPS3000ADigitalDirection');
structs.tPS3000ATriggerChannelProperties.packing=1;
structs.tPS3000ATriggerChannelProperties.members=struct('thresholdUpper', 'int16', 'thresholdUpperHysteresis', 'uint16', 'thresholdLower', 'int16', 'thresholdLowerHysteresis', 'uint16', 'channel', 'enPS3000AChannel', 'thresholdMode', 'enPS3000A_ThresholdMode');
structs.tPS3000ATriggerInfo.packing=1;
structs.tPS3000ATriggerInfo.members=struct('status', 'uint32', 'segmentIndex', 'uint32', 'reserved0', 'uint32', 'triggerTime', 'int64', 'timeUnits', 'int16', 'reserved1', 'int16', 'timeStampCounter', 'uint64');
enuminfo.enPS3000ASweepType=struct('PS3000A_UP',0,'PS3000A_DOWN',1,'PS3000A_UPDOWN',2,'PS3000A_DOWNUP',3,'PS3000A_MAX_SWEEP_TYPES',4);
enuminfo.enPS3000ARatioMode=struct('PS3000A_RATIO_MODE_NONE',0,'PS3000A_RATIO_MODE_AGGREGATE',1,'PS3000A_RATIO_MODE_DECIMATE',2,'PS3000A_RATIO_MODE_AVERAGE',4);
enuminfo.enPS3000ATimeUnits=struct('PS3000A_FS',0,'PS3000A_PS',1,'PS3000A_NS',2,'PS3000A_US',3,'PS3000A_MS',4,'PS3000A_S',5,'PS3000A_MAX_TIME_UNITS',6);
enuminfo.enPS3000AChannelBufferIndex=struct('PS3000A_CHANNEL_A_MAX',0,'PS3000A_CHANNEL_A_MIN',1,'PS3000A_CHANNEL_B_MAX',2,'PS3000A_CHANNEL_B_MIN',3,'PS3000A_CHANNEL_C_MAX',4,'PS3000A_CHANNEL_C_MIN',5,'PS3000A_CHANNEL_D_MAX',6,'PS3000A_CHANNEL_D_MIN',7,'PS3000A_MAX_CHANNEL_BUFFERS',8);
enuminfo.enPS3000ASigGenTrigSource=struct('PS3000A_SIGGEN_NONE',0,'PS3000A_SIGGEN_SCOPE_TRIG',1,'PS3000A_SIGGEN_AUX_IN',2,'PS3000A_SIGGEN_EXT_IN',3,'PS3000A_SIGGEN_SOFT_TRIG',4);
enuminfo.enPS3000AWaveType=struct('PS3000A_SINE',0,'PS3000A_SQUARE',1,'PS3000A_TRIANGLE',2,'PS3000A_RAMP_UP',3,'PS3000A_RAMP_DOWN',4,'PS3000A_SINC',5,'PS3000A_GAUSSIAN',6,'PS3000A_HALF_SINE',7,'PS3000A_DC_VOLTAGE',8,'PS3000A_MAX_WAVE_TYPES',9);
enuminfo.enPS3000AChannelInfo=struct('PS3000A_CI_RANGES',0);
enuminfo.enPS3000ATriggerState=struct('PS3000A_CONDITION_DONT_CARE',0,'PS3000A_CONDITION_TRUE',1,'PS3000A_CONDITION_FALSE',2,'PS3000A_CONDITION_MAX',3);
enuminfo.enPS3000AThresholdDirection=struct('PS3000A_ABOVE',0,'PS3000A_BELOW',1,'PS3000A_RISING',2,'PS3000A_FALLING',3,'PS3000A_RISING_OR_FALLING',4,'PS3000A_ABOVE_LOWER',5,'PS3000A_BELOW_LOWER',6,'PS3000A_RISING_LOWER',7,'PS3000A_FALLING_LOWER',8,'PS3000A_INSIDE',0,'PS3000A_OUTSIDE',1,'PS3000A_ENTER',2,'PS3000A_EXIT',3,'PS3000A_ENTER_OR_EXIT',4,'PS3000A_POSITIVE_RUNT',9,'PS3000A_NEGATIVE_RUNT',10,'PS3000A_NONE',2);
enuminfo.enPS3000ADigitalChannel=struct('PS3000A_DIGITAL_CHANNEL_0',0,'PS3000A_DIGITAL_CHANNEL_1',1,'PS3000A_DIGITAL_CHANNEL_2',2,'PS3000A_DIGITAL_CHANNEL_3',3,'PS3000A_DIGITAL_CHANNEL_4',4,'PS3000A_DIGITAL_CHANNEL_5',5,'PS3000A_DIGITAL_CHANNEL_6',6,'PS3000A_DIGITAL_CHANNEL_7',7,'PS3000A_DIGITAL_CHANNEL_8',8,'PS3000A_DIGITAL_CHANNEL_9',9,'PS3000A_DIGITAL_CHANNEL_10',10,'PS3000A_DIGITAL_CHANNEL_11',11,'PS3000A_DIGITAL_CHANNEL_12',12,'PS3000A_DIGITAL_CHANNEL_13',13,'PS3000A_DIGITAL_CHANNEL_14',14,'PS3000A_DIGITAL_CHANNEL_15',15,'PS3000A_DIGITAL_CHANNEL_16',16,'PS3000A_DIGITAL_CHANNEL_17',17,'PS3000A_DIGITAL_CHANNEL_18',18,'PS3000A_DIGITAL_CHANNEL_19',19,'PS3000A_DIGITAL_CHANNEL_20',20,'PS3000A_DIGITAL_CHANNEL_21',21,'PS3000A_DIGITAL_CHANNEL_22',22,'PS3000A_DIGITAL_CHANNEL_23',23,'PS3000A_DIGITAL_CHANNEL_24',24,'PS3000A_DIGITAL_CHANNEL_25',25,'PS3000A_DIGITAL_CHANNEL_26',26,'PS3000A_DIGITAL_CHANNEL_27',27,'PS3000A_DIGITAL_CHANNEL_28',28,'PS3000A_DIGITAL_CHANNEL_29',29,'PS3000A_DIGITAL_CHANNEL_30',30,'PS3000A_DIGITAL_CHANNEL_31',31,'PS3000A_MAX_DIGITAL_CHANNELS',32);
enuminfo.enPS3000APulseWidthType=struct('PS3000A_PW_TYPE_NONE',0,'PS3000A_PW_TYPE_LESS_THAN',1,'PS3000A_PW_TYPE_GREATER_THAN',2,'PS3000A_PW_TYPE_IN_RANGE',3,'PS3000A_PW_TYPE_OUT_OF_RANGE',4);
enuminfo.enPS3000ADigitalPort=struct('PS3000A_DIGITAL_PORT0',128,'PS3000A_DIGITAL_PORT1',129,'PS3000A_DIGITAL_PORT2',130,'PS3000A_DIGITAL_PORT3',131,'PS3000A_MAX_DIGITAL_PORTS',4);
enuminfo.enPS3000ASigGenTrigType=struct('PS3000A_SIGGEN_RISING',0,'PS3000A_SIGGEN_FALLING',1,'PS3000A_SIGGEN_GATE_HIGH',2,'PS3000A_SIGGEN_GATE_LOW',3);
enuminfo.enPS3000ABandwidthLimiter=struct('PS3000A_BW_FULL',0,'PS3000A_BW_20MHZ',1);
enuminfo.enPS3000AChannel=struct('PS3000A_CHANNEL_A',0,'PS3000A_CHANNEL_B',1,'PS3000A_CHANNEL_C',2,'PS3000A_CHANNEL_D',3,'PS3000A_EXTERNAL',4,'PS3000A_MAX_CHANNELS',4,'PS3000A_TRIGGER_AUX',5,'PS3000A_MAX_TRIGGER_SOURCES',6);
enuminfo.enPS3000ACoupling=struct('PS3000A_AC',0,'PS3000A_DC',1);
enuminfo.enPS3000AIndexMode=struct('PS3000A_SINGLE',0,'PS3000A_DUAL',1,'PS3000A_QUAD',2,'PS3000A_MAX_INDEX_MODES',3);
enuminfo.enPS3000AHoldOffType=struct('PS3000A_TIME',0,'PS3000A_EVENT',1,'PS3000A_MAX_HOLDOFF_TYPE',2);
enuminfo.enPS3000ARange=struct('PS3000A_10MV',0,'PS3000A_20MV',1,'PS3000A_50MV',2,'PS3000A_100MV',3,'PS3000A_200MV',4,'PS3000A_500MV',5,'PS3000A_1V',6,'PS3000A_2V',7,'PS3000A_5V',8,'PS3000A_10V',9,'PS3000A_20V',10,'PS3000A_50V',11,'PS3000A_MAX_RANGES',12);
enuminfo.enPS3000A_ThresholdMode=struct('PS3000A_LEVEL',0,'PS3000A_WINDOW',1);
enuminfo.enPS3000AEtsMode=struct('PS3000A_ETS_OFF',0,'PS3000A_ETS_FAST',1,'PS3000A_ETS_SLOW',2,'PS3000A_ETS_MODES_MAX',3);
enuminfo.enPS3000AExtraOperations=struct('PS3000A_ES_OFF',0,'PS3000A_WHITENOISE',1,'PS3000A_PRBS',2);
enuminfo.enPS3000ADigitalDirection=struct('PS3000A_DIGITAL_DONT_CARE',0,'PS3000A_DIGITAL_DIRECTION_LOW',1,'PS3000A_DIGITAL_DIRECTION_HIGH',2,'PS3000A_DIGITAL_DIRECTION_RISING',3,'PS3000A_DIGITAL_DIRECTION_FALLING',4,'PS3000A_DIGITAL_DIRECTION_RISING_OR_FALLING',5,'PS3000A_DIGITAL_MAX_DIRECTION',6);
methodinfo=fcns;