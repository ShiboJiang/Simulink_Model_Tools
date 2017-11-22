%---------------------------------------------------------------------------
%   Simulink scrip for Autosar configuration set 
%   MATLAB version: R2017a
%   Please read the document <基于Autosar配置说明文档 v0.9> to learn details.
%   Shibo Jiang    2017/11/2
%   Version: 0.9.6
%   Instructions: Run this scrip in matlab command,and one model should be 
%                 opened at least. 
%---------------------------------------------------------------------------
%   适配Autosar目标的simulink模型配置脚本
%   MATLAB 版本: R2017a
%   具体每项内容可以参考《基于Autosar配置说明文档 v0.9》文档内容
%   姜世博         2017/11/2
%   版本:    0.9.6
%   说明: 在matlab命令窗格直接运行此脚本
%         需要注意至少打开一个模型进行配置。
%---------------------------------------------------------------------------

function Configurate = Autosar_configuration()

paraModel = bdroot;

% Original matalb version is R2017a
% 检查Matlab版本是否为R2017a
CorrectVersion_win = '9.2.0.556344 (R2017a)';    % windows
CorrectVersion_linux =  '9.2.0.538062 (R2017a)';   % linux
CurrentVersion = version;
if 1 ~= bitor(strcmp(CorrectVersion_win, CurrentVersion),...
              strcmp(CorrectVersion_linux, CurrentVersion))
   warning('Matlab version mismatch, this scrip should be used for Matlab R2017a'); 
end


% Original environment character encoding: GBK
% 脚本编码环境是否为GBK
% if ~strcmpi(get_param(0, 'CharacterEncoding'), 'GBK')
%     warning('Simulink:EncodingUnMatched', 'The target character encoding (%s) is different from the original (%s).',  get_param(0, 'CharacterEncoding'), 'GBK');
% end

% Original configuration set target is autosar.tlc
% 将代码生成目标模板设置为 autosar.tlc
myConfigObj=getActiveConfigSet(paraModel);
try
    switchTarget(myConfigObj, 'autosar.tlc', '');
catch
    disp(ME.message);
    disp('Setting ''System target file'' to ''ert.tlc''.');
    switchTarget(myConfigObj, 'ert.tlc', '');
end

% Set [Display > Signals & Ports > Wide Nonscalar Lines] as on
set_param(paraModel, 'WideLines', 'on');
% Set [Display > Signals & Ports > Viewer Indicator] as on
set_param(paraModel, 'ShowViewerIcons', 'on');
% Set [Display > Signals & Ports > Test point & Logging Indicator] as on
set_param(paraModel, 'ShowTestPointIcons', 'on');
% Set [Display > Signals & Ports > Linearization Indicators] as on
set_param(paraModel, 'ShowLinearizationAnnotations', 'on');
% Set [Display > Library Links] as none
set_param(paraModel,'LibraryLinkDisplay', 'none');
% Set font style as Arial
set_param(paraModel,'DefaultAnnotationFontName', 'Arial');
set_param(paraModel,'DefaultBlockFontName', 'Arial');
set_param(paraModel,'DefaultLineFontName', 'Arial');

set_param(paraModel,'DefaultAnnotationFontSize', '10');
set_param(paraModel,'DefaultBlockFontSize', '10');
set_param(paraModel,'DefaultLineFontSize', '10');

% Do not change the order of the following commands. There are dependencies between the parameters.
% 不要修改如下命令行的顺序，相互之间有依赖关系

set_param(paraModel, 'HardwareBoard', 'None');   % Hardware board

% Solver
set_param(paraModel, 'StartTime', '0.0');   % Start time
set_param(paraModel, 'StopTime', '10');   % Stop time
set_param(paraModel, 'SolverType', 'Fixed-step');   % Type
set_param(paraModel, 'EnableConcurrentExecution', 'off');   % Show concurrent execution options
set_param(paraModel, 'SampleTimeConstraint', 'Unconstrained');   % Periodic sample time constraint
set_param(paraModel, 'Solver', 'FixedStepDiscrete');   % Solver
set_param(paraModel, 'FixedStep', 'auto');   % Fixed-step size (fundamental sample time)
set_param(paraModel, 'EnableMultiTasking', 'on');   % Treat each discrete rate as a separate task
set_param(paraModel, 'AutoInsertRateTranBlk', 'off');   % Automatically handle rate transition for data transfer
set_param(paraModel, 'PositivePriorityOrder', 'off');   % Higher priority value indicates higher task priority

% Data Import/Export
set_param(paraModel, 'LoadExternalInput', 'off');   % Load external input
set_param(paraModel, 'LoadInitialState', 'off');   % Load initial state
set_param(paraModel, 'SaveTime', 'off');   % Save time
set_param(paraModel, 'SaveState', 'off');   % Save states
set_param(paraModel, 'SaveFormat', 'Dataset');   % Format
set_param(paraModel, 'SaveOutput', 'off');   % Save output
set_param(paraModel, 'SaveFinalState', 'off');   % Save final state
set_param(paraModel, 'SignalLogging', 'on');   % Signal logging
set_param(paraModel, 'SignalLoggingName', 'logsout');   % Signal logging name
set_param(paraModel, 'DSMLogging', 'on');   % Data stores
set_param(paraModel, 'DSMLoggingName', 'dsmout');   % Data stores logging name
set_param(paraModel, 'LoggingToFile', 'off');   % Log Dataset data to file
set_param(paraModel, 'DatasetSignalFormat', 'timeseries');   % DatasetSignalFormat
set_param(paraModel, 'ReturnWorkspaceOutputs', 'off');   % Single simulation output
set_param(paraModel, 'InspectSignalLogs', 'off');   % Record logged workspace data in Simulation Data Inspector
set_param(paraModel, 'LimitDataPoints', 'on');   % Limit data points
set_param(paraModel, 'MaxDataPoints', '1000');   % Maximum number of data points
set_param(paraModel, 'Decimation', '1');   % Decimation

% Optimization
set_param(paraModel, 'BlockReduction', 'on');   % Block reduction
set_param(paraModel, 'ConditionallyExecuteInputs', 'on');   % Conditional input branch execution
set_param(paraModel, 'BooleanDataType', 'on');   % Implement logic signals as Boolean data (vs. double)
set_param(paraModel, 'LifeSpan', 'inf');   % Application lifespan (days)
set_param(paraModel, 'UseDivisionForNetSlopeComputation', 'on');   % Use division for fixed-point net slope computation
set_param(paraModel, 'UseFloatMulNetSlope', 'off');   % Use floating-point multiplication to handle net slope corrections
set_param(paraModel, 'DefaultUnderspecifiedDataType', 'single');   % Default for underspecified data type
set_param(paraModel, 'UseSpecifiedMinMax', 'off');   % Optimize using the specified minimum and maximum values
set_param(paraModel, 'ZeroExternalMemoryAtStartup', 'off');   % Remove root level I/O zero initialization
set_param(paraModel, 'InitFltsAndDblsToZero', 'off');   % Use memset to initialize floats and doubles to 0.0
set_param(paraModel, 'ZeroInternalMemoryAtStartup', 'on');   % Remove internal data zero initialization
set_param(paraModel, 'EfficientFloat2IntCast', 'off');   % Remove code from floating-point to integer conversions that wraps out-of-range values
set_param(paraModel, 'EfficientMapNaN2IntZero', 'off');   % Remove code from floating-point to integer conversions with saturation that maps NaN to zero
set_param(paraModel, 'NoFixptDivByZeroProtection', 'off');   % Remove code that protects against division arithmetic exceptions
set_param(paraModel, 'SimCompilerOptimization', 'off');   % Compiler optimization level
set_param(paraModel, 'AccelVerboseBuild', 'off');   % Verbose accelerator builds
set_param(paraModel, 'DefaultParameterBehavior', 'Inlined');   % Default parameter behavior
set_param(paraModel, 'OptimizeBlockIOStorage', 'on');   % Signal storage reuse
set_param(paraModel, 'LocalBlockOutputs', 'on');   % Enable local block outputs
set_param(paraModel, 'ExpressionFolding', 'on');   % Eliminate superfluous local variables (expression folding)
set_param(paraModel, 'BufferReuse', 'on');   % Reuse local block outputs
set_param(paraModel, 'GlobalBufferReuse', 'on');   % Reuse global block outputs
set_param(paraModel, 'GlobalVariableUsage', 'Use global to hold temporary results');   % Optimize global data access
set_param(paraModel, 'OptimizeBlockOrder', 'off');   % Optimize block operation order in the generated code
set_param(paraModel, 'OptimizeDataStoreBuffers', 'on');   % Reuse buffers for Data Store Read and Data Store Write blocks
set_param(paraModel, 'BusAssignmentInplaceUpdate', 'on');   % Perform inplace updates for Bus Assignment blocks
set_param(paraModel, 'StrengthReduction', 'off');   % Simplify array indexing
set_param(paraModel, 'EnableMemcpy', 'on');   % Use memcpy for vector assignment
set_param(paraModel, 'MemcpyThreshold', 64);   % Memcpy threshold (bytes)
set_param(paraModel, 'BooleansAsBitfields', 'off');   % Pack Boolean data into bitfields
set_param(paraModel, 'InlineInvariantSignals', 'off');   % Inline invariant signals
set_param(paraModel, 'RollThreshold', 5);   % Loop unrolling threshold
set_param(paraModel, 'MaxStackSize', 'Inherit from target');   % Maximum stack size (bytes)
set_param(paraModel, 'PassReuseOutputArgsAs', 'Individual arguments');   % Pass reusable subsystem outputs as
set_param(paraModel, 'StateBitsets', 'off');   % Use bitsets for storing state configuration
set_param(paraModel, 'DataBitsets', 'off');   % Use bitsets for storing Boolean data
set_param(paraModel, 'ActiveStateOutputEnumStorageType', 'Native Integer');   % Base storage type for automatically created enumerations
set_param(paraModel, 'AdvancedOptControl', '');   % AdvancedOptControl
set_param(paraModel, 'BufferReusableBoundary', 'off');   % BufferReusableBoundary
set_param(paraModel, 'PassReuseOutputArgsThreshold', 12);   % Threshold

% Diagnostics
set_param(paraModel, 'AlgebraicLoopMsg', 'error');   % Algebraic loop
set_param(paraModel, 'ArtificialAlgebraicLoopMsg', 'error');   % Minimize algebraic loop
set_param(paraModel, 'BlockPriorityViolationMsg', 'error');   % Block priority violation
set_param(paraModel, 'MinStepSizeMsg', 'warning');   % Min step size violation
set_param(paraModel, 'TimeAdjustmentMsg', 'none');   % Sample hit time adjusting
set_param(paraModel, 'MaxConsecutiveZCsMsg', 'error');   % Consecutive zero crossings violation
set_param(paraModel, 'UnknownTsInhSupMsg', 'warning');   % Unspecified inheritability of sample time
set_param(paraModel, 'ConsistencyChecking', 'none');   % Solver data inconsistency
set_param(paraModel, 'SolverPrmCheckMsg', 'error');   % Automatic solver parameter selection
set_param(paraModel, 'ModelReferenceExtraNoncontSigs', 'error');   % Extraneous discrete derivative signals
set_param(paraModel, 'StateNameClashWarn', 'warning');   % State name clash
set_param(paraModel, 'SimStateInterfaceChecksumMismatchMsg', 'warning');   % SimState interface checksum mismatch
set_param(paraModel, 'SimStateOlderReleaseMsg', 'error');   % SimState object from earlier release
set_param(paraModel, 'InheritedTsInSrcMsg', 'warning');   % Source block specifies -1 sample time
set_param(paraModel, 'MultiTaskRateTransMsg', 'error');   % Multitask rate transition
set_param(paraModel, 'SingleTaskRateTransMsg', 'warning');   % Single task rate transition
set_param(paraModel, 'MultiTaskCondExecSysMsg', 'error');   % Multitask conditionally executed subsystem
set_param(paraModel, 'TasksWithSamePriorityMsg', 'warning');   % Tasks with equal priority
set_param(paraModel, 'SigSpecEnsureSampleTimeMsg', 'warning');   % Enforce sample times specified by Signal Specification blocks
set_param(paraModel, 'SignalResolutionControl', 'UseLocalSettings');   % Signal resolution
set_param(paraModel, 'CheckMatrixSingularityMsg', 'warning');   % Division by singular matrix
set_param(paraModel, 'IntegerSaturationMsg', 'error');   % Saturate on overflow
set_param(paraModel, 'UnderSpecifiedDataTypeMsg', 'warning');   % Underspecified data types
set_param(paraModel, 'SignalRangeChecking', 'warning');   % Simulation range checking
set_param(paraModel, 'IntegerOverflowMsg', 'error');   % Wrap on overflow
set_param(paraModel, 'SignalInfNanChecking', 'warning');   % Inf or NaN block output
set_param(paraModel, 'RTPrefix', 'warning');   % "rt" prefix for identifiers
set_param(paraModel, 'ParameterDowncastMsg', 'warning');   % Detect downcast
set_param(paraModel, 'ParameterOverflowMsg', 'warning');   % Detect overflow
set_param(paraModel, 'ParameterUnderflowMsg', 'warning');   % Detect underflow
set_param(paraModel, 'ParameterPrecisionLossMsg', 'warning');   % Detect precision loss
set_param(paraModel, 'ParameterTunabilityLossMsg', 'warning');   % Detect loss of tunability
set_param(paraModel, 'ReadBeforeWriteMsg', 'EnableAllAsWarning');   % Detect read before write
set_param(paraModel, 'WriteAfterReadMsg', 'EnableAllAsWarning');   % Detect write after read
set_param(paraModel, 'WriteAfterWriteMsg', 'EnableAllAsWarning');   % Detect write after write
set_param(paraModel, 'MultiTaskDSMMsg', 'warning');   % Multitask data store
set_param(paraModel, 'UniqueDataStoreMsg', 'warning');   % Duplicate data store names
set_param(paraModel, 'UnderspecifiedInitializationDetection', 'Simplified');   % Underspecified initialization detection
set_param(paraModel, 'ArrayBoundsChecking', 'none');   % Array bounds exceeded
set_param(paraModel, 'AssertControl', 'DisableAll');   % Model Verification block enabling
set_param(paraModel, 'AllowSymbolicDim', 'off');   % Allow symbolic dimension specification
set_param(paraModel, 'UnnecessaryDatatypeConvMsg', 'warning');   % Unnecessary type conversions
set_param(paraModel, 'VectorMatrixConversionMsg', 'warning');   % Vector/matrix block input conversion
set_param(paraModel, 'Int32ToFloatConvMsg', 'warning');   % 32-bit integer to single precision float conversion
set_param(paraModel, 'FixptConstUnderflowMsg', 'warning');   % Detect underflow
set_param(paraModel, 'FixptConstOverflowMsg', 'warning');   % Detect overflow
set_param(paraModel, 'FixptConstPrecisionLossMsg', 'warning');   % Detect precision loss
set_param(paraModel, 'SignalLabelMismatchMsg', 'warning');   % Signal label mismatch
set_param(paraModel, 'UnconnectedInputMsg', 'warning');   % Unconnected block input ports
set_param(paraModel, 'UnconnectedOutputMsg', 'warning');   % Unconnected block output ports
set_param(paraModel, 'UnconnectedLineMsg', 'warning');   % Unconnected line
set_param(paraModel, 'RootOutportRequireBusObject', 'warning');   % Unspecified bus object at root Outport block
set_param(paraModel, 'BusObjectLabelMismatch', 'warning');   % Element name mismatch
set_param(paraModel, 'StrictBusMsg', 'ErrorOnBusTreatedAsVector');   % Bus signal treated as vector
set_param(paraModel, 'NonBusSignalsTreatedAsBus', 'warning');   % Non-bus signals treated as bus signals
set_param(paraModel, 'BusNameAdapt', 'WarnAndRepair');   % Repair bus selections
set_param(paraModel, 'InvalidFcnCallConnMsg', 'error');   % Invalid function-call connection
set_param(paraModel, 'FcnCallInpInsideContextMsg', 'error');   % Context-dependent inputs
set_param(paraModel, 'SFcnCompatibilityMsg', 'warning');   % S-function upgrades needed
set_param(paraModel, 'FrameProcessingCompatibilityMsg', 'error');   % Block behavior depends on frame status of signal
set_param(paraModel, 'ModelReferenceVersionMismatchMessage', 'warning');   % Model block version mismatch
set_param(paraModel, 'ModelReferenceIOMismatchMessage', 'warning');   % Port and parameter mismatch
set_param(paraModel, 'ModelReferenceIOMsg', 'warning');   % Invalid root Inport/Outport block connection
set_param(paraModel, 'ModelReferenceDataLoggingMessage', 'warning');   % Unsupported data logging
set_param(paraModel, 'SaveWithDisabledLinksMsg', 'warning');   % Block diagram contains disabled library links
set_param(paraModel, 'SaveWithParameterizedLinksMsg', 'warning');   % Block diagram contains parameterized library links
set_param(paraModel, 'SFUnusedDataAndEventsDiag', 'warning');   % Unused data, events, messages and functions
set_param(paraModel, 'SFUnexpectedBacktrackingDiag', 'error');   % Unexpected backtracking
set_param(paraModel, 'SFInvalidInputDataAccessInChartInitDiag', 'warning');   % Invalid input data access in chart initialization
set_param(paraModel, 'SFNoUnconditionalDefaultTransitionDiag', 'error');   % No unconditional default transitions
set_param(paraModel, 'SFTransitionOutsideNaturalParentDiag', 'warning');   % Transition outside natural parent
set_param(paraModel, 'SFUnreachableExecutionPathDiag', 'warning');   % Unreachable execution path
set_param(paraModel, 'SFUndirectedBroadcastEventsDiag', 'warning');   % Undirected event broadcasts
set_param(paraModel, 'SFTransitionActionBeforeConditionDiag', 'warning');   % Transition action specified before condition action
set_param(paraModel, 'SFOutputUsedAsStateInMooreChartDiag', 'error');   % Read-before-write to output in Moore chart
set_param(paraModel, 'SFTemporalDelaySmallerThanSampleTimeDiag', 'warning');   % Absolute time temporal value shorter than sampling period
set_param(paraModel, 'SFSelfTransitionDiag', 'warning');   % Self-transition on leaf state
set_param(paraModel, 'SFExecutionAtInitializationDiag', 'warning');   % 'Execute-at-initialization' disabled in presence of input events
set_param(paraModel, 'SFMachineParentedDataDiag', 'warning');   % Use of machine-parented data instead of Data Store Memory
set_param(paraModel, 'IgnoredZcDiagnostic', 'warning');   % IgnoredZcDiagnostic
set_param(paraModel, 'InitInArrayFormatMsg', 'warning');   % InitInArrayFormatMsg
set_param(paraModel, 'MaskedZcDiagnostic', 'warning');   % MaskedZcDiagnostic
set_param(paraModel, 'ModelReferenceSymbolNameMessage', 'warning');   % ModelReferenceSymbolNameMessage
set_param(paraModel, 'AllowedUnitSystems', 'all');   % Allowed unit systems
set_param(paraModel, 'UnitsInconsistencyMsg', 'warning');   % Units inconsistency messages
set_param(paraModel, 'AllowAutomaticUnitConversions', 'on');   % Allow automatic unit conversions

% Hardware Implementation
set_param(paraModel, 'ProdHWDeviceType', 'Infineon->TriCore');   % Production device vendor and type
set_param(paraModel, 'ProdLongLongMode', 'off');   % Support long long in production hardware
set_param(paraModel, 'ProdLargestAtomicInteger', 'Char');   % Production hardware largest atomic integer size
set_param(paraModel, 'ProdLargestAtomicFloat', 'Float');   % Production hardware largest atomic floating-point size
set_param(paraModel, 'ProdIntDivRoundTo', 'Zero');   % Production hardware signed integer division rounds to
set_param(paraModel, 'ProdEqTarget', 'on');   % Test hardware is the same as production hardware
set_param(paraModel, 'TargetPreprocMaxBitsSint', 32);   % TargetPreprocMaxBitsSint
set_param(paraModel, 'TargetPreprocMaxBitsUint', 32);   % TargetPreprocMaxBitsUint

% Model Referencing
set_param(paraModel, 'UpdateModelReferenceTargets', 'IfOutOfDateOrStructuralChange');   % Rebuild
set_param(paraModel, 'EnableParallelModelReferenceBuilds', 'off');   % Enable parallel model reference builds
set_param(paraModel, 'ModelReferenceNumInstancesAllowed', 'Multi');   % Total number of instances allowed per top model
set_param(paraModel, 'PropagateVarSize', 'Infer from blocks in model');   % Propagate sizes of variable-size signals
set_param(paraModel, 'ModelReferenceMinAlgLoopOccurrences', 'off');   % Minimize algebraic loop occurrences
set_param(paraModel, 'EnableRefExpFcnMdlSchedulingChecks', 'on');   % Enable strict scheduling checks for referenced export-function models
set_param(paraModel, 'PropagateSignalLabelsOutOfModel', 'on');   % Propagate all signal labels out of the model
set_param(paraModel, 'ModelReferencePassRootInputsByReference', 'off');   % Pass fixed-size scalar root inputs by value for code generation
set_param(paraModel, 'ModelDependencies', '');   % Model dependencies
set_param(paraModel, 'ParallelModelReferenceErrorOnInvalidPool', 'on');   % ParallelModelReferenceErrorOnInvalidPool
set_param(paraModel, 'SupportModelReferenceSimTargetCustomCode', 'off');   % SupportModelReferenceSimTargetCustomCode

% Simulation Target
set_param(paraModel, 'MATLABDynamicMemAlloc', 'off');   % Dynamic memory allocation in MATLAB Function blocks
set_param(paraModel, 'CompileTimeRecursionLimit', 50);   % Compile-time recursion limit for MATLAB functions
set_param(paraModel, 'EnableRuntimeRecursion', 'on');   % Enable run-time recursion for MATLAB functions
set_param(paraModel, 'SFSimEcho', 'on');   % Echo expressions without semicolons
set_param(paraModel, 'SimCtrlC', 'on');   % Ensure responsiveness
set_param(paraModel, 'SimIntegrity', 'on');   % Ensure memory integrity
set_param(paraModel, 'SimGenImportedTypeDefs', 'off');   % Generate typedefs for imported bus and enumeration types
set_param(paraModel, 'SimBuildMode', 'sf_incremental_build');   % Simulation target build mode
set_param(paraModel, 'SimReservedNameArray', []);   % Reserved names
set_param(paraModel, 'SimParseCustomCode', 'off');   % Parse custom code symbols
set_param(paraModel, 'SimCustomSourceCode', '');   % Source file
set_param(paraModel, 'SimCustomHeaderCode', '');   % Header file
set_param(paraModel, 'SimCustomInitializer', '');   % Initialize function
set_param(paraModel, 'SimCustomTerminator', '');   % Terminate function
set_param(paraModel, 'SimUserIncludeDirs', '');   % Include directories
set_param(paraModel, 'SimUserSources', '');   % Source files
set_param(paraModel, 'SimUserLibraries', '');   % Libraries
set_param(paraModel, 'SimUserDefines', '');   % Defines
set_param(paraModel, 'SFSimEnableDebug', 'off');   % Allow setting breakpoints during simulation

% Code Generation
set_param(paraModel, 'RemoveResetFunc', 'on');   % Remove reset function
set_param(paraModel, 'ExistingSharedCode', '');   % Existing shared code
set_param(paraModel, 'TargetLang', 'C');   % Language
set_param(paraModel, 'CompOptLevelCompliant', 'on');   % CompOptLevelCompliant
set_param(paraModel, 'Toolchain', 'Automatically locate an installed toolchain');   % Toolchain
set_param(paraModel, 'BuildConfiguration', 'Faster Builds');   % Build configuration
set_param(paraModel, 'ObjectivePriorities', []);   % Prioritized objectives
set_param(paraModel, 'CheckMdlBeforeBuild', 'off');   % Check model before generating code
set_param(paraModel, 'SILDebugging', 'off');   % Enable source-level debugging for SIL
set_param(paraModel, 'GenCodeOnly', 'on');   % Generate code only
set_param(paraModel, 'PackageGeneratedCodeAndArtifacts', 'off');   % Package code and artifacts
set_param(paraModel, 'RTWVerbose', 'off');   % Verbose build
set_param(paraModel, 'RetainRTWFile', 'off');   % Retain .rtw file
set_param(paraModel, 'ProfileTLC', 'off');   % Profile TLC
set_param(paraModel, 'TLCDebug', 'off');   % Start TLC debugger when generating code
set_param(paraModel, 'TLCCoverage', 'off');   % Start TLC coverage when generating code
set_param(paraModel, 'TLCAssert', 'off');   % Enable TLC assertion
set_param(paraModel, 'RTWUseSimCustomCode', 'off');   % Use the same custom code settings as Simulation Target
set_param(paraModel, 'CustomSourceCode', '');   % Source file
set_param(paraModel, 'CustomHeaderCode', '');   % Header file
set_param(paraModel, 'CustomInclude', '');   % Include directories
set_param(paraModel, 'CustomSource', '');   % Source files
set_param(paraModel, 'CustomLibrary', '');   % Libraries
set_param(paraModel, 'CustomLAPACKCallback', '');   % Custom LAPACK library callback
set_param(paraModel, 'CustomDefine', '');   % Defines
set_param(paraModel, 'CustomInitializer', '');   % Initialize function
set_param(paraModel, 'CustomTerminator', '');   % Terminate function
set_param(paraModel, 'CodeExecutionProfiling', 'off');   % Measure task execution time
set_param(paraModel, 'CodeProfilingInstrumentation', 'off');   % Measure function execution times
set_param(paraModel, 'CodeCoverageSettings', coder.coverage.CodeCoverageSettings([],'off','off','None'));   % Third-party tool
set_param(paraModel, 'CreateSILPILBlock', 'None');   % Create block
set_param(paraModel, 'PortableWordSizes', 'on');   % Enable portable word sizes
set_param(paraModel, 'PostCodeGenCommand', '');   % Post code generation command
set_param(paraModel, 'SaveLog', 'off');   % Save build log
set_param(paraModel, 'TLCOptions', '');   % TLC command line options
set_param(paraModel, 'GenerateReport', 'on');   % Create code generation report
set_param(paraModel, 'LaunchReport', 'on');   % Open report automatically
set_param(paraModel, 'IncludeHyperlinkInReport', 'on');   % Code-to-model
set_param(paraModel, 'GenerateTraceInfo', 'on');   % Model-to-code
set_param(paraModel, 'GenerateWebview', 'off');   % Generate model Web view
set_param(paraModel, 'GenerateTraceReport', 'on');   % Eliminated / virtual blocks
set_param(paraModel, 'GenerateTraceReportSl', 'on');   % Traceable Simulink blocks
set_param(paraModel, 'GenerateTraceReportSf', 'on');   % Traceable Stateflow objects
set_param(paraModel, 'GenerateTraceReportEml', 'on');   % Traceable MATLAB functions
set_param(paraModel, 'GenerateCodeMetricsReport', 'on');   % Static code metrics
set_param(paraModel, 'GenerateCodeReplacementReport', 'on');   % Summarize which blocks triggered code replacements
set_param(paraModel, 'GenerateComments', 'on');   % Include comments
set_param(paraModel, 'SimulinkBlockComments', 'on');   % Simulink block / Stateflow object comments
set_param(paraModel, 'MATLABSourceComments', 'on');   % MATLAB source code as comments
set_param(paraModel, 'ShowEliminatedStatement', 'on');   % Show eliminated blocks
set_param(paraModel, 'ForceParamTrailComments', 'on');   % Verbose comments for SimulinkGlobal storage class
set_param(paraModel, 'OperatorAnnotations', 'on');   % Operator annotations
set_param(paraModel, 'InsertBlockDesc', 'on');   % Simulink block descriptions
set_param(paraModel, 'SFDataObjDesc', 'on');   % Stateflow object descriptions
set_param(paraModel, 'SimulinkDataObjDesc', 'on');   % Simulink data object descriptions
set_param(paraModel, 'ReqsInCode', 'off');   % Requirements in block comments
set_param(paraModel, 'EnableCustomComments', 'off');   % Custom comments (MPT objects only)
set_param(paraModel, 'MATLABFcnDesc', 'on');   % MATLAB function help text
set_param(paraModel, 'CustomSymbolStrGlobalVar', '$R$N$M');   % Global variables
set_param(paraModel, 'CustomSymbolStrType', '$N$R$M_T');   % Global types
set_param(paraModel, 'CustomSymbolStrField', '$N$M');   % Field name of global types
set_param(paraModel, 'CustomSymbolStrFcn', '$R$N$M$F');   % Subsystem methods
set_param(paraModel, 'CustomSymbolStrFcnArg', 'rt$I$N$M');   % Subsystem method arguments
set_param(paraModel, 'CustomSymbolStrTmpVar', '$N$M');   % Local temporary variables
set_param(paraModel, 'CustomSymbolStrBlkIO', 'rtb_$N$M');   % Local block output variables
set_param(paraModel, 'CustomSymbolStrMacro', '$R$N$M');   % Constant macros
set_param(paraModel, 'CustomSymbolStrUtil', '$N$C');   % Shared utilities
set_param(paraModel, 'CustomSymbolStrEmxType', 'emxArray_$M$N');   % EMX array types identifier format
set_param(paraModel, 'CustomSymbolStrEmxFcn', 'emx$M$N');   % EMX array utility functions identifier format
set_param(paraModel, 'MangleLength', 4);   % Minimum mangle length
set_param(paraModel, 'MaxIdLength', 31);   % Maximum identifier length
set_param(paraModel, 'InternalIdentifier', 'Shortened');   % System-generated identifiers
set_param(paraModel, 'InlinedPrmAccess', 'Literals');   % Generate scalar inlined parameters as
set_param(paraModel, 'SignalNamingRule', 'None');   % Signal naming
set_param(paraModel, 'ParamNamingRule', 'None');   % Parameter naming
set_param(paraModel, 'DefineNamingRule', 'None');   % #define naming
set_param(paraModel, 'UseSimReservedNames', 'off');   % Use the same reserved names as Simulation Target
set_param(paraModel, 'ReservedNameArray', []);   % Reserved names
set_param(paraModel, 'IgnoreCustomStorageClasses', 'off');   % Ignore custom storage classes
set_param(paraModel, 'IgnoreTestpoints', 'on');   % Ignore test point signals
set_param(paraModel, 'CommentStyle', 'Auto');   % Comment style
set_param(paraModel, 'IncAutoGenComments', 'off');   % IncAutoGenComments
set_param(paraModel, 'IncDataTypeInIds', 'off');   % IncDataTypeInIds
set_param(paraModel, 'IncHierarchyInIds', 'off');   % IncHierarchyInIds
set_param(paraModel, 'InsertPolySpaceComments', 'off');   % Insert Polyspace comments
set_param(paraModel, 'PreserveName', 'off');   % PreserveName
set_param(paraModel, 'PreserveNameWithParent', 'off');   % PreserveNameWithParent
set_param(paraModel, 'CustomUserTokenString', '');   % Custom token text
set_param(paraModel, 'TargetLangStandard', 'C89/C90 (ANSI)');   % Standard math library
set_param(paraModel, 'CodeReplacementLibrary', 'None');   % Code replacement library
set_param(paraModel, 'UtilityFuncGeneration', 'Shared location');   % Shared code placement
set_param(paraModel, 'CodeInterfacePackaging', 'Nonreusable function');   % Code interface packaging
set_param(paraModel, 'GRTInterface', 'off');   % Classic call interface
set_param(paraModel, 'PurelyIntegerCode', 'off');   % Support floating-point numbers
set_param(paraModel, 'SupportNonFinite', 'off');   % Support non-finite numbers
set_param(paraModel, 'SupportComplex', 'off');   % Support complex numbers
set_param(paraModel, 'SupportAbsoluteTime', 'off');   % Support absolute time
set_param(paraModel, 'SupportContinuousTime', 'off');   % Support continuous time
set_param(paraModel, 'SupportNonInlinedSFcns', 'off');   % Support non-inlined S-functions
set_param(paraModel, 'SupportVariableSizeSignals', 'off');   % Support variable-size signals
set_param(paraModel, 'MultiwordTypeDef', 'System defined');   % Multiword type definitions
set_param(paraModel, 'CombineOutputUpdateFcns', 'on');   % Single output/update function
set_param(paraModel, 'IncludeMdlTerminateFcn', 'off');   % Terminate function required
set_param(paraModel, 'MatFileLogging', 'off');   % MAT-file logging
set_param(paraModel, 'SuppressErrorStatus', 'on');   % Remove error status field in real-time model data structure
set_param(paraModel, 'CombineSignalStateStructs', 'off');   % Combine signal/state structures
set_param(paraModel, 'ParenthesesLevel', 'Maximum');   % Parentheses level
set_param(paraModel, 'CastingMode', 'Standards');   % Casting modes
set_param(paraModel, 'GenerateSampleERTMain', 'off');   % Generate an example main program
set_param(paraModel, 'IncludeFileDelimiter', 'UseQuote');   % #include file delimiter
set_param(paraModel, 'CPPClassGenCompliant', 'on');   % CPPClassGenCompliant
set_param(paraModel, 'ConcurrentExecutionCompliant', 'off');   % ConcurrentExecutionCompliant
set_param(paraModel, 'ERTCustomFileBanners', 'on');   % ERTCustomFileBanners
set_param(paraModel, 'ERTFirstTimeCompliant', 'on');   % ERTFirstTimeCompliant
set_param(paraModel, 'GenerateFullHeader', 'on');   % GenerateFullHeader
set_param(paraModel, 'InferredTypesCompatibility', 'off');   % InferredTypesCompatibility
set_param(paraModel, 'GenerateSharedConstants', 'off');   % Generate shared constants
set_param(paraModel, 'ModelReferenceCompliant', 'on');   % ModelReferenceCompliant
set_param(paraModel, 'ModelStepFunctionPrototypeControlCompliant', 'off');   % ModelStepFunctionPrototypeControlCompliant
set_param(paraModel, 'ParMdlRefBuildCompliant', 'on');   % ParMdlRefBuildCompliant
set_param(paraModel, 'TargetFcnLib', 'ansi_tfl_table_tmw.mat');   % TargetFcnLib
set_param(paraModel, 'TargetLibSuffix', '');   % TargetLibSuffix
set_param(paraModel, 'TargetPreCompLibLocation', '');   % TargetPreCompLibLocation
set_param(paraModel, 'UseToolchainInfoCompliant', 'on');   % UseToolchainInfoCompliant
set_param(paraModel, 'RemoveDisableFunc', 'off');   % Remove disable function
set_param(paraModel, 'MemSecPackage', '--- None ---');   % Memory sections package for model data and functions
set_param(paraModel, 'GlobalDataDefinition', 'Auto');   % Data definition
set_param(paraModel, 'GlobalDataReference', 'Auto');   % Data declaration
set_param(paraModel, 'ExtMode', 'off');   % External mode
set_param(paraModel, 'EnableUserReplacementTypes', 'off');   % Replace data type names in the generated code
set_param(paraModel, 'ConvertIfToSwitch', 'on');   % Convert if-elseif-else patterns to switch-case statements
set_param(paraModel, 'ERTCustomFileTemplate', 'example_file_process.tlc');   % File customization template
set_param(paraModel, 'ERTDataHdrFileTemplate', 'ert_code_template.cgt');   % Header file template
set_param(paraModel, 'ERTDataSrcFileTemplate', 'ert_code_template.cgt');   % Source file template
set_param(paraModel, 'ERTFilePackagingFormat', 'Compact');   % File packaging format
set_param(paraModel, 'ERTHdrFileBannerTemplate', 'ert_code_template.cgt');   % Header file template
set_param(paraModel, 'ERTSrcFileBannerTemplate', 'ert_code_template.cgt');   % Source file template
set_param(paraModel, 'EnableDataOwnership', 'off');   % Use owner from data object for data definition placement
set_param(paraModel, 'GenerateASAP2', 'on');   % ASAP2 interface
set_param(paraModel, 'IndentSize', '4');   % Indent size
set_param(paraModel, 'IndentStyle', 'Allman');   % Indent style
set_param(paraModel, 'InlinedParameterPlacement', 'Hierarchical');   % Parameter structure
set_param(paraModel, 'MemSecDataConstants', 'Default');   % Memory section for constants
set_param(paraModel, 'MemSecDataIO', 'Default');   % Memory section for inputs/outputs
set_param(paraModel, 'MemSecDataInternal', 'Default');   % Memory section for internal data
set_param(paraModel, 'MemSecDataParameters', 'Default');   % Memory section for parameters
set_param(paraModel, 'MemSecFuncExecute', 'Default');   % Memory section for execution functions
set_param(paraModel, 'MemSecFuncInitTerm', 'Default');   % Memory section for initialize/terminate functions
set_param(paraModel, 'MemSecFuncSharedUtil', 'Default');   % Memory section for shared utility functions
set_param(paraModel, 'ParamTuneLevel', 10);   % Parameter tune level
set_param(paraModel, 'EnableSignedLeftShifts', 'off');   % Replace multiplications by powers of two with signed bitwise shifts
set_param(paraModel, 'EnableSignedRightShifts', 'off');   % Allow right shifts on signed integers
set_param(paraModel, 'PreserveExpressionOrder', 'on');   % Preserve operand order in expression
set_param(paraModel, 'PreserveExternInFcnDecls', 'on');   % Preserve extern keyword in function declarations
set_param(paraModel, 'PreserveIfCondition', 'on');   % Preserve condition expression in if statement
set_param(paraModel, 'RTWCAPIParams', 'off');   % Generate C API for parameters
set_param(paraModel, 'RTWCAPIRootIO', 'off');   % Generate C API for root-level I/O
set_param(paraModel, 'RTWCAPISignals', 'off');   % Generate C API for signals
set_param(paraModel, 'RTWCAPIStates', 'off');   % Generate C API for states
set_param(paraModel, 'RateGroupingCode', 'on');   % RateGroupingCode
set_param(paraModel, 'SignalDisplayLevel', 10);   % Signal display level
set_param(paraModel, 'SuppressUnreachableDefaultCases', 'off');   % Suppress generation of default cases for Stateflow switch statements if unreachable
set_param(paraModel, 'BooleanTrueId', 'true');   % Boolean true identifier
set_param(paraModel, 'BooleanFalseId', 'false');   % Boolean false identifier
set_param(paraModel, 'MaxIdInt32', 'MAX_int32_T');   % 32-bit integer maximum identifier
set_param(paraModel, 'MinIdInt32', 'MIN_int32_T');   % 32-bit integer minimum identifier
set_param(paraModel, 'MaxIdUint32', 'MAX_uint32_T');   % 32-bit unsigned integer maximum identifier
set_param(paraModel, 'MaxIdInt16', 'MAX_int16_T');   % 16-bit integer maximum identifier
set_param(paraModel, 'MinIdInt16', 'MIN_int16_T');   % 16-bit integer minimum identifier
set_param(paraModel, 'MaxIdUint16', 'MAX_uint16_T');   % 16-bit unsigned integer maximum identifier
set_param(paraModel, 'MaxIdInt8', 'MAX_int8_T');   % 8-bit integer maximum identifier
set_param(paraModel, 'MinIdInt8', 'MIN_int8_T');   % 8-bit integer minimum identifier
set_param(paraModel, 'MaxIdUint8', 'MAX_uint8_T');   % 8-bit unsigned integer maximum identifier
set_param(paraModel, 'TypeLimitIdReplacementHeaderFile', '');   % Type limit identifier replacement header file
set_param(paraModel, 'AutosarCompilerAbstraction', 'off');   % Use AUTOSAR compiler abstraction macros
set_param(paraModel, 'AutosarMatrixIOAsArray', 'off');   % Support root-level matrix I/O using one-dimensional arrays
set_param(paraModel, 'AutosarMaxShortNameLength', 64);   % Maximum SHORT-NAME length
set_param(paraModel, 'AutosarSchemaVersion', '4.2');   % Generate XML file for schema version

% Simulink Coverage
set_param(paraModel, 'CovModelRefEnable', 'off');   % Record coverage for referenced models
set_param(paraModel, 'RecordCoverage', 'off');   % Record coverage for this model
set_param(paraModel, 'CovEnable', 'off');   % Enable coverage analysis
set_param(paraModel, 'CovEnableCumulative', 'on');   % Enable cumulative data collection
set_param(paraModel, 'CovSaveCumulativeToWorkspaceVar', 'on');   % Save cumulative coverage results in workspace variable
set_param(paraModel, 'CovCumulativeVarName', 'covCumulativeData');   % Cumulative coverage variable name
set_param(paraModel, 'CovSaveName', 'covdata');   % Last coverage run variable name
set_param(paraModel, 'CovNameIncrementing', 'off');   % Increment cvdata variable name with each simulation
set_param(paraModel, 'CovReportOnPause', 'on');   % Update coverage results on pause
set_param(paraModel, 'CovHTMLOptions', '');   % Coverage report options
set_param(paraModel, 'CovCumulativeReport', 'off');   % Include cumulative data in coverage report
set_param(paraModel, 'CovCompData', '');   % Additional data to include in coverage report
set_param(paraModel, 'CovFilter', '');   % Coverage filter filename
set_param(paraModel, 'CovSaveOutputData', 'on');   % Save output data

% HDL Coder
hdlset_param(paraModel,'GenerateHDLCode','off');   % Generate HDL code

Configurate = 'Autosar config successful, script version 0.9.6';