; *******************************************************************************
;
; Name:       fit_plane.pro
;
; Author:     Tim Cook
;
; History:    Written 6/10/9
;
; Function:   Find the least square fit on [x,y,z] data points to a plane of the
; form Z=aX+bY+c
;
; INPUTS:     X  vector of x location of data points
; Y  vector of y location of data points
; Z  vector of z location of data points
;
; OUTPUTS:    a,b,c - coefficients of the above equation
;
; SYNTAX:     [a,b,c] = fit_plane(x,y,z)
;
; *******************************************************************************

function fit_plane, x, y, z
  compile_opt idl2
  ; Check data
  n = n_elements(x)
  if ((n ne n_elements(y)) or (n ne n_elements(z))) then stop, 'Vectors must be of equal length'

  ; Find matrix coefficients
  axx = total((x) ^ 2)
  ayy = total((y) ^ 2)

  axy = total(x * y)
  axz = total(x * z)
  ayz = total(y * z)

  ax = total(x)
  ay = total(y)
  az = total(z)

  arr = [[axx, axy, ax], $
    [axy, ayy, ay], $
    [ax, ay, n]]

  vec = [axz, ayz, az]

  ainv = invert(arr, status, /double)

  stat_mess = ['Good', 'Singular matrix', 'Small pivitol element']
  if status ne 0 then stop, 'Print invert status = ', status, stat_mess[status]

  abc = ainv # vec

  return, abc
end