; + 
; NAME:
; mage_combspec
; Version 0.1
;
; PURPOSE:
;  Combines an array of obj_structs into a fire fspec structure.  This
;  allows the combination of multiple observations and must be done
;  before  making a 1-d spectrum (even of just a single observation).  
;
; CALLING SEQUENCE:
;
;  mage_combspec,objstr,fspec
;
; INPUTS:
;   objstr  - An object structure generated from the mage_script
;             extraction routines, which has been fluxed
;
; RETURNS:
;
; OUTPUTS:
;
;   fspec   - The name of the firefspecstrct produced by combining the
;             input object structures
;
;
; OPTIONAL KEYWORDS:
;
; OPTIONAL OUTPUTS:
;
; COMMENTS:
;
; EXAMPLES:
;   mage_combspec,obj_strct,fspec
;
;
; PROCEDURES/FUNCTIONS CALLED:
;
;    magefspecstrct__define, x_echcombspec
;
; REVISION HISTORY:
;   16-Jun-2008 CLW

pro tspec_combspec,objstr,fspec,CHK=CHK, FLAG=flag, ERR_MESSAGE=err_message

fspec={firefspecstrct}
fspec.nexp=n_elements(objstr)/5;21  ;because there are 21 orders; i am sick of mysterious hard coding

;mage_echcombspec,objstr,fspec,[6,20],0
tspec_esi_echcombspec, objstr, fspec, iref=1, CHK=CHK, FLAG=flag, ERR_MESSAGE=err_message

end
