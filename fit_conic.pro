function fit_conic, data, roc, conic, guess=guess

;Fits a displaced and rotated conic surface to a set of points

;Args:
;data -> 3 x N Array contiaining data to be fit to (Points are rows)
;roc -> Radius of curvature of conic surface to fit
;conic -> Conic constant of surface to fit
;guess -> 5 element vector containing initial guess. Zero if not given
;   [Ax, Az, X, Y, Z], where:
;   Ai - Rotation angles about corresponding axis
;   X,Y,Z - Displacement

;Returns:
;Vector of guess and residual square distances
;   [Ax, Az, X, Y, Z, Res], where:
;   Res - Residual square distance

;Initialize common block
    COMMON conic_opt, r,k, fitpoints

    r = roc
    k = conic
    fitpoints = data

    if not keyword_set(guess) then guess = [0d,0d,0d,0d,0d]       ;Initial guess (Angles need to be within ~90 Deg)

    xbnd = transpose([[-180.0,180.0],$                          ;Variable bounds [Ax,Az,X,Y,Z]
                      [-180.0,180.0],$
                      [-5.0,5.0],$
                      [-5.0,5.0],$
                      [-5.0,5.0]])

    gbnd = [0.0,0.0]                            ;Function bounds (objective function unbound)
    nobj = 0                                    ;Index of objective function
    epstop = 1e-10                              ;Convergence Criteria
    nstop = 10

    CONSTRAINED_MIN, guess, xbnd, gbnd, nobj, 'conic_min_func', inform,EPSTOP=epstop, NSTOP=nstop

    d = conic_min_func(guess)

    return, [guess,d]
end