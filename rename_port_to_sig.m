%------------------------------------------------------------------------------
%   Simulink scrip for rename the blocks' name to signals' name
%   MATLAB version: R2017a
%   Author        : Shibo Jiang 
%   Time          : 2017/12/20
%   Version       : Initial                                   -0.1
%                   Support goto & from block   
%                   Code refactoring                          -0.2
%   Instructions  : 
%------------------------------------------------------------------------------

function rename_ports_result = rename_port_to_sig()

    paraModel = bdroot;

    % Original matalb version is R2017a
    % 检查Matlab版本是否为R202017a
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
    %            get_param(0, 'CharacterEncoding'), 'GBK');
    % end

    % find all inport block
    inport_block = find_system(paraModel,'FindAll','on','BlockType','Inport');
    % find all outport block
    outport_block = find_system(paraModel,'FindAll','on',...
                                      'BlockType','Outport');
    % Find all Goto block
    goto_block = find_system(paraModel, 'FindAll','on','BlockType','Goto');
    % Find all From block
    from_block = find_system(paraModel,'FindAll','on','BlockType','From');

    % rename inport blocks to signals' name
    SetPortName(inport_block, 'OutputSignalNames', 'Name');
    % rename outport blocks to signals' name
    SetPortName(outport_block, 'InputSignalNames', 'Name');
    % Rename Goto blocks to signals's name
    SetPortName(goto_block, 'InputSignalNames','GotoTag');
    % Rename From blocks to signals's name
    SetPortName(from_block, 'OutputSignalNames','GotoTag');

    

    rename_ports_result = 'rename port to signal name successful';
end
%-----------------End of function----------------------------------------------

%-----------Start of function--------------------------------------------------
function SetPortName(block, get_type, set_type)
    if isempty(block)
        % Do nothing
    else
        length_block = length(block);
        for i = 1:length_block
            current_sig_name = get(block(i), get_type);
            % translate cell to string
            current_sig_name = cell2mat(current_sig_name);
            if 1 == isempty(current_sig_name)
                % Do nothing. output line has no name defined.       
            else
                % find if tag symbol '<' exit
                if strcmp('<',current_sig_name(1))
                    % remove the tag symbol '< >'
                    current_sig_name = current_sig_name(2:end-1);
                else
                    % Do nothing
                end
                % rename
                try
                    set(block(i), set_type, current_sig_name);        
                catch
                    
                end
            end
        end
    end
end
%-----------------End of function----------------------------------------------
