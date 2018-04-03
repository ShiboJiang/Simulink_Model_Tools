#!/usr/bin/env python3
# -*- coding: utf-8 -*-

#------------------------------------------------------------------------------
# Function   : This scrip is used to creat sl_customization.m with all .m files
# Enviroment : python 3
# Author     : Shibo Jiang
# Time       : 2018.3.23
# Version    : 0.1
# Notes      : None
#------------------------------------------------------------------------------

import os

# Start of find_files function-------------------------------------------------
def find_files(path, search, default_result, exclude = None):
    for x_path in os.listdir(path):
        if x_path != exclude:
            x_path = os.path.join(path, x_path)
            if os.path.isdir(x_path):
                find_files(x_path, search, default_result, exclude = None)
            elif (os.path.splitext(x_path)[1]).lower() == search:
                default_result.append(x_path)
# End of find_files function---------------------------------------------------

# Start of main function-------------------------------------------------------
def main():
    # Config constant value
    MAIN_FILE   = 'sl_customization.m'
    TARGET_FILE = 'sl_customization_all.m'
    PWD_PATH    = os.path.abspath('.')

    # Delete exit target files
    if TARGET_FILE in os.listdir(PWD_PATH):
        delete_file = os.path.join(PWD_PATH,TARGET_FILE)
        os.remove(delete_file)

    # Parameters
    m_files = [os.path.join(PWD_PATH, MAIN_FILE)]
    find_files(PWD_PATH, '.m', m_files)

    # Copy files content
    done_file = []
    repeat_file = []
    with open(TARGET_FILE, 'w', encoding='gbk') as tar_file:
        for x_file in m_files:
            # Judge whether file is repeat
            if not x_file in done_file:
                # Read file's content
                with open(x_file, 'r', encoding='gbk') as src_file:
                    while True:
                        content = src_file.readline()
                        # Write content to target file
                        tar_file.write(content)
                        if not content:
                            tar_file.write('\n'+'\n')
                            break
                # Add file's name to done_file which already copied
                done_file.append(x_file)
                print(str(os.path.split(x_file)[1]) + ' --already copied!')
            else:
                if str(os.path.split(x_file)[1]) != MAIN_FILE: 
                    repeat_file.append(x_file)
    # Report repeat files
    print('These files are repeated:' + str(repeat_file))
# End of main function---------------------------------------------------------

# Run script
main()
