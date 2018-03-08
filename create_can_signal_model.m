%------------------------------------------------------------------------------
%   Simulink scrip for creating can signal out/in model
%   MATLAB       : R2017a
%   Author       : Shibo Jiang 
%   Version      : 0.1
%   Time         : 2018/3/7
%   Instructions : New file                             - 0.1
% 
%------------------------------------------------------------------------------

%-----Start of creat_can_signal_model------------------------------------------
function output = creat_can_signal_model()

    paraModel = bdroot;

    % Define file name
    filename = 'target.xlsx';
    % Import excel file's data
    [number_matrix, str_matrix] = xlsread(filename, 'K-Matrix ');
    NUM_START_ROW = 1;
    STR_START_ROW = 2;
    NAME_COLUMN = 8;
    % 18 - 2
    FACTOR_COLUMN = 16; 
    % 19 - 2
    OFFSET_COLUMN = 17;

    % Calculate loop times
    length_str = length(number_matrix(:,1));
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
                CreatBlocks(inport_name, factor_value, offset_value,...
                            model_dest, paraModel, j);
            end
            last_name = inport_name;
        end
        % Delete auto block
        delete_block([model_dest,'/In1']);
        delete_block([model_dest,'/Out1']);
    end
    
end
%-----End of creat_can_signal_model--------------------------------------------

%-----Start of CreatBlocks-----------------------------------------------------
function CreatBlocks(name, factor, offset, dest, paraModel, index)
    % Add inport block
    in_dest_name = [dest,'/', name];
    add_block('simulink/Sources/In1',in_dest_name);
    % Move block
    target_block = find_system(paraModel,'FindAll','on','BlockType',...
                              'Inport','Name',name);
    current_pos = get(target_block,'Position');
    % Y down 150 ,Position[a,b,c,d], add b,d sametime can move in Y.
    target_pos = current_pos;
    target_pos(2) = target_pos(2) + (index*150);
    target_pos(4) = target_pos(4) + (index*150);
    set(target_block,'Position',target_pos);

    % Add factor block
    
end
%-----End of CreatBlocks-------------------------------------------------------
