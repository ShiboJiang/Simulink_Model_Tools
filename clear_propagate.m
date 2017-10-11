%------------------------------------------------------------------------------
%   Simulink scrip for clear propagated signals.
%   MATLAB version: R2016a
%   Author: Shibo Jiang 
%   Version: 0.1
%   Instructions: 
%------------------------------------------------------------------------------
%   用于在信号线上清楚勾选 信号广播的脚本
%   MATLAB 版本: R2016a
%   作者: 姜世博 
%   版本:    0.1
%   说明: 
%------------------------------------------------------------------------------

function clear_propagae_result = clear_propagate()

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
length_ps_line = length(all_line);
for i = 1:length_ps_line
    try
        set(all_line(i),'SignalPropagation','off');
    catch
       
    end
end
% report configurate results
clear_propagae_result = 'Clear propagated successful';