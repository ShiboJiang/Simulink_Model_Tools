%------------------------------------------------------------------------------
%   Simulink scrip for rename the blocks' name to signals' name
%   MATLAB version: R2017a
%   Author: Shibo Jiang 
%   Version: 0.1
%   Instructions: 
%------------------------------------------------------------------------------
%   用于重命名模块上 信号线 上的名字，修改为所连接的端口的名字
%   MATLAB 版本: R2017a
%   作者: 姜世博 
%   版本:    0.1
%   说明: 
%------------------------------------------------------------------------------

function rename_sig_result = rename_sig_to_port()

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

    % find all blocks which needed
    inport_block = find_system(paraModel,'FindAll','on','BlockType','Inport');
    outport_block = find_system(paraModel,'FindAll','on','BlockType','Outport');
    all_line = find_system(paraModel,'FindAll','on','type','line');
    % filter lines which can be named
    n = 0;
    for i = 1:length(all_line)
        current_cfg = get(all_line(i),'SignalPropagation');
        if strcmp('off', current_cfg)
            n = n + 1;
            filter_lines(n) = all_line(i);        
        end
    end
    % rename them
    RenameSigName(inport_block, filter_lines);
    RenameSigName(outport_block, filter_lines);

    rename_sig_result = 'Rename signal lines successful';
end
%-----------End of function----------------------------------------------------

%-----------Start of function--------------------------------------------------
function RenameSigName(blocks, lines)
    length_lines = length(lines);
    length_block = length(blocks);
    % judge reference handles type
    if strcmp('Inport', get_param(blocks(1), 'BlockType'))
        handle_type = 'SrcBlockHandle';
    else
        handle_type = 'DstBlockHandle';
    end
    % find block links and rename them
    for i = 1:length_block
        current_handle = num2str(get_param(blocks(i),'Handle'));
        for j = 1:length_lines
            % calculate reference handle
            reference_handle = num2str(get_param(lines(j), handle_type));
            if strcmp(current_handle, reference_handle)
                target_name = get_param(blocks(i), 'Name');
                set_param(lines(j), 'Name', target_name);
                break;
            end
        end
    end
end
%-----------End of function----------------------------------------------------