function fit_zernike, points
;-------------------------------------------------------------
;Fits zernike polynomials to a list of 3-D points

;Args:
;points -> 3xN Array of points

;Returns:
;Coeff -> Vector containing coefficients of zernike functions
;-------------------------------------------------------------

    ;Fitting Parameters
    n_terms = 25                       ;Number of zernike terms to fit

    ;Get column vectors, init zernike matrix
    x = DOUBLE(points[0,*])
    y = DOUBLE(points[1,*])
    z = TRANSPOSE(DOUBLE(points[2,*]))
    zern_mat = dblarr(n_terms,n_elements(x))

    ;Construct matrix of zernike values
    for k = 1,n_terms do begin
        zern_mat[k-1,*] = tp_zernike( [x,y], k, xy=1)
    endfor

    ;Get singular values of zernike matrix
    SVDC, zern_mat, w, u, v, /DOUBLE 

    ;Solve for coefficients
    coeff = svsol(u, w, v, z, /DOUBLE)

    return, coeff
end