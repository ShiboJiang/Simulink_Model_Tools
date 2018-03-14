%------------------------------------------------------------------------------
%   Simulink scrip for creating can signal out model.
%   Use CanSigSend模块信号列表.xlsx 
%   MATLAB       : R2017a
%   Author       : Shibo Jiang 
%   Version      : 0.1
%   Time         : 2018/3/14
%   Instructions : New file                                   - 0.1
% 
%------------------------------------------------------------------------------

%-----Start of creat_model_cansigsend------------------------------------------
function output = creat_model_cansigsend()

    paraModel = bdroot;

    % Define file name
    filename = 'CanSigSend模块信号列表.xlsx';
    % Import excel file's data
    [in_num_matrix, in_str_matrix] = xlsread(filename, 'in');
    [out_num_matrix,out_str_matrix] = xlsread(filename, 'out');
    % out datasheet structure
    NUM_START_ROW = 1;
    STR_START_ROW = 2;
    NAME_COLUMN   = 4;
    MEAN_COL      = 7;
    RANGE_COL     = 8; 
    FACTOR_COLUMN = 9; 
    OFFSET_COLUMN = 10;
    DATATYPE_COL  = 11;

    % in datasheet structure
    IN_NAME_COL     = 3;
    IN_DATATYPE_COL = 4;
    IN_DESCRIP_COL  = 5;

    % Creat translate subsystem
    % Calculate loop times
    length_str = length(out_str_matrix(:,1)) - 1;
    if 0 == length_str
        % Do nothing
    else
        % Creat new subsystem
        trans_block_name = 'SigTranslate';
        model_dest = [paraModel,'/',trans_block_name]; 
        add_block('simulink/Ports & Subsystems/Subsystem', model_dest);
        % Creat translate model
        j = 0;
        last_name = '';
        for i = 1:length_str
            sig_name = out_str_matrix{i+NUM_START_ROW, NAME_COLUMN};
            factor_value = 1/out_num_matrix(i, FACTOR_COLUMN);
            offset_value = out_num_matrix(i, OFFSET_COLUMN);
            datatype = out_str_matrix{i+NUM_START_ROW, DATATYPE_COL};
            sig_mean = out_str_matrix{i+NUM_START_ROW, MEAN_COL};
            sig_range = out_str_matrix{i+NUM_START_ROW, RANGE_COL};

            if ~strcmp(last_name, sig_name)
                j = j + 1;
                % Calculate signal description
                sig_descrip = [sig_mean;...
                '--------------------------------------------------';...
                               sig_range];
                % Call function, create translate subsystem
                CreatTransBlocks(sig_name, factor_value, offset_value,...
                            model_dest, paraModel, j, datatype, sig_descrip);

                % Call function, create outport block in root level
                outport_name = sig_name;
                CreatOutports(outport_name, datatype,...
                            paraModel, j, sig_descrip);

                % Add line between translate subsystem with outport block
                add_line(paraModel,[trans_block_name,'/',j],...
                                   [outport_name,'/1']);
            end
            % last_name = sig_name;
        end
        % Delete auto block
        delete_block([model_dest,'/In1']);
        delete_block([model_dest,'/Out1']);
    end

    % Creat inport on root level
    j = 0;
    last_name = '';
    for i = 1:(length(in_str_matrix(:,1)) - 1)
        inport_name = in_str_matrix{i + NUM_START_ROW,...
                                  IN_NAME_COL};
                
        inport_datatpye = in_str_matrix{i + NUM_START_ROW,...
                                  IN_DATATYPE_COL};

        inport_descrip = in_str_matrix{i + NUM_START_ROW,...
                                  IN_DESCRIP_COL};

        if ~strcmp(last_name, inport_name)
            j = j + 1;
            % Call function
            CreatInports(inport_name, inport_datatpye,...
                         paraModel, j, inport_descrip);
                                 
        end
    end
end
%-----End of creat_model_cansigsend--------------------------------------------

%-----Start of CreatTransBlocks------------------------------------------------
function CreatTransBlocks(name, factor, offset, dest, ...
                          paraModel, index, datatype,...
                          description)
    % Add inport block---------------------------------------------------------
    in_dest_name = [dest,'/', name,'_in'];
    add_block('simulink/Sources/In1',in_dest_name);
    % Move block
    target_block = find_system(paraModel,'FindAll','on','BlockType',...
                              'Inport','Name',name);
    current_pos = get(target_block,'Position');
    target_pos_base = current_pos;
    % Y down 150 ,Position[a,b,c,d], add b,d sametime can move in Y.
    target_pos_base(2) = target_pos_base(2) + (index*150);
    target_pos_base(4) = target_pos_base(4) + (index*150);
    set(target_block,'Position',target_pos_base);
    % -------------------------------------------------------------------------

    % Add add block------------------------------------------------------------
    add_name = ['add','_',num2str(index)];
    add_dest_name = [dest,'/',add_name];
    add_block('simulink/Math Operations/Add',add_dest_name);
    % Move block
    tar_block_add = find_system(paraModel,'FindAll','on','BlockType',...
                              'Sum','Name',add_name);
    cur_pos_add = get(tar_block_add,'Position');
    % Y down 150 ,Position[a,b,c,d], add b,d sametime can move in Y.
    tar_pos_add = cur_pos_add;
    tar_pos_add(2) = tar_pos_add(2) + (index*150);
    tar_pos_add(4) = tar_pos_add(4) + (index*150);
    % horizontal direction same as inport
    diff_add_in = tar_pos_add(2) - target_pos_base(2);
    tar_pos_add(2) = target_pos_base(2);
    tar_pos_add(4) = tar_pos_add(4) - diff_add_in;
    % Vertical direction down to inport 120
    diff_add_in = tar_pos_add(1) - target_pos_base(1);
    tar_pos_add(1) = target_pos_base(1) + 120;
    tar_pos_add(3) = tar_pos_add(3) - diff_add_in + 120;
    set(tar_block_add,'Position',tar_pos_add);
    % Hide block name
    set(tar_block_add,'ShowName','off');
    % Set add block property
    set(tar_block_add,'Inputs','+-');
    set(tar_block_add,'OutDataTypeStr','single');
    % -------------------------------------------------------------------------

    % Add offset block---------------------------------------------------------
    offset_name = [name,'_','offset'];
    offset_dest_name = [dest,'/',offset_name];
    add_block('simulink/Sources/Constant',offset_dest_name);
    % Move block
    tar_block_offset = find_system(paraModel,'FindAll','on','BlockType',...
                              'Constant','Name',offset_name);
    cur_pos_offset = get(tar_block_offset,'Position');
    % Y down 150 ,Position[a,b,c,d], add b,d sametime can move in Y.
    tar_pos_offset = cur_pos_offset;
    tar_pos_offset(2) = tar_pos_offset(2) + (index*150);
    tar_pos_offset(4) = tar_pos_offset(4) + (index*150);
    % Horizontal direction down to inport 50
    diff_offset_in = tar_pos_offset(2) - target_pos_base(2);
    tar_pos_offset(2) = target_pos_base(2) + 50;
    tar_pos_offset(4) = tar_pos_offset(4) - diff_offset_in + 50;
    % Vertical direction direction same as inport
    diff_offset_in = tar_pos_offset(1) - target_pos_base(1);
    tar_pos_offset(1) = target_pos_base(1);
    tar_pos_offset(3) = tar_pos_offset(3) - diff_offset_in;
    set(tar_block_offset,'Position',tar_pos_offset);
    % Hide offset name
    % set(tar_block_offset,'ShowName','off');
    % Set constant value
    set(tar_block_offset,'Value',upper(offset_name));
    try
        offset_defined = Simulink.Parameter;
        offset_defined.DataType = datatype;
        offset_defined.Value = offset;
        offset_defined.Description = [name,' 信号的偏移量'];
        assignin('base',upper(offset_name),offset_defined);
    end
    % -------------------------------------------------------------------------

    % Add product block--------------------------------------------------------
    product_name = ['product','_',num2str(index)];
    product_dest_name = [dest,'/',product_name];
    add_block('simulink/Math Operations/Product',product_dest_name);
    % Move block
    tar_block_product = find_system(paraModel,'FindAll','on','BlockType',...
                              'Product','Name',product_name);
    cur_pos_product = get(tar_block_product,'Position');
    % Y down 150 ,Position[a,b,c,d], add b,d sametime can move in Y.
    tar_pos_product = cur_pos_product;
    tar_pos_product(2) = tar_pos_product(2) + (index*150);
    tar_pos_product(4) = tar_pos_product(4) + (index*150);
    % horizontal direction down to inport 10
    diff_product_in = tar_pos_product(2) - target_pos_base(2);
    tar_pos_product(2) = target_pos_base(2) + 10;
    tar_pos_product(4) = tar_pos_product(4) - diff_product_in + 10;
    % Vertical direction down to inport 200
    diff_product_in = tar_pos_product(1) - target_pos_base(1);
    tar_pos_product(1) = target_pos_base(1) + 200;
    tar_pos_product(3) = tar_pos_product(3) - diff_product_in + 200;
    set(tar_block_product,'Position',tar_pos_product);
    % Set product property
    set(tar_block_product,'ShowName','off');
    set(tar_block_add,'OutDataTypeStr','single');
    % -------------------------------------------------------------------------

    % Add factor block---------------------------------------------------------
    factor_name = [name,'_','fac'];
    factor_dest_name = [dest,'/',factor_name];
    add_block('simulink/Sources/Constant',factor_dest_name);
    % Move block
    tar_block_fac = find_system(paraModel,'FindAll','on','BlockType',...
                              'Constant','Name',factor_name);
    cur_pos_fac = get(tar_block_fac,'Position');
    % Y down 150 ,Position[a,b,c,d], add b,d sametime can move in Y.
    tar_pos_fac = cur_pos_fac;
    tar_pos_fac(2) = tar_pos_fac(2) + (index*150);
    tar_pos_fac(4) = tar_pos_fac(4) + (index*150);

    % Horizontal direction down to inport 50
    diff_fac_in = tar_pos_fac(2) - target_pos_base(2);
    tar_pos_fac(2) = target_pos_base(2) + 50;
    tar_pos_fac(4) = tar_pos_fac(4) - diff_fac_in + 50;
    % Vertical direction down to inport 120
    diff_fac_in = tar_pos_fac(1) - target_pos_base(1);
    tar_pos_fac(1) = target_pos_base(1) + 120;
    tar_pos_fac(3) = tar_pos_fac(3) - diff_fac_in + 120;
    set(tar_block_fac,'Position',tar_pos_fac);
    % Hide factor name
    % set(tar_block_fac,'ShowName','off');
    % Set constant value
    set(tar_block_fac,'Value',upper(factor_name));
    try
        factor_defined = Simulink.Parameter;
        factor_defined.DataType = 'single';
        factor_defined.Value = factor;
        factor_defined.Description = [name,' 信号的放大系数'];
        assignin('base',upper(factor_name),factor_defined);
    end
    % -------------------------------------------------------------------------

    % Add Data Type Conversion block-------------------------------------------
    convert_name = ['DatatypeConvert','_',num2str(index)];
    convert_dest_name = [dest,'/',convert_name];
    add_block('simulink/Signal Attributes/Data Type Conversion',...
              convert_dest_name);
    % Move block
    tar_block_convert = find_system(paraModel,'FindAll','on','BlockType',...
                              'DataTypeConversion','Name',convert_name);
    cur_pos_convert = get(tar_block_convert,'Position');
    % Y down 150 ,Position[a,b,c,d], out b,d sametime can move in Y.
    tar_pos_convert = cur_pos_convert;
    tar_pos_convert(2) = tar_pos_convert(2) + (index*150);
    tar_pos_convert(4) = tar_pos_convert(4) + (index*150);
    % horizontal direction down to inport 20
    diff_convert_in = tar_pos_convert(2) - target_pos_base(2);
    tar_pos_convert(2) = target_pos_base(2) + 20;
    tar_pos_convert(4) = tar_pos_convert(4) - diff_convert_in + 20;
    % Vertical direction down to inport 300
    diff_convert_in = tar_pos_convert(1) - target_pos_base(1);
    tar_pos_convert(1) = target_pos_base(1) + 300;
    tar_pos_convert(3) = tar_pos_convert(3) - diff_convert_in + 300;
    set(tar_block_convert,'Position',tar_pos_convert);
    % Set convert block property
    set(tar_pos_convert,'OutDataTypeStr',datatype);
    % -------------------------------------------------------------------------

    % Add out block------------------------------------------------------------
    out_name = name;
    out_dest_name = [dest,'/',out_name];
    add_block('simulink/Sinks/Out1',out_dest_name);
    % Move block
    tar_block_out = find_system(paraModel,'FindAll','on','BlockType',...
                              'Outport','Name',out_name);
    cur_pos_out = get(tar_block_out,'Position');
    % Y down 150 ,Position[a,b,c,d], out b,d sametime can move in Y.
    tar_pos_out = cur_pos_out;
    tar_pos_out(2) = tar_pos_out(2) + (index*150);
    tar_pos_out(4) = tar_pos_out(4) + (index*150);
    % horizontal direction down to inport 20
    diff_out_in = tar_pos_out(2) - target_pos_base(2);
    tar_pos_out(2) = target_pos_base(2) + 20;
    tar_pos_out(4) = tar_pos_out(4) - diff_out_in + 20;
    % Vertical direction down to inport 300
    diff_out_in = tar_pos_out(1) - target_pos_base(1);
    tar_pos_out(1) = target_pos_base(1) + 400;
    tar_pos_out(3) = tar_pos_out(3) - diff_out_in + 400;
    set(tar_block_out,'Position',tar_pos_out);
    % Hide product name
    % set(tar_block_out,'ShowName','off');

    % Set outport block property
    set(tar_block_out,'OutDataTypeStr',datatype);
    set(tar_block_out,'Description', description);
    % -------------------------------------------------------------------------

    % Add lines----------------------------------------------------------------
    add_line(dest,[name,'/1'],[product_name,'/1']);
    add_line(dest,[factor_name,'/1'],[product_name,'/2']);
    add_line(dest,[product_name,'/1'],[add_name,'/1']);
    add_line(dest,[offset_name,'/1'],[add_name,'/2']);
    add_line(dest,[add_name,'/1'],[convert_name,'/1']);
    add_line(dest,[convert_name,'/1'],[out_name,'/1']);
    % -------------------------------------------------------------------------
end
%-----End of CreatTransBlocks--------------------------------------------------

%-----Start of CreatOutports---------------------------------------------------
function CreatOutports(name, datatype, paraModel, index, description)
    out_dest_name = [paraModel,'/', name];
    add_block('simulink/Sinks/Out1',out_dest_name);
    % Move block
    target_block = find_system(paraModel,'FindAll','on','BlockType',...
                              'Outport','Name',name);
    current_pos = get(target_block,'Position');
    % Y down 150 ,Position[a,b,c,d], add b,d sametime can move in Y.
    target_pos_base = current_pos;
    target_pos_base(2) = target_pos_base(2) + (index*30);
    target_pos_base(4) = target_pos_base(4) + (index*30);
    % Move x to 300
    target_pos_base(1) = target_pos_base(1) + 300;
    target_pos_base(3) = target_pos_base(3) + 300;

    set(target_block,'Position',target_pos_base);
    set(target_block,'OutDataTypeStr',datatype);
    set(target_block,'Description', description);
end
%-----End of CreatOutports-----------------------------------------------------

%-----Start of CreatInports-----------------------------------------------------
function CreatInports(name, datatype, paraModel, index, description)
    dest_name = [paraModel,'/', name];
    add_block('simulink/Sources/In1',dest_name);
    % Move block
    target_block = find_system(paraModel,'FindAll','on','BlockType',...
                              'Inport','Name',name);
    current_pos = get(target_block,'Position');
    % Y down 150 ,Position[a,b,c,d], add b,d sametime can move in Y.
    target_pos_base = current_pos;
    target_pos_base(2) = target_pos_base(2) + (index*30);
    target_pos_base(4) = target_pos_base(4) + (index*30);
    % Move x to 300
    target_pos_base(1) = target_pos_base(1) - 200;
    target_pos_base(3) = target_pos_base(3) - 200;

    set(target_block,'Position',target_pos_base);
    set(target_block,'OutDataTypeStr',datatype);
    set(target_block,'Description', description);
end
%-----End of CreatInports-------------------------------------------------------
