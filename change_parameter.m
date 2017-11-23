%------------------------------------------------------------------------------
%   Simulink scrip for rename parameters and change parameter's value
%   MATLAB       : R2017a
%   Author       : Shibo Jiang 
%   Version      : 0.3
%   Time         : 2017/11/23
%   Instructions : Add change stateflow parameter function.
%                  Add creat new parameter function.             - 0.3
% 
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

    % Jduge only_line & dict sheet is empty?
    if isempty(number_par)
        temp_judge_par = 2;
    else
        temp_judge_par = 0;
    end
    
    if isempty(number_line)
        temp_judge_line = 1;
    else
        temp_judge_line = 0;
    end

    switch (temp_judge_line + temp_judge_par)
    case 0
        name_all = [name_par(2:end,1:3); name_line(2:end,1:3)];
        number_all = number_par(end,1) + number_line(end,1);
    case 1
        name_all = name_par(2:end,1:3);
        number_all = number_par(end,1);
    case 2
        name_all = name_line(2:end,1:3);
        number_all = number_line(end,1);
    case 3
        name_all = [];
    end
    return_message = 'No parameter name changed.';
    % Whether writing paramter's name
    if ~isempty(name_all)
        i_diff_name = 1;
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
                % Find the parameter name in stateflow
                sf = sfroot;
                par_sf_data = sf.find('-isa','Stateflow.Data','Name', temp_old);

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
                SetNewName(par_sf_data, 'Name', temp_new);

                return_message = 'Rename parameter successful.';

                % Store diff name for changing value
                old_name{i_diff_name} = temp_old;
                new_name{i_diff_name} = temp_new;
                i_diff_name = i_diff_name + 1;
            else
                % Do nothing
            end
        end
    end

    % Find simulink parameter in list and change the datatype&value
    [num_simu_par, str_simu_par] = xlsread(filename, 'simu_parameter');
    if ~isempty(num_simu_par)
        for i = 1:num_simu_par(end,1)
            temp_simu_par_name = str_simu_par(i+1, 2);
            temp_simu_par_datatype = str_simu_par(i+1, 4);
            temp_simu_par_value = num_simu_par(i, 5);
            % Set new property
            temp_return = SetDictParameter(dic_entry,...
                                        temp_simu_par_name{1},...
                                        temp_simu_par_datatype{1},...
                                        temp_simu_par_value);
            % Report whether set successful
            if strcmp('Invalid name', temp_return)
                % Use new name to try again
                % Judge whether need find new name
                if 1 < i_diff_name
                    % Find new name
                    for i = 1:(i_diff_name-1)
                        if strcmp(old_name{i}, temp_simu_par_name{1})
                            temp_simu_par_name{1} = new_name{i};
                            break;
                        end
                    end
                end
                % Creat new entry in dict
                initial_value = Simulink.Parameter;
                % Try creat new ,if parameter does not exit.
                try
                    addEntry(dic_entry, temp_simu_par_name{1}, initial_value);
                end
                % Set entry's property
                SetDictParameter(dic_entry,...
                                temp_simu_par_name{1},...
                                temp_simu_par_datatype{1},...
                                temp_simu_par_value);
                return_message = {return_message, ['The parameter "' ,...
                                                temp_simu_par_name{1},...
                            '" does not exit, have already created it.']};
            end
        end
        return_message = {return_message,...
                         'Change simulink parameter successful.'};
    end

    % Find table in list and change the datatype&value
    [num_simu_table, str_simu_table] = xlsread(filename, 'simu_table');
    % Judge whether need writing talbe data
    if ~isempty(num_simu_table)
        len_simu_table_temp = length(num_simu_table(:,1));
        % Calculate cycle time
        for i = 1: len_simu_table_temp
            if ~strcmp('NaN', num2str(num_simu_table(len_simu_table_temp+1-i,1)))
                cycle_time_tale = num_simu_table(len_simu_table_temp+1-i,1);
                break;
            end
        end
        % Read tabel data and write to dict
        temp_row = 1;
        for i = 1: cycle_time_tale
            temp_table_name = str_simu_table(1+temp_row, 2);
            temp_table_datatype = str_simu_table(1+temp_row, 4);
            temp_row_spacing = num_simu_table(temp_row, 5);
            temp_column_spacing = num_simu_table(temp_row, 6);
            temp_table_data = num_simu_table(temp_row:...
                                (temp_row + temp_row_spacing - 1),...
                                7:(7 + temp_column_spacing - 1));
            
            % Set new property
            temp_return = SetDictParameter(dic_entry,...
                                        temp_table_name{1},...
                                        temp_table_datatype{1},...
                                        temp_table_data);
            % Report whether creat new parameter
            if strcmp('Invalid name', temp_return)
                % Use new name to try again
                % Judge whether need find new name
                if 1 < i_diff_name
                    % Find new name
                    for i = 1:(i_diff_name-1)
                        if strcmp(old_name{i}, temp_table_name{1})
                            temp_table_name{1} = new_name{i};
                            break;
                        end
                    end
                end
                % Creat new entry in dict
                initial_value = Simulink.Parameter;
                % Try creat new ,if parameter does not exit.
                try
                    addEntry(dic_entry, temp_table_name{1}, initial_value);
                end
                % Set entry's property
                SetDictParameter(dic_entry,...
                                temp_table_name{1},...
                                temp_table_datatype{1},...
                                temp_table_data);
                return_message = {return_message, ['The parameter "' ,...
                                                temp_table_name{1},...
                            '" does not exit, have already created it.']};
            end
            temp_row = temp_row + temp_row_spacing;
        end
        return_message = {return_message, 'Change table data successful.'};
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
            catch
                try
                    set(input(i), item, new_name);
                end
            end
        end
    else
        try
            set_param(input, item, new_name);
        catch
            try
                set(input, item, new_name);
            end
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
