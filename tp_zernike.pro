function tp_zernike, points, inoll, xy=xy
;Evaluates a zernike polynomial on a list of 2D points

;Args:
;Points -> 2xN Array of points (in radial or cartesian coordinates) for the position on the surface
;Must be formatted as: [x,y] or [r,th]
;inoll -> Noll index of zernike term to evaluate

    ;Get indices, useful #'s based on them
    ns = NOLL_SEQUENCE(inoll)
    m  = ns[0,inoll-1]
    n  = ns[1,inoll-1]
    mm = ABS( m )
    nm = ( n - mm ) / 2
    mn = ( n + mm ) / 2

    ;Check for invalid n,m
    ON_ERROR, 2
    IF ( ( ( n - mm ) MOD 2 ) NE 0 ) THEN MESSAGE, 'Illegal value for N or M',/NONAME

    ;Get column vectors
    if keyword_set(xy) then begin
        r = SQRT(points[0,*]^2 + points[1,*]^2)
        th = ATAN(points[1,*],points[0,*])
    endif else begin
        r = points[0,*]
        th = points[1,*]
    endelse

    ;normalize to largest radius
    r /= MAX(r)

    ;init output vector
    rad = DBLARR(1,n_elements(r))

    ;Radial Polynomial
    for k = 0, nm do begin
        rad = rad + (-1)^k * FACTORIAL(n - k) * r^(n - 2*k) / $
            ( FACTORIAL(k) * FACTORIAL(mn - k) * FACTORIAL(nm - k) )
    endfor

    ;Normalization
    z = SQRT( n + 1.0 ) * rad
    if (m NE 0) then z = z * SQRT( 2.0D )

    ;Angular component
    if (m GE 0) then z = z * COS(mm * th) else z = z * SIN(mm * th)

    return, z
end