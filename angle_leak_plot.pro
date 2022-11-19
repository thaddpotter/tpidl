pro leak_angle_plot

;Setup
n = 1000                                         ;Sample Points for Error
m = 4                                           ;Angle Points
ampr = 5d * !dtor                               ;Roll amplitude

mis = 2d * dindgen(n,start=1)/(n)              ;Max Misalignment Angle (Arcminutes)
misb = mis * (!dtor / 60d) 

ang = !Pi * dindgen(m)/(m)                      ;Orientation of Misalignment (CW from X)

theta = dblarr(n,m)                             ;Angle Arrays
psi = theta
phi = theta

;Plot settings for stripcharts
xstart = 0.1
xend   = 0.99
yspace = 0.94
ybuf   = 0.05

;Loop over orientation
for j = 0,m-1 do begin

    rvec = [COS(ang[j] - !Pi/2), SIN(ang[j] - !Pi/2), 0]  ;Rotation Vector

    ;Loop over magnitude
    for i = 0, n-1 do begin
        ;Get PICC basis
        picc = axis_angle(IDENTITY(3), rvec, misb[i])

        ;Project WASP z onto PICC basis
        picc_axis = picc ## [[0],[0],[1]]

        ;Perform Rotation
        roll = axis_angle(Identity(3), picc_axis, ampr)

        ;Decompose
        theta[i,j] = -asin(roll[0,2])
        psi[i,j] = atan(roll[1,2]/cos(theta[i,j]) , roll[2,2]/cos(theta[i,j]))  
    endfor
endfor

theta = theta * (3600 / ampr) 
psi = psi * (3600 / ampr)

;Make Stripcharts
for j = 0,1 do begin

    if j EQ 0 then plotfile = 'plots/pointerr_lin.eps' else plotfile = 'plots/pointerr_log.eps'

    mkeps,name= plotfile
    !P.Multi = [0, 1, m]
    dy = yspace / m

    color=bytscl([1,2],top=254)
    loadct,39

    for i=0,m-1 do begin
        ystart = 1 - (i+1) * dy
        yend   = ystart + dy - ybuf
        position = [xstart,ystart,xend,yend]
        xtickname = replicate(' ',10)
        if i eq m-1 then xtickname=''
        xtitle=''
        ytitle=''
        if i eq m/2 then ytitle = '                                   Pointing Error (Arcseconds per degree Roll)'
        if i eq m-1 then xtitle='Boresight Misalignment (arcminutes)'

        if j EQ 0 then $
        plot,mis,abs(theta[*,i]),title='Theta = ' + n2s(round(ang[i]/!dtor)),charthick=2,xthick=2,ythick=2,yminor=1,ytitle=ytitle,$
            position=position,xtickname=xtickname,xtitle=xtitle,/xs,color=color[0],yrange=minmax(abs([theta[1:*,i],psi[1:*,i]])) else $
        plot,mis,abs(theta[*,i]),title='Theta = ' + n2s(round(ang[i]/!dtor)),charthick=2,xthick=2,ythick=2,yminor=1,ytitle=ytitle,/ylog, $
            position=position,xtickname=xtickname,xtitle=xtitle,/xs,color=color[0],yrange=minmax(abs([theta[1:*,i],psi[1:*,i]]))
        oplot,mis,abs(psi[*,i]),color=color[1]
    endfor

    cbmlegend,['Yaw','Pitch'],intarr(2),color,[0.845,0.99],linsize=0.5
    mkeps,/close
    !P.Multi = 0
endfor



;a = surface(theta,mis,ang,RGB_Table=colortable(39))
;cb = COLORBAR(TITLE='Fractional Error')


stop
end


