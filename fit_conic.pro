function fit_conic, data
;Initialize common block
    COMMON conic_opt, roc,k, fitpoints

    roc = 120.0
    k = -1.0
    fitpoints = data

    vec = [0.0,0.0,0.0,0.0,0.0]                 ;Initial guess (Angles need to be within ~90 Deg)

    xbnd = transpose([[-180.0,180.0],$          ;Variable bounds [Ax,Az,X,Y,Z]
                      [-180.0,180.0],$
                      [-5.0,5.0],$
                      [-5.0,5.0],$
                      [-5.0,5.0]])

    gbnd = [0.0,0.0]                            ;Function bounds (objective function unbound)
    nobj = 0                                    ;Index of objective function
    epstop = 1e-10                              ;Convergence Criteria
    nstop = 10

    CONSTRAINED_MIN, vec, xbnd, gbnd, nobj, 'conic_min_func', inform,EPSTOP=epstop, NSTOP=nstop

    d = conic_min_func(vec)

    return, [vec,d]
end