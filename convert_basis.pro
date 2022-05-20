function convert_basis, coord_arr, points
;-------------------------------------------------------
;Projects a set of points onto a new set of basis vectors

;Inputs:
;coord_arr - 3x3 Matrix containing the basis vectors as ROWS
;points - 3xN Matrix containing a list of points as ROWS

;Outputs:
;Newpoints - 3xN Matrix containing the point in the new basis
;--------------------------------------------------------

;Get array length, create output
sz = size(points)
newpoints = dblarr(sz[1],sz[2])

;Loop over elements, do dot products
for j = 0, 2 do begin
    for i = 0, sz[2] - 1 do begin
        newpoints[j,i] = total(coord_arr[*,j] * points[*,i])
    endfor
endfor

return, newpoints
end