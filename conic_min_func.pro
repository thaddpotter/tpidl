function conic_min_func, in
    ;Calculates the total square distance from a set of points to a conic surface

    ;Import/initialize variables
    COMMON opt_points, data
    r = in[0]
    k = in[1]

    sz = size(data)

    total = 0d

    for j = 0, sz[2]-1 do begin
        total += conic_min_dist(data[*,j],r,k)   ;Find square distance for each point, Add to total distance
    endfor

    return, total
end