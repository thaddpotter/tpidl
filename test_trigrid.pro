pro test_trigrid, time = time
  ; This function is made to test behaviour and evaluation times for TRIGRID at different numbers of input and output points
  compile_opt idl2
  n = 7
  n_init = [50, 500, 1600, 4800, 15000]

  ; Make 50 normal x, y points:
  x = randomn(seed, 50)
  y = randomn(seed, 50)
  ; Make the Gaussian:
  z = exp(-(x ^ 2 + y ^ 2))

  if (~keyword_set(time)) then begin
    ; Obtain triangulation:
    triangulate, x, y, tr, b

    j = trigrid(x, y, z, tr)

    stop
    ; Show points:
    iplot, x, y, sym_index = 1, linestyle = 6, $
      view_title = 'Random Points', view_grid = [3, 2], $
      dimensions = [1000, 800]

    ; Show linear surface:
    isurface, trigrid(x, y, z, tr), view_title = 'Linear Surface', $
      style = 1, /view_next
    ; Show smooth quintic surface:
    isurface, trigrid(x, y, z, tr, /quintic), $
      view_title = 'Quintic Surface', style = 1, /view_next
    ; Show smooth extrapolated surface:
    isurface, trigrid(x, y, z, tr, extra = b), $
      view_title = 'Extrapolated Surface', style = 1, /view_next
    ; Set output grid size to 12 x 24:
    isurface, trigrid(x, y, z, tr, nx = 12, ny = 24), $
      view_title = '12x24 Grid', style = 1, /view_next
    isetproperty, 'text*', font_size = 36
  endif else begin
    for j = 0, 4 do begin
      print, 'Running for: ' + n2s(n_init[j]) + ' Initial Points'
      ; Make 50 normal x, y points:
      x = randomn(seed, n_init[j])
      y = randomn(seed, n_init[j])
      ; Make the Gaussian:
      z = exp(-(x ^ 2 + y ^ 2))

      ; Obtain triangulation:
      tri = tic('Tri')
      triangulate, x, y, tr, b
      toc, tri

      npoints = intarr(n)
      for i = 0, n - 1 do begin
        npoints[i] = 5 ^ (i)
      endfor
      for i = 0, n - 1 do begin
        clock = tic(n2s(npoints[i]))
        out = trigrid(x, y, z, tr, extrapolate = b, nx = npoints[i], ny = npoints[i])
        toc, clock
      endfor
    endfor
  endelse
end