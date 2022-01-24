function conic_dist, in
    ;Calculates square of distance between two points, one of which is located on a conic surface
    ;Arguments: In -> [x2,y2] X and Y Coordinates of the point on the parabola
    ;Returns: Squared distance between two points
    COMMON dist_opt, x1,y1,z1,r,k
    x2 = in[0]
    y2 = in[1]

    return, (x1 - x2)^2 + (y1 -y2)^2 + (z1 - conic_z(x2,y2,r,k))^2
end

function gradxy, in
    ;Calculates the gradient of the square distance with respect to X and Y coordinates of the point on conic surface
    ;Arguments: In -> [x2,y2] X and Y Coordinates of the point on the parabola
    ;Returns: [gradx, grady] -> Partial derivatives with respect to x2, y2
    COMMON dist_opt, x1,y1,z1,r,k
    x2 = in[0]
    y2 = in[1]

    r2 = x2^2 + y2^2

    f1 = sqrt(r^2 - (1+k)*r2)

    f2 = (z1 - r2/( r + f1 )) / f1
    return, [-2 * (x1 + x2*(f2-1)), -2 * (y1 + y2*(f2-1))]
end

function calc_dist, point, rad, conic
    ;Calculates the minimum square distance from a point to a given conic surface

    ;Arguments:
    ;point -> Vector containing 3D coords [x,y,z]
    ;rad -> Radius of curvature (Must be >0)
    ;conic -> Conic Constant

    ;Returns:
    ;d -> minimized square distance

    ;Initialize and assign common block variables
    COMMON dist_opt, x,y,z,r,k

    x = DOUBLE(point[0])
    y = DOUBLE(point[1])
    z = DOUBLE(point[2])
    r = DOUBLE(rad)
    k = DOUBLE(conic)

    ;Setup
    guess = [1d,1d] ;Initial Guess
    gtol = 1e-7

    ;Minimize
    DFPMIN, guess, Gtol, fmin, 'conic_dist', 'gradxy'

    return, fmin
end