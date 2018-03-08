%------------------------------------------------------------------------------
%   Simulink scrip for hiding block names.
%   MATLAB version: R2017a
%   Author        : Shibo Jiang 
%   Version       : 0.1
%   Instructions  : the blocks include MinMax,UnitDelay,Sqrt,Merge,Product,
%                   Logic,RelationalOperator,Switch,MultiPortSwitch,Goto,
%                   From,Terminator,ModelReference
%------------------------------------------------------------------------------

function hide_block_name_result = hide_name_blocks()

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

    % find MinMax blocks
    min_max_blocks = find_system(paraModel,'FindAll',...
                                 'on','BlockType','MinMax');
    % find UnitDelay blocks
    uint_delay_blocks = find_system(paraModel,'FindAll',...
                                    'on','BlockType','UnitDelay');
    % find Sqrt blocks
    sqrt_blocks = find_system(paraModel,'FindAll',...
                              'on','BlockType','Sqrt');
    % find Merge blocks
    merge_blocks = find_system(paraModel,'FindAll','on',...
                               'BlockType','Merge');
    % find Product blocks
    product_blocks = find_system(paraModel,'FindAll',...
                                 'on','BlockType','Product');
    % find Logic blocks
    logic_blocks = find_system(paraModel,'FindAll',...
                               'on','BlockType','Logic');
    % find RelationalOperator blocks
    relational_operator_blocks = find_system(paraModel,'FindAll',...
                             'on','BlockType','RelationalOperator');
    % find Switch blocks
    switch_blocks = find_system(paraModel,'FindAll',...
                                'on','BlockType','Switch');
    % find MultiPortSwitch blocks
    multi_switch_blocks = find_system(paraModel,'FindAll',...
                                'on','BlockType','MultiPortSwitch');
    % find Goto blocks
    goto_blocks = find_system(paraModel,'FindAll',...
                              'on','BlockType','Goto');
    % find From blocks
    from_blocks = find_system(paraModel,'FindAll',...
                              'on','BlockType','From');
    % find Terminator blocks
    terminator_blocks = find_system(paraModel,'FindAll',...
                              'on','BlockType','Terminator');
    % find ModelReference blocks
    model_reference_blocks = find_system(paraModel,'FindAll',...
                              'on','BlockType','ModelReference');
    % find Switch blocks
    switch_blocks = find_system(paraModel,'FindAll',...
                              'on','BlockType','Switch');

    % all blocks which need hiding names
    hide_name_blocks = [min_max_blocks',uint_delay_blocks',sqrt_blocks',...
                        merge_blocks',product_blocks',logic_blocks'...
                        ,relational_operator_blocks',switch_blocks',...
                        multi_switch_blocks',goto_blocks',from_blocks'...
                        ,terminator_blocks',model_reference_blocks',...
                        switch_blocks'];

    length_hide_name_line = length(hide_name_blocks);
    for i = 1:length_hide_name_line
        try
            set_param(hide_name_blocks(i),'ShowName','off');
        catch
            % do nothing
        end
    end
    % report configurate results
    hide_block_name_result = 'Hide block name successful';
end
