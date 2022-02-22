pro plot_const

;Set up ranges to sample over
t_env = 240d
t_obj = 300d
l = 0.1d
p = 101325d/760*400         ;Pascals

t_env_lim = [200d,280d]
t_obj_lim = [230d, 370d]
l_lim = [0.01d,1d]          ;Log Scale
p_lim = [300d,500d]           ;Torr

plotpath = '~/idl/tpidl/plots/'

;Set up sampling, arrays
n = 301

pt_arr = dindgen(n, start=p_lim[0], increment=(p_lim[1]-p_lim[0])/(n-1))                    ;Torr
p_arr = 101325d/760*pt_arr                                                                   ;Pascal
t_env_arr = dindgen(n, start=t_env_lim[0], increment=(t_env_lim[1]-t_env_lim[0])/(n-1))
t_obj_arr = dindgen(n, start=t_obj_lim[0], increment=(t_obj_lim[1]-t_obj_lim[0])/(n-1))
l_arr = dindgen(n, start=l_lim[0], increment=(l_lim[1]-l_lim[0])/(n-1))

;Plot H vs Pressure
plotfile='h_vs_pressure.eps'
mkeps,name= plotpath + plotfile

h = conv_const(p_arr, t_obj, t_env, l,/quiet)

plot,pt_arr,h,position=[0.12,0.12,0.84,0.94],yrange=minmax(h),/xs,/ys,xtitle='Pressure (Torr)',ytitle='H_conv (W m^-2 K^-1)',title='Convective Cooling vs Pressure'


mkeps,/close
print,'Wrote: '+plotpath+plotfile

;Plot H vs Object Temp
plotfile='h_vs_object.eps'
mkeps,name= plotpath + plotfile

h = conv_const(p, t_obj_arr, t_env, l,/quiet)

plot,t_obj_arr,h,position=[0.12,0.12,0.84,0.94],yrange=minmax(h),/xs,/ys,xtitle='Object Temp (K)',ytitle='H_conv (W m^-2 K^-1)',title='Convective Cooling vs Object Temp'

mkeps,/close
print,'Wrote: '+plotpath+plotfile

;Plot H vs Environment Temperature
plotfile='h_vs_enviro.eps'
mkeps,name= plotpath + plotfile

h = conv_const(p, t_obj, t_env_arr, l,/quiet)

plot,t_env_arr,h,position=[0.12,0.12,0.84,0.94],yrange=minmax(h),/xs,/ys,xtitle='Environment Temp (K)',ytitle='H_conv (W m^-2 K^-1)',title='Convective Cooling vs Environment Temp'

mkeps,/close
print,'Wrote: '+plotpath+plotfile

;Plot H vs Length
plotfile='h_vs_length.eps'
mkeps,name= plotpath + plotfile

h = conv_const(p, t_obj, t_env, l_arr,/quiet)

plot_oi,l_arr,h,position=[0.12,0.12,0.84,0.94],yrange=[0,6],/xs,/ys,xtitle='Scale Length (m)',ytitle='H_conv (W m^-2 K^-1)',title='Convective Cooling vs Scale Length'

mkeps,/close
print,'Wrote: '+plotpath+plotfile

end