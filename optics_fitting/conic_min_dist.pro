function conic_dist, in
    ;Calculates square of distance between two points, one of which is located on a conic surface
    ;Arguments: In -> [x2,y2] X and Y Coordinates of the point on the parabola
    ;Returns: Squared distance between two points
    COMMON dist_opt,x1,y1,z1
    COMMON conic_opt,r,k

    x2 = in[0]
    y2 = in[1]

    return, (x1 - x2)^2 + (y1 -y2)^2 + (z1 - conic_z(x2,y2,r,k))^2
end

function conic_min_dist, point
    ;Calculates the minimum square distance from a point to a given conic surface

    ;Arguments:
    ;point -> Vector containing 3D coords [x,y,z]
    ;rad -> Radius of curvature (Must be >0)
    ;conic -> Conic Constant

    ;Returns:
    ;d -> minimized square distance

    ;Initialize and assign common block variables
    COMMON dist_opt, x,y,z

    x = DOUBLE(point[0])
    y = DOUBLE(point[1])
    z = DOUBLE(point[2])

    ;Setup
    guess = [1d,1d]  ;Initial Guess
    ftol = 1e-3    ;Fractional Tolerance
    xi = Identity(2) ;Starting Direction

    ;Minimize
    Powell, guess, xi, ftol, fmin, 'conic_dist', /DOUBLE

    return, fmin
end