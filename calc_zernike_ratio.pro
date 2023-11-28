pro calc_zernike_ratio
  compile_opt idl2
  ; Returns 0 if both Astig and Coma are zero
  ; Returns nan if only astig is 0

  ; Some approximations:
  ; Field angle is small, so y2 is constant

  ; Mirror Params
  R1 = 120 * 0.0254d
  R2 = 20 * 0.0254d
  K1 = -1d
  K2 = -0.422335d

  y1 = 0.0254d * [27.75, 16, 4.25]
  y2 = 0.0254d * [-6.126, -3.384, -0.642]

  ; Field Angle
  theta = [-1, 0, 1] / 360d

  ; M2 Displacements
  a = 0.06d ; Angle between axes
  l = 0 ; Shift of parent perpendicular to Opt Axis

  for j = 0, n_elements(theta) - 1 do begin
    ; Telescope Parameters
    k = y2 / y1
    w = -R1 / 2d * (1d - k)
    m = (R2 / R1) / ((R2 / R1) - k)

    ; Common Factors
    mfac = (m + 1) / (m - 1)
    afac = a + l / R2

    ; Coma
    B220 = -(w * theta[j] / (R2 ^ 2)) * (K2 / R2 + mfac * (1 / w - 1 / R2))
    B221 = (l / R2 * (K2 - mfac) - (a * mfac)) / R2 ^ 2

    ; Astig
    B120 = -(w * theta[j]) ^ 2 / R2 * ((K2 / R2 ^ 2) + (1 / w - 1 / R2) ^ 2)
    B121 = -(afac ^ 2 + 2 * theta[j] * afac + (K2 * l / R2) * $
      (l / R2 - (2 * w * theta[j]) / R2)) / R2

    init = B220 / B120
    sel = where((B220 eq 0) and (B120 eq 0))
    init[sel] = 0

    final = (B220 + B221) / (B120 + B121)

    print, 'Coma/Astig for Field of ' + n2s(theta[j]) + ' Degrees:   Initial | Final'
    print, 'Marginal Ray 1: ' + n2s(init[0]) + ' | ' + n2s(final[0])
    print, 'Chief Ray:' + n2s(init[1]) + ' | ' + n2s(final[1])
    print, 'Marginal Ray 2: ' + n2s(init[2]) + ' | ' + n2s(final[2])
    print, ''
  endfor

  stop
end