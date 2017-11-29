%------------------------------------------------------------------------------
%   Simulink scrip for change ports property to default
%   MATLAB version: R2017a
%   Author        : Shibo Jiang 
%   Version       : 0.3
%   Instructions  : 修改bug，仅对模型root层输入输出端口进行修改           - 0.2
%                   策略修改，仅还原能够使用信号线上后缀名字定义的数据
%                   类型的端口                                          - 0.3
%------------------------------------------------------------------------------

function default_ports_result = default_port_property()

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
    %     warning('Simulink:EncodingUnMatched', 'The target character...
    %     encoding (%s) is different from the original (%s).',...
    %         get_param(0, 'CharacterEncoding'), 'GBK');
    % end

    DefaultPortProperty(paraModel, 'Inport')
    DefaultPortProperty(paraModel, 'Outport')

    default_ports_result = 'change port property to default value successful';
end
%-----------End of function----------------------------------------------------

%-----------Start of function--------------------------------------------------
function DefaultPortProperty(paraModel, block)
    % find all inport block
    inport_block = find_system(paraModel,'SearchDepth', '1','FindAll','on',...
                            'BlockType',block);
    % Calculate parameter
    if strcmp('Inport', block)
        SigNamePar = 'OutputSignalNames';
    elseif strcmp('Outport', block)
        SigNamePar = 'InputSignalNames';
    else
        % Do nothing
    end
    % rename inport blocks to signals' name
    length_inport = length(inport_block);
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
                % get parameters datatype
                inport_datatype = current_out_sig_name(end-2:end);
                set_datatype = CalculateDataType(inport_datatype);
                if ~strcmp('None',set_datatype)
                    % define inport block property
                    set(inport_block(i),'OutDataTypeStr','Inherit: auto');
                    set(inport_block(i),'OutMin','[]');
                    set(inport_block(i),'OutMax','[]');
                    set(inport_block(i),'SampleTime','-1');
                    set(inport_block(i),'PortDimensions','-1'); 
                else
                    set(inport_block(i),'OutMin','[]');
                    set(inport_block(i),'OutMax','[]');
                    set(inport_block(i),'SampleTime','-1');
                    set(inport_block(i),'PortDimensions','-1');
                end      
            catch
                % Do nothing
            end
        end
    end
end
%-----------End of function----------------------------------------------------

%-----------Start of function--------------------------------------------------
function set_datatype = CalculateDataType(data_type_in)
    % translate the upper to lower
    data_type_in = lower(data_type_in);
    % calculate the data type config
    switch data_type_in
    case '_u8'
        set_datatype = 'uint8';
    case 'u16'
        set_datatype = 'uint16';
    case 'u32'
        set_datatype = 'uint32';
    case 'f32'
        set_datatype = 'single';
    case 'f64'
        set_datatype = 'double';
    case '_s8'
        set_datatype = 'int8';
    case 's16'
        set_datatype = 'int16';
    case 's32'
        set_datatype = 'int32';
    case '_bl'
        set_datatype = 'boolean';
    otherwise
        set_datatype = 'None';
    end
end
%-----------------End of function----------------------------------------------