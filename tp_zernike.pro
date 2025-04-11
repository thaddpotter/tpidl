function tp_zernike, points, inoll, xy = xy
  compile_opt idl2
  ; Evaluates a zernike polynomial on a list of 2D points

  ; Args:
  ; Points -> 2xN Array of points (in radial or cartesian coordinates) for the position on the surface
  ; Must be formatted as: [x,y] or [r,th]
  ; inoll -> Noll index of zernike term to evaluate

  ; Get indices, useful #'s based on them
  ns = NOLL_SEQUENCE(inoll)
  m = ns[0, inoll - 1]
  n = ns[1, inoll - 1]
  mm = abs(m)
  nm = (n - mm) / 2
  mn = (n + mm) / 2

  ; Check for invalid n,m
  on_error, 2
  if (((n - mm) mod 2) ne 0) then message, 'Illegal value for N or M', /noname

  ; Get column vectors
  if keyword_set(xy) then begin
    r = sqrt(points[0, *] ^ 2 + points[1, *] ^ 2)
    th = atan(points[1, *], points[0, *])
  endif else begin
    r = points[0, *]
    th = points[1, *]
  endelse

  ; normalize to largest radius
  r /= max(r)

  ; init output vector
  rad = dblarr(1, n_elements(r))

  ; Radial Polynomial
  for k = 0, nm do begin
    rad = rad + (-1) ^ k * factorial(n - k) * r ^ (n - 2 * k) / $
      (factorial(k) * factorial(mn - k) * factorial(nm - k))
  endfor

  ; Normalization
  z = sqrt(n + 1.0) * rad
  if (m ne 0) then z = z * sqrt(2.0d)

  ; Angular component
  if (m ge 0) then z = z * cos(mm * th) else z = z * sin(mm * th)

  return, z
end
