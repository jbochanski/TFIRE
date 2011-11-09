PRO clear_fire_find_streaks, nregs, firsts, lasts
	nregs = 0
	fire_undefine, firsts
	fire_undefine, lasts
	RETURN
END

;; Inputs a vector and outputs first ('firsts') and last ('lasts') indices of regions with at least
;; MIN_WIDTH consecutive non-zero elements
;; If argument mask is present, then return a vector equal to 1 where such regions exist, 0 otherwise (unless /REVERSE
;;	is passed, in which mask will have 0's in regions and 1's outside).
;; If buff is set, then 'buff' pixels around good regions are added to good regions.
FUNCTION fire_find_streaks, vector, min_width, nregs, firsts, lasts, MASK=mask, BUFF=buff, REVERSE=reverse

	func_name = "fire_find_streaks"

	if is_undefined(vector) then begin
		fire_siren, func_name + ": ERROR!  Input 'vector' is undefined.  Returning non-sensical value."
		clear_fire_find_streaks, nregs, firsts, lasts
		RETURN, -1
	endif
	
	if is_undefined(min_width) then begin
		fire_siren, func_name + ": ERROR!  Input 'min_width' is undefined.  Returning non-sensical value." 
		clear_fire_find_streaks, nregs, firsts, lasts
		RETURN, -1
	endif	

	npix = n_elements(vector)
	tmp = fix( vector GT 0 )
	diffs = tmp - shift(tmp,1)
	if tmp(0) EQ 1 then begin
		diffs(0) = 1
	endif else begin
		diffs(0) = 0
	endelse
	if tmp(npix-1) EQ 1 then begin
		diffs = [ diffs, -1 ]
	endif else begin
		diffs = [ diffs, 0 ]		
	endelse

	firsts = where( diffs EQ 1, nfirsts )
	lasts = where( diffs EQ -1, nlasts )
	if nfirsts NE nlasts then begin
		fire_siren, func_name + ": ERROR! Number of firsts not equal to number of lasts." + $
			"  Something fishy going on.  Exiting."
		clear_fire_find_streaks, nregs, firsts, lasts
		RETURN, -1
	endif
	if nfirsts EQ 0 then begin
		clear_fire_find_streaks, nregs, firsts, lasts
		RETURN, 0
	endif

	lasts = lasts-1
	widths = lasts - firsts + 1
	good_regions = where( widths GE min_width, ngood )
	if ngood EQ 0 then begin
		clear_fire_find_streaks, nregs, firsts, lasts
		RETURN, 0
	endif

	firsts = firsts(good_regions)
	lasts = lasts(good_regions)
	nregs = ngood

	if keyword_set(BUFF) then begin
		firsts = (firsts - buff) > 0
		lasts = (lasts + buff) < (npix-1)
	endif

	if arg_present(MASK) then begin
		if keyword_set(REVERSE) then begin
			value_out = 1
			value_in = 0
		endif else begin
			value_out = 0
			value_in = 1
		endelse
		mask = make_array( npix, 1, /integer, value=value_out )
		for j=0, nregs-1 do begin
			mask( firsts(j):lasts(j) ) = value_in
		endfor
	endif
	
	RETURN, 0
	
END
