function ax_angle, axis, angle
  ; Creates a rotation matrix for some angle about some axis
  compile_opt idl2
  ; ANGLE MUST BE IN RADIANS
  a = double(angle)

  axis /= norm(axis, /double)
  x = axis[0]
  y = axis[1]
  z = axis[2]

  ; Make rotation matrices for axes
  return, double([[cos(a) + x ^ 2 * (1 - cos(a)), x * y * (1 - cos(a)) - z * sin(a), x * z * (1 - cos(a)) + y * sin(a)], $
    [x * y * (1 - cos(a)) + z * sin(a), cos(a) + y ^ 2 * (1 - cos(a)), y * z * (1 - cos(a)) - x * sin(a)], $
    [x * z * (1 - cos(a)) - y * sin(a), y * z * (1 - cos(a)) - x * sin(a), cos(a) + z ^ 2 * (1 - cos(a))]])
end