function total_dist, in
    ;Calculates the total square distance from a set of points to a conic surface

    ;Import/initialize variables
    COMMON opt_points, data
    r = in[0]
    k = in[1]

    sz = size(data)

    total = 0d

    for j = 0, sz[2]-1 do begin
        total += calc_dist(data[*,j],r,k)   ;Find square distance for each point, Add to total distance
    endfor

    return, total
end

pro test_conic
    ;Create a list of x and y values for a grid (n x n)
    n = 10.
    min = -15.
    max = -10.
    x = dblarr(1,n^2)
    y = x

    row = 0.
    for i = 0,n^2-1 do begin
        x[i] = (max-min) * (i MOD n)/(n-1) + min
        if ~(i eq 0) && ~(i MOD n) then row++
        y[i] = (max-min) * (row/(n-1)) + min
    endfor

    ;Get z height values (with some noise)
    z = conic_z(x,y,50.0,-1.0)+0.01*RANDOMU(seed,n^2)

    ;Initialize common block
    COMMON opt_points, data
    data = [x,y,z]

    ;Setup
    vec = [80.0,0.0]                      ;Initial guess
    xbnd = [[0.0 ,-5.0], $              ;Limits on R, K:
            [1e30, 5.0]]                ;R > 0, -5 < K < 5     
            
    gbnd = [0.0,0.0]                    ;Unbounded objective function
    nobj = 0                            ;Index of objective function
    epstop = 1e-5                       ;Convergence Criteria
    report = '/home/thad/idl/tpidl/report.txt'
    
    ;Check Validity of guess
    g = conic_z(x,y,vec[0],vec[1])  
    chk = where(FINITE(g,/NAN) , count)
    if count NE 0 then begin
        print, 'Coordinates for conic outside of defined range: Radial Coordinate Larger than ROC!'
        stop
    endif

    CONSTRAINED_MIN, vec, xbnd, gbnd, nobj, 'total_dist', inform,EPSTOP=epstop ;,REPORT=report

    d = total_dist(vec)

    print, 'ROC: ' +n2s(vec[0])
    print, 'Conic: ' +n2s(vec[1])
    print, 'Total Distance: ' +n2s(d)

    if inform NE 0 then begin
        print, 'Error in CONSTRAINED_MIN'
        print, 'Error Code: ' +n2s(inform)
    endif

end