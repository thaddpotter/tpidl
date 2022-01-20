function conic_z, x,y,r,k
    ;X -> X value
    ;Y -> Y value
    ;r -> Radius of Curvature
    ;k -> Conic Constant (-e^2)
    ;Returns z: values of a conic section with given radius of curvature and conic constant
    return, (x^2 + y^2) / ( r + sqrt( r^2 - (k+1)*(x^2 + y^2) ) )
end