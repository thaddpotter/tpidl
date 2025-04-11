pro zodiplot, map2
  compile_opt idl2

  s = size(map2)
  num = s[1] / 2.0

  case 1 of
    num le 9: rfactor = 16
    (num le 18) and (num gt 9): rfactor = 8
    (num le 37) and (num gt 18): rfactor = 8
    (num le 73) and (num gt 37): rfactor = 4
    (num le 145) and (num gt 73): rfactor = 2
    else: rfactor = 1
  endcase

  if s[1] lt 600 then begin
    pic = rebin(map2, s[1] * rfactor, s[1] * rfactor, /sample)
    sz = size(pic)

    window, 0, title = 'Surface Brightness', xsize = sz[1], ysize = sz[2]
    tvscl, pic

    window, 1, title = 'Log Surface Brightness', xsize = sz[1], ysize = sz[2]
    places = where(pic gt 0)
    if places[0] ne -1 then begin
      amin = min(pic[places])
      amin = amin > 1e-20
      pic = pic > amin
      tvscl, alog10(pic)
    endif
  endif
end
