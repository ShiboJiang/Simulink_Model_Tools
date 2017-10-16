%------------------------------------------------------------------------------
%   Simulink scrip for resolve to signals.
%   MATLAB version: R2017a
%   Author: Shibo Jiang 
%   Version: 0.1
%   Instructions: 
%------------------------------------------------------------------------------
%   用于在信号线上勾选 Signal name must resolve to Simulink signal object 的脚本
%   MATLAB 版本: R2017a
%   作者: 姜世博 
%   版本:    0.1
%   说明: 
%------------------------------------------------------------------------------

function clear_resolve_result = clear_resolve()

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
%     warning('Simulink:EncodingUnMatched', 'The target character encoding (%s) is different from the original (%s).',...
%            get_param(0, 'CharacterEncoding'), 'GBK');
% end

all_line = find_system(paraModel,'FindAll','on','type','line');

length_rs_line = length(all_line);
for i = 1:length_rs_line
    try
        set(all_line(i),'MustResolveToSignalObject',0);
    catch
        % do nothing
    end
end
% report configurate results
clear_resolve_result = 'Clear resolve successful';
