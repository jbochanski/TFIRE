FUNCTION FIRE_NUMS_TO_FILENAMES, file, PATH=path, NOPATH=NOPATH

	if keyword_set(NOPATH) then begin
		dirpath = ""
	endif else if NOT keyword_set(PATH) then begin
		dirpath = "../Raw/"
   endif else begin
     dirpath = path
   endelse

	file_prefix = "fire_"
	file_suffix = ".fits"
        
        num = n_elements(file)
        filename=strarr(num)
        for i =0,num-1 do begin

          spawn,'ls *' + strtrim(file[i],2) + '.fits',name
          fname = strsplit(name[0],'/',/extract,count=nc)
          filename[i] = fname[nc-1]
        endfor

	RETURN, dirpath + filename
END
