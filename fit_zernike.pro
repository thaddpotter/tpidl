function fit_zernike, points
  compile_opt idl2
  ; -------------------------------------------------------------
  ; Fits zernike polynomials to a list of 3-D points

  ; Args:
  ; points -> 3xN Array of points

  ; Returns:
  ; Coeff -> Vector containing coefficients of zernike functions
  ; -------------------------------------------------------------

  ; Fitting Parameters
  n_terms = 25 ; Number of zernike terms to fit

  ; Get column vectors, init zernike matrix
  x = double(points[0, *])
  y = double(points[1, *])
  z = transpose(double(points[2, *]))
  zern_mat = dblarr(n_terms, n_elements(x))

  ; Construct matrix of zernike values
  for k = 1, n_terms do begin
    zern_mat[k - 1, *] = tp_zernike([x, y], k, xy = 1)
  endfor

  ; Get singular values of zernike matrix
  svdc, zern_mat, w, u, v, /double

  ; Regularization
  ind = where(abs(w) le 1.0e-5)
  w[ind] = 0

  ; Solve for coefficients
  coeff = svsol(u, w, v, z, /double)

  return, coeff
end
