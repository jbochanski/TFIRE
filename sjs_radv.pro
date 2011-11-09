;sjs sept 25 2011

;calculate the radial velocty between two Tspec from FIRE
;sjs_radv,'2M035511','2M050003'
;sjs_radv,'2M035511','SD053900'
;sjs_radv,'2M050003','SD053900'
function sjs_radv,name1,name2,mask=mask,wgt=wgt,noj=noj

  one = sjs_readfirespec(name1,h1)
  two = sjs_readfirespec(name2,h2)

  rngJ = where(one[*,0] gt 1.0e4 and one[*,0] lt 1.3e4,nJ)
  rngH = where(one[*,0] gt 1.5e4 and one[*,0] lt 1.75e4,nH)
  rngK = where(one[*,0] gt 2.25e4 and one[*,0] lt 2.35e4,nK)

  wJ = one[rngJ,0]
  wH = one[rngH,0]
  wK = one[rngK,0]

  fJ1 = one[rngJ,1]/mean(one[rngJ,1])
  fH1 = one[rngH,1]/mean(one[rngH,1])
  fK1 = one[rngK,1]/mean(one[rngK,1])

  snJ1 = one[rngJ,1]/one[rngJ,2]
  snH1 = one[rngH,1]/one[rngH,2]
  snK1 = one[rngK,1]/one[rngK,2]
  
  normJ2 = mean(two[rngJ,1]) ;should only be off by 1-3 pixels
  normH2 = mean(two[rngH,1]) 
  normK2 = mean(two[rngK,1]) 

  fJ2 = interpol(two[*,1]/normJ2,two[*,0],wJ)
  fH2 = interpol(two[*,1]/normH2,two[*,0],wH)
  fK2 = interpol(two[*,1]/normK2,two[*,0],wK)

  snJ2 = interpol(two[*,1]/two[*,2],two[*,0],wJ)
  snH2 = interpol(two[*,1]/two[*,2],two[*,0],wH)
  snK2 = interpol(two[*,1]/two[*,2],two[*,0],wK)

  if keyword_set(mask) then begin

    mskJ = where(fJ1 gt 0 and fJ1 lt 2 and fJ2 gt 0 and fJ2 lt 2,nmskj)
    mskH = where(fH1 gt 0.5 and fH1 lt 1.5 and fH2 gt 0.5 and fH2 lt 1.5,nmskh)
    mskK = where(fK1 gt 0.5 and fK1 lt 1.5 and fK2 gt 0.5 and fK2 lt 1.5,nmskk)

    fJ1 = fJ1[mskJ]
    fJ2 = fJ2[mskJ]
    fH1 = fH1[mskH]
    fH2 = fH2[mskH]
    fK1 = fK1[mskK]
    fK2 = fK2[mskK]
  
    snJ1 = snJ1[mskJ]
    snJ2 = snJ2[mskJ]
    snH1 = snH1[mskH]
    snH2 = snH2[mskH]
    snK1 = snK1[mskK]
    snK2 = snK2[mskK]
  
    wJ = wJ[mskJ]
    wH = wH[mskH]
    wK = wK[mskK]

  endif

;  c = 299792.458D
  velpix = 30.5

  xcorl,fJ1,fJ2,6,shftJ,crossJ,/fine,/pl,/pr
  xcorl,fH1,fH2,6,shftH,crossH,/fine,/pl,/pr
  xcorl,fK1,fK2,6,shftK,crossK,/fine,/pl,/pr

  print,-shftJ*velpix
  print,-shftH*velpix
  print,-shftK*velpix

  if keyword_set(wgt) then begin

    snJ = median([snJ1,snJ2])
    snH = median([snH1,snH2])
    snK = median([snK1,snK2])

    meanvel = -1*(shftJ*snJ + shftH*snH + shftK*snK)*velpix/(snJ + snH + snK)

  endif else meanvel = mean(-1*[shftj,shfth,shftk]*velpix)
  
  if keyword_set(noj) then meanvel = mean(-0.5*(shfth+shftk)*velpix)

  return,meanvel

end
