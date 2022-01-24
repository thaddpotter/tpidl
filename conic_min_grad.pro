function conic_min_grad, in
    ;Calculates the gradient of total square distance from a set of points to a rotated and displaced conic surface
    ;Uses the forward difference approximation

    dA = 0.001      ;Epsilon for angles (Deg)
    dX = 0.0001     ;Epsilon for displacement (U)

    ;Import/initialize variables
    COMMON conic_opt,r,k,data
    
    angleX = in[0]
    angleZ = in[1]
    X = in[2]
    Y = in[3]
    Z = in[4]

    sz = size(data)
    grad = fltarr(5)

    ;Displace/Rotate points backwards to meet the conic
    tmp = rotate_displace(data,angleX,0.0,angleZ,[X,Y,Z],/INVERSE)

    ;---Initial Point------------------------------
    origin = 0d
    for j = 0, sz[2]-1 do begin
        origin += conic_min_dist(tmp[*,j])
    endfor

    ;---X------------------------------------------
    total = 0d
    tmp[0,*] += dX
    for j = 0, sz[2]-1 do begin
        total += conic_min_dist(tmp[*,j])
    endfor
    grad[2] = (total-origin)/dX
    tmp[0,*] -= dX

    ;---Y------------------------------------------
    total = 0d
    tmp[1,*] += dX
    for j = 0, sz[2]-1 do begin
        total += conic_min_dist(tmp[*,j])
    endfor
    grad[3] = (total-origin)/dX
    tmp[1,*] -= dX

    ;---Z------------------------------------------
    total = 0d
    tmp[2,*] += dX
    for j = 0, sz[2]-1 do begin
        total += conic_min_dist(tmp[*,j])
    endfor
    grad[4] = (total-origin)/dX
    tmp[2,*] -= dX

    ;---AngleX-------------------------------------
    tmp = rotate_displace(data,angleX+dA,0.0,angleZ,[X,Y,Z],/INVERSE)
    total = 0d
    for j = 0, sz[2]-1 do begin
        total += conic_min_dist(tmp[*,j])
    endfor
    grad[0] = (total-origin)/dA

    ;---AngleZ-------------------------------------
    tmp = rotate_displace(data,angleX,0.0,angleZ+dA,[X,Y,Z],/INVERSE)
    total = 0d
    for j = 0, sz[2]-1 do begin
        total += conic_min_dist(tmp[*,j])
    endfor
    grad[1] = (total-origin)/dA

    return, grad
end