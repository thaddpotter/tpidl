function conic_z, x, y, r, k
  compile_opt idl2
  ; X -> X value
  ; Y -> Y value
  ; r -> Radius of Curvature
  ; k -> Conic Constant (-e^2)
  ; Returns z: values of a conic section with given radius of curvature and conic constant
  r2 = (x ^ 2 + y ^ 2)

  return, r2 / (r + sqrt(r * r - (k + 1) * r2))
end