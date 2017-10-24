%------------------------------------------------------------------------------
%   Simulink scrip for change ports property
%   MATLAB version: R2017a
%   Author: Shibo Jiang 
%   Version: 0.4
%   Instructions: fix bugs
%------------------------------------------------------------------------------
%   用于修改inport和outport端口模块属性的脚本
%   MATLAB 版本: R2017a
%   作者: 姜世博 
%   版本:    0.4
%   说明: 修改bug，仅更改模型root层的输入和输出端口属性，不对子系统进行修改  - 0.2
%         修改脚本，在遇到线上没有数据类型端口，不进行默认为uint8的类型改写，
%         当线上没有数据类型时，检测端口是否已经定义数据类型，如定义则根据所
%         定义的数据类型自动补全数据范围等其它属性                         - 0.3 
%         修改bug，在检测到模型配置中采样时间设为连续时，将端口的采样时间设
%         为 默认的 -1                                                  - 0.4                            
%------------------------------------------------------------------------------

function change_ports_result = change_port_property()

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
    %     warning('Simulink:EncodingUnMatched', 'The target character encoding (%s) is different from the original (%s).',...
    %         get_param(0, 'CharacterEncoding'), 'GBK');
    % end

    ChangePortProperty(paraModel, 'Inport')
    ChangePortProperty(paraModel, 'Outport')

    change_ports_result = 'change port property successful';
end
%-----------End of function----------------------------------------------------

%-----------Start of function--------------------------------------------------
function ChangePortProperty(paraModel, block)
    % find all block
    inport_block = find_system(paraModel,'SearchDepth', '1','FindAll','on','BlockType',block);
    % Calculate get parameter
    length_inport = length(inport_block);
    if strcmp('Inport', block)
        SigNamePar = 'OutputSignalNames';
    elseif strcmp('Outport', block)
        SigNamePar = 'InputSignalNames';
    else
        % Do nothing
    end
    % rename inport blocks to signals' name
    for i = 1:length_inport
        current_out_sig_name = get(inport_block(i),SigNamePar);
        % translate cell to string
        current_out_sig_name = cell2mat(current_out_sig_name);
        if 1 == isempty(current_out_sig_name)
            % Do nothing. output line has no name defined.       
        else
            % find if tag symbol '<' exit
            if strcmp('<',current_out_sig_name(1))
                % remove the tag symbol '< >'
                current_out_sig_name = current_out_sig_name(2:end-1);
            else
                % Do nothing
            end
            % change ports property
            try
                set(inport_block(i),'Name',current_out_sig_name);    
                % get parameters datatype
                inport_datatype = current_out_sig_name(end-2:end);
                [set_min, set_max,...
                 set_datatype] = CalculateDataType(inport_datatype);
                disable_flag = 0;
                if strcmp('None',set_datatype)
                    set_datatype = get(inport_block(i),'OutDataTypeStr');
                    set_datatype = TranslateDatatype(set_datatype);
                    if strcmp('StillNone',set_datatype)
                        % do not set port's property
                        disable_flag = 1;
                    else
                        % get new set value
                        [set_min, set_max, ...
                        set_datatype] = CalculateDataType(set_datatype);
                    end
                else
                    % do nothing
                end
                % judge whether set port's property
                if 0 == disable_flag
                    % get cfg
                    if strcmp('Fixed-step', get_param(paraModel, 'SolverType'))
                        sample_time = get_param(paraModel,'FixedStep');
                    else
                        sample_time = '-1';
                    end
                    % define inport block property
                    port_dimension = '1';
                    SetPortProperty(inport_block(i), set_min, set_max,...
                                    set_datatype, sample_time, port_dimension) 
                    % clear port signal resolved
                    inport_signal_line = find_system(paraModel,'FindAll','on','type',...
                                        'line','Name',current_out_sig_name);  
                    set(inport_signal_line,'MustResolveToSignalObject',0); 
                else
                    % do nothing  
                end  
            catch
            
            end
        end
    end
end
%-----------------End of function----------------------------------------------

%-----------Start of function--------------------------------------------------
function [set_min, set_max, set_datatype] = CalculateDataType(data_type_in)
    % translate the upper to lower
    data_type_in = lower(data_type_in);
    % calculate the data type config
    switch data_type_in
    case '_u8'
        set_datatype = 'uint8';
        set_min = '0';
        set_max = '255';
    case 'u16'
        set_datatype = 'uint16';
        set_min = '0';
        set_max = '65535';
    case 'u32'
        set_datatype = 'uint32';
        set_min = '0';
        set_max = '4294967295';
    case 'f32'
        set_datatype = 'single';
        set_min = '-200000000';
        set_max = '200000000';
    case 'f64'
        set_datatype = 'double';
        set_min = '-200000000';
        set_max = '200000000';
    case '_s8'
        set_datatype = 'int8';
        set_min = '-128';
        set_max = '127';
    case 's16'
        set_datatype = 'int16';
        set_min = '-32768';
        set_max = '32767';
    case 's32'
        set_datatype = 'int32';
        set_min = '-2147483648';
        set_max = '2147483647';
    case '_bl'
        set_datatype = 'boolean';
        set_min = '0';
        set_max = '1';
    otherwise
        set_datatype = 'None';
        set_min = '[]';
        set_max = '[]';
    end
end
%-----------------End of function----------------------------------------------

%-----------Start of function--------------------------------------------------
function set_datatype = TranslateDatatype(datatype)
    switch datatype
    case 'uint8'
        set_datatype = '_u8';
    case 'uint16'
        set_datatype = 'u16';
    case 'uint32'
        set_datatype = 'u32';
    case 'single'
        set_datatype = 'f32';
    case 'double'
        set_datatype = 'f64';
    case 'int8'
        set_datatype = '_s8';
    case 'int16'
        set_datatype = 's16';
    case 'int32'
        set_datatype = 's32';
    case 'boolean'
        set_datatype = '_bl';
    otherwise
        set_datatype = 'StillNone';
    end
end
%-----------------End of function----------------------------------------------

%-----------Start of function--------------------------------------------------
function SetPortProperty(port_block, set_min, set_max, ...
                         set_datatype, sample_time, port_dimension)
    set(port_block,'OutDataTypeStr',set_datatype);
    set(port_block,'OutMin',set_min);
    set(port_block,'OutMax',set_max);
    set(port_block,'SampleTime',sample_time);
    set(port_block,'PortDimensions',port_dimension);  
end
%-----------------End of function----------------------------------------------