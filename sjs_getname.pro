;sjs sept 15 2011

;hack to get firehose the name it demands

function sjs_getname,numfits

  spawn,'ls *' + numfits + '> std.txt'
  readcol,'std.txt',name,f='(a)'
  spawn,'rm std.txt'
  return,name[0]

end
