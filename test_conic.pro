function total_dist, in
    ;Calculates the total square distance from a set of points to a conic surface

    ;Import/initialize variables
    COMMON opt_points, data
    r = in[0]
    k = in[1]

    sz = size(data)

    total = 0d

    ;Find square distance for each point and add to total distance
    for j = 0, sz[2]-1 do begin
        tmp = calc_dist(data[*,j],r,k)
        total += tmp
    endfor

    return, total
end

pro test_conic

    ;Create a list of x and y values for a grid (n x n)
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

    ;Get z height values (with a bit of noise)
    z = conic_z(x,y,50,0) + 0.1*RANDOMU(seed,n^2)

    ;Initialize common block
    COMMON opt_points, data
    data = [x,y,z]

    print, total_dist([50,1])
    print, total_dist([50,0])

    ;Setup
    ftol = 1e-4
    x = [1d,0d]
    xi = IDENTITY(2)

    POWELL, x, xi, ftol, fmin, 'total_dist'
    print, 'Least squared Distance: '+ ns2(fmin)
    print, 'ROC: ' +n2s(x[0])
    print, 'K: ' +n2s(x[1])

end