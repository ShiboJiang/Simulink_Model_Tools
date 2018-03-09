%------------------------------------------------------------------------------
%   Simulink scrip for creating can signal out/in model. Use specify excel.
%   MATLAB       : R2017a
%   Author       : Shibo Jiang 
%   Version      : 0.1
%   Time         : 2018/3/9
%   Instructions : New file                                             - 0.1
%                  Fix bugs. Use upper string to add simulink parameter 
%                  name as a mcro.                                      - 0.2
%------------------------------------------------------------------------------

%-----Start of creat_can_model_specific----------------------------------------
function output = creat_can_model_specific()

    paraModel = bdroot;

    % Define file name
    filename = 'CanSigRec_modify.xlsx';
    % Import excel file's data
    [number_matrix, str_matrix] = xlsread(filename, 'in');
    [out_num_matrix,out_str_matrix] = xlsread(filename, 'out');
    NUM_START_ROW = 1;
    STR_START_ROW = 2;
    NAME_COLUMN = 4;
    
    FACTOR_COLUMN = 7; 
    
    OFFSET_COLUMN = 8;

    % Calculate loop times
    length_str = length(str_matrix(:,1)) - 1;
    if 0 == length_str
        % Do nothing
    else
        % Creat new subsystem
        model_dest = [paraModel,'/SigTranslate']; 
        add_block('simulink/Ports & Subsystems/Subsystem', model_dest);
        % Creat translate model
        j = 0;
        last_name = '';
        for i = 1:length_str
            inport_name = str_matrix{i+NUM_START_ROW, NAME_COLUMN};
            factor_value = number_matrix(i, FACTOR_COLUMN);
            offset_value = number_matrix(i, OFFSET_COLUMN);

            if ~strcmp(last_name, inport_name)
                j = j + 1;
                % Call function
                CreatTransBlocks(inport_name, factor_value, offset_value,...
                            model_dest, paraModel, j);
            end
            % last_name = inport_name;
        end
        % Delete auto block
        delete_block([model_dest,'/In1']);
        delete_block([model_dest,'/Out1']);
    end

    % Creat out port
    OUTPORT_NAME_COLUMN = 3;
    OUTPORT_DATATYPE_COLUMN = 4;
    out_model_dest = paraModel;
    j = 0;
    last_name = '';
    for i = 1:(length(out_str_matrix(:,1)) - 1)
        outport_name = out_str_matrix{i + NUM_START_ROW,...
                                  OUTPORT_NAME_COLUMN};
        outport_datatpye = out_str_matrix{i + NUM_START_ROW,...
                                  OUTPORT_DATATYPE_COLUMN};

        if ~strcmp(last_name, outport_name)
            j = j + 1;
            % Call function
            CreatOutports(outport_name, outport_datatpye,...
                            paraModel, j);
        end
        
    end
    
end
%-----End of creat_can_signal_model--------------------------------------------

%-----Start of CreatBlocks-----------------------------------------------------
function CreatTransBlocks(name, factor, offset, dest, paraModel, index)
    % Add inport block---------------------------------------------------------
    in_dest_name = [dest,'/', name];
    add_block('simulink/Sources/In1',in_dest_name);
    add_block('simulink/Sources/In1',[paraModel,'/',name]);
    % Move block
    target_block = find_system(paraModel,'FindAll','on','BlockType',...
                              'Inport','Name',name);
    for index_inport = 1 : length(target_block)
        current_pos = get(target_block(index_inport),'Position');
        % Y down 150 ,Position[a,b,c,d], add b,d sametime can move in Y.
        target_pos_base = current_pos;
        if 1 == index_inport
            target_pos_base(2) = target_pos_base(2) + (index*30);
            target_pos_base(4) = target_pos_base(4) + (index*30);
        else
            target_pos_base(2) = target_pos_base(2) + (index*150);
            target_pos_base(4) = target_pos_base(4) + (index*150);
        end
        set(target_block(index_inport),'Position',target_pos_base);
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
    % horizontal direction same as inport
    diff_product_in = tar_pos_product(2) - target_pos_base(2);
    tar_pos_product(2) = target_pos_base(2);
    tar_pos_product(4) = tar_pos_product(4) - diff_product_in;
    % Vertical direction down to inport 120
    diff_product_in = tar_pos_product(1) - target_pos_base(1);
    tar_pos_product(1) = target_pos_base(1) + 120;
    tar_pos_product(3) = tar_pos_product(3) - diff_product_in + 120;
    set(tar_block_product,'Position',tar_pos_product);
    % Hide product name
    set(tar_block_product,'ShowName','off');
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
    % Vertical direction direction same as inport
    diff_fac_in = tar_pos_fac(1) - target_pos_base(1);
    tar_pos_fac(1) = target_pos_base(1);
    tar_pos_fac(3) = tar_pos_fac(3) - diff_fac_in;
    set(tar_block_fac,'Position',tar_pos_fac);
    % Hide factor name
    % set(tar_block_fac,'ShowName','off');
    % Set constant value
    set(tar_block_fac,'Value',upper(factor_name));
    try
        factor_defined = Simulink.Parameter;
        factor_defined.DataType = 'single';
        factor_defined.Value = factor;
        assignin('base',upper(factor_name),factor_defined);
    end
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
    % horizontal direction down to inport 10
    diff_add_in = tar_pos_add(2) - target_pos_base(2);
    tar_pos_add(2) = target_pos_base(2) + 10;
    tar_pos_add(4) = tar_pos_add(4) - diff_add_in + 10;
    % Vertical direction down to inport 200
    diff_add_in = tar_pos_add(1) - target_pos_base(1);
    tar_pos_add(1) = target_pos_base(1) + 200;
    tar_pos_add(3) = tar_pos_add(3) - diff_add_in + 200;
    set(tar_block_add,'Position',tar_pos_add);
    % Hide product name
    set(tar_block_add,'ShowName','off');
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
    % Vertical direction down to inport 120
    diff_offset_in = tar_pos_offset(1) - target_pos_base(1);
    tar_pos_offset(1) = target_pos_base(1) + 120;
    tar_pos_offset(3) = tar_pos_offset(3) - diff_offset_in + 120;
    set(tar_block_offset,'Position',tar_pos_offset);
    % Hide offset name
    % set(tar_block_offset,'ShowName','off');
    % Set constant value
    set(tar_block_offset,'Value',upper(offset_name));
    try
        offset_defined = Simulink.Parameter;
        offset_defined.DataType = 'single';
        offset_defined.Value = offset;
        assignin('base',upper(offset_name),offset_defined);
    end
    % -------------------------------------------------------------------------

    % Add out block------------------------------------------------------------
    out_name = [name,'_','out'];
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
    tar_pos_out(1) = target_pos_base(1) + 300;
    tar_pos_out(3) = tar_pos_out(3) - diff_out_in + 300;
    set(tar_block_out,'Position',tar_pos_out);
    % Hide product name
    % set(tar_block_out,'ShowName','off');
    % -------------------------------------------------------------------------

    % Add lines----------------------------------------------------------------
    add_line(dest,[name,'/1'],[product_name,'/1']);
    add_line(dest,[factor_name,'/1'],[product_name,'/2']);
    add_line(dest,[product_name,'/1'],[add_name,'/1']);
    add_line(dest,[offset_name,'/1'],[add_name,'/2']);
    add_line(dest,[add_name,'/1'],[out_name,'/1']);
    % -------------------------------------------------------------------------
end
%-----End of CreatBlocks-------------------------------------------------------

%-----Start of CreatBlocks-----------------------------------------------------
function CreatOutports(name, datatype, paraModel, index)
% Add inport block---------------------------------------------------------
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
    
end
%-----End of CreatBlocks-------------------------------------------------------
