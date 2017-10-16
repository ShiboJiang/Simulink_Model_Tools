%------------------------------------------------------------------------------
%   Simulink scrip for hiding port names.
%   MATLAB version: R2017a
%   Author: Shibo Jiang 
%   Version: 0.1
%   Instructions: the blocks include Inport,Outport
%------------------------------------------------------------------------------
%   用于隐藏部分模块名称 的脚本
%   MATLAB 版本: R2017a
%   作者: 姜世博 
%   版本:    0.1
%   说明: 
%------------------------------------------------------------------------------

function hide_port_name_result = hide_ports_name()

paraModel = bdroot;

% Original matalb version is R2017a
% 检查Matlab版本是否为R202017a
CorrectVersion = '9.2.0.556344 (R2017a)';
CurrentVersion = version;
if 1 ~= strcmp(CorrectVersion,CurrentVersion);
   warning('Matlab version mismatch, this scrip should be used for Matlab R2017a'); 
end

% Original environment character encoding: GBK
% 脚本编码环境是否为GBK
if ~strcmpi(get_param(0, 'CharacterEncoding'), 'GBK')
    warning('Simulink:EncodingUnMatched', 'The target character encoding (%s) is different from the original (%s).',...
           get_param(0, 'CharacterEncoding'), 'GBK');
end

% find inport blocks
Inport_blocks = find_system(paraModel,'FindAll','on','BlockType','Inport');
% find Outport blocks
Outport_blocks = find_system(paraModel,'FindAll','on','BlockType','Outport');

% all blocks which need hiding names
hide_name_ports = [Inport_blocks',Outport_blocks'];

length_hide_name_line = length(hide_name_ports);
for i = 1:length_hide_name_line
    try
        set_param(hide_name_ports(i),'ShowName','off')
    catch
        % do nothing
    end
end
% report configurate results
hide_port_name_result = 'Hide port name successful';
