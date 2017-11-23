%------------------------------------------------------------------------------
%   Simulink scrip for define stateflow parameter's type as 
%   'Inherit: Same as Simulink'.
%   MATLAB       : R2017a
%   Author       : Shibo Jiang 
%   Version      : 0.2
%   Time         : 2017/11/23
%   Instructions : Fix bugs                -0.2
%------------------------------------------------------------------------------

function result = auto_sf_par_type()

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
    %            get_param(0, 'CharacterEncoding'), 'GBK');
    % end

    % find all stateflow parameter
    sf = sfroot;
    all_sf_parameter = sf.find('-isa','Stateflow.Data');

    if isempty(all_sf_parameter)
        % report the result
        result = 'There is no stateflow parameter in this model.';
    else
        % define the input/output parameter's data type
        length_sf_par = length(all_sf_parameter);
        for i = 1:length_sf_par
            set(all_sf_parameter(i),'DataType','Inherit: Same as Simulink'); 
        end
        result = 'Define stateflow parameters datatype as [Inherit: Same as Simulink] successful';

    end
end
