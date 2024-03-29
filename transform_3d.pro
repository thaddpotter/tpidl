function transform_3d, input, angle, disp, scale = scale, center = center, inverse = inverse, reg = reg
  compile_opt idl2
  ; ------------------------------------------------------------------------------
  ; Rotates and displaces a set of points according to the following equation:
  ; r2 = a * R # r1 + r0, where:
  ; r2 -> Output points
  ; a -> Scaling constant
  ; R -> Rotation Matrix (clockwise about x,y,z)
  ; r1 -> Input vector
  ; r0 -> Displacement vector

  ; Arguments:
  ; input - 3 x N Array of Coordinates to be rotated and displaced (each point is a row)
  ; angle - Rotation Angle Vector [Ax,Ay,Az]
  ; disp -   displacement vector [x,y,z]
  ; scale - scaling constant [Defaults to 1]
  ; center - Perform rotation about the another point [X,Y,Z]. Defaults to centroid of the point set.

  ; Keywords:
  ; inverse - Perform the inverse operation, undoing the original transformation:
  ; r2 = R^(-1)(r1 - r0)
  ; reg- If set, will round small elements (LE 1e-8) to zero in the output array

  ; Returns:
  ; N x 3 Array of Coordinates in the new frame
  ; ------------------------------------------------------------------------------

  if not keyword_set(scale) then scale = 1.0d

  ; Convert angles to radians
  a = double(angle[0]) * !dtor
  b = double(angle[1]) * !dtor
  c = double(angle[2]) * !dtor

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

  ; Make shift matrix for alternate rotation origin
  if keyword_set(center) then begin
    if n_elements(center) eq 3 then cent = center else $
      cent = [total(input[0, *]), total(input[1, *]), total(input[2, *])] / sz[2]
    shift = rebin(cent, 3, sz[2])
  endif

  ; Forward Operation
  if ~keyword_set(inverse) then begin
    Rfull = Rz # Ry # Rx

    if keyword_set(center) then $
      Rout = scale * (Rfull # (input - shift) + shift) + trans else $
      Rout = scale * (Rfull # input) + trans

    ; Inverse
  endif else begin
    Rfull = transpose(Rx) # transpose(Ry) # transpose(Rz)

    if keyword_set(center) then $
      Rout = Rfull # ((input - trans) / scale - shift) else $
      Rout = Rfull # (input - trans) / scale
  endelse

  ; Regularize
  if keyword_set(reg) then begin
    Rout[where(abs(Rout) le 1d-8, /null)] = 0
  endif

  return, Rout
end