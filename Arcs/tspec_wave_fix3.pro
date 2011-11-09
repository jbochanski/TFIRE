PRO tspec_wave_fix3

psig=10.0
pkwdth=5.0
toler=10.0
mxoff=1.0

 FORDR = 9L
 box_rad = 5L
 maxsep = 10L
 fwcoeff = 3L



FOR ii=0, 4 DO BEGIN
igss = ii
;guess_fit.LSIG=2.0
;guess_fit.HSIG=2.0

fire_dir = getenv('FIRE_DIR')
guessarc = getenv('FIRE_DIR')+'/Arcs/TSpec_jjb_guess2.idl'
linlist = '/astro/research/jjb29/Astronomy/sarah/TFIRE/Arcs/FIRE_OH_R6000.lst'

restore,guessarc
guess_fit=all_arcfit

x_arclist, linlist, lines
;STOP
x_templarc, sv_aspec[*,ii], lines, guess_fit[ii], MSK=msk $
            , ALL_PK=all_pk, PKWDTH=pkwdth $
            ,PKSIG=psig, FLG=flg_templ, BEST=best, /FWEIGHT, $
            /THIN,TOLER=TOLER,mxoff=mxoff

;STOP

x_identify,sv_aspec[*,ii], calib_out, xsize = 1200, ysize = 600 $
           , lineroot='/astro/research/jjb29/Astronomy/sarah/TFIRE/Arcs/' $
           ,linelist = 'FIRE_OH_R6000.lst'$
           , PKSIG =psig, PKWDTH = pkwdth, TOLER =TOLER, MXOFF = mxoff $
           , /THIN, /FWEIGHT,incalib=guess_fit[ii], INLIN=lines

STOP

;;  x_templarc, sv_aspec[*,ii], lines, calib_out, MSK=msk $
;;              , ALL_PK=all_pk, PKWDTH=pkwdth $
;;              ,PKSIG=psig, FLG=flg_templ, BEST=best, /FWEIGHT, $
;;              /THIN,TOLER=TOLER,mxoff=mxoff

;;  x_identify,sv_aspec[*,ii], calib_out, xsize = 1200, ysize = 600 $
;;             , lineroot='/astro/research/jjb29/Astronomy/sarah/TFIRE/Arcs/' $
;;             ,linelist = 'FIRE_OH_R6000.lst'$
;;             , PKSIG =psig, PKWDTH = pkwdth, TOLER =TOLER, MXOFF = mxoff $
;;             , /THIN, /FWEIGHT,incalib=guess_fit[ii], INLIN=lines

;; STOP

;; lines.flg_plt = 0
;; x_templarc, sv_aspec[*,ii], lines, calib_out, MSK=msk $
;;             , ALL_PK=all_pk, PKWDTH=pkwdth, FORDR=9 $
;;             ,PKSIG=psig, FLG=flg_templ, BEST=best, /FWEIGHT, $
;;             /THIN,TOLER=TOLER,mxoff=mxoff
 
gdfit = where(lines.flg_plt EQ 1, ngd)

tmp_fit = {fitstrct}
copy_struct, calib_out, tmp_fit, $
             EXCEPT_TAGS=['FFIT','NRM','RMS']
tmp_fit.flg_rej = 1 
tmp_fit.niter = 3 
tmp_fit.maxrej = 10 
tmp_fit.minpt = 5

fit = x_fitrej(lines[gdfit].pix, alog10(lines[gdfit].wave), $
               FITSTR=tmp_fit, REJPT=rejpt)

all_arcfit[ii] = tmp_fit



ENDFOR          

STOP



END
