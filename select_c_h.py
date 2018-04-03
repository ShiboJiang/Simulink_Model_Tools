#!/usr/bin/env python3
# -*- coding: utf-8 -*-

#------------------------------------------------------------------------------
# Function   : This scrip is used for selecting .c and .h files
# Enviroment : python 3.6.2
# Author     : Shibo Jiang
# Time       : 2017.10.6
# Version    : 0.1
# Notes      : None
#------------------------------------------------------------------------------
import os
import shutil

#creat folder named 'select_result' to store select results
abs_path = os.path.join(os.path.abspath('.'), 'select_result')

# #judge whether folder is exist,and creat a stand folder
# folder_number = 0
# temp_path = abs_path
# exclude_path = [abs_path]
# while 1:
#     if (os.path.split(abs_path))[1] in os.listdir(os.path.abspath('.')):
#         folder_number = folder_number + 1
#         abs_path = temp_path + '_' + str(folder_number)
#         exclude_path.append(abs_path)
#     else:
#         break

#delete older folder and creat new
if (os.path.split(abs_path))[1] in os.listdir(os.path.abspath('.')):
    shutil.rmtree(abs_path)

#search c&h files function
def find_files(path, search, default_result, exclude = None):
    for x_path in os.listdir(path):
        if x_path != exclude:
            x_path = os.path.join(path, x_path)
            if os.path.isdir(x_path):
                find_files(x_path, search, default_result, exclude = None)
            elif (os.path.splitext(x_path)[1]).lower() == search:
                default_result.append(x_path)

#find .h files and store the path in a list
h_files = ['0']
find_files(os.path.abspath('.'), '.h', h_files)

#find .c files and store the path in a list
c_files = ['0']
find_files(os.path.abspath('.'), '.c', c_files)

#creat new folder named files_c & file_h in select_result
os.mkdir(abs_path)
new_dir = [0, 0]
C = 0
H = 1
new_dir[C] = os.path.join(abs_path, 'files_c')
new_dir[H] = os.path.join(abs_path, 'files_h')
for i in range(2):
    os.mkdir(new_dir[i])
        
#copy .h files to the folder named files_h
repeat_name_file = []
if len(h_files) > 1:
    for x_file in h_files[1:]:
        if (os.path.split(x_file))[1] in os.listdir(new_dir[H]):
            repeat_name_file.append(x_file)
        else:
            shutil.copy(x_file, new_dir[H])

#copy .c files to the folder named files_c
if len(c_files) > 1:
    for x_file in c_files[1:]:
        if (os.path.split(x_file))[1] in os.listdir(new_dir[C]):
            repeat_name_file.append(x_file)
        else:
            shutil.copy(x_file, new_dir[C])

#report files need rename
if len(repeat_name_file) > 0:
    print('These files have duplicate names and are not \
copied to result floder.- \n' + str(repeat_name_file))

#-End of file------------------------------------------------------------------
