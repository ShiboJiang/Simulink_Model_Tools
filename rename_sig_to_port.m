%------------------------------------------------------------------------------
%   Simulink scrip for rename the blocks' name to signals' name
%   MATLAB version: R2017a
%   Author        : Shibo Jiang 
%   Time          : 2017/12/20
%   Version       : Creat as initial                               - 0.1
%                   Support goto & from block   
%                   Code refactoring                               - 0.2
%   Instructions  : 
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
    goto_block = find_system(paraModel, 'FindAll','on','BlockType','Goto');
    from_block = find_system(paraModel,'FindAll','on','BlockType','From');

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
    % Rename them
    RenameSigName(goto_block, filter_lines, 'DstBlockHandle', 'GotoTag');
    RenameSigName(from_block, filter_lines, 'SrcBlockHandle', 'GotoTag');
    RenameSigName(inport_block, filter_lines, 'SrcBlockHandle', 'Name');
    RenameSigName(outport_block, filter_lines, 'DstBlockHandle', 'Name');

    rename_sig_result = 'Rename signal lines successful';
end
%-----------End of function----------------------------------------------------

%-----------Start of function--------------------------------------------------
function RenameSigName(blocks, lines, connect_handle, name_par)
    length_lines = length(lines);
    % Judge whether block is empty
    if isempty(blocks)
        % Do Nothing
    else
        length_block = length(blocks);
        % find block links and rename them
        for i = 1:length_block
            current_handle = num2str(get_param(blocks(i),'Handle'));
            for j = 1:length_lines
                % calculate reference handle
                reference_handle = num2str(get_param(lines(j), ...
                                           connect_handle));
                if strcmp(current_handle, reference_handle)
                    target_name = get_param(blocks(i), name_par);
                    set_param(lines(j), 'Name', target_name);
                    break;
                end
            end
        end
    end
end
%-----------End of function----------------------------------------------------