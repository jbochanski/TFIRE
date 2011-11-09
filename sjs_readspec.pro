;sjs sept 16 2011

;read in the dumb formating that firehose outputs

function sjs_readspec,fileroot,microns=microns,hdr=hdr

  flux = x_readspec(fileroot + '_F.fits',wav=wav,head=hdr)
  err = x_readspec(fileroot + '_E.fits',wav=wav)


  if keyword_set(microns) then wav = wav/10000.

  return,[[wav],[flux],[err]]

end
