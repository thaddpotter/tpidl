function transform_opt, params
  compile_opt idl2
  ; ------------------------------------------------------------------------------
  ; Optimization function for calculating 3D transformation between 2 frames
  ; Performs rotation and displacement from input, and compares to output
  ; Uses sum of square distances as the minimizer
  ; For exact details on functions, see transform_3D.pro
  ; (Uses /center)

  ; Takes length 6 input vector: [Ax,Ay,Az, Dx,Dy,Dz]
  ; ------------------------------------------------------------------------------

  ; Variable import/setup
  common transform_opt, input, output
  angle = double(params[0 : 2])
  disp = double(params[3 : 5])

  ; Convert angles to radians
  a = angle[0] * !dtor
  b = angle[1] * !dtor
  c = angle[2] * !dtor

  ; Make rotation matrices for axes
  Rx = [[1, 0, 0], $
    [0, cos(a), -sin(a)], $
    [0, sin(a), cos(a)]]

  Ry = [[cos(b), 0, sin(b)], $
    [0, 1, 0], $
    [-sin(b), 0, cos(b)]]

  Rz = [[cos(c), -sin(c), 0], $
    [sin(c), cos(c), 0], $
    [0, 0, 1]]

  ; Make translation matrix
  sz = size(input)
  trans = rebin(disp, 3, sz[2])

  ; Find centroid, make centering matrix
  cent = [total(input[0, *]), total(input[1, *]), total(input[2, *])] / sz[2]
  shift = rebin(cent, 3, sz[2])

  ; Do forwards transform
  Rfull = Rz # Ry # Rx
  Rout = (Rfull # (input - shift) + shift) + trans

  ; Calculate sum of square distances
  return, total((Rout - output) ^ 2)
end

function fit_transform, r1, r2, guess = guess
  compile_opt idl2
  ; -------------------------------------------------------------------------
  ; Minimizing function for calculating coordinate transforms
  ; -------------------------------------------------------------------------

  ; Initialize common block
  common transform_opt, input, output
  input = r1
  output = r2

  ; Minimization Settings
  ftol = 1e-8 ; Fractional Tolerance
  if ~keyword_set(guess) then $
    guess = [0.0d, 0.0d, 0.0d, 0.0d, 0.0d, 0.0d] ; Initial Guess
  xi = identity(6) ; Starting Direction Vector

  ; Solve
  powell, guess, xi, ftol, fmin, 'transform_opt', /double

  return, [guess, fmin]
end