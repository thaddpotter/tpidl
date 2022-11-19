function axis_angle, input, axis, angle
    ;------------------------------------------------------------------------------
    ;Rotates a set of points about some vector in 3 Space:

    ;Arguments:
    ;input - 3 x N Array of Coordinates to be rotated and displaced (each point is a row)
    ;axis - 3 Vector that will be the axis of rotation
    ;angle - Rotation angle

    ;Returns:
    ;N x 3 Array of Coordinates in the new frame
    ;------------------------------------------------------------------------------

    ;ANGLE MUST BE IN RADIANS
    a = DOUBLE(angle)
    x = axis[0]
    y = axis[1]
    z = axis[2]

    ;Make rotation matrices for axes
    Rfull = [[cos(a) + x^2*(1- cos(a)) , x*y*(1-cos(a)) - z*sin(a) , x*z*(1-cos(a)) + y*sin(a)], $
             [x*y*(1-cos(a)) + z*sin(a) , cos(a) + y^2*(1- cos(a)) , y*z*(1-cos(a)) - x*sin(a) ], $
             [x*z*(1-cos(a)) - y*sin(a) , y*z*(1-cos(a)) - x*sin(a) , cos(a) + z^2*(1- cos(a))] ]

    ;Forward Operation
    return, Rfull # input
end