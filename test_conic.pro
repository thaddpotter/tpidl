function fit_conic,data

    ;Fits a circular paraboloid to a set of 3-D points

    ;-----------------------------------------------------------------------
    ;Parabola Parameterization: 6 DOF
        ;Vertex - (x0,y0,z0)
        ;Radial Coefficient - r
        ;Rotation Angles about x,z - u,w
    ;NOTE: Displacement is applied to the parabola, then is rotated about x, then about z

    ;Args:
        ;data - 3xN matrix containing the coordinates of the points to fit to

    ;Returns
        ;out - vector of parabola parameters [x0,y0,z0,r,u,w]
    ;-----------------------------------------------------------------------

    ;Get initial guess
    p = dblarr(1)
    p = 1
    ;p[0] = [0,0,0]              ;Vertex
    ;p[3] = [0.1]                ;Radial
    ;p[4] = [0,0]                ;Rotation Angles

    xi = IDENTITY(1)            ;Initial Guess Vector
    ftol = 1.0e-8               ;Tolerance

    powell, p, xi, ftol, fmin, 'par_dist',itmax=1000 

    print, p
    print, fmin
    
    return, p
end

function paraboloid, x,y,r
    return, (1/r^2)*(x^2 + y^2)
end

pro test_conic

    common par_block, testdata
    ;Create a list of x and y values (n x n)
    n = 11.
    min = -10.
    max = 10.
    x = dblarr(1,n^2)
    y = x

    row = 0.
    for i = 0,n^2-1 do begin
        x[i] = (max-min) * (i MOD n)/(n-1) + min
        if ~(i eq 0) && ~(i MOD n) then row++
        y[i] = (max-min) * (row/(n-1)) + min
    endfor

    ;Input Parameters
    x0 = 1.
    y0 = 2.
    z0 = 3.
    r = 5.

    z = paraboloid(x,y,r)

    testdata = [x,y,z]

    sol = fit_conic(testdata)

end