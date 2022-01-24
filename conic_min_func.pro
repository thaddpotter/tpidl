function conic_min_func, in
    ;Calculates the total square distance from a set of points to a rotated and displaced conic surface

    ;Import/initialize variables
    COMMON conic_opt,r,k,data
    
    angleX = in[0]
    angleZ = in[1]
    X = in[2]
    Y = in[3]
    Z = in[4]

    sz = size(data)

    ;Displace/Rotate points backwards to meet the conic
    tmp = rotate_displace(data,angleX,0.0,angleZ,[X,Y,Z],/INVERSE)

    ;Loop over datapoints, calculate total of square distances
    total = 0d
    for j = 0, sz[2]-1 do begin
        total += conic_min_dist(tmp[*,j])
    endfor

    return, total
end