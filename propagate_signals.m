%------------------------------------------------------------------------------
%   Simulink scrip for propagating signals.
%   MATLAB version: R2017a
%   Author        : Shibo Jiang 
%   Version       : 0.1
%   Instructions  : 
%------------------------------------------------------------------------------

function propagae_signals_result = propagate_signals()

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

    all_line = find_system(paraModel,'FindAll','on','type','line');
    % Parameters define
    j = 1;
    % k = 1;
    enable_pg_flag = 0;
    length_line = length(all_line);

    % Find the line which need propagating signals
    for i = 1:length_line
        % Detect 'Show propagated signals' state 
        current_line_sp = get(all_line(i),'SignalPropagation');
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
        % judge whether 'Show propagated signals' is 'on'
        if 0 == strcmp(current_line_sp,'on')
            sp_flag = 2;
        else
            sp_flag = 0;
        end
        line_a_flag = bitor(sp_flag,ne_flag);
        if 3 == line_a_flag
            propagated_signals_line(j) = all_line(i);
            j = j + 1;
            enable_pg_flag = 1;
        else
            % Do nothing
        end
    end

    % set signal propagation to on
    if 1 == enable_pg_flag
        length_ps_line = length(propagated_signals_line);
        for i = 1:length_ps_line
            try
                set(propagated_signals_line(i),'SignalPropagation','on');
            catch
                warning('This line',propagated_signals_line(i),...
                'can not set the propagated signals on,',...
                ' it should define name first');
            end
        end
        % report configurate results
        propagae_signals_result = 'Propagate signals successful';
    else
        % report configurate results
        propagae_signals_result = 'No signal line need propagating signal';
    end
end

