function rotate_displace, input, angleX, angleY, angleZ, disp, inverse=inverse
    ;------------------------------------------------------------------------------
    ;Rotates and displaces a set of points according to the following equation:
    ;r2 = R # r1 + r0, where:
    ;r2 -> Output point
    ;R -> Rotation Matrix (clockwise about x,y,z)
    ;r1 -> Input vector
    ;r0 -> Displacement vector

    ;Arguments:
    ;input - N x 3 Array of Coordinates to be rotated and displaced (each point is a column vector)
    ;angleX - rotation angle about x (Degrees)
    ;angleY - rotation angle about y (Degrees)
    ;angleZ - rotation angle about z (Degrees)
    ;disp -   displacement vector [x,y,z]

    ;Keywords:
    ;/inverse - Performs the inverse operation, undoing the original transformation:
    ;r2 = R^(-1)(r1 - r0)

    ;Returns:
    ;N x 3 Array of Coordinates in the new frame
    ;------------------------------------------------------------------------------

    ;Convert to radians
    phi = angleX * !DTOR
    theta = angleY * !DTOR
    psi = angleZ * !DTOR

    ;Make rotation matrices for axes
    Rx = [[1,     0,      0],$
          [0,cos(a),-sin(a)],$
          [0,sin(a), cos(a)]]

    Ry = [[cos(b) , 0, sin(b)],$
          [0      , 1,      0],$
          [-sin(b), 0, cos(b)]]

    Rz = [[cos(c), -sin(c), 0],$
          [sin(c), cos(c) , 0],$
          [0     , 0      , 1]]

    ;Make shift matrix
    sz = size(input)
    shift = rebin(reform(disp,1,3),sz[1],3)

    ;Forward Operation
    if ~keyword_set(inverse) then begin
        Rfull = Rz # Ry # Rx
        return, (Rfull # input) + shift

    ;Reverse
    endif else begin
        Rfull = transpose(Rx) # transpose(Ry) # transpose(Rz)
        return, Rfull # (input - shift)
    endelse
end