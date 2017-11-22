%------------------------------------------------------------------------------
%   Simulink scrip for rename parameters and change parameter's value
%   MATLAB       : R2017a
%   Author       : Shibo Jiang 
%   Version      : 0.2
%   Time         : 2017/11/22
%   Instructions : 
%------------------------------------------------------------------------------
function output = change_parameter()

    paraModel = bdroot;

    % Original matalb version is R2017a
    % 检查Matlab版本是否为R202017a
    CorrectVersion_win = '9.2.0.556344 (R2017a)';    % windows
    CorrectVersion_linux =  '9.2.0.538062 (R2017a)';   % linux
    CurrentVersion = version;
    if 1 ~= bitor(strcmp(CorrectVersion_win, CurrentVersion),...
                strcmp(CorrectVersion_linux, CurrentVersion))
    warning(['Matlab version mismatch, this scrip should be' ...
             'used for Matlab R2017a']); 
    end

    % % Get inter parameter which defined in model workspace
    % simulink_var_space = get_param(paraModel,'ModelWorkspace');
    % simulink_par_inter = simulink_var_space.whos;
        
    % Define list file's name
    filename = [paraModel,'_list.xlsx'];

    % Open outlink parameter which defined in data dictionary
    data_dictionary = get_param(paraModel, 'DataDictionary');
    current_dic = Simulink.data.dictionary.open(data_dictionary);
    dic_entry = getSection(current_dic, 'Design Data');

    % Find data in dictionary&model and change name
        % Import excel file's data
    [number_par, name_par] = xlsread(filename, 'dict');
    [number_line, name_line] = xlsread(filename, 'only_line');

    name_all = [name_par(2:end,1:end); name_line(2:end,1:end)];
    number_all = number_par(end) + number_line(end);

    return_message = 'No parameter name changed.';
    for i = 1:number_all(end)
        temp_old = name_all{i, 2};
        temp_new = name_all{i, 3};
        if ~strcmp(temp_new, temp_old)
            % Find the parameter name in dict
            par_dict = find(dic_entry, 'Name', temp_old);
            % Find the parameter name in signal line
            par_signal = find_system(paraModel,'FindAll','on','type','line'...
                                    ,'Name',temp_old);
            % Find the parameter name in constant block
            par_const = find_system(paraModel,'FindAll','on','BlockType'...
                                    ,'Constant','Value', temp_old);
            % Find the parameter name in table block
            par_nd_table = find_system(paraModel,'FindAll','on','BlockType'...
                                    ,'Lookup_n-D','Table', temp_old);
            par_direct_table = find_system(paraModel,'FindAll','on',...
                                          'BlockType','LookupNDDirect',...
                                          'Table', temp_old);
            % Find the parameter name in port block
            par_inport = find_system(paraModel,'FindAll','on','BlockType'...
                                     ,'Inport','Name', temp_old);
            par_outport = find_system(paraModel,'FindAll','on','BlockType'...
                                     ,'Outport','Name', temp_old);

            % Set new name
            try
                par_dict.Name = temp_new;
            end
            SetNewName(par_signal, 'Name', temp_new);
            SetNewName(par_inport, 'Name', temp_new);
            SetNewName(par_outport, 'Name', temp_new);
            SetNewName(par_const, 'Value', temp_new);
            SetNewName(par_nd_table, 'Table', temp_new);
            SetNewName(par_direct_table, 'Table', temp_new);

            return_message = 'Rename parameter successful.';
        else
            % Do nothing
        end
    end

    % Find simulink parameter in list and change the datatype&value
    [num_simu_par, str_simu_par] = xlsread(filename, 'simu_parameter');
    if 0 < length(num_simu_par)
        for i = 1:num_simu_par(end,1)
            temp_simu_par_name = str_simu_par(i+1, 2);
            temp_simu_par_datatype = str_simu_par(i+1, 3);
            temp_simu_par_value = num_simu_par(i, 4);
            % Set new property
            temp_return = SetDictParameter(dic_entry,...
                                        temp_simu_par_name{1},...
                                        temp_simu_par_datatype{1},...
                                        temp_simu_par_value);
            % Repory whether set successful
            if strcmp('Invalid name', temp_return)
                return_message = [return_message, {['The parameter "' ,...
                                                temp_simu_par_name{1},...
                                            '" is invalid, please do check']}];
            end
        end
        return_message = [return_message,...
                         'Change simulink parameter successful.'];
    end

    % Find table in list and change the datatype&value
    [num_simu_table, str_simu_table] = xlsread(filename, 'simu_table');
    % Judge whether need writing talbe data
    len_simu_table_temp = length(num_simu_table);
    if 0 < len_simu_table_temp
        % Calculate cycle time
        for i = 1: length(num_simu_table)
            if ~strcmp('NaN', num2str(num_simu_table(len_simu_table_temp+1-i,1)))
                cycle_time_tale = num_simu_table(len_simu_table_temp+1-i,1);
                break;
            end
        end
        % Read tabel data and write to dict
        temp_row = 1;
        for i = 1: cycle_time_tale
            temp_table_name = str_simu_table(1+temp_row, 2);
            temp_table_datatype = str_simu_table(1+temp_row, 3);
            temp_row_spacing = num_simu_table(temp_row, 4);
            temp_column_spacing = num_simu_table(temp_row, 5);
            temp_table_data = num_simu_table(temp_row:...
                                (temp_row + temp_row_spacing - 1),...
                                6:(6 + temp_column_spacing - 1));
            
            % Set new property
            temp_return = SetDictParameter(dic_entry,...
                                        temp_table_name{1},...
                                        temp_table_datatype{1},...
                                        temp_table_data);
            % Repory whether set successful
            if strcmp('Invalid name', temp_return)
                return_message = [return_message, {['The parameter "' ,...
                                                temp_table_name{1},...
                                            '" is invalid, please do check']}];
            end
            temp_row = temp_row + temp_row_spacing;
        end
        return_message = [return_message, 'Change table data successful.'];
    end

    % Save changes to the dictionary and close it.
    saveChanges(current_dic);
    close(current_dic);

    % Report
    output = return_message;
end
%-----------------End of function----------------------------------------------

%-----------Start of function--------------------------------------------------
function SetNewName(input, item, new_name)
    if 1 < length(input)
        for i = 1:length(input)
            try
                set_param(input(i), item, new_name);
            end
        end
    else
        try
            set_param(input, item, new_name);
        end
    end
end
%-----------------End of function----------------------------------------------

%-----------Start of function--------------------------------------------------
function output = SetDictParameter(entry, name, data_type, value)
    % Find the parameter name in dict
    simu_par = find(entry, 'Name', name);
    if isempty(simu_par)
        output = 'Invalid name';
    else
        output = 'Valid name';
        temp_change = getValue(simu_par);
        temp_change.DataType = data_type;
        temp_change.Value = value;
        % Write dict
        setValue(simu_par, temp_change);
    end
end
%-----------------End of function----------------------------------------------
