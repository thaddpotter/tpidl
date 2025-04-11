; $Id: //depot/Release/ENVI50_IDL82/idl/idldir/lib/read_csv.pro#3 $
;
; Copyright (c) 2008-2013, Exelis Visual Information Solutions, Inc. All
; rights reserved. Unauthorized reproduction is prohibited.

; ----------------------------------------------------------------------------
function read_csv_fieldnames, fieldCount
  compile_opt idl2, hidden

  digits_str = strtrim(string(strlen(strtrim(string(fieldCount), 2))), 2)
  fstr = '(i' + digits_str + '.' + digits_str + ')'
  fieldNames = 'field' + string(lindgen(fieldCount) + 1, format = fstr)

  return, fieldNames
end

; ----------------------------------------------------------------------------
;+
; :Description:
;    The READ_CSV function reads data from a "comma-separated value"
;    (comma-delimited) text file into an IDL structure variable.
;
;    This routine handles CSV files consisting of an optional line of column
;    headers, followed by columnar data, with commas separating each field.
;    Each row is assumed to be a new record.
;
;    The READ_CSV routine will automatically return each column (or field)
;    in the correct IDL variable type using the following rules:
;
;       * Long - All data within that column consists of integers,
;           all of which are smaller than the maximum 32-bit integer.
;       * Long64 - All data within that column consists of integers,
;           with at least one greater than the maximum 32-bit integer.
;       * Double - All data within that column consists of numbers, at least
;           one of which has either a decimal point or an exponent.
;       * String - All data which does not fit into one of the above types.
;
;    This routine is written in the IDL language. Its source code can be
;    found in the file read_csv.pro in the lib subdirectory of the IDL
;    distribution.
;
; :Syntax:
;    Result = READ_CSV( Filename
;      [, COUNT=variable] [, HEADER=variable] [, MISSING_VALUE=value]
;      [, NUM_RECORDS=value] [, RECORD_START=value]
;      [, N_TABLE_HEADER=value] [,TABLE_HEADER=variable]
;      )
;
; :Params:
;    Filename
;      A string containing the name of a CSV file to read into an IDL variable.
;
; :Keywords:
;    COUNT
;      Set this keyword equal to a named variable that will contain the
;      number of records read.
;
;    HEADER
;      Set this keyword equal to a named variable that will contain the
;      column headers as a vector of strings. If no header exists,
;      an empty scalar string is returned.
;
;    MISSING_VALUE
;      Set this keyword equal to a value used to replace any missing
;      floating-point or integer data. The default value is 0.
;
;    NUM_RECORDS
;      Set this keyword equal to the number of records to read.
;      The default is to read all records in the file.
;
;    RECORD_START
;      Set this keyword equal to the index of the first record to read.
;      The default is the first record of the file (record 0).
;
;    N_TABLE_HEADER
;       Set this keyword to the number of lines to skip at the beginning of the file,
;       not including the HEADER line. These extra lines may be retrieved by using the TABLE_HEADER keyword.
;
;    TABLE_HEADER
;       Set this keyword to a named variable in which to return an array of strings
;       containing the extra table headers at the beginning of the
;       file, as specified by N_TABLE_HEADER.
;
;    TAGNAMES
;       Set this keyword to an array of strings to use as the
;       structure tags instead of FIELD01, FIELD02, etc
;
;    DELIM
;       Set this keyword to the delimiting character of the file.
;       Default is comma
;
;
; :History:
;   Written, CT, VIS, Oct 2008
;   MP, VIS, Oct 2009: Added keyword NSKIP and SKIP_HEADER
;
;   Edited by Chris Mendillo  - 3/6/2017 (cbm_read_csv)
;   Added TAGNAMES Keyword
;
;   Further edited by Thad Potter - 12/1/2021
;   Added DELIM keyword
;
;
;-
function tp_read_txt, Filename, $
  count = count, $
  header = header, $
  missing_value = missingValue, $
  num_records = numRecordsIn, $
  record_start = recordStart, $
  n_table_header = nTableHeader, $
  table_header = tableHeader, $
  tagnames = tagnames, $
  delim = delim, $
  _extra = _extra ; needed for iOpen
  compile_opt idl2, hidden

  on_error, 2 ; Return on error

  catch, err
  if (err ne 0) then begin
    catch, /cancel
    if (n_elements(lun) gt 0) then $
      free_lun, lun
    if (max(ptr_valid(pData)) eq 1) then $
      ptr_free, pData
    message, !error_state.msg
  endif

  header = ''

  if (n_params() eq 0) then $
    message, 'Incorrect number of arguments.'

  ; Empty file
  if (file_test(Filename, /zero_length)) then $
    return, 0

  ; Default delimiter is Comma
  if not keyword_set(delim) then delim = ','

  ; Set appropriate dataStart, where dataStart includes column header.
  dataStart = keyword_set(nTableHeader) ? long64(nTableHeader) : 0

  openr, lun, Filename, /get_lun

  str = ''
  tableHeader = ''
  for i = 0l, dataStart do begin
    readf, lun, str
    if i ne dataStart then begin
      pos = stregex(str, '"')
      if pos ne 0 then begin ; string not enclosed in quotes
        pos = stregex(str, delim + '+') ; check for extra delimiters
        if pos ne -1 then str = strmid(str, 0, pos)
      endif else begin
        ; string enclosed in commas
        pos = stregex(str, '"' + delim + '+') ; check for extra delimiters
        if pos ne -1 then str = strmid(str, 1, pos - 1) else str = strjoin(strsplit(str, '"', /extract))
      endelse

      if i eq 0 then tableHeader = str else tableHeader = [tableHeader, str]
    endif
  endfor

  while (strlen(strtrim(str, 2)) eq 0) do begin
    readf, lun, str
  endwhile

  free_lun, lun

  ; We need to count the number of fields.
  ; First remove escaped quote characters, which look like "".
  str = strjoin(STRTOK(str, '""', /regex, /extract))
  ; Now remove quoted strings, which might contain bogus delimiters.
  str = strjoin(STRTOK(str, '"[^"]*"', /regex, /extract))
  ; Finally, count the number of delimiters.
  fieldCount = n_elements(STRTOK(str, delim, /preserve_null))

  fieldNames = read_csv_fieldnames(fieldCount)
  ; ;code added by cbm 3/6/2017
  if keyword_set(tagnames) then fieldNames = tagnames

  template = { $
    version: 1.0, $
    dataStart: dataStart, $ ; specified as a keyword below
    delimiter: byte(delim), $ ; delimiter
    missingValue: 0, $
    commentSymbol: '', $
    fieldCount: fieldCount, $
    fieldTypes: replicate(7l, fieldCount), $
    fieldNames: fieldNames, $
    fieldLocations: lonarr(fieldCount), $ ; ignored for csv
    fieldGroups: lindgen(fieldCount) $ ; ungrouped
    }

  if (n_elements(numRecordsIn)) then $
    numRecords = numRecordsIn[0] + 1

  data = read_ascii(Filename, $
    count = count, $
    data_start = dataStart, $
    num_records = numRecords, $
    record_start = recordStart, $
    template = template)

  if (n_tags(data) eq 0) then $
    message, 'File "' + Filename + '" is not a valid file. Contains no Columns!', /noname

  ; Eliminate empty columns
  columnLen = lonarr(fieldCount)
  firstNonEmptyRow = count - 1
  lastNonEmptyRow = 0l

  for i = 0l, fieldCount - 1 do begin
    data.(i) = strtrim(data.(i), 2)
    lengths = strlen(data.(i))
    good = where(lengths gt 0, ngood)
    if (ngood gt 0) then begin
      firstNonEmptyRow = firstNonEmptyRow < min(good)
      lastNonEmptyRow = lastNonEmptyRow > max(good)
      columnLen[i] = max(lengths)
    endif
  endfor

  nColumns = long(total(columnLen gt 0))

  ; All of the fields were empty.
  if (nColumns eq 0) then begin
    return, 0
  endif

  count = lastNonEmptyRow - firstNonEmptyRow + 1

  ; Convert each field to a pointer, for easier manipulation.
  j = 0l
  pData = ptrarr(nColumns)
  for i = 0l, fieldCount - 1 do begin
    if (columnLen[i] eq 0) then continue
    columnLen[j] = columnLen[i]
    pData[j] = ptr_new((data.(i))[firstNonEmptyRow : lastNonEmptyRow])
    j++
  endfor

  data = 0
  columnLen = columnLen[0 : nColumns - 1]

  ; Attempt to determine the data types for each field.
  types = bytarr(nColumns)
  if (count gt 1) then begin
    for j = 0, nColumns - 1 do begin
      subdata = (*pData[j])[1 : (100 < (count - 1))]

      on_ioerror, skip1

      tmpDouble = double(subdata)
      tmpLong64 = long64(subdata)
      tmpLong = long(subdata)
      hasDecimal = max(strpos(subdata, '.')) ge 0

      if (hasDecimal || ~array_equal(tmpLong64, tmpDouble)) then begin
        ; Double
        types[j] = 5
      endif else begin
        ; CR61359: Make sure that our integer data doesn't have any
        ; non-numeric characters. If so, then just return strings instead.
        newLen = strlen(strtrim(tmpLong64, 2))
        origLen = strlen(subdata)
        ; Null strings will have been converted to the number zero.
        ; Set their length back to 0.
        newLen[where(origLen eq 0, /null)] = 0
        if (~array_equal(newLen, origLen) || array_equal(newLen, 0)) then continue
        ; Long or Long64
        types[j] = array_equal(tmpLong, tmpLong64) ? 3 : 14
      endelse

      skip1:
      on_ioerror, null
    endfor

    ; Attempt to determine if the first line is a header line.
    isFirstLineText = 0
    for j = 0, nColumns - 1 do begin
      if (types[j] ne 0) then begin
        on_ioerror, skip2
        ; If we fail to convert the first item to the type for that column,
        ; then assume that it is a "string" column header.
        result = fix((*pData[j])[0], type = types[j])
        continue
        skip2:
        on_ioerror, null
        isFirstLineText = 1
        break
      endif
    endfor

    nheader = isFirstLineText ? 1 : 0

    fieldNames = read_csv_fieldnames(nColumns)
    ; ;code added by cbm 3/6/2017
    if keyword_set(tagnames) then fieldNames = tagnames

    if (nheader gt 0) then begin
      count -= nheader
      header = strarr(nColumns, nheader)
      for j = 0, nColumns - 1 do begin
        header[j, *] = (*pData[j])[0 : nheader - 1]
      endfor
    endif else begin
      ; If NUM_RECORDS was specified, we needed to read one extra record,
      ; in case there was a header. Since there was no header, get rid
      ; of the extra record.
      if (n_elements(numRecordsIn)) then count--
    endelse

    hasMissingValue = n_elements(missingValue) eq 1 && $
      missingValue[0] ne 0

    ; Do the actual type conversion.

    for j = 0, nColumns - 1 do begin
      *pData[j] = (*pData[j])[nheader : nheader + count - 1]

      if (types[j] ne 0) then begin
        if (hasMissingValue) then begin
          iMiss = where(*pData[j] eq '', nmiss)
        endif

        on_ioerror, skip3
        ; Do the actual type conversion.
        *pData[j] = fix(*pData[j], type = types[j])

        if (hasMissingValue && nmiss gt 0) then begin
          (*pData[j])[iMiss] = missingValue[0]
        endif
        skip3:
        on_ioerror, null
      endif
    endfor
  endif ; count gt 1

  ; Create the final anonymous structure.
  data = READ_ASCII_CREATE_STRUCT(fieldNames, pData)

  ptr_free, pData

  return, data
end
