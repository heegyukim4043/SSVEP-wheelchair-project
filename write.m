function write(t,filename,varargin)
%WRITE Write a table to a file.
%   WRITE(T) writes the table T to a comma-delimited text file. The file name is
%   the workspace name of the table T, appended with '.txt'. If WRITE cannot
%   construct the file name from the table input, it writes to the file
%   'table.txt'. WRITE overwrites any existing file.
%
%   WRITE(T,FILENAME) writes the table T to the file FILENAME as column-oriented
%   data. WRITE determines the file format from its extension. The extension
%   must be one of those listed below.
%
%   WRITE(T,FILENAME,'FileType',FILETYPE) specifies the file type, where
%   FILETYPE is one of 'text' or 'spreadsheet'.
%
%   WRITE writes data to different file types as follows:
%
%   .txt, .dat, .csv:  Delimited text file (comma-delimited by default).
%
%          WRITE creates a column-oriented text file, i.e., each column of each
%          variable in T is written out as a column in the file. T's variable
%          names are written out as column headings in the first line of the
%          file.
%
%          Use the following optional parameter name/value pairs to control how
%          data are written to a delimited text file:
%
%          'Delimiter'      The delimiter used in the file. Can be any of ' ',
%                           '\t', ',', ';', '|' or their corresponding character
%                           vector names 'space', 'tab', 'comma', 'semi', or
%                           'bar'. Default is ','.
%
%          'WriteVariableNames'  A logical value that specifies whether or not
%                           T's variable names are written out as column
%                           headings. Default is true.
%
%          'WriteRowNames'  A logical value that specifies whether or not T's
%                           row names are written out as first column of the
%                           file. Default is false. If the 'WriteVariableNames'
%                           and 'WriteRowNames' parameter values are both true,
%                           T's first dimension name is written out as the
%                           column heading for the first column of the file.
%
%          'DateLocale'     A character vector specifying the locale that
%                           writetable uses to create month and day names when
%                           writing datetimes to the file. LOCALE must be a
%                           character vector in the form xx_YY. See the
%                           documentation for DATETIME for more information.
%
%          'QuoteStrings'   A logical value that specifies whether to write
%                           strings out enclosed in double quotes ("..."). If
%                           'QuoteStrings' is true, any double quote characters
%                           that appear as part of a string are replaced by two
%                           double quote characters.
%
%          'Encoding'       The encoding to use when creating the file.
%                           Default is 'system' which means use the system's
%                           default file encoding.
%
%   .xls, .xlsx, .xlsb, .xlsm:  Spreadsheet file.
%
%          WRITE creates a column-oriented spreadsheet file, i.e., each column
%          of each variable in T is written out as a column in the file. T's
%          variable names are written out as column headings in the first row of
%          the file.
%
%          Use the following optional parameter name/value pairs to control how
%          data are written to a spreadsheet file:
%
%          'WriteVariableNames'  A logical value that specifies whether or not
%                           T's variable names are written out as column
%                           headings. Default is true.
%
%          'WriteRowNames'  A logical value that specifies whether or not T's
%                           row names are written out as first column of the
%                           file. Default is false. If the 'WriteVariableNames'
%                           and 'WriteRowNames' parameter values are both true,
%                           T's first dimension name is written out as the
%                           column heading for the first column of the file.
%
%          'DateLocale'     A character vector specifying the locale that
%                           writetable uses to create month and day names when
%                           writing datetimes to the file. LOCALE must be a
%                           character vector in the form xx_YY. See the
%                           documentation for DATETIME for more information.
%
%          'Sheet'          The sheet to write, specified as a character vector
%                           that contains the worksheet name, or a positive
%                           integer indicating the worksheet index.
%
%          'Range'          A character vector that specifies a rectangular
%                           portion of the worksheet to write, using the Excel
%                           A1 reference style.
%
%   In some cases, WRITE creates a file that does not represent T exactly, as
%   described below. If you use TABLE(FILENAME) to read that file back in and
%   create a new table, the result may not have exactly the same format or
%   contents as the original table.
%
%   *  WRITE writes out numeric variables using long g format, and
%      categorical or character variables as unquoted strings.
%   *  For non-character variables that have more than one column, WRITE
%      writes out multiple delimiter-separated fields on each line, and
%      constructs suitable column headings for the first line of the file.
%   *  WRITE writes out variables that have more than two dimensions as two
%      dimensional variables, with trailing dimensions collapsed.
%   *  For cell-valued variables, WRITE writes out the contents of each cell
%      as a single row, in multiple delimiter-separated fields, when the
%      contents are numeric, logical, character, or categorical, and writes out
%      a single empty field otherwise.
%
%   Save T as a mat file if you need to import it again as a table.
%      
%   See also TABLE, READTABLE.

%   Copyright 2012-2019 The MathWorks, Inc.

writetable(t,filename,varargin{:});
