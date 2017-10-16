%------------------------------------------------------------------------------
%   Simulink scrip for patameters adding as uint8.
%   MATLAB version: R2016a
%   Author: Shibo Jiang 
%   Version: 0.1
%   Instructions: 
%------------------------------------------------------------------------------
%   用于定义simulink变量的脚本
%   MATLAB 版本: R2016a
%   作者: 姜世博 
%   版本:    0.1
%   说明: 
%------------------------------------------------------------------------------

function add_parameter_result = add_sig_parameter_u8()

paraModel = bdroot;

% Original matalb version is R2016a
% 检查Matlab版本是否为R2016a
CorrectVersion = '9.0.0.341360 (R2016a)';
CurrentVersion = version;
if 1 ~= strcmp(CorrectVersion,CurrentVersion);
    %warning('Matlab version mismatch, this scrip should be used for Matlab R2016a'); 
end

% Original environment character encoding: GBK
% 脚本编码环境是否为GBK
if ~strcmpi(get_param(0, 'CharacterEncoding'), 'GBK')
    warning('Simulink:EncodingUnMatched', 'The target character encoding (%s) is different from the original (%s).',...
           get_param(0, 'CharacterEncoding'), 'GBK');
end

all_line = find_system(paraModel,'FindAll','on','type','line');
% Parameters define
k = 1;
length_line = length(all_line);
named_flag = 0;
% Find the line which have name
for i = 1:length_line
    % Detect 'Signal name'
    current_line_name = get(all_line(i),'Name');
     % judge whether signal has name 
    if 1 == isempty(current_line_name)
        % no name
        ne_flag = 1;
    else
        % have name
        ne_flag = 0;
    end
    % collect signals name
    if  0 == ne_flag
        named_signals_line(k) = all_line(i);
        k = k + 1;
        named_flag = 1;
    else
        % Do nothing ,keep named_flag = 0;
    end
end

% find simulink's variables
simulink_var_space = get_param(paraModel,'ModelWorkspace');
simulink_var = simulink_var_space.whos;
if 1 == isempty(simulink_var)
    % no variable defined
    simulink_var_flag = 0;
else
    % have some variables defined
    simulink_var_flag = 1;
end

% judge whether signal's name have been defined to variables
var_define_enable = 0;
% have signal names and have some variables defined
if (1 == named_flag)&&(1 == simulink_var_flag)
    length_named_line = length(named_signals_line);
    length_var = length(simulink_var);
    k = 1;
    for i = 1:length_named_line
        signal_name = get(named_signals_line(i),'Name');
        for j = 1:length_var
            var_name = simulink_var(j).name;
            if 1 == strcmp(signal_name,var_name)
                break;
            else
                % collect name which need be defined 
                if length_var == j
                    var_need_defined{k} = signal_name;
                    k = k + 1;
                    var_define_enable = 1;
                else
                    % Do nothing ,wrong state
                end        
            end
        end
    end  
% have signal names and have no variables defined          
elseif (1 == named_flag)&&(0 == simulink_var_flag)
    length_named_line = length(named_signals_line);
    k = 1;
    for i = 1:length_named_line
        var_need_defined{k} = get(named_signals_line(i),'Name');
        k = k + 1;
    end
    var_define_enable = 1;
% have no signal names, do not auto define variables    
else    
    % Do nothing
end

% auto add variables in simulink workspace
data_type_cfg = 'uint8';
if 1 == var_define_enable
    length_add_var = length(var_need_defined);
    for i = 1:length_add_var
        name_defined = var_need_defined{i};
        try
        temp_defined = Simulink.Signal;
        temp_defined.DataType =  data_type_cfg;
        % eval([name_defined '= temp_defined']);
        % clear temp_defined;
        assignin('base',name_defined,temp_defined);
        catch
            % do nothing
        end
    end
    % report configurate results
    add_parameter_result = 'Add signal parameters successful';
else
    % report configurate results
    add_parameter_result = 'No signal line have names';
end
