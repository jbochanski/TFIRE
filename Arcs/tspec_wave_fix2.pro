PRO tspec_wave_fix2

FOR ii=0, 4 DO BEGIN
igss = ii
;guess_fit.LSIG=2.0
;guess_fit.HSIG=2.0
 fire_dir = getenv('FIRE_DIR')
guessarc = getenv('FIRE_DIR')+'/Arcs/OH_guess_v5.idl'
restore,guessarc
guess_fit=all_arcfit
;; STOP
;;  x_identify, sv_aspec[*,ii], calib_temp $
;;              , mfitstr = guess_fit[igss], mspec =guess_spec[*,igss] $
;;              , mshift = shft $
;;              , xsize = 1200, ysize = 600 $
;;              , linelist = strtrim(fire_dir,2)+'/Arcs/FIRE_OH_R6000.lst'$
;;              , PKSIG = psig, PKWDTH = pkwdth, TOLER =TOLER, MXOFF = mxoff $
;;              , /THIN, /FWEIGHT 
;; stop
;restore,'order6.sav'
;calib_old=calib_temp
;delvarx,calib_temp
psig=10.0
pkwdth=5.0
toler=10.0
mxoff=1.0

 FORDR = 9L
 box_rad = 5L
 maxsep = 10L
 fwcoeff = 3L


;; filename = '/Volumes/moria1/jjb29/Astronomy/sarah/forjohn/SD053900.0050.fits'
;; slitfile = '/astro/research/jjb29/Astronomy/sarah/Flat/Orders_0108.fits'
;; linelist = '/Volumes/moria1/jjb29/Astronomy/sarah/TFIRE/Arcs/FIRE_OH_R6000.lst'
;; ;----------
;; ; Read in slit structure 
;; tset_slits = xmrdfits(slitfile, 1, silent = (keyword_set(verbose) EQ 0))

;; tspec_proc, filename, arcimg, arcivar, hdr = hdr $
;;            ,verbose = verbose, /maskbadpix

;; wstruct = tspec_wstruct_ld(hdr)


;; ;;---------
;; ;; set parameters from wavestruct
;; linelist_ap = wstruct.linelist_ap
;; linelist = wstruct.linelist
;; REID = wstruct.REID
;; AUTOID = wstruct.AUTOID
;; RADIUS = wstruct.RADIUS
;; SIG_WPIX = wstruct.SIG_WPIX

;; badpix = WHERE(finite(arcimg) NE 1 OR finite(arcivar) NE 1, nbad)
;; IF nbad NE 0 THEN arcivar[badpix] = 0.0D

;; dims = size(arcimg, /dimens)
;; nx = dims[0]
;; ny = dims[1]
;; nyby2 = ny/2L


;; ;; ------
;; ;; Expand slit set to get left and right edge
;; traceset2xy, tset_slits[0], rows, left_edge
;; traceset2xy, tset_slits[1], rows, right_edge


;; if (size(left_edge, /n_dimen) EQ 1) then nslit = 1 $
;; else nslit = (size(left_edge, /dimens))[1]
;; trace = (left_edge + right_edge)/2.0D
;; ;; Open line lists
;; x_arclist, linelist, lines

;; arc1d = fltarr(ny, nslit)
;; for islit = 0L, nslit-1L do begin
;;     splog, 'Working on slit #', islit+1, ' (', islit+1, ' of ', nslit, ')'
;;     ;; iteratively compute mean arc spectrum which is robust against cosmics
;;     FOR j = 0L, ny-1L DO BEGIN
;;         left  = floor(trace[j, islit] - BOX_RAD) > 0
;;         right = ceil(trace[j, islit] + BOX_RAD)
;;         sub_arc  = arcimg[left:right, j]
;;         sub_ivar = arcivar[left:right, j]
;;         sub_var = 1.0/(sub_ivar + (sub_ivar EQ 0.0))
;;         djs_iterstat, sub_arc, invvar = sub_ivar $
;;                       , mean = mean, sigrej = 3.0, mask = mask, median = median
;;         arc1d[j, islit] = mean
;; ;        arc1d[j, islit] = arcimg[(left+right)/2,j]
;;         IF total(mask) NE 0 THEN var = total(sub_var*mask)/total(mask)^2 $
;;         ELSE var = total(sub_var)
;;      ENDFOR






;;   fin_fit = tspec_reidentify(arc1d[*, islit], lines, wstruct $
;;                                  , gdfit = gdfit, rejpt = rejpt $
;;                                  , MXSHIFT = wstruct.mxshift $
;;                                  , fit_flag = fit_flag, /ARC_INTER) 


;; STOP


x_identify,sv_aspec[*,ii], calib_out, xsize = 1200, ysize = 600, $
           , lineroot='/astro/research/jjb29/Astronomy/sarah/TFIRE/Arcs/' $
           ,linelist = 'FIRE_OH_R6000.lst'$
           , PKSIG =psig, PKWDTH = pkwdth, TOLER =TOLER, MXOFF = mxoff $
           , /THIN, /FWEIGHT,incalib=all_arcfit[igss]
stop
;x_arclist, linlist, lines
lines.flg_plt = 0
x_templarc, sv_aspec[*,ii], lines, calib_out, MSK=msk $
            , ALL_PK=all_pk, PKWDTH=pkwdth, FORDR=9 $
            ,PKSIG=psig, FLG=flg_templ, BEST=best, /FWEIGHT, $
            /THIN,TOLER=TOLER,mxoff=mxoff
 
gdfit = where(lines.flg_plt EQ 1, ngd)

tmp_fit = {fitstrct}
copy_struct, calib_out, tmp_fit, $
             EXCEPT_TAGS=['FFIT','NRM','RMS']
tmp_fit.flg_rej = 1 
tmp_fit.niter = 3 
tmp_fit.maxrej = 10 
tmp_fit.minpt = 5
ENDFOR          
fit = x_fitrej(lines[gdfit].pix, alog10(lines[gdfit].wave), $
               FITSTR=tmp_fit, REJPT=rejpt)





END
