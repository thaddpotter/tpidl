function angle_leak, input
    
    COMMON ang_leak, theta_target, psi_target
    
    ;Setup
    ampr = 1d * !dtor                               ;Roll amplitude

    misb = input(0) * (!dtor / 60d)                 ;Misalignment Angle (Arcminutes)

    ang = input(1) * !dtor                          ;Orientation of Misalignment (deg CCW from X)

    rvec = [COS(ang + !Pi/2), SIN(ang + !Pi/2), 0]  ;Rotation Vector

    ;Get PICC basis
    picc = axis_angle(IDENTITY(3), rvec, misb)

    ;Project WASP z onto PICC Frame
    picc_axis = picc ## [[0],[0],[1]]

    ;Roll about WASP Z in Picture Frame
    roll = axis_angle(Identity(3), picc_axis, ampr)

    ;Decompose
    theta = -asin(roll[0,2])
    psi = atan(roll[1,2]/cos(theta) , roll[2,2]/cos(theta))  

    theta = theta * (3600 / ampr) 
    psi = psi * (3600 / ampr)

    return, (theta - theta_target)^2 + (psi - psi_target)^2
end

pro angle_leak_calc

common ang_leak, theta_target, psi_target

theta_target = -3
psi_target = 1

ftol = 1e-7
p = [2d, 215d]
xi = Identity(2)

powell, p,xi, ftol, fmin, 'angle_leak', /DOUBLE

stop
end
