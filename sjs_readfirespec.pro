;sjs sept 25 2011

;read in a fire spectrum flux and error, retun header, wavelength,
;flux, and error.

function sjs_readfirespec,name,hdr
  
  spec = mrdfits('FSpec/' + name + '_F.fits',0,hdr)
  err =  mrdfits('FSpec/' + name + '_E.fits',0,ehdr)
  
  cdelt1 = sxpar(hdr,'CDELT1')
  crval1 = sxpar(hdr,'CRVAL1')
  
  npts = n_elements(spec)
  wave = 10^(crval1 + cdelt1*(dindgen(npts)))

return,[[wave],[spec],[err]]

end

