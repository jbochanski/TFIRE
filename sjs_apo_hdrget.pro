;sjs september 2 2011

;a function to return the jd, ra_deg and dec_deg that is called for in
;the fire pipeline for heliocentric corrections

function sjs_apo_hdrget,hdr,ra=ra,dec=dec,rjd=rjd

  if keyword_set(ra) then begin

    rastr = strtrim(sxpar(hdr,'RA'),2)
    h = double(strmid(rastr,0,2))
    m = double(strmid(rastr,3,2))
    s = double(strmid(rastr,6,5))

    ra_hou = h + m/60. + s/3600.

    return,ra_hou*15

  endif

  if keyword_set(dec) then begin

    decstr = sxpar(hdr,'DEC')
    if abs(decstr) eq float(decstr) then begin
      d = double(strmid(decstr,0,2))
      m = double(strmid(decstr,3,2))
      s = double(strmid(decstr,6,5))
      sign = 1D
    endif else begin
      d = double(strmid(decstr,1,2))
      m = double(strmid(decstr,4,2))
      s = double(strmid(decstr,7,5))
      sign = -1D
    endelse

    return,(d + m/60. + s/3600.)*sign

  endif

  if keyword_set(rjd) then begin

    return,date_conv(sxpar(hdr,'DATE-OBS'),'julian')-2400000.d

  endif

end
