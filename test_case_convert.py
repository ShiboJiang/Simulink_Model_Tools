#!/usr/bin/env python3
# -*- coding: utf-8 -*-

#------------------------------------------------------------------------------
# Function   : This scrip is used for convert testcase's macro to number
# Enviroment : python 3.6.2
# Author     : Shibo Jiang
# Time       : 2018.4.4
# Version    : 0.1
# Notes      : None
#------------------------------------------------------------------------------
import xlrd
import openpyxl

# Maro define
FILE = 'CANSigRec_TestCase.xlsx'
SHEET_DEF = 'TestCase_MacroDef'
SHEET_OUT = 'TestCase_convert'
SHEET_ORGIN = 'TestCase_orgin'

def test_case_convert():
    # Get excel files and sheets
    work_book = xlrd.open_workbook(FILE)
    macro_sheet = work_book.sheet_by_name(SHEET_DEF)
    orgin_sheet = work_book.sheet_by_name(SHEET_ORGIN)

    # Get macro_sheet data and creat dict
    macro_dict = dict()
    for i in range(macro_sheet.nrows):
        data = macro_sheet.row_values(i)
        # Set dict
        macro_dict[str(data[0])] = data[1]
    
    # Get orgin sheet and use dict's value to replace out sheet
    w_row = list()
    w_col = list()
    w_value = list()
    for temp_row in range(orgin_sheet.nrows):
        temp_list = orgin_sheet.row_values(temp_row)
        temp_col = 0
        for temp_data in temp_list:
            if temp_data in macro_dict:
                w_row.append(temp_row)
                w_col.append(temp_col)
                w_value.append(macro_dict[temp_data])
            temp_col = temp_col + 1

    # Write new value to out sheet
    write_book = openpyxl.load_workbook(FILE)
    out_sheet = write_book.get_sheet_by_name(SHEET_OUT)
    for i in range(len(w_row)):
        out_sheet.cell(row = w_row[i],column = w_col[i]).value = w_value[i]

# Run script
test_case_convert()
