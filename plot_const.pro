pro plot_const, total=total

;--Set up sampling, ranges for values-----------------------------------------------
n = 301d
e = 2.7182818284590452d

;Central Values
t_env = 240d
t_obj = 300d
l = 1d
p = 101325d/760*4         ;Pascals

;Ranges
t_env_lim = [200d,260d]
t_obj_lim = [250d, 350d]
l_lim = [0.01d,1d]         ;Log Scale
p_lim = [1d,20d]           ;Torr
p_lim_log = [4d,760d]

plotpath = '~/idl/tpidl/plots/'
check_and_mkdir, plotpath

;--Set up sampling, arrays-----------------------------------------------------
pt_arr = dindgen(n, start=p_lim[0], increment=(p_lim[1]-p_lim[0])/(n-1))                    ;Torr
p_arr = 101325d/760*pt_arr                                                                  ;Pascal

t_env_arr = dindgen(n, start=t_env_lim[0], increment=(t_env_lim[1]-t_env_lim[0])/(n-1))
t_obj_arr = dindgen(n, start=t_obj_lim[0], increment=(t_obj_lim[1]-t_obj_lim[0])/(n-1))

exp_arr = dblarr(n)
for i = 0,n-1 do begin
    exp_arr[i] = exp( i/(n-1) ) - 1d ;Exponential Sampling from 0 to e-1
endfor

l_arr = (l_lim[1]-l_lim[0])/(e-1) * exp_arr + l_lim[0]

pt_log_arr = (p_lim_log[1]-p_lim_log[0])/(e-1) * exp_arr + p_lim_log[0]                     ;Torr
p_log_arr = 101325d/760*pt_log_arr                                                          ;Log Pascal

;--Plot H vs Pressure on Log Scale-----------------------------------------------------------
plotfile='h_vs_full_pressure.eps'
mkeps,name= plotpath + plotfile

h = conv_const(p_log_arr, t_obj, t_env, l,/quiet) * (t_obj-t_env)
plot_oi,pt_log_arr,h,position=[0.12,0.12,0.84,0.94],xrange=[760,4],yrange=minmax(h),/xs,/ys,xtitle='Pressure (mmHg)',ytitle='Convective Cooling (W m^-2)'

mkeps,/close
print,'Wrote: '+plotpath+plotfile

;--Plot H vs Pressure-----------------------------------------------------------
plotfile='h_vs_pressure.eps'
mkeps,name= plotpath + plotfile

h = conv_const(p_arr, t_obj, t_env, l,/quiet)
plot,pt_arr,h,position=[0.12,0.12,0.84,0.94],yrange=minmax(h),/xs,/ys,xtitle='Pressure (Torr)',ytitle='H_conv (W m^-2 K^-1)',title='Hconv vs P (dT = 60 K)'

mkeps,/close
print,'Wrote: '+plotpath+plotfile

;--Plot H vs Object Temp---------------------------------------------------------
plotfile='h_vs_object.eps'
mkeps,name= plotpath + plotfile

h = conv_const(p, t_obj_arr, t_env, l,/quiet)
plot,t_obj_arr,h,position=[0.12,0.12,0.84,0.94],yrange=minmax(h),/xs,/ys,xtitle='Object Temp (K)',ytitle='H_conv (W m^-2 K^-1)',title='Hconv vs To (Te = 240 K)'

mkeps,/close
print,'Wrote: '+plotpath+plotfile

;--Plot H vs Environment Temperature---------------------------------------------
plotfile='h_vs_enviro.eps'
mkeps,name= plotpath + plotfile

h = conv_const(p, t_obj, t_env_arr, l,/quiet)
plot,t_env_arr,h,position=[0.12,0.12,0.84,0.94],yrange=minmax(h),/xs,/ys,xtitle='Environment Temp (K)',ytitle='H_conv (W m^-2 K^-1)',title='Hconv vs Te (To = 300 K)'

mkeps,/close
print,'Wrote: '+plotpath+plotfile

;--Plot H vs Length--------------------------------------------------------------
plotfile='h_vs_length.eps'
mkeps,name= plotpath + plotfile

h = conv_const(p, t_obj, t_env, l_arr,/quiet)
plot_oi,l_arr,h,position=[0.12,0.12,0.84,0.94],yrange=[0,6],/xs,/ys,xtitle='Scale Length (m)',ytitle='H_conv (W m^-2 K^-1)',title='Hconv vs Scale Length (Float Conditions)'

mkeps,/close
print,'Wrote: '+plotpath+plotfile

end