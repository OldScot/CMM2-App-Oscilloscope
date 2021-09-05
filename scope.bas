' SCOPE.BAS
' 
' 2021-Sep-04
' Craig S. Buchanan
'

OPTION EXPLICIT
OPTION DEFAULT NONE

' Prepare Storage
'dim a as float    ' average
dim be as integer ' blue
dim bk as integer ' black
dim c as integer  ' center
dim d as float    ' delay
dim f as float    ' scale factor
dim fn as string  ' filename
dim g as float    ' gain
dim gn as integer ' green
dim h as float    ' halfway
dim h1 as integer ' horizontal 1
dim k as integer  ' key
'dim l as float    ' last measurement
dim m as float    ' measurement
dim md as integer ' mode
dim o as float    ' offset
dim p as integer  ' pen colour
dim r(1920) as integer 'remove
dim rd as integer ' red
dim s as float    ' scale
dim t as integer  ' tracking
dim v1 as integer ' vertical 1
dim v2 as integer ' vertical 2
dim v3 as integer ' vertical 3
dim v4 as integer ' vertical 3
dim x as integer  ' x
dim y as integer  ' y

' Prepare I/O
const mx = 3.3    ' max measurement
const sp = 15     ' set pin
setpin sp, AIN, 8

' Prepare Screen
md = 6
be = rgb(blue)
bk = rgb(black)
rd = rgb(red)
gn = rgb(green)
p = gn
do
  Cls
  md = md mod 18
  Mode md, 8
  Colour p, rgb(black)
  Cls

  ' Prepare Scaling and Drawing
  h = mx / 2
  c = mm.vres / 2
  f = mm.vres / mx
  v1 = 2
  v2 = mm.info(fontheight) + v1 + 2
  v3 = mm.info(fontheight) + v2 + 2
  v4 = mm.vres - mm.info(fontheight) - 2
  h1 = mm.hres - mm.info(fontwidth) * 9 - 2

  ' Go
  x = 0
  d = 0
  g = 0.5
  s = f * g
  o = 0
  Text 2,v1,"Gain  :"+str$(g)+"            "
  Text 2,v2,"Delay :"+str$(d)+"            "
  Text 2,v3,"Offset:"+str$(o)+"            "
  Text 2,v4,"Keys: arrows, page, home, print, q, +, -"
  Text h1,v1,"Mode:"+str$(md)
  Text h1,v2,str$(mm.hres)+"x"+str$(mm.vres)
  do

    ' Get Measurement
    m = pin(sp) + o

    ' Scale
    y = (h - m)*s + c

    ' Remove
    Pixel x, r(x), bk

    ' Graph
    Pixel x, c, rd
    Pixel x, y, p

    ' Record
    r(x) = y

    ' Next
    inc x
    x = x mod mm.hres
    pause d

    ' Controls
    k = asc(inkey$)
    if k <> 0 then
      if k = 157 then
        fn = "scope."+left$(Date$,2)+mid$(Date$,4,2)+right$(Date$,2)+"."+left$(Time$,2)+mid$(Time$,4,2)+right$(Time$,2)+".bmp"
        save image fn
      end if
      if k = 27 or k = 113 then end
      if k = 128 then inc g, 0.1
      if k = 129 and g > 0 then inc g, -0.1
      if k = 130 and d > 0 then inc d, -.05
      if k = 131 then inc d, .05
      if k = 136 then inc o, 0.1
      if k = 137 then inc o, -0.1
      if k = 134 then g = 0.5 : o = 0 : d = 0
      if k = 43 then md = (md + 1) mod 18 : if md < 1 then md = 1
      if k = 45 then md = md - 1: if md < 1 then md = 17
      if d < .05 then d = 0
      if g < .1 then g = 0
      if o > -0.1 and o < 0.1 then o = 0 
      s = f * g
      Text 2,v1,"Gain  :"+str$(g)+"            "
      Text 2,v2,"Delay :"+str$(d)+"            "
      Text 2,v3,"Offset:"+str$(o)+"            "
      Text 2,v4,"Keys: arrows, page, home, print, q, +, -"
      Text h1,v1,"Mode:"+str$(md)
      Text h1,v2,str$(mm.hres)+"x"+str$(mm.vres)
    end if  

  loop until k = 43 or k = 45

loop


