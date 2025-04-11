; **********************************************************************
;
; Name:          find_tri.pro
;
; Author:        Tim Cook
;
; History:       Written 5/18/17
;
; Function:      Given a triangular tesselation (e.g. from
; the triangulate routine) find the first triangle
; containing point pt
;
; INPUTS:        pt 2 element vector containg the X,Y position
; x X values corresponding to the triangle vertices
; y Y values corresponding to the triangle vertices
; tr triangle vertices
;
; RETURN:        Number (in tr list) if triangle containing pt
;
; SYNTAX:        triangle_number=find_tri(pt,x,y,tr)
;
; **********************************************************************

function find_tri, pt, x, y, tr
  compile_opt idl2
  sz = size(tr)
  index = indgen(3)
  for i = 0, sz[2] - 1 do begin
    dx = pt[0] - x[tr[*, i]]
    dy = pt[1] - y[tr[*, i]]
    ind = where((dx eq 0) and (dy eq 0), cnt)
    if cnt gt 0 then return, i ; if we hit a vertex, return it
    angles = atan(dx, dy)
    rangles = abs(angles[index] - angles[shift(index, -1)])
    ind = where(rangles gt !dpi, cnt)
    if cnt gt 0 then rangles[ind] = 2 * !dpi - rangles[ind]
    if total(rangles) eq (2. * !dpi) then return, i
  endfor
  return, -1
end