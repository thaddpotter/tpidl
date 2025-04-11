function convert_basis, points, coord_arr
  compile_opt idl2
  ; -------------------------------------------------------
  ; Projects a set of points onto a new set of basis vectors

  ; Inputs:
  ; points - 3xN Matrix containing a list of points as ROWS
  ; coord_arr - 3x3 Matrix containing the basis vectors as ROWS

  ; Outputs:
  ; Newpoints - 3xN Matrix containing the point in the new basis
  ; --------------------------------------------------------

  return, points ## transpose(coord_arr)
end
