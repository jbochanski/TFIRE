
pro fire_superflat_ld, blue=blueflat, red=redflat, illum=illumflat, $
                    raw=rawdir, slitfile=slitfile, $
                    wavefile=wavefile, splitrow=splitrow, $
                    outpix=outpix, outillum=outillum


  sig = 100.0
  wt = fltarr(4096)
  wt[splitrow:4095] = 1.0
  gs = exp(-(findgen(4096)-2048)^2/(2*sig^2))
  tmp = fft(fft(wt)*fft(gs), /inverse)

  weight = fltarr(2048)
  weight[*] = tmp[(2048-1100)+findgen(2048)]
  weight[splitrow+3.0*sig:2047] = 0
  weight /= max(weight)
  wimg = weight ## (fltarr(2048)+1.0)

  composite = wimg * xmrdfits(strtrim(rawdir,2)+blueflat, 0, hdr) + $
              (1-wimg) * xmrdfits(strtrim(rawdir,2)+redflat)
  mwrfits, composite, "flat_composite.fits", hdr, /create


  fire_superflat_work, ["flat_composite.fits",strtrim(rawdir,2)+illumflat] ,$
                  outpix, outillum, slitfile=slitfile, $
                  use_illum=[0,1], use_pixel=[1,0], /chk    


end
