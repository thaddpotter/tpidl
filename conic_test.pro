pro conic_test

    ;Create a list of x and y values for a grid (n x n)

    oad = 16
    r = 12
    min = oad - r
    max =  oad + r

    n = 15.
    x = dblarr(1,n^2)
    y = x

    row = 0.
    for i = 0,n^2-1 do begin
        x[i] = (max-min) * (i MOD n)/(n-1) + min
        if ~(i eq 0) && ~(i MOD n) then row++
        y[i] = (max-min) * (row/(n-1)) + min
    endfor

    ;Initialize common block
    COMMON conic_opt, roc,k, data

    roc = 120.0
    k = -1.0
    noise = 0

    ;Get z height values
    z = conic_z(x,y,roc,k)
    z += (noise*max(z))*RANDOMU(seed,n^2)

    ;Concatenate coordinates, apply rotation and displacement
    data = rotate_displace([x,y,z],15,0,30,[1.278,-3.94,0.02])

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

    print, 'Rotation Angles: [' + n2s(vec[0]) + ',' + n2s(vec[1]) + ']'
    print, 'Vertex: [' + n2s(vec[2]) + ',' + n2s(vec[3]) + ',' + n2s(vec[4]) + ']'
    print, 'Total Distance: ' +n2s(d)


end