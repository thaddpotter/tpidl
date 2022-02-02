function fit_conic, data,guess=guess

;Fits a displaced and rotated conic surface to a set of points

;Args:
;data - 3 x N Array contiaining data to be fit to (Points are rows)
;guess - 5 element vector containing initial guess. Zero if not given

;Initialize common block
    COMMON conic_opt, roc,k, fitpoints

    roc = 120.0
    k = -1.0
    fitpoints = data

    if not keyword_set(guess) then guess = [0.0,0.0,0.0,0.0,0.0]       ;Initial guess (Angles need to be within ~90 Deg)

    xbnd = transpose([[-180.0,180.0],$                          ;Variable bounds [Ax,Az,X,Y,Z]
                      [-180.0,180.0],$
                      [-5.0,5.0],$
                      [-5.0,5.0],$
                      [-5.0,5.0]])

    gbnd = [0.0,0.0]                            ;Function bounds (objective function unbound)
    nobj = 0                                    ;Index of objective function
    epstop = 1e-12                              ;Convergence Criteria
    nstop = 15

    CONSTRAINED_MIN, guess, xbnd, gbnd, nobj, 'conic_min_func', inform,EPSTOP=epstop, NSTOP=nstop

    d = conic_min_func(guess)

    return, [guess,d]
end