%------------------------------------------------------------------------------
%   Simulink scrip for listing dictionary parameters
%   MATLAB       : R2017a
%   Author       : Shibo Jiang 
%   Version      : 0.5
%   Time         : 2017/11/23
%   Instructions : Fix bugs ,modify temp name as '____'   - 0.4
%                  Add datasource information             - 0.5
%------------------------------------------------------------------------------
function output = list_parameter()

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

    % Get outlink parameter which defined in data dictionary
    data_dictionary = get_param(paraModel, 'DataDictionary');
    current_dic = Simulink.data.dictionary.open(data_dictionary);
    dic_entry = getSection(current_dic, 'Design Data');
    simulink_par_database = find(dic_entry);

    % Get all parameter's name and mark the line which has same name
    len_dict = length(simulink_par_database);
    for index = 1:len_dict
        par_name{index} = simulink_par_database(index).Name;
        par_name_source{index} = simulink_par_database(index).DataSource;
        % Mark the line
        line_marked{index} = find_system(paraModel,'FindAll','on','type'...
                                         ,'line','Name',par_name{index});
        set_param(line_marked{index}, 'Name', [par_name{index},'____']);
    end
    par_name = par_name';

    % Get line's name which is not defined in dictionary
    all_line = find_system(paraModel,'FindAll','on','type','line');
    j = 1;
    for i = 1:length(all_line)
        current_line_name = get(all_line(i), 'Name');
        try
            if strcmp('____', current_line_name(end-3:end))
                % Revert the line's name
                set_param(all_line(i), 'Name', current_line_name(1:(end-4)));
            else
                only_line_name{j} = current_line_name;
                j = j + 1;
            end
        end
    end

    % Find and mark the simulink parameter & table
    simulink_par = find(dic_entry,'-value','-class','Simulink.Parameter');
    len_simu_par = length(simulink_par);
    index_table = 1;
    index_par = 1;
    if 0 < len_simu_par
        for i = 1:len_simu_par
            simu_par_temp = getValue(simulink_par(i));
            simu_par_temp_name = simulink_par(i).Name;
            simu_par_temp_source = simulink_par(i).DataSource;
            simu_par_temp_value = simu_par_temp.Value;
            simu_par_temp_datatype = simu_par_temp.DataType;
            simu_par_temp_dim = simu_par_temp.Dimensions;
            if [1, 1] == simu_par_temp_dim
                simu_par_name{index_par} = simu_par_temp_name;
                simu_par_source{index_par} = simu_par_temp_source;
                simu_par_datatype{index_par} = simu_par_temp_datatype;
                simu_par_value{index_par} = simu_par_temp_value;
                index_par = index_par + 1;
            else
                simu_table{index_table} = {simu_par_temp_name, ...
                                           simu_par_temp_source,...
                                           simu_par_temp_datatype, ...
                                           simu_par_temp_dim, ...
                                           simu_par_temp_value};
                index_table = index_table + 1;
            end
        end
    end

    report_message = 'Listing is running.';

    % Define table name
    filename = [paraModel,'_list.xlsx'];
    table_name_change_history = {'Version', 'Change History', 'Name', 'Notes'};
    warning off MATLAB:xlswrite:AddSheet;
    xlswrite(filename, table_name_change_history, 1, 'A1');
    table_name_dict = {'No.', 'Old Name', 'New Name', 'Data Source'};
    xlswrite(filename, table_name_dict, 'dict', 'A1');
    table_name_only_line = {'No.', 'Old Name', 'New Name'};
    xlswrite(filename, table_name_only_line, 'only_line', 'A1')
    table_name_simu_par = {'No.', 'Name', 'Data Source','Data Type', 'Value'};
    xlswrite(filename, table_name_simu_par, 'simu_parameter', 'A1');
    table_name_table = {'No.', 'Name','Data Source', 'Data Type',...
                        'Row', 'Column','Value'};
    xlswrite(filename, table_name_table, 'simu_table', 'A1');

    % Write parameters to excel
    if 0 < len_dict
        number_par = [1:1:len_dict]';
        xlswrite(filename, number_par, 'dict', 'A2');
        xlswrite(filename, par_name, 'dict', 'B2');
        xlswrite(filename, par_name, 'dict', 'C2');
        xlswrite(filename, par_name_source', 'dict', 'D2');
    else
        report_message = {report_message, 'This model has no dictionary.'};
    end

    % Write only line's name to excel
    if 1 < j
        number_only_line = [1:1:(j-1)]';
        only_line_name = only_line_name';
        xlswrite(filename, number_only_line, 'only_line', 'A2');
        xlswrite(filename, only_line_name, 'only_line', 'B2');
        xlswrite(filename, only_line_name, 'only_line', 'C2');
    else
        report_message = {report_message, ['This model has no ',...
                          'line name which only defined on line.']};
    end

    % Write simulink parameters to excel
    if 1 < index_par
        number_simu_par = [1:1:(index_par-1)]';
        xlswrite(filename, number_simu_par, 'simu_parameter', 'A2');
        xlswrite(filename, simu_par_name', 'simu_parameter', 'B2');
        xlswrite(filename, simu_par_source', 'simu_parameter', 'C2');
        xlswrite(filename, simu_par_datatype', 'simu_parameter', 'D2');
        xlswrite(filename, simu_par_value', 'simu_parameter', 'E2');
    end

    % Write table data to excel
    if 1 < index_table
        temp_dim = 1;
        for i = 1:(index_table-1)
            % Calculate write position
            temp_pos = num2str(1 + temp_dim);
            table_num_position = ['A' temp_pos];
            table_name_position = ['B' temp_pos];
            table_source_position = ['C' temp_pos];
            table_datatype_position = ['D' temp_pos];
            table_dim_position = ['E' temp_pos];
            % table_dim_column_position = ['F' temp_pos];
            table_value_position = ['G' temp_pos];
            % Start writing
            xlswrite(filename, i, 'simu_table', ...
                     table_num_position);
            xlswrite(filename, simu_table{i}(1), 'simu_table', ...
                     table_name_position);
            xlswrite(filename, simu_table{i}(2), 'simu_table', ...
                     table_source_position);
            xlswrite(filename, simu_table{i}(3), 'simu_table', ...
                     table_datatype_position);
            xlswrite(filename, simu_table{i}{4}, 'simu_table', ...
                     table_dim_position);
            try
                xlswrite(filename, simu_table{i}{5}, 'simu_table', ...
                     table_value_position);
            end
                    
            temp_dim = temp_dim + simu_table{i}{4}(1);
        end
    end

    % close the dictionary 
    close(current_dic);
    report_message = {report_message, 'Listing name successful.'};
    output = report_message;
    
end