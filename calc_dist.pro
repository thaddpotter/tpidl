function conic_dist, in
    ;Returns the squared distance between two points, one of which is located on a conic surface
    ;Arguments:

    COMMON dist_opt, x1,y1,z1,r,k
    x2 = in[0]
    y2 = in[1]

    return, (x1 - x2)^2 + (y1 -y2)^2 + (z1 - conic_z(x2,y2,r,k))^2
end

function gradxy, in
    ;Returns the partial derivatives of the square distance with respect to x2, y2
    ;Arguments
    ;
    COMMON dist_opt, x1,y1,z1,r,k
    x2 = in[0]
    y2 = in[1]

    fact = (z1 - (x2^2 + y2^2)/( r + sqrt(r^2 - (1+k)*(x2^2+y2^2)) )) / sqrt(r^2 - (1+k)*(x2^2+y2^2))
    return, [-2 * (x1 + x2*(fact-1)), -2 * (y1 + y2*(fact-1))]
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