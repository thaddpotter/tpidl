function par_dist, i

common par_block, data
;--------------------------------------------------------------------------------------
;Least square distance of a group of points to an arbitrary parabola parameterized as the following:
;z - z0 = 1/r^2 * ((x-x0)^2 + (y-y0)^2), which is rotated by: u degrees about x and v degrees about y

;Relations for x2, y2 were derived using Wolfram Mathematica with the following commands, and further simplified by hand:
; Par[x_, y_, r_] = (x^2 + y^2)/r^2;
; R2[x1_, y1_, z1_, x2_, y2_, r_] = (x1 - x2)^2 + (y1 - y2)^2 + (z1 - Par[x2, y2, r])^2;
; s = NSolve[{D[R2full[x1, y1, z1, x2, y2, r], x2] == 0,
;	          D[R2full[x1, y1, z1, x2, y2, r], y2] == 0}, {x2, y2}];
; Simplify[s[[1]]]

;Args:
;i - Vector of paraboloid parameters: [x0,y0,z0,r,u,w]
    ;Vertex - (x0,y0,z0)
    ;Radial Coefficient - r
    ;Rotation Angles about x,z - u,w [RADIANS]
;data - 3xN matrix containing the coordinates of the test points

;Returns:
;optval - sum of square distances from points to parabola
;--------------------------------------------------------------------------------------

;Since parabola is displaced and then rotated, we have to undo it in the opposite order

;Rotation Matrices:
;Since parabola will be rotated x,z, we rotate the points -z,-x
;r1 = [[cos(i[5]),sin(i[5]),0],$ ; about -z
;        [-sin(i[5]),cos(i[5]),0],$
;        [0,0,1]]
;r2 = [[1,0,0],$ ;about -x
;        [0,cos(i[4]),sin(i[4])],$
;        [0,-sin(i[4]),cos(i[4])]]

;tmp = r2 # (r1 # data)

;Displacement of points, create column vectors:
x1 = data[0,*]; - i[0]
y1 = data[1,*]; - i[1]
z1 = data[2,*]; - i[2]

;Calculate value of a large repeating block in the expressions for x2 & y2
root = (sqrt(i[3]^6*x1^6*( (108*i[3]*(x1^2 + y1^2))^2 + 864*(x1^2 + y1^2)^3*(i[3]^2 - 2*z1)^3)) - 108*i[3]^4 * x1^3 * (x1^2 + y1^2))^(1./3)

;Get coordinates of the points on the parabola
x2 = -0.132283420997350 * root / (x1^2 + y1^2) + i[3]^2 * x1^2 *(1.259921049894873*i[3]^2 - 2.519842099789746*z1) / root

y2 = -0.132283420997350 * y1 * (root^2 - 9.52440631180920 * i[3]^2 * x1^2 * (x1^2 + y1^2)*(i[3]^2 - 2*z1) ) / $
    (x1 * (x1^2 + y1^2) * root)

z2 = (1/i[3]^2)*(x2^2 + y2^2)

;calculate distance
return, total((x2-x1)^2 + (y2-y1)^2 + (z2-z1)^2)

end