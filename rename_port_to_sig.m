%------------------------------------------------------------------------------
%   Simulink scrip for rename the blocks' name to signals' name
%   MATLAB version: R2017a
%   Author: Shibo Jiang 
%   Version: 0.1
%   Instructions: 
%------------------------------------------------------------------------------
%   用于重命名模块上 inport端口名称为信号名称的脚本
%   MATLAB 版本: R2017a
%   作者: 姜世博 
%   版本:    0.1
%   说明: 
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
%     warning('Simulink:EncodingUnMatched', 'The target character encoding (%s) is different from the original (%s).',...
%            get_param(0, 'CharacterEncoding'), 'GBK');
% end

% find all inport block
inport_block = find_system(paraModel,'FindAll','on','BlockType','Inport');
% rename inport blocks to signals' name
length_inport = length(inport_block);
for i = 1:length_inport
    current_out_sig_name = get(inport_block(i),'OutputSignalNames');
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
        % rename
        try
            set(inport_block(i),'Name',current_out_sig_name);        
        catch
            
        end
    end
end

% find all outport block
outport_block = find_system(paraModel,'FindAll','on','BlockType','Outport');
% rename outport blocks to signals' name
length_outport = length(outport_block);
for i = 1:length_outport
    current_in_sig_name = get(outport_block(i),'InputSignalNames');
    % translate cell to string
    current_in_sig_name = cell2mat(current_in_sig_name);
    if 1 == isempty(current_in_sig_name)
        % Do nothing. input line has no name defined.
    else
        % find if tag symbol '<' exit
        if strcmp('<',current_in_sig_name(1))
            % remove the tag symbol '< >'
            current_in_sig_name = current_in_sig_name(2:end-1);
        else
            % Do nothing
        end
        % rename
        try
           set_param(outport_block(i),'Name',current_in_sig_name);         
        catch
            
        end
    end
end

rename_ports_result = 'rename port to signal name successful';