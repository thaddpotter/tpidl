function zernike_name, noll_index
  compile_opt idl2

  ; ;Zernike Names
  namezern = strarr(24)

  namezern[0] = 'Piston'
  namezern[1] = 'Tilt X'
  namezern[2] = 'Tilt Y'
  namezern[3] = 'Power'
  namezern[4] = 'Astig 1'
  namezern[5] = 'Astig 2'
  namezern[6] = 'Coma 1'
  namezern[7] = 'Coma 2'
  namezern[8] = 'Trefoil 1'
  namezern[9] = 'Trefoil 2'
  namezern[10] = 'Spherical'
  namezern[11] = '2nd Astig 1'
  namezern[12] = '2nd Astig 2'
  namezern[13] = 'Tetrafoil 1'
  namezern[14] = 'Tetrafoil 2'
  namezern[15] = '2nd Coma 1'
  namezern[16] = '2nd Coma 2'
  namezern[17] = '2nd Trefoil 1'
  namezern[18] = '2nd Trefoil 2'
  namezern[19] = 'Pentafoil 1'
  namezern[20] = 'Pentafoil 2'
  namezern[21] = '2nd Spherical'
  namezern[22] = '3rd Astig 1'
  namezern[23] = '3rd Astig 2'

  return, namezern[noll_index - 1]
end
