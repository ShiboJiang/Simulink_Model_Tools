%------------------------------------------------------------------------------
%   Matlab scrip for p file created.
%   MATLAB version: R2017a
%   Author        : Shibo Jiang   
%   Time          : 2017/8/28
%   Version       : 0.1
%   Instructions  : Use this scrip and the *.m files which need translating 
%                   to *.p files in the same folder.
%------------------------------------------------------------------------------

%-----Start of creat_p_files---------------------------------------------------
function output = creat_p_files()
    % get work floder path
    the_path = cd;
    % get all files in this floder
    files = dir(the_path);
    % find the .m files' name
    length_all_files = length(files);
    select_type = '.m';
    for i = 1:length_all_files
        current_name = files(i).name;
        % protect from wrong state running
        try
            current_type = current_name(end-1:end);
            if 1 == strcmp(select_type,current_type)
                % creat .p file
                pcode (current_name);
            else
                % not .m file, do nothing
            end
        catch
            % do nothing
        end
    end
    output = 'Creat P files successful';       
end